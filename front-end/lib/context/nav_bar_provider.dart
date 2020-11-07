import 'package:flutter/material.dart';

class NavbarProvider extends ChangeNotifier {
  int _tabIndex = 2;

  int get getTabIndex => _tabIndex;

  void setTabIndex(int tabIndex) {
    _tabIndex = tabIndex;
    notifyListeners();
  }
}
