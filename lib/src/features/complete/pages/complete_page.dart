import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:consignment/core/data/datasources/mock_remote_data_source.dart';
import 'package:consignment/core/data/repositories/complete_repository.dart';

import '../viewmodels/complete_page_viewmodel.dart';
import '../widgets/date_range_query_bar.dart';
import '../widgets/date_range_calendar_dropdown.dart';
import '../widgets/driving_history_table_template.dart';

class CompletePage extends StatelessWidget {
  const CompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CompletePageViewModel>(
      create: (_) {
        final repo = CompleteRepository(remote: const MockRemoteDataSource());
        return CompletePageViewModel(repository: repo);
      },
      child: const _CompletePageView(),
    );
  }
}

class _CompletePageView extends StatelessWidget {
  const _CompletePageView();

  // DateRangeQueryBar 위/아래 여백 포함한 "헤더 영역" 높이
  static const double _kTopSpacing = 12.0;
  static const double _kBarHeight = 48.0;
  static const double _kBarBottomSpacing = 12.0;

  static const double _kHeaderHeight = _kTopSpacing + _kBarHeight + _kBarBottomSpacing;

  // 캘린더 최대 높이(필요시 조절)
  static const double _kCalendarMaxHeight = 360.0;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CompletePageViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            // -------------------------------
            // (1) 리스트는 항상 헤더 밑에서 시작 (겹침 방지 핵심)
            // -------------------------------
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.only(top: _kHeaderHeight),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (vm.isLoading)
                        const Padding(
                          padding: EdgeInsets.only(top: 24),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else if (vm.errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: Center(
                            child: Text(
                              vm.errorMessage!,
                              style: const TextStyle(color: Color(0xFF828282)),
                            ),
                          ),
                        )
                      else
                        DrivingHistoryTableTemplate(
                          histories: vm.histories,
                          onTapHistory: (id) async {
                            // ✅ 핵심: row 클릭 → VM이 상세 조회 → 모달 오픈
                            await context.read<CompletePageViewModel>().openDrivingDetailModal(context, id: id);
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // -------------------------------
            // (2) 상단 고정: 날짜바
            // -------------------------------
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: _kTopSpacing),
                  DateRangeQueryBar(
                    startDateText: vm.startDateText,
                    endDateText: vm.endDateText,
                    onTapStartDate: () => context.read<CompletePageViewModel>().openCalendar(DateFieldMode.start),
                    onTapEndDate: () => context.read<CompletePageViewModel>().openCalendar(DateFieldMode.end),
                    onTapQuery: () async {
                      final readVm = context.read<CompletePageViewModel>();
                      await readVm.query();
                      readVm.closeCalendar();
                    },
                  ),
                  const SizedBox(height: _kBarBottomSpacing),
                ],
              ),
            ),

            // -------------------------------
            // (3) 캘린더 열려 있을 때: 뒤 터치 막기 + 캘린더 오버레이
            // -------------------------------
            if (vm.isCalendarOpen) ...[
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => context.read<CompletePageViewModel>().closeCalendar(),
                  child: const ModalBarrier(
                    dismissible: true,
                    color: Colors.transparent,
                  ),
                ),
              ),

              Positioned(
                left: 0,
                right: 0,
                top: _kTopSpacing + _kBarHeight + 8,
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: _kCalendarMaxHeight),
                    child: SingleChildScrollView(
                      child: DateRangeCalendarDropdown(
                        focusedMonth: vm.focusedMonth,
                        startDate: vm.startDate,
                        endDate: vm.endDate,
                        mode: vm.activeField,
                        onPrevMonth: () => context.read<CompletePageViewModel>().prevMonth(),
                        onNextMonth: () => context.read<CompletePageViewModel>().nextMonth(),
                        onSelectDate: (picked) => context.read<CompletePageViewModel>().selectDate(picked),
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
}
