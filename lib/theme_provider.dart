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
