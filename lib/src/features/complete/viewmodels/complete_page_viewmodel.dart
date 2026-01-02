import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:consignment/core/data/domain/driving_history.dart';
import 'package:consignment/core/data/repositories/complete_repository.dart';

import 'package:consignment/src/components/driving_detail_modal.dart';

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

  DateTime _startDate = DateTime(2025, 11, 22);
  DateTime _endDate = DateTime(2025, 11, 22);

  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;

  String get startDateText => _formatDate(_startDate);
  String get endDateText => _formatDate(_endDate);

  bool _isCalendarOpen = false;
  DateFieldMode _activeField = DateFieldMode.start;
  DateTime _focusedMonth = DateTime(2025, 11, 1);

  bool get isCalendarOpen => _isCalendarOpen;
  DateFieldMode get activeField => _activeField;
  DateTime get focusedMonth => _focusedMonth;

  final List<DrivingHistory> _histories = [];
  List<DrivingHistory> get histories => List.unmodifiable(_histories);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> _init() async {
    await query();
  }

  void openCalendar(DateFieldMode field) {
    _activeField = field;
    _isCalendarOpen = true;

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

  void selectDate(DateTime picked) {
    final normalized = _normalizeDate(picked);

    if (_activeField == DateFieldMode.start) {
      _startDate = normalized;

      if (_endDate.isBefore(_startDate)) {
        _endDate = _startDate;
      }

      _activeField = DateFieldMode.end;
      _focusedMonth = DateTime(_endDate.year, _endDate.month, 1);
      _isCalendarOpen = true;

      notifyListeners();
      return;
    }

    _endDate = normalized;

    if (_endDate.isBefore(_startDate)) {
      _endDate = _startDate;
    }

    _isCalendarOpen = false;
    notifyListeners();
  }

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
        fareText: _formatWon(detail.price),
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

  DateTime _normalizeDate(DateTime date) => DateTime(date.year, date.month, date.day);

  String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  String _formatWon(int won) {
    final s = won.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final idxFromEnd = s.length - i;
      buf.write(s[i]);
      if (idxFromEnd > 1 && idxFromEnd % 3 == 1) {
        buf.write(',');
      }
    }
    return '${buf.toString()}원';
  }
}
