import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:consignment/src/features/login/config/phone_utils.dart';

class PhoneInputField extends StatelessWidget {
  final TextEditingController controller;
  final bool hasText;
  final VoidCallback onClear;

  const PhoneInputField({
    super.key,
    required this.controller,
    required this.hasText,
    required this.onClear,
  });

  static const Color _blackTextColor = Color(0xFF3B3B3B);
  static const Color _inputBgColor = Color(0xFFF6F6F4);
  static const Color _placeholderColor = Color(0xFFDEDBD0);
  static const Color _iconGray = Color(0xFFB3B3B3);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: _inputBgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          KoreanPhoneNumberFormatter(),
        ],
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: 'Pretendard',
          color: _blackTextColor,
        ),
        decoration: InputDecoration(
          isCollapsed: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          border: InputBorder.none,
          hintText: '전화번호 입력',
          hintStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Pretendard',
            color: _placeholderColor,
          ),
          suffixIcon: hasText
              ? IconButton(
            onPressed: onClear,
            splashRadius: 18,
            icon: const Icon(
              Icons.close,
              size: 18,
              color: _iconGray,
            ),
          )
              : null,
        ),
      ),
    );
  }
}
