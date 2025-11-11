import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shuffle/provider.dart';

class MovingTile extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSelected;
  const MovingTile({
    super.key,
    required this.color,
    required this.text,
    required this.isSelected,

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: color,
          border: Border.all(
              color: isSelected
                  ? Colors.green
                  : Colors.transparent,

              width: 5.0,
          ),
      ),
      child: Center(
        child: Text(
          text,
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

    if (event.logicalKey == LogicalKeyboardKey.keyW && provider.selectedRow! != 0) {
      provider.setSelectedPosition(provider.selectedRow! - 1, provider.selectedCol!);
    }

    else if (event.logicalKey == LogicalKeyboardKey.keyA && provider.selectedCol! != 0) {
      provider.setSelectedPosition(provider.selectedRow!, provider.selectedCol! - 1);
    }

    else if (event.logicalKey == LogicalKeyboardKey.keyS && provider.selectedRow != provider.rowCount - 1) {
      provider.setSelectedPosition(provider.selectedRow! + 1, provider.selectedCol!);
    }

    else if (event.logicalKey == LogicalKeyboardKey.keyD && provider.selectedCol! != provider.colCount - 1) {
      provider.setSelectedPosition(provider.selectedRow!, provider.selectedCol! + 1);
    }

    else if (event.logicalKey == LogicalKeyboardKey.enter) {
      if (provider.selectedRow! != 0 && provider.grid2DimData[provider.selectedRow! - 1][provider.selectedCol!] == 0) {
        provider.swapTiles(provider.selectedRow!, provider.selectedCol!, provider.selectedRow! - 1, provider.selectedCol!);
      }

      else if (provider.selectedCol! != 0 && provider.grid2DimData[provider.selectedRow!][provider.selectedCol! - 1] == 0) {
        provider.swapTiles(provider.selectedRow!, provider.selectedCol!, provider.selectedRow!, provider.selectedCol! - 1);
      }

      else if (provider.selectedRow! != provider.rowCount - 1 && provider.grid2DimData[provider.selectedRow! + 1][provider.selectedCol!] == 0) {
        provider.swapTiles(provider.selectedRow!, provider.selectedCol!, provider.selectedRow! + 1, provider.selectedCol!);
      }

      else if (provider.selectedCol! != provider.colCount - 1 && provider.grid2DimData[provider.selectedRow!][provider.selectedCol! + 1] == 0) {
        provider.swapTiles(provider.selectedRow!, provider.selectedCol!, provider.selectedRow!, provider.selectedCol! + 1);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    int buildColCount = context.read<ShuffleProvider>().colCount;
    final provider = context.watch<ShuffleProvider>();
    List<List<int>> buildGrid2DimData = provider.grid2DimData;

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
              context.read<ShuffleProvider>().switchSelectedPosition();
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
                itemCount: buildGrid2DimData.length * buildGrid2DimData[0].length,
                itemBuilder: (BuildContext context, int index) {

                    int row = index ~/ buildColCount;
                    int col = index % buildColCount;

                    bool selectionCriterion = provider.selectedRow == row && provider.selectedCol == col && buildGrid2DimData[row][col] != 0;

                    return buildGrid2DimData[row][col] == 0
                        ? MovingTile(
                      isSelected: selectionCriterion,
                      color: Colors.grey,
                      text: "",

                    )
                        : MovingTile(
                      isSelected: selectionCriterion,
                      color: Colors.yellow,
                      text: "${buildGrid2DimData[row][col]}",

                    );
                }
              ),
            ),
        ),
      ],
    );
  }
}
