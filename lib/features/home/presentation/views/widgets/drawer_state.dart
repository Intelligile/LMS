import 'package:flutter/material.dart';

class DrawerStateProvider extends ChangeNotifier {
  final Map<String, bool> _expansionState = {};

  bool isExpanded(String title) => _expansionState[title] ?? false;

  void toggleExpansion(String title) {
    _expansionState[title] = !(_expansionState[title] ?? false);
    notifyListeners();
  }
}
