import 'package:flutter/foundation.dart';

import 'package:consignment/core/data/settlement/domain/settlement_withdraw_session.dart';
import 'package:consignment/core/data/settlement/domain/settlement_withdraw_sms_result.dart';
import 'package:consignment/core/data/settlement/domain/settlement_withdraw_submit_result.dart';
import 'package:consignment/core/data/settlement/repositories/settlement_repository.dart';

class SettlementWithdrawVerifyViewModel extends ChangeNotifier {
  final SettlementRepository _repository;
  final SettlementWithdrawSession session;

  SettlementWithdrawVerifyViewModel({
    required SettlementRepository repository,
    required this.session,
  }) : _repository = repository;

  String _phoneNumber = '010-1234-5678';
  String get phoneNumber => _phoneNumber;

  String _code = '';
  String get code => _code;

  bool _smsRequested = false;
  bool get smsRequested => _smsRequested;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  int _smsFeeAmount = 20;
  int get smsFeeAmount => _smsFeeAmount;

  bool get canSubmit => _smsRequested && _code.trim().isNotEmpty && !_isLoading;

  void setPhoneNumber(String v) {
    _phoneNumber = v;
    notifyListeners();
  }

  void setCode(String v) {
    _code = v;
    notifyListeners();
  }

  Future<SettlementWithdrawSmsResult> requestSms() async {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _repository.requestWithdrawSms(
        sessionId: session.sessionId,
        phoneNumber: _phoneNumber,
      );

      _smsFeeAmount = result.smsFeeAmount;
      _smsRequested = result.success;

      if (!result.success) {
        _errorMessage = result.message;
      }

      return result;
    } catch (e) {
      _errorMessage = 'SMS 요청 중 오류가 발생했습니다.';
      return const SettlementWithdrawSmsResult(
        success: false,
        message: 'SMS 요청 중 오류가 발생했습니다.',
        smsFeeAmount: 20,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<SettlementWithdrawSubmitResult> submit() async {
    _errorMessage = null;
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _repository.submitWithdraw(
        sessionId: session.sessionId,
        phoneNumber: _phoneNumber,
        code: _code,
      );

      if (!result.success) {
        _errorMessage = result.message;
      }

      return result;
    } catch (e) {
      _errorMessage = '출금 요청 중 오류가 발생했습니다.';
      return const SettlementWithdrawSubmitResult(
        success: false,
        message: '출금 요청 중 오류가 발생했습니다.',
        receiptId: null,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
