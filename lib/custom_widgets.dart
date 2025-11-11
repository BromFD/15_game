import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shuffle/provider.dart';

class MovingTile extends StatefulWidget {
  final Color color;
  final String text;
  final int currentIndex;

  const MovingTile({
    super.key,
    required this.color,
    required this.text,
    required this.currentIndex,
  });

  @override
  State<MovingTile> createState() => _MovingTileState();
}

class _MovingTileState extends State<MovingTile> {

  @override
  Widget build(BuildContext context) {
  int currentIndex = widget.currentIndex;
    return Container(
      decoration: BoxDecoration(
          color: widget.color,
          border: Border.all(
              color: context.watch<ShuffleProvider>().gridData[currentIndex] != 0
                  && context.watch<ShuffleProvider>().selectedIndex == currentIndex && currentIndex != null
                  ? Colors.green
                  : Colors.transparent,

              width: 5.0,
          ),
      ),
      child: Center(
        child: Text(
          widget.text,
          style: const TextStyle(
              fontSize: 24.0,
              color: Colors.red
          ),
        ),
      ),
    );
  }
}


class ShuffleGrid extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  const ShuffleGrid({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  State<ShuffleGrid> createState() => _ShuffleGridState();
}

class _ShuffleGridState extends State<ShuffleGrid> {

  final FocusNode gridFocusNode = FocusNode();

  @override
  void dispose() {
    gridFocusNode.dispose();
    super.dispose();
  }

  void manageKeyboardInputs(KeyEvent event){
    final provider  = context.read<ShuffleProvider>();

    if (event is! KeyDownEvent) {
      return;
    }


    if (event.logicalKey == LogicalKeyboardKey.keyW && provider.selectedIndex! - provider.colCount >= 0) {
      provider.setSelectedIndex(provider.selectedIndex! - provider.colCount);
    }

    if (event.logicalKey == LogicalKeyboardKey.keyA && provider.selectedIndex! - 1 >= 0) {
      provider.setSelectedIndex(provider.selectedIndex! - 1);
    }

    if (event.logicalKey == LogicalKeyboardKey.keyS && provider.selectedIndex! + provider.colCount <= 15) {
      provider.setSelectedIndex(provider.selectedIndex! + provider.colCount);
    }

    if (event.logicalKey == LogicalKeyboardKey.keyD && provider.selectedIndex! + 1 <= 15) {
      provider.setSelectedIndex(provider.selectedIndex! + 1);
    }


    if (provider.selectedIndex! - provider.colCount >= 0) {
      if (event.logicalKey == LogicalKeyboardKey.keyI && provider.gridData[provider.selectedIndex! - provider.colCount] == 0){
        provider.swapTiles(provider.selectedIndex!, provider.selectedIndex! - provider.colCount);
      }
    }

    if (provider.selectedIndex! - 1 >= 0) {
      if (event.logicalKey == LogicalKeyboardKey.keyJ && provider.gridData[provider.selectedIndex! - 1] == 0 && (provider.selectedIndex!) % provider.colCount != 0){
        provider.swapTiles(provider.selectedIndex!, provider.selectedIndex! - 1);
      }
    }

    if (provider.selectedIndex! + 1 <= 15) {
      if (event.logicalKey == LogicalKeyboardKey.keyL && provider.gridData[provider.selectedIndex! + 1] == 0 && (provider.selectedIndex! + 1) % provider.colCount != 0){
        provider.swapTiles(provider.selectedIndex!, provider.selectedIndex! + 1);
      }
    }

    if (provider.selectedIndex! + provider.colCount <= 15) {
      if (event.logicalKey == LogicalKeyboardKey.keyK && provider.gridData[provider.selectedIndex! + provider.colCount] == 0){
        provider.swapTiles(provider.selectedIndex!, provider.selectedIndex! + provider.colCount);
      }
    }

    
  }

  @override
  Widget build(BuildContext context) {
    List<int> buildGridData = context.watch<ShuffleProvider>().gridData;
    int buildColCount = context.read<ShuffleProvider>().colCount;
    final provider = context.read<ShuffleProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (provider.isGameStarted && !gridFocusNode.hasFocus) {
        gridFocusNode.requestFocus();
      }
      else if (!provider.isGameStarted && gridFocusNode.hasFocus) {
        gridFocusNode.unfocus();
      }
    });

    return Column(
      children: [

        Container(
          color: Colors.black,
          height: widget.screenHeight * 0.15,
          width: double.infinity,
          child: TextButton(
            onPressed: (){
              context.read<ShuffleProvider>().switchSelectedIndex();
              context.read<ShuffleProvider>().isGameStartedSwitch();
              if (gridFocusNode.hasFocus) {
                gridFocusNode.unfocus();
              } else {
                gridFocusNode.requestFocus();
              }
            },
            child: Text(
              context.watch<ShuffleProvider>().isGameStarted
                  ? "Завершить игру"
                  : "Начать игру",
              style: TextStyle(
                  color: Colors.white
              ),
            ),
          ),
        ),

        Padding(padding: EdgeInsetsGeometry.only(top: widget.screenHeight * 0.05)),

        Expanded(
          child: KeyboardListener(
              focusNode: gridFocusNode,
              autofocus: false,
              onKeyEvent: manageKeyboardInputs,
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: buildColCount,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                  ),
                itemCount: buildGridData.length,
                itemBuilder: (BuildContext context, int index) {

                    return buildGridData[index] == 0
                        ? MovingTile(
                      currentIndex: index,
                      color: Colors.grey,
                      text: "",

                    )
                        : MovingTile(
                      currentIndex: index,
                      color: Colors.yellow,
                      text: "${buildGridData[index]}",

                    );
                }
              ),
            ),
        ),
      ],
    );
  }
}
