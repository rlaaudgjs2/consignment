import 'package:flutter/services.dart';

/// 한국 휴대전화 번호(010 포함)인지 간단히 검사하는 유틸.
/// - 숫자만 남겼을 때 길이가 11자리면 유효한 번호라고 가정.
bool isValidKoreanPhone(String input) {
  final digitsOnly = input.replaceAll(RegExp(r'\D'), '');
  return digitsOnly.length == 11;
}

/// 010-1234-5678 형식으로 자동 하이픈을 넣어주는 포맷터.
/// TextField의 inputFormatters에 넣어서 사용.
class KoreanPhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // 숫자만 추출
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 11) {
      digits = digits.substring(0, 11);
    }

    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i == 3 || i == 7) buffer.write('-'); // 010-1234-5678 포맷
      buffer.write(digits[i]);
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
