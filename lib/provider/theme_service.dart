import 'package:chater/data/preferences/prefs.dart';
import 'package:flutter/material.dart';

class ThemeService extends ChangeNotifier {
  ThemeService() {
    _getTheme();
  }

  bool _isDarkTheme = false;
  bool _isAnimated = false;

  bool get isDarkTheme => _isDarkTheme;
  bool get isAnimated => _isAnimated;

  void _getTheme() async {
    _isDarkTheme = await prefs.getTheme();
    notifyListeners();
  }

  void setDarkTheme(bool value) {
    prefs.setDarkTheme(value);
    _getTheme();
  }

  void setAnimated(bool value) {
    _isAnimated = value;
    notifyListeners();
  }
}
