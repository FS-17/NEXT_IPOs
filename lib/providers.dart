import 'package:flutter/material.dart';
import 'theme.dart';
import 'consts.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = ConstManager.dark;

  bool get isDarkMode => _isDarkMode;

  ThemeData get currentTheme =>
      _isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;

  void makeDark(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }
}

class SettingsProvider with ChangeNotifier {
  String _market = ConstManager.market;
  DateTime _fromDate = ConstManager.fromDate;
  DateTime _toDate = ConstManager.toDate;

  String get market => _market;
  DateTime get fromDate => _fromDate;
  DateTime get toDate => _toDate;

  set market(String value) {
    _market = value;
    ConstManager.market = value;
    notifyListeners();
  }

  set fromDate(DateTime value) {
    _fromDate = value;
    ConstManager.fromDate = value;
    notifyListeners();
  }

  set toDate(DateTime value) {
    _toDate = value;
    ConstManager.toDate = value;
    notifyListeners();
  }
}
