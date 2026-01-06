import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:consignment/core/data/datasources/settings_remote_data_source.dart';
import 'package:consignment/core/data/repositories/settings_repository.dart';

import '../viewmodels/settings_viewmodel.dart';
import '../widgets/settings_menu_tile.dart';
import '../widgets/settings_section_title.dart';

import 'settings_my_info_page.dart';
import 'settings_notice_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = SettingsRepository(remote: SettingsRemoteDataSource());

    return MultiProvider(
      providers: [
        Provider<SettingsRepository>.value(value: repo),
        ChangeNotifierProvider<SettingsViewModel>(
          create: (_) => SettingsViewModel(repository: repo),
        ),
      ],
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  static const _bg = Color(0xFFFFFFFF);
  static const _divider = Color(0xFFEAEAEA);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SettingsViewModel>();

    return Scaffold(
      backgroundColor: _bg,
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
                  const Expanded(
                    child: Text(
                      '다크 모드',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        height: 1.0,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                  Switch(
                    value: vm.darkMode,
                    onChanged: vm.toggleDarkMode,

                    // ✅ OFF(해제) = 첫번째 스샷 느낌(회색 트랙 + 흰 썸)
                    inactiveTrackColor: const Color(0xFFD9D9D9),
                    inactiveThumbColor: const Color(0xFFFFFFFF),

                    // ✅ ON(활성) = 세번째 스샷 느낌(초록 트랙 + 흰 썸)
                    activeTrackColor: const Color(0xFF7ED957), // 원하는 초록 톤으로 조절 가능
                    activeColor: const Color(0xFFFFFFFF),

                    // ✅ 2번처럼 테두리(아웃라인) 생기는 것 방지
                    trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),

                    // (선택) 썸 아이콘 없애서 깔끔하게
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
