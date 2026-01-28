import 'package:flutter/material.dart';

import 'package:consignment/core/data/network/api_exception.dart';
import 'package:consignment/core/data/repositories/auth_repository.dart';
import 'package:consignment/core/data/repositories/health_repository.dart';
import 'package:consignment/src/features/login/config/phone_utils.dart';

class LoginViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;
  final HealthRepository _healthRepository;

  final TextEditingController phoneController = TextEditingController();

  bool _isLoading = false;
  bool _isPinging = false;

  String? _errorMessage;

  LoginViewModel({
    required AuthRepository authRepository,
    required HealthRepository healthRepository,
  })  : _authRepository = authRepository,
        _healthRepository = healthRepository {
    phoneController.addListener(_onPhoneChanged);
  }

  void _onPhoneChanged() {
    notifyListeners();
  }

  bool get hasText => phoneController.text.isNotEmpty;

  bool get isValidPhone => isValidKoreanPhone(phoneController.text);

  bool get isLoading => _isLoading;

  bool get isPinging => _isPinging;

  String? get errorMessage => _errorMessage;

  void clearPhone() {
    phoneController.clear();
  }

  Future<bool> login() async {
    if (_isLoading) return false;

    _setLoading(true);
    _errorMessage = null;

    try {
      final phone = phoneController.text.trim();

      await _authRepository.login(phone: phone);

      _setLoading(false);
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      _setLoading(false);
      return false;
    } catch (_) {
      _errorMessage = '알 수 없는 오류가 발생했습니다.';
      _setLoading(false);
      return false;
    }
  }

  Future<String?> ping() async {
    if (_isPinging) return null;

    _isPinging = true;
    notifyListeners();

    try {
      final message = await _healthRepository.ping();
      _isPinging = false;
      notifyListeners();
      return message;
    } on ApiException catch (e) {
      _isPinging = false;
      notifyListeners();
      _errorMessage = e.message;
      return null;
    } catch (_) {
      _isPinging = false;
      notifyListeners();
      _errorMessage = '서버 연결 확인 중 오류가 발생했습니다.';
      return null;
    }
  }

  String _normalizePhone(String input) {
    final digitsOnly = input.replaceAll(RegExp(r'[^0-9]'), '');
    return digitsOnly;
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    phoneController.removeListener(_onPhoneChanged);
    phoneController.dispose();
    super.dispose();
  }
}
