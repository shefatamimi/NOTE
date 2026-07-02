import 'package:flutter/material.dart';
import '../Utils/shared_prefernce.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _isDarkMode = AppSharedPreferences.getThemeMode();
  }

  void toggleTheme(bool value) async {
    _isDarkMode = value;
    await AppSharedPreferences.setThemeMode(value);
    notifyListeners();
  }
}
