import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:consignment/src/features/complete/widgets/date_range_query_bar.dart';
import 'package:consignment/src/features/complete/widgets/date_range_calendar_dropdown.dart';

import 'package:consignment/src/utils/date_range_types.dart';

import 'package:consignment/core/data/datasources/settlement_remote_data_source.dart';
import 'package:consignment/core/data/repositories/settlement_repository.dart';

import '../viewmodels/settlement_viewmodel.dart';
import '../widgets/settlement_subtab_bar.dart';
import '../widgets/settlement_daily_income_tab.dart';
import '../widgets/settlement_transactions_tab.dart';
import '../widgets/settlement_wallet_tab.dart';

class SettlementPage extends StatelessWidget {
  const SettlementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<SettlementRepository>(
          create: (_) => SettlementRepository(
            remote: const SettlementRemoteDataSource(),
          ),
        ),
        ChangeNotifierProvider<SettlementViewModel>(
          create: (ctx) => SettlementViewModel(
            repository: ctx.read<SettlementRepository>(),
          ),
        ),
      ],
      child: const _SettlementPageView(),
    );
  }
}

class _SettlementPageView extends StatelessWidget {
  const _SettlementPageView();

  static const double _kTopSpacing = 12.0;
  static const double _kSubTabHeight = 40.0;
  static const double _kBetweenSubTabAndMiddle = 10.0;

  static const double _kDateBarHeight = 48.0;

  static const double _kHeaderBottomSpacing = 12.0;
  static const double _kCalendarMaxHeight = 360.0;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SettlementViewModel>();
    final cs = Theme.of(context).colorScheme;

    final bool isWallet = vm.activeTab == SettlementSubTab.wallet;
    final double middleHeight = isWallet ? 0.0 : _kDateBarHeight;

    final double headerHeight =
        _kTopSpacing +
            _kSubTabHeight +
            (isWallet ? 0.0 : _kBetweenSubTabAndMiddle) +
            middleHeight +
            _kHeaderBottomSpacing;

    return Scaffold(
      // ✅ 하드코딩 제거
      backgroundColor: cs.surface,
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.only(top: headerHeight),
                child: _buildBodyByTab(vm.activeTab),
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: _kTopSpacing),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      height: _kSubTabHeight,
                      child: SettlementSubTabBar(
                        activeTab: vm.activeTab,
                        onTap: (tab) => context.read<SettlementViewModel>().setTab(tab),
                      ),
                    ),
                  ),

                  if (!isWallet) ...[
                    const SizedBox(height: _kBetweenSubTabAndMiddle),
                    SizedBox(
                      height: _kDateBarHeight,
                      child: DateRangeQueryBar(
                        startDateText: vm.startDateText,
                        endDateText: vm.endDateText,
                        onTapStartDate: () => context
                            .read<SettlementViewModel>()
                            .dateRange
                            .openCalendar(DateFieldMode.start),
                        onTapEndDate: () => context
                            .read<SettlementViewModel>()
                            .dateRange
                            .openCalendar(DateFieldMode.end),
                        onTapQuery: () async {
                          await context.read<SettlementViewModel>().queryCurrentTab();
                        },
                      ),
                    ),
                  ],

                  const SizedBox(height: _kHeaderBottomSpacing),

                  if (vm.isLoading) const LinearProgressIndicator(minHeight: 2),

                  if (vm.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          vm.errorMessage!,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                            color: cs.error,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            if (!isWallet && vm.isCalendarOpen) ...[
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => context.read<SettlementViewModel>().dateRange.closeCalendar(),
                  child: const ModalBarrier(
                    dismissible: true,
                    color: Colors.transparent,
                  ),
                ),
              ),

              Positioned(
                left: 0,
                right: 0,
                top: _kTopSpacing +
                    _kSubTabHeight +
                    _kBetweenSubTabAndMiddle +
                    _kDateBarHeight -
                    4,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: _kCalendarMaxHeight),
                    child: SingleChildScrollView(
                      child: DateRangeCalendarDropdown(
                        focusedMonth: vm.focusedMonth,
                        startDate: vm.startDate,
                        endDate: vm.endDate,
                        mode: vm.activeField,
                        onPrevMonth: () => context.read<SettlementViewModel>().dateRange.prevMonth(),
                        onNextMonth: () => context.read<SettlementViewModel>().dateRange.nextMonth(),
                        onSelectDate: (picked) =>
                            context.read<SettlementViewModel>().dateRange.selectDate(picked),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBodyByTab(SettlementSubTab tab) {
    switch (tab) {
      case SettlementSubTab.dailyIncome:
        return const SettlementDailyIncomeTab();
      case SettlementSubTab.transactions:
        return const SettlementTransactionsTab();
      case SettlementSubTab.wallet:
        return const SettlementWalletTab();
    }
  }
}
