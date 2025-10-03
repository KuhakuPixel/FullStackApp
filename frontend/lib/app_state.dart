import 'package:flutter/material.dart';

class AppStateProvider extends ChangeNotifier {
  int page = 1;
  int limit = 50;

  List<Map<String, dynamic>> datas = [
    {"name": "cool name", "price": 300, "category": "horror"},
    {"name": "cool name", "price": 300, "category": "horror"},
    {"name": "cool name", "price": 300, "category": "horror"},
    {"name": "cool name", "price": 300, "category": "horror"},
  ];


  void incrementPage(int incCount) {
    page += incCount;
    notifyListeners(); // To notify all the listeners that the value may change
  }
}
