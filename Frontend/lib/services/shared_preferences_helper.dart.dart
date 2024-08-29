import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeNotifier() {
    _loadTheme();
  }

  ThemeMode get themeMode => _themeMode;

  void setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('themeMode', mode.toString().split('.').last);
  }

  void _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? themeString = prefs.getString('themeMode');
    if (themeString != null) {
      _themeMode = ThemeMode.values
          .firstWhere((e) => e.toString().split('.').last == themeString);
      notifyListeners();
    }
  }
}

Future<String?> getThreadIdFromPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('thread_id');
}

Future<void> saveThreadIdToPreferences(String threadId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('thread_id', threadId);
}
