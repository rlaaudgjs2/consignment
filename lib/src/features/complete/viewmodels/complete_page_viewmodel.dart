import 'package:flutter/foundation.dart';

import 'package:consignment/core/data/complete/domain/driving_history.dart';
import 'package:consignment/core/data/complete/repositories/complete_repository.dart';

enum DateFieldMode {
  start,
  end,
}

class CompletePageViewModel extends ChangeNotifier {
  final CompleteRepository repository;

  CompletePageViewModel({
    required this.repository,
  }) {
    _init();
  }

  // -----------------------
  // Date Range State
  // -----------------------
  DateTime _startDate = DateTime(2025, 11, 22);
  DateTime _endDate = DateTime(2025, 11, 22);

  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;

  String get startDateText => _formatDate(_startDate);
  String get endDateText => _formatDate(_endDate);

  // -----------------------
  // Calendar Dropdown UI State
  // -----------------------
  bool _isCalendarOpen = false;
  DateFieldMode _activeField = DateFieldMode.start;
  DateTime _focusedMonth = DateTime(2025, 11, 1);

  bool get isCalendarOpen => _isCalendarOpen;
  DateFieldMode get activeField => _activeField;
  DateTime get focusedMonth => _focusedMonth;

  // -----------------------
  // Data State
  // -----------------------
  final List<DrivingHistory> _histories = [];
  List<DrivingHistory> get histories => List.unmodifiable(_histories);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> _init() async {
    // 최초 로딩
    await query();
  }

  // -----------------------
  // Calendar controls
  // -----------------------
  void openCalendar(DateFieldMode field) {
    print('openCalendar: $field');
    _activeField = field;
    _isCalendarOpen = true;

    // 포커스 달은 해당 필드 날짜가 속한 달로 맞춤
    final base = (field == DateFieldMode.start) ? _startDate : _endDate;
    _focusedMonth = DateTime(base.year, base.month, 1);

    notifyListeners();
  }

  void closeCalendar() {
    if (!_isCalendarOpen) return;
    _isCalendarOpen = false;
    notifyListeners();
  }

  void prevMonth() {
    _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1, 1);
    notifyListeners();
  }

  void nextMonth() {
    _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 1);
    notifyListeners();
  }

  /// 캘린더에서 날짜를 눌렀을 때
  /// 정책:
  /// - start 선택 -> startDate 갱신 후 즉시 end 선택 모드로 전환(캘린더 유지)
  /// - end 선택 -> endDate 갱신 후 캘린더 닫힘
  /// - end < start -> end = start 로 보정
  void selectDate(DateTime picked) {
    final normalized = _normalizeDate(picked);

    if (_activeField == DateFieldMode.start) {
      _startDate = normalized;

      // start 선택 후 end 캘린더를 바로 띄우기 위해
      // end가 start보다 빠르면 end를 start로 맞춰두고,
      // activeField를 end로 전환 + focusedMonth를 end 기준으로 세팅.
      if (_endDate.isBefore(_startDate)) {
        _endDate = _startDate;
      }

      _activeField = DateFieldMode.end;
      _focusedMonth = DateTime(_endDate.year, _endDate.month, 1);
      _isCalendarOpen = true;

      notifyListeners();
      return;
    }

    // activeField == end
    _endDate = normalized;

    // end < start => end = start (요청 정책)
    if (_endDate.isBefore(_startDate)) {
      _endDate = _startDate;
    }

    _isCalendarOpen = false;
    notifyListeners();
  }

  // -----------------------
  // Query / Data
  // -----------------------
  Future<void> query() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await repository.fetchDrivingHistories(
        startDate: _startDate,
        endDate: _endDate,
      );

      _histories
        ..clear()
        ..addAll(result);
    } catch (e) {
      _errorMessage = '조회에 실패했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // -----------------------
  // Helpers
  // -----------------------
  DateTime _normalizeDate(DateTime date) => DateTime(date.year, date.month, date.day);

  String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}
