import 'package:flutter/material.dart';
import 'theme_prefs.dart';

class ThemeController extends ChangeNotifier {
  final ThemePrefs _prefs;

  ThemeMode _mode = ThemeMode.system;
  ThemeMode get mode => _mode;

  ThemeController({required ThemePrefs prefs}) : _prefs = prefs;

  /// 앱 시작 시 1회 호출
  Future<void> init() async {
    final saved = await _prefs.loadThemeMode();
    _mode = _fromString(saved);
    notifyListeners();
  }

  bool get isDark => _mode == ThemeMode.dark;

  /// 설정 탭 스위치에서 사용할 토글
  Future<void> setDark(bool value) async {
    _mode = value ? ThemeMode.dark : ThemeMode.light;
    await _prefs.saveThemeMode(value ? 'dark' : 'light');
    notifyListeners();
  }

  /// 시스템 모드까지 지원하고 싶으면 이것도 사용
  Future<void> setSystem() async {
    _mode = ThemeMode.system;
    await _prefs.saveThemeMode('system');
    notifyListeners();
  }

  ThemeMode _fromString(String? v) {
    switch (v) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }
}
