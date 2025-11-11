import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shuffle/custom_widgets.dart';
import 'package:shuffle/provider.dart';

class UI extends StatefulWidget {
  const UI({super.key});

  @override
  State<UI> createState() => _UIState();
}

class _UIState extends State<UI> {

  @override
  Widget build(BuildContext context) {

    final provider = context.watch<ShuffleProvider>();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    void _showVictoryDialog(BuildContext context) {
      final provider = context.read<ShuffleProvider>();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Победа!'),
            content: const Text('Вы собрали пятнашки!'),
            actions: <Widget>[
              TextButton(
                child: const Text('Играть снова'),
                onPressed: () {
                  provider.playAgain();
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          );
        },
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (provider.isVictory) {
        _showVictoryDialog(context);
      }
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal:screenWidth * 0.225),
          child: Column(
            children: [

              Padding(padding: EdgeInsets.only(top: screenHeight * 0.05),),

            Expanded(
              child: Row(
                    children: [

                      Container(
                        color: Colors.red,
                        width: screenWidth * 0.1,
                        height: screenHeight * 0.75,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: (){
                                  context.read<ShuffleProvider>().shuffleGrid();
                                },
                                icon: Icon(
                                  Icons.shuffle,
                                  color: Colors.white,
                                  size: 50,
                                ),
                              ),
                            ],
                          )
                      ),

                      Padding(padding: EdgeInsets.only(right: screenWidth * 0.05),),

                      Expanded(
                        child: SizedBox(
                          height: screenHeight * 0.75,
                          child: ShuffleGrid(screenHeight: screenHeight, screenWidth: screenWidth,)
                        ),
                      ),

                      Padding(padding: EdgeInsets.only(left: screenWidth * 0.05),),

                      Container(
                        width: screenWidth * 0.1,
                        height: screenHeight * 0.75,
                        color: Colors.red,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            PopupMenuButton(

                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'selection',
                                  child: Text('WASD - двигать выделение'),
                                ),
                                PopupMenuItem(
                                  value: 'movement',
                                  child: Text('Enter - двигать плитку'),
                                ),
                                PopupMenuItem(
                                  value: 'autors',
                                  child: Text('Сделали Бочкарёв, Федоров и Куликов'),
                                ),
                                PopupMenuItem(
                                  value: '...',
                                  child: Text('Поставьте хорошую оценку пожалуйста :)'),
                                ),
                            ],
                              tooltip: 'Небольшая справка',
                              icon: Icon(
                                Icons.info,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),
                          ],
                        ),
                      ),

                    ]
                  ),


                  ),

              Padding(padding: EdgeInsets.only(bottom: screenHeight * 0.05),),

            ]
          ),
        ),
      ),
    );
  }
}
