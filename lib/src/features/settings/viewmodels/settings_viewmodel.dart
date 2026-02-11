import 'package:flutter/foundation.dart';
import 'package:consignment/core/data/repositories/settings_repository.dart';

class SettingsViewModel extends ChangeNotifier {
  final SettingsRepository repository;

  SettingsViewModel({
    required this.repository,
  });

  bool _darkMode = false;
  bool get darkMode => _darkMode;

  void toggleDarkMode(bool v) {
    _darkMode = v;
    notifyListeners();
  }
}
