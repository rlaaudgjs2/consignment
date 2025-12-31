import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:consignment/core/data/settings/repositories/settings_repository.dart';
import '../viewmodels/settings_notice_viewmodel.dart';
import '../widgets/settings_notice_tile.dart';

class SettingsNoticePage extends StatelessWidget {
  const SettingsNoticePage({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = context.read<SettingsRepository>();

    return ChangeNotifierProvider<SettingsNoticeViewModel>(
      create: (_) => SettingsNoticeViewModel(repository: repo),
      child: const _SettingsNoticeView(),
    );
  }
}

class _SettingsNoticeView extends StatelessWidget {
  const _SettingsNoticeView();

  static const _bg = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SettingsNoticeViewModel>();

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 8,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Color(0xFF333333)),
        ),
        title: const Text(
          '공지사항',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            height: 1.0,
            color: Color(0xFF333333),
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            if (vm.isLoading) const LinearProgressIndicator(minHeight: 2),
            if (vm.errorMessage != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    vm.errorMessage!,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      height: 1.0,
                      color: Color(0xFFE53935),
                    ),
                  ),
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: vm.items.length,
                itemBuilder: (context, index) {
                  final item = vm.items[index];
                  final expanded = vm.expandedIndex == index;

                  return SettingsNoticeTile(
                    title: item.title,
                    date: item.date,
                    body: item.body,
                    expanded: expanded,
                    onTap: () => context.read<SettingsNoticeViewModel>().toggleExpanded(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
