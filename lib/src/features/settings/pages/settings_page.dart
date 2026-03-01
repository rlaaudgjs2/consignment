import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:consignment/core/data/datasources/settings_remote_data_source.dart';
import 'package:consignment/core/data/repositories/settings_repository.dart';

import '../viewmodels/settings_viewmodel.dart';
import '../widgets/settings_menu_tile.dart';
import '../widgets/settings_section_title.dart';

import 'settings_my_info_page.dart';
import 'settings_notice_page.dart';

import 'package:consignment/src/settings/theme_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = SettingsRepository(remote: SettingsRemoteDataSource());

    return MultiProvider(
      providers: [
        Provider<SettingsRepository>.value(value: repo),

        // ✅ SettingsViewModel에 ThemeController를 주입해서 toggle에서 전역 테마 변경
        ChangeNotifierProvider<SettingsViewModel>(
          create: (_) => SettingsViewModel(
            repository: repo,
            themeController: context.read<ThemeController>(),
          ),
        ),
      ],
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  static const _divider = Color(0xFFEAEAEA);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SettingsViewModel>();
    final theme = context.watch<ThemeController>(); // ✅ 현재 테마 상태 표시용

    // ✅ 다크/라이트에 따라 배경/텍스트가 자연스럽게 바뀌도록 Theme 기반 사용 권장
    final bg = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingsMenuTile(
              title: '내 정보',
              onTap: () {
                final repo = context.read<SettingsRepository>();

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => Provider<SettingsRepository>.value(
                      value: repo,
                      child: const SettingsMyInfoPage(),
                    ),
                  ),
                );
              },
            ),
            const Divider(height: 1, thickness: 1, color: _divider),

            SettingsMenuTile(
              title: '공지사항',
              onTap: () {
                final repo = context.read<SettingsRepository>();

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => Provider<SettingsRepository>.value(
                      value: repo,
                      child: const SettingsNoticePage(),
                    ),
                  ),
                );
              },
            ),
            const Divider(height: 1, thickness: 1, color: _divider),

            const SettingsSectionTitle(title: '옵션 설정'),

            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '다크 모드',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.0,
                        color: textColor,
                      ),
                    ),
                  ),

                  // ✅ 스위치 상태는 전역 ThemeController 기준
                  Switch(
                    value: theme.isDark,
                    onChanged: vm.toggleDarkMode,

                    // ✅ OFF(해제) = 회색 트랙 + 흰 썸
                    inactiveTrackColor: const Color(0xFFD9D9D9),
                    inactiveThumbColor: const Color(0xFFFFFFFF),

                    // ✅ ON(활성) = 초록 트랙 + 흰 썸 (원하는 톤으로 조절)
                    activeTrackColor: const Color(0xFF7ED957),
                    activeColor: const Color(0xFFFFFFFF),

                    // ✅ 테두리(아웃라인) 방지
                    trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),

                    // ✅ 썸 아이콘 제거
                    thumbIcon: const WidgetStatePropertyAll(null),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 1, color: _divider),
          ],
        ),
      ),
    );
  }
}
