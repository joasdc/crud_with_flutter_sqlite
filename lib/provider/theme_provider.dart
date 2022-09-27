import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  String currentTheme = "light";

  ThemeMode get themeMode {
    if (currentTheme == "light") {
      return ThemeMode.light;
    } else if (currentTheme == "dark") {
      return ThemeMode.dark;
    } else {
      return ThemeMode.light;
    }
  }

  void changeTheme(String theme) async {
    final _prefs = await SharedPreferences.getInstance();

    await _prefs.setString("theme", theme);

    currentTheme = theme;

    notifyListeners();
  }

  void initialize() async {
    final _prefs = await SharedPreferences.getInstance();

    currentTheme = _prefs.getString("theme") ?? "light";

    notifyListeners();
  }
}
