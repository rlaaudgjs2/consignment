import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:consignment/core/data/complete/datasources/complete_remote_data_source.dart';
import 'package:consignment/core/data/complete/repositories/complete_repository.dart';

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
        final repo = CompleteRepository(
          remote: MockCompleteRemoteDataSource(),
        );
        return CompletePageViewModel(repository: repo);
      },
      child: const _CompletePageView(),
    );
  }
}

class _CompletePageView extends StatelessWidget {
  const _CompletePageView();

  static const double _kTopSpacing = 12.0;
  static const double _kBarHeight = 48.0;

  // 캘린더 드롭다운 높이(디자인/실측에 맞춰 필요 시 조정)
  static const double _kCalendarHeight = 360.0;

  // 로딩바 높이
  static const double _kLoadingHeight = 2.0;

  // 에러 영역(대략적인 안전 높이; 필요 시 조정)
  static const double _kErrorAreaHeight = 52.0;

  double _calcTopPadding({
    required bool calendarOpen,
    required bool isLoading,
    required bool hasError,
  }) {
    double padding = 0;

    // 상단 여백 + 날짜바
    padding += _kTopSpacing + _kBarHeight;

    // 캘린더가 열리면 그 높이만큼
    if (calendarOpen) {
      padding += _kCalendarHeight;
    }

    // 날짜바/캘린더 아래 여백(기존 Column의 SizedBox 12)
    padding += _kTopSpacing;

    // 로딩바가 보이면 그 높이만큼
    if (isLoading) {
      padding += _kLoadingHeight;
    }

    // 에러가 보이면 에러 영역 높이만큼
    if (hasError) {
      padding += _kErrorAreaHeight;
    }

    return padding;
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CompletePageViewModel>();

    final bool hasError = vm.errorMessage != null;
    final double topPadding = _calcTopPadding(
      calendarOpen: vm.isCalendarOpen,
      isLoading: vm.isLoading,
      hasError: hasError,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            // -------------------------------
            // (1) 아래 레이어: 운행내역 스크롤
            // -------------------------------
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.only(top: topPadding),
                child: SingleChildScrollView(
                  child: DrivingHistoryTableTemplate(
                    histories: vm.histories,
                  ),
                ),
              ),
            ),

            // -------------------------------
            // (2) 위 레이어: 날짜바 + 캘린더 + 로딩/에러 (최상단)
            // -------------------------------
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: Column(
                children: [
                  const SizedBox(height: _kTopSpacing),

                  DateRangeQueryBar(
                    startDateText: vm.startDateText,
                    endDateText: vm.endDateText,
                    onTapStartDate: () {
                      context.read<CompletePageViewModel>().openCalendar(DateFieldMode.start);
                    },
                    onTapEndDate: () {
                      context.read<CompletePageViewModel>().openCalendar(DateFieldMode.end);
                    },
                    onTapQuery: () async {
                      final readVm = context.read<CompletePageViewModel>();
                      await readVm.query();
                      readVm.closeCalendar();
                    },
                  ),

                  // 캘린더 영역은 "항상 동일한 높이"를 갖도록 고정
                  // (열릴 때만 AnimatedSwitcher로 표시)
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: vm.isCalendarOpen
                        ? SizedBox(
                      key: const ValueKey('calendar-open'),
                      height: _kCalendarHeight,
                      child: DateRangeCalendarDropdown(
                        focusedMonth: vm.focusedMonth,
                        startDate: vm.startDate,
                        endDate: vm.endDate,
                        mode: vm.activeField,
                        onPrevMonth: () => context.read<CompletePageViewModel>().prevMonth(),
                        onNextMonth: () => context.read<CompletePageViewModel>().nextMonth(),
                        onSelectDate: (picked) => context.read<CompletePageViewModel>().selectDate(picked),
                      ),
                    )
                        : const SizedBox(key: ValueKey('calendar-closed')),
                  ),

                  const SizedBox(height: _kTopSpacing),

                  if (vm.isLoading) const LinearProgressIndicator(minHeight: _kLoadingHeight),

                  if (hasError)
                    SizedBox(
                      height: _kErrorAreaHeight,
                      child: Padding(
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
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
