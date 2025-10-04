import 'package:flutter/material.dart';

class AppStateProvider extends ChangeNotifier {
  int page = 1;
  int limit = 50;
  int pageCount = 0;
  String category = "";

  void setPageCount(int pageCount) {
    this.pageCount = pageCount;
    notifyListeners(); 
  }

  void setCategory(String category) {
    this.category = category;
    notifyListeners(); 
  }

  void incrementPage(int incCount) {
    page += incCount;
    notifyListeners(); 
  }
}
