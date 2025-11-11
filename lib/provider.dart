import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ShuffleProvider extends ChangeNotifier{
  late List<int> gridData;
  final int rowCount = 4;
  final int colCount = 4;
  bool isGameStarted = false;
  bool isVictory = false;
  int? selectedIndex;
  List<int> constGridData = [];
  List<List<int>> grid2DimData = [];


  ShuffleProvider() {
    genGridData();
  }

  void switchSelectedIndex() {
    if (selectedIndex == null){
      selectedIndex = 0;
    }
    else {
      selectedIndex = null;
    };
    notifyListeners();
  }

  void setSelectedIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void isGameStartedSwitch(){
    if (isGameStarted == false){
      isGameStarted = true;
    }
    else {
      isGameStarted = false;
    }
    notifyListeners();
  }


  void genGridData(){
    gridData = List.generate(rowCount * colCount, (index) => index);
    constGridData = List.from(gridData);
    constGridData.remove(0);
    constGridData.add(0);
    shuffleGrid();
    notifyListeners();
  }

  void shuffleGrid() {
    selectedIndex = selectedIndex == null ? selectedIndex : 0;
    while (true) {
      gridData.shuffle();

      int inversionCount = 0;
      for (int i = 0; i < gridData.length - 1; i++) {
        if (gridData[i] == 0) continue;
        for (int j = i + 1; j < gridData.length; j++) {
          if (gridData[j] == 0) continue;
          if (gridData[i] > gridData[j]) {
            inversionCount++;
          }
        }
      }

      int emptyRowIndex = gridData.indexOf(0) ~/ colCount;

      bool isSolvable;
      if ((emptyRowIndex % 2) == 1) {
        isSolvable = (inversionCount % 2) == 0;
      } else {
        isSolvable = (inversionCount % 2) == 1;
      }

      if (isSolvable) {
        break;
      }
    }
    build2DimGrid();
    notifyListeners();
  }

  void build2DimGrid(){

  }

  void swapTiles(int index1, int index2) {
    int temp = gridData[index1];
    gridData[index1] = gridData[index2];
    gridData[index2] = temp;
    selectedIndex = index2;
    checkVictoryCondition();
    notifyListeners();
  }

  void checkVictoryCondition(){
    if (listEquals(gridData, constGridData)){
      isVictory = true;
      notifyListeners();
    }
  }

  void playAgain(){
    genGridData();
    shuffleGrid();
    isGameStarted = true;
    isVictory = false;
    notifyListeners();
  }
}