import 'package:flutter/material.dart';

import 'package:consignment/core/data/domain/settlement_daily_summary.dart';
import 'package:consignment/core/data/domain/settlement_transaction.dart';
import 'package:consignment/core/data/domain/settlement_wallet.dart';
import 'package:consignment/core/data/domain/settlement_transaction_detail.dart';
import 'package:consignment/core/data/repositories/settlement_repository.dart';

import 'package:consignment/src/components/driving_fee_detail_modal.dart';
import 'package:consignment/src/components/settlement_etc_detail_modal.dart';

import 'package:consignment/src/utils/date_range_controller.dart';
import 'package:consignment/src/utils/date_range_types.dart';
import 'package:consignment/src/utils/formatters.dart';

enum SettlementSubTab {
  dailyIncome,
  transactions,
  wallet,
}

class SettlementViewModel extends ChangeNotifier {
  final SettlementRepository _repository;

  /// ✅ 공통 캘린더/기간 컨트롤러
  final DateRangeController dateRange;

  SettlementViewModel({
    required SettlementRepository repository,
  })  : _repository = repository,
        dateRange = DateRangeController(
          startDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
          endDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
          focusedMonth: DateTime(DateTime.now().year, DateTime.now().month, 1),
          activeField: DateFieldMode.start,
          isCalendarOpen: false,
        ) {
    dateRange.addListener(_onDateRangeChanged);
  }

  void _onDateRangeChanged() {
    notifyListeners();
  }

  SettlementSubTab _activeTab = SettlementSubTab.dailyIncome;
  SettlementSubTab get activeTab => _activeTab;

  DateTime get focusedMonth => dateRange.focusedMonth;
  DateTime get startDate => dateRange.startDate;
  DateTime get endDate => dateRange.endDate;
  DateFieldMode get activeField => dateRange.activeField;
  bool get isCalendarOpen => dateRange.isCalendarOpen;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  SettlementDailySummary? _dailySummary;
  SettlementDailySummary? get dailySummary => _dailySummary;

  List<SettlementTransaction> _transactions = const <SettlementTransaction>[];
  List<SettlementTransaction> get transactions => _transactions;

  SettlementWallet? _wallet;
  SettlementWallet? get wallet => _wallet;

  String get startDateText => Formatters.ymd(startDate);
  String get endDateText => Formatters.ymd(endDate);

  String get walletBalanceText {
    final amount = _wallet?.currentBalance ?? 0;
    return Formatters.moneyWon(amount, signed: true);
  }

  bool get hasWallet => _wallet != null;

  void setTab(SettlementSubTab tab) {
    if (_activeTab == tab) return;

    _activeTab = tab;
    _errorMessage = null;

    // 탭 전환 시 캘린더 닫기(이전 로직 유지)
    if (dateRange.isCalendarOpen) {
      dateRange.closeCalendar(); // dateRange가 notify -> VM도 notify -> UI 갱신
    }

    // wallet 탭은 최초 진입 시만 로딩
    if (_activeTab == SettlementSubTab.wallet) {
      if (_wallet == null) {
        queryCurrentTab();
      }
    }

    notifyListeners();
  }

  Future<void> queryCurrentTab() async {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    try {
      if (_activeTab == SettlementSubTab.dailyIncome) {
        _dailySummary = await _repository.fetchDailySummary(
          startDate: startDate,
          endDate: endDate,
        );
      } else if (_activeTab == SettlementSubTab.transactions) {
        _transactions = await _repository.fetchTransactions(
          startDate: startDate,
          endDate: endDate,
        );
      } else {
        _wallet = await _repository.fetchWallet(
          startDate: startDate,
          endDate: endDate,
        );
      }

      // 조회 성공하면 캘린더 닫기(이전 로직 유지)
      if (dateRange.isCalendarOpen) {
        dateRange.closeCalendar();
      }
    } catch (_) {
      _errorMessage = '조회 중 오류가 발생했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> openTransactionDetailModal(
      BuildContext context, {
        required SettlementTransaction tx,
      }) async {
    try {
      final detail = await _repository.fetchTransactionDetail(id: tx.id);

      if (detail.type == SettlementTransactionDetailType.drivingFee) {
        await DrivingFeeDetailModal.show(
          context,
          orderType: detail.orderType!,
          tags: detail.tags,
          dateTimeText: detail.dateTimeText,
          titleText: detail.titleText,
          amountWon: detail.amountWon,
          orderNo: detail.orderNo ?? '-',
          startAddress: detail.startAddress ?? '-',
          endAddress: detail.endAddress ?? '-',
          fareText: detail.fareText ?? '-',
        );
        return;
      }

      await SettlementEtcDetailModal.show(
        context,
        dateTimeText: detail.dateTimeText,
        titleText: detail.titleText,
        amountWon: detail.amountWon,
        noteText: detail.noteText ?? '-',
      );
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('상세 조회에 실패했습니다.')),
      );
    }
  }

  @override
  void dispose() {
    dateRange.removeListener(_onDateRangeChanged);
    dateRange.dispose();
    super.dispose();
  }
}
