import 'package:flutter/foundation.dart';
import 'package:consignment/core/data/repositories/settings_repository.dart';

// ✅ ThemeController import
import 'package:consignment/src/settings/theme_controller.dart';

class SettingsViewModel extends ChangeNotifier {
  final SettingsRepository repository;
  final ThemeController themeController;

  SettingsViewModel({
    required this.repository,
    required this.themeController,
  });

  // ✅ 화면에서 필요하면 이렇게 읽기만
  bool get darkMode => themeController.isDark;

  // ✅ 스위치 토글 → 전역 테마 변경 + 저장까지 ThemeController가 처리
  Future<void> toggleDarkMode(bool v) async {
    await themeController.setDark(v);

    // (선택) SettingsViewModel 내부에서 추가로 해야할 동작이 있으면 여기서 처리
    // 예: 서버에 사용자 설정 저장 등

    notifyListeners();
  }
}
