import 'package:flutter/material.dart';

class AppStateProvider extends ChangeNotifier {
  int page = 1;
  int limit = 50;
  int pageCount = 0;

  void setPageCount(int pageCount) {
    this.pageCount = pageCount;
    notifyListeners(); 
  }

  void incrementPage(int incCount) {
    page += incCount;
    notifyListeners(); 
  }
}
