import 'package:flutter/material.dart';

class ExpansionTileDrawerProvider extends ChangeNotifier {
  final Map<String, bool> _expansionState = {};

  bool isExpanded(String title) => _expansionState[title] ?? false;

  void toggleExpansion(String title) {
    _expansionState[title] = !(_expansionState[title] ?? false);
    notifyListeners();
  }
}

class OpenedAndClosedDrawerProvider extends ChangeNotifier {
  bool _isDrawerOpen = true;

  bool get isDrawerOpen => _isDrawerOpen;

  void toggleDrawer() {
    _isDrawerOpen = !_isDrawerOpen;
    notifyListeners();
  }

  void setDrawerOpen(bool isOpen) {
    _isDrawerOpen = isOpen;
    notifyListeners();
  }
}
