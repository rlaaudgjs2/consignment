import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:consignment/src/features/complete/widgets/date_range_query_bar.dart';
import 'package:consignment/src/features/complete/widgets/date_range_calendar_dropdown.dart';
import 'package:consignment/src/features/complete/viewmodels/complete_page_viewmodel.dart';

import 'package:consignment/core/data/datasources/mock_remote_data_source.dart';
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
        /// ✅ repo는 정산 진입 시 1회만 생성해서 트리에 올림
        Provider<SettlementRepository>(
          create: (_) => SettlementRepository(
            remote: MockRemoteDataSource(),
          ),
        ),

        /// ✅ VM은 위에서 올린 repo를 read 해서 사용
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

  // DateRangeQueryBar 실제 높이(바깥에서 잡는 영역 높이)
  static const double _kDateBarHeight = 48.0;

  static const double _kHeaderBottomSpacing = 12.0;
  static const double _kCalendarMaxHeight = 360.0;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SettlementViewModel>();

    final bool isWallet = vm.activeTab == SettlementSubTab.wallet;

    // ✅ wallet이면 중간슬롯(날짜바) 자체가 없음
    final double middleHeight = isWallet ? 0.0 : _kDateBarHeight;

    // ✅ 헤더 높이도 탭별로 동기화 (wallet이면 날짜바 공간이 사라짐)
    final double headerHeight =
        _kTopSpacing +
            _kSubTabHeight +
            (isWallet ? 0.0 : _kBetweenSubTabAndMiddle) +
            middleHeight +
            _kHeaderBottomSpacing;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
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

                  // ✅ 날짜바는 wallet이 아닐 때만
                  if (!isWallet) ...[
                    const SizedBox(height: _kBetweenSubTabAndMiddle),

                    SizedBox(
                      height: _kDateBarHeight,
                      child: DateRangeQueryBar(
                        startDateText: vm.startDateText,
                        endDateText: vm.endDateText,
                        onTapStartDate: () => context
                            .read<SettlementViewModel>()
                            .openCalendar(DateFieldMode.start),
                        onTapEndDate: () => context
                            .read<SettlementViewModel>()
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
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                            color: Color(0xFFE53935),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ✅ 캘린더는 dateRangeBar가 있는 탭에서만
            if (!isWallet && vm.isCalendarOpen) ...[
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => context.read<SettlementViewModel>().closeCalendar(),
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
                        onPrevMonth: () => context.read<SettlementViewModel>().prevMonth(),
                        onNextMonth: () => context.read<SettlementViewModel>().nextMonth(),
                        onSelectDate: (picked) =>
                            context.read<SettlementViewModel>().selectDate(picked),
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
