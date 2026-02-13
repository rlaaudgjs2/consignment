import 'package:flutter/foundation.dart';
import 'date_range_types.dart';

class DateRangeController extends ChangeNotifier {
  DateRangeController({
    DateTime? startDate,
    DateTime? endDate,
    DateTime? focusedMonth,
    DateFieldMode activeField = DateFieldMode.start,
    bool isCalendarOpen = false,
  })  : _startDate = _normalizeDate(startDate ?? DateTime.now()),
        _endDate = _normalizeDate(endDate ?? DateTime.now()),
        _focusedMonth = DateTime(
          (focusedMonth ?? DateTime.now()).year,
          (focusedMonth ?? DateTime.now()).month,
          1,
        ),
        _activeField = activeField,
        _isCalendarOpen = isCalendarOpen {
    if (_endDate.isBefore(_startDate)) {
      _endDate = _startDate;
    }
  }

  DateTime _startDate;
  DateTime _endDate;

  DateFieldMode _activeField;
  bool _isCalendarOpen;
  DateTime _focusedMonth;

  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;
  DateFieldMode get activeField => _activeField;
  bool get isCalendarOpen => _isCalendarOpen;
  DateTime get focusedMonth => _focusedMonth;

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

  void setRange({required DateTime start, required DateTime end}) {
    _startDate = _normalizeDate(start);
    _endDate = _normalizeDate(end);

    if (_endDate.isBefore(_startDate)) {
      _endDate = _startDate;
    }

    final base = (_activeField == DateFieldMode.start) ? _startDate : _endDate;
    _focusedMonth = DateTime(base.year, base.month, 1);

    notifyListeners();
  }

  static DateTime _normalizeDate(DateTime d) => DateTime(d.year, d.month, d.day);
}
