import 'package:flutter/material.dart';

class AppStateProvider extends ChangeNotifier {
  int page = 1;
  int limit = 50;
  int pageCount = 0;
  bool isDataLoading = false;
  String category = "";
  String search = "";

  void setIsDataLoading(bool val) {
    // for this case we don't need to trigger a rebuild so no need for notifyListeners
    this.isDataLoading = val;
  }

  void setPage(int page) {
    this.page = page;
    notifyListeners(); 
  }

  void setCategory(String category) {
    this.category = category;
    notifyListeners(); 
  }

  void setSearch(String search) {
    this.search = search;
    notifyListeners(); 
  }

  void incrementPage(int incCount) {
    page += incCount;
    notifyListeners(); 
  }
}
