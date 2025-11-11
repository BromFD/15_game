import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class ShuffleProvider extends ChangeNotifier{
  late List<int> gridData;
  final int rowCount = 4;
  final int colCount = 4;
  bool isGameStarted = false;
  bool isVictory = false;
  int? selectedRow;
  int? selectedCol;
  List<int> constGridData = [];
  List<List<int>> grid2DimData = [];


  ShuffleProvider() {
    genGridData();
  }

  void switchSelectedPosition() {
    if (selectedRow == null && selectedCol == null){
      selectedRow = 0;
      selectedCol = 0;
    }
    else {
      selectedRow = null;
      selectedCol = null;
    };
    notifyListeners();
  }

  void setSelectedPosition(int row, int col) {
    selectedRow = row;
    selectedCol = col;
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
    selectedRow = selectedRow == null ? selectedRow : 0;
    selectedCol = selectedCol == null ? selectedCol : 0;
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
    grid2DimData = [];
    for (int i = 0; i < rowCount; i++) {
      List<int> row = [];
      for (int j = 0; j < colCount; j++) {
        row.add(gridData[i * colCount + j]);
      }
      grid2DimData.add(row);
      }
    }


  void swapTiles(int localSelectedRow, int localSelectedCol, int nullRow, int nullCol) {
    int temp = grid2DimData[localSelectedRow][localSelectedCol];
    grid2DimData[localSelectedRow][localSelectedCol] = grid2DimData[nullRow][nullCol];
    grid2DimData[nullRow][nullCol] = temp;
    checkVictoryCondition();
    notifyListeners();
  }

  void checkVictoryCondition(){
    List<int> backToFlat = grid2DimData.expand((row) => row).toList();
    if (listEquals(backToFlat, constGridData)){
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