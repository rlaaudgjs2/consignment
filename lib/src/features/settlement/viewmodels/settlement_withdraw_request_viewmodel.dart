import 'package:flutter/foundation.dart';

import 'package:consignment/core/data/settlement/domain/settlement_withdraw_info.dart';
import 'package:consignment/core/data/settlement/domain/settlement_withdraw_session.dart';
import 'package:consignment/core/data/settlement/repositories/settlement_repository.dart';

class SettlementWithdrawRequestViewModel extends ChangeNotifier {
  final SettlementRepository _repository;

  SettlementWithdrawRequestViewModel({
    required SettlementRepository repository,
  }) : _repository = repository {
    _init();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  SettlementWithdrawInfo? _info;
  SettlementWithdrawInfo? get info => _info;

  int _amount = 10000;
  int get amount => _amount;

  Future<void> _init() async {
    await load();
  }

  Future<void> load() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.fetchWithdrawInfo();
      _info = result;

      // 최소 단위로 초기화
      final unit = _info?.unitAmount ?? 10000;
      _amount = unit;
    } catch (e) {
      _errorMessage = '출금 정보를 불러오지 못했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  int get unitAmount => _info?.unitAmount ?? 10000;
  int get availableAmount => _info?.availableAmount ?? 0;

  bool get canMinus => _amount > unitAmount;
  bool get canPlus => (_amount + unitAmount) <= availableAmount;

  void increase() {
    if (!canPlus) return;
    _amount += unitAmount;
    notifyListeners();
  }

  void decrease() {
    if (!canMinus) return;
    _amount -= unitAmount;
    notifyListeners();
  }

  void reset() {
    _amount = unitAmount;
    notifyListeners();
  }

  /// ✅ prepareWithdraw 삭제
  /// ✅ "출금" 버튼 누르면 서버 세션 생성(createWithdrawSession)하고 그걸 Verify 화면에 넘김
  Future<SettlementWithdrawSession?> createSession() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final session = await _repository.createWithdrawSession(amount: _amount);
      return session;
    } catch (e) {
      _errorMessage = '출금 세션 생성 중 오류가 발생했습니다.';
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
