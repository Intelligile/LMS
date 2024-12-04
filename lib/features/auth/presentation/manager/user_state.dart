import 'package:flutter/foundation.dart';

class UserState extends ChangeNotifier {
  bool _isLicensor = false;
  //List<String> _userRoles = [];

  bool get isLicensor => _isLicensor;
  //List<String> get userRoles => _userRoles;

  void setUserInfo(bool isLicensor) {
    _isLicensor = isLicensor;
    // _userRoles = userRoles;
    notifyListeners();
  }
}
