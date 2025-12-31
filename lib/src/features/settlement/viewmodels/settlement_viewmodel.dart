import 'package:flutter/foundation.dart';

// ✅ complete의 DateFieldMode를 그대로 사용
import 'package:consignment/src/features/complete/viewmodels/complete_page_viewmodel.dart';

import 'package:consignment/core/data/settlement/domain/settlement_daily_summary.dart';
import 'package:consignment/core/data/settlement/domain/settlement_transaction.dart';
import 'package:consignment/core/data/settlement/domain/settlement_wallet.dart';
import 'package:consignment/core/data/settlement/repositories/settlement_repository.dart';

enum SettlementSubTab {
  dailyIncome,
  transactions,
  wallet,
}

class SettlementViewModel extends ChangeNotifier {
  final SettlementRepository _repository;

  SettlementViewModel({
    required SettlementRepository repository,
  }) : _repository = repository;

  SettlementSubTab _activeTab = SettlementSubTab.dailyIncome;
  SettlementSubTab get activeTab => _activeTab;

  DateTime _focusedMonth = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime get focusedMonth => _focusedMonth;

  DateTime _startDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime get startDate => _startDate;

  DateTime _endDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime get endDate => _endDate;

  DateFieldMode _activeField = DateFieldMode.start;
  DateFieldMode get activeField => _activeField;

  bool _isCalendarOpen = false;
  bool get isCalendarOpen => _isCalendarOpen;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  SettlementDailySummary? _dailySummary;
  SettlementDailySummary? get dailySummary => _dailySummary;

  List<SettlementTransaction> _transactions = const [];
  List<SettlementTransaction> get transactions => _transactions;

  SettlementWallet? _wallet;
  SettlementWallet? get wallet => _wallet;

  String get startDateText => _formatYMD(_startDate);
  String get endDateText => _formatYMD(_endDate);

  /// ✅ "현재 잔액" 표시용 텍스트
  String get walletBalanceText {
    final amount = _wallet?.currentBalance ?? 0;
    return '${_formatMoney(amount)}원';
  }

  bool get hasWallet => _wallet != null;

  void setTab(SettlementSubTab tab) {
    if (_activeTab == tab) return;

    _activeTab = tab;
    _isCalendarOpen = false;
    _errorMessage = null;

    // ✅ 내 지갑 탭으로 진입하면 자동 조회
    if (_activeTab == SettlementSubTab.wallet) {
      if (_wallet == null) {
        queryCurrentTab();
      }
    }

    notifyListeners();
  }

  void openCalendar(DateFieldMode mode) {
    _activeField = mode;
    _isCalendarOpen = true;

    final base = (mode == DateFieldMode.start) ? _startDate : _endDate;
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
    final normalized = DateTime(picked.year, picked.month, picked.day);

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

  Future<void> queryCurrentTab() async {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    try {
      if (_activeTab == SettlementSubTab.dailyIncome) {
        _dailySummary = await _repository.fetchDailySummary(
          startDate: _startDate,
          endDate: _endDate,
        );
      } else if (_activeTab == SettlementSubTab.transactions) {
        _transactions = await _repository.fetchTransactions(
          startDate: _startDate,
          endDate: _endDate,
        );
      } else {
        _wallet = await _repository.fetchWallet(
          startDate: _startDate,
          endDate: _endDate,
        );
      }

      _isCalendarOpen = false;
    } catch (e) {
      _errorMessage = '조회 중 오류가 발생했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _formatYMD(DateTime dt) {
    final y = dt.year.toString();
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  String _formatMoney(int value) {
    final s = value.abs().toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final idxFromEnd = s.length - i;
      buf.write(s[i]);
      if (idxFromEnd > 1 && idxFromEnd % 3 == 1) {
        buf.write(',');
      }
    }
    final out = buf.toString();
    return value < 0 ? '-$out' : out;
  }
}
