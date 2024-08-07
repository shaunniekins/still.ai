import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  // Default theme mode is dark
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }
}
