import 'package:flutter/material.dart';
import 'package:consignment/src/features/login/config/phone_utils.dart';

class LoginViewModel extends ChangeNotifier {
  final TextEditingController phoneController = TextEditingController();

  LoginViewModel() {
    phoneController.addListener(_onPhoneChanged);
  }

  void _onPhoneChanged() {
    notifyListeners();
  }

  bool get hasText => phoneController.text.isNotEmpty;

  bool get isValidPhone => isValidKoreanPhone(phoneController.text);

  void clearPhone() {
    phoneController.clear();
  }

  @override
  void dispose() {
    phoneController.removeListener(_onPhoneChanged);
    phoneController.dispose();
    super.dispose();
  }
}
