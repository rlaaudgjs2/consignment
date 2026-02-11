import 'package:flutter/material.dart';

import 'package:consignment/core/data/domain/driving_history.dart';
import 'package:consignment/core/data/repositories/complete_repository.dart';

import 'package:consignment/src/components/driving_detail_modal.dart';
import 'package:consignment/src/utils/date_range_controller.dart';
import 'package:consignment/src/utils/date_range_types.dart';
import 'package:consignment/src/utils/formatters.dart';

class CompletePageViewModel extends ChangeNotifier {
  final CompleteRepository repository;

  /// ✅ 공통 캘린더/기간 컨트롤러
  final DateRangeController dateRange;

  CompletePageViewModel({
    required this.repository,
  }) : dateRange = DateRangeController(
    startDate: DateTime(2025, 11, 22),
    endDate: DateTime(2025, 11, 22),
    focusedMonth: DateTime(2025, 11, 1),
    activeField: DateFieldMode.start,
    isCalendarOpen: false,
  ) {
    // ✅ dateRange 변경이 일어나면 VM도 notify해서 Provider 갱신되게 브릿지
    dateRange.addListener(_onDateRangeChanged);

    _init();
  }

  void _onDateRangeChanged() {
    // dateRange의 notify를 VM이 받아서 다시 notify -> UI가 VM을 구독하므로 갱신됨
    notifyListeners();
  }

  DateTime get startDate => dateRange.startDate;
  DateTime get endDate => dateRange.endDate;

  String get startDateText => Formatters.ymd(startDate);
  String get endDateText => Formatters.ymd(endDate);

  bool get isCalendarOpen => dateRange.isCalendarOpen;
  DateFieldMode get activeField => dateRange.activeField;
  DateTime get focusedMonth => dateRange.focusedMonth;

  final List<DrivingHistory> _histories = <DrivingHistory>[];
  List<DrivingHistory> get histories => List.unmodifiable(_histories);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> _init() async {
    await query();
  }

  Future<void> query() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await repository.fetchDrivingHistories(
        startDate: startDate,
        endDate: endDate,
      );

      _histories
        ..clear()
        ..addAll(result);
    } catch (_) {
      _errorMessage = '조회에 실패했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> openDrivingDetailModal(
      BuildContext context, {
        required String id,
      }) async {
    try {
      final detail = await repository.fetchDrivingHistoryDetail(id: id);

      await DrivingDetailModal.show(
        context,
        orderType: detail.orderType,
        tags: detail.tags,
        clientName: detail.clientName,
        situationRoom: detail.situationRoom,
        startAddress: detail.startAddress,
        endAddress: detail.endAddress,
        fareText: Formatters.moneyWon(detail.price, signed: false),
        fareTypeText: detail.fareTypeText,
        orderNo: detail.orderNo,
        receivedAtText: detail.receivedAtText,
        dispatchedAtText: detail.dispatchedAtText,
        completedAtText: detail.completedAtText,
        carModel: detail.carModel,
        carNumber: detail.carNumber,
      );
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('운행 상세 조회에 실패했습니다.')),
      );
    }
  }

  @override
  void dispose() {
    dateRange.removeListener(_onDateRangeChanged);
    dateRange.dispose(); // DateRangeController가 ChangeNotifier이므로 dispose 권장
    super.dispose();
  }
}
