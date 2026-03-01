import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'package:consignment/src/features/login/pages/login_page.dart';
import 'package:consignment/core/di/app_providers.dart';

import 'package:consignment/src/theme/app_theme.dart';
import 'package:consignment/src/settings/theme_controller.dart';
import 'package:consignment/src/settings/theme_prefs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // .env 로드 (pubspec.yaml assets에 - .env 추가되어 있어야 함)
  await dotenv.load(fileName: '.env');

  // ✅ ThemeController 초기화(앱 시작 시 저장값 로드)
  final themeController = ThemeController(prefs: ThemePrefs());
  await themeController.init();

  runApp(
    ConsignmentApp(themeController: themeController),
  );
}

class ConsignmentApp extends StatelessWidget {
  final ThemeController themeController;

  const ConsignmentApp({
    super.key,
    required this.themeController,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ...appProviders,
        // ✅ 전역 ThemeController 주입
        ChangeNotifierProvider<ThemeController>.value(value: themeController),
      ],
      child: Consumer<ThemeController>(
        builder: (context, theme, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Consignment Driver',

            // ✅ 라이트/다크 테마 + 모드 연결
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: theme.mode,

            home: const LoginPage(),
          );
        },
      ),
    );
  }
}
