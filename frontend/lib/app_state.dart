import 'package:flutter/material.dart';

class AppStateProvider extends ChangeNotifier {
  int page = 1;

  AppStateProvider(){
    page=1;
  }

  void incrementPage(int incCount) {
    page += incCount;
    notifyListeners(); // To notify all the listeners that the value may change
  }
}
