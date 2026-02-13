import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'temp_signup_complete_page.dart';

class TempSignupPage extends StatefulWidget {
  const TempSignupPage({super.key});

  @override
  State<TempSignupPage> createState() => _TempSignupPageState();
}

class _TempSignupPageState extends State<TempSignupPage> {
  static const _bg = Color(0xFFFFFFFF);
  static const _text = Color(0xFF333333);
  static const _sub = Color(0xFF828282);
  static const _primary = Color(0xFFF2B36A);

  final _nameController = TextEditingController();
  final _birthController = TextEditingController();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();

  bool _isOtpRequested = false;

  @override
  void dispose() {
    _nameController.dispose();
    _birthController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  bool get _canRequestOtp {
    final phoneDigits = _phoneController.text.replaceAll(RegExp(r'\D'), '');
    return phoneDigits.length >= 10;
  }

  bool get _canSubmit {
    final name = _nameController.text.trim();
    final birth = _birthController.text.trim();
    final phoneDigits = _phoneController.text.replaceAll(RegExp(r'\D'), '');
    final otp = _otpController.text.trim();

    return name.isNotEmpty &&
        birth.length == 10 &&
        phoneDigits.length >= 10 &&
        _isOtpRequested &&
        otp.length == 6;
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final initial = DateTime(now.year - 25, 1, 1);

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900, 1, 1),
      lastDate: DateTime(now.year, now.month, now.day),
      helpText: '생년월일 선택',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: _primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return;

    final mm = picked.month.toString().padLeft(2, '0');
    final dd = picked.day.toString().padLeft(2, '0');
    _birthController.text = '${picked.year}-$mm-$dd';
    setState(() {});
  }

  void _requestOtp() {
    setState(() {
      _isOtpRequested = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('인증번호가 전송되었습니다.')),
    );
  }

  void _submitTempSignup() {
    if (!_canSubmit) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TempSignupCompletePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        title: const Text(
          '임시 회원가입',
          style: TextStyle(
            color: _text,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        iconTheme: const IconThemeData(color: _text),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _WarningCard(),
              const SizedBox(height: 18),

              const _Label('이름'),
              const SizedBox(height: 8),
              _Input(
                controller: _nameController,
                hint: '이름 입력',
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),

              const _Label('생년월일'),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickBirthDate,
                child: AbsorbPointer(
                  child: _Input(
                    controller: _birthController,
                    hint: 'YYYY-MM-DD',
                    suffixIcon: const Icon(Icons.calendar_month_rounded),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              const _Label('휴대폰번호'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _Input(
                      controller: _phoneController,
                      hint: '010-0000-0000',
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9-]')),
                      ],
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: _canRequestOtp ? _requestOtp : null,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: _primary, width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                      ),
                      child: const Text(
                        '인증번호 받기',
                        style: TextStyle(
                          color: _primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              const _Label('SMS 인증번호 (OTP)'),
              const SizedBox(height: 8),
              _Input(
                controller: _otpController,
                hint: '000000',
                keyboardType: TextInputType.number,
                enabled: _isOtpRequested,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                onChanged: (_) => setState(() {}),
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _canSubmit ? _submitTempSignup : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primary,
                    disabledBackgroundColor: _primary.withOpacity(0.35),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '임시 가입하기',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _isOtpRequested
                    ? '인증번호 입력 후 임시 가입을 완료해주세요.'
                    : '인증번호를 먼저 요청해주세요.',
                style: const TextStyle(fontSize: 12, color: _sub),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WarningCard extends StatelessWidget {
  const _WarningCard();

  static const _card = Color(0xFFF6F6F6);
  static const _primary = Color(0xFFF2B36A);
  static const _text = Color(0xFF333333);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '주의사항',
            style: TextStyle(
              color: _primary,
              fontWeight: FontWeight.w900,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 6),
          Text(
            '이 회원가입 절차는 정식 가입이 아니며,\n사무실 등록 후 실제 이용이 가능합니다.',
            style: TextStyle(
              color: _text,
              fontWeight: FontWeight.w600,
              fontSize: 13,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        color: Color(0xFF333333),
      ),
    );
  }
}

class _Input extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool enabled;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;

  const _Input({
    required this.controller,
    required this.hint,
    this.enabled = true,
    this.keyboardType,
    this.inputFormatters,
    this.suffixIcon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Color(0xFFE8E8E8), width: 1),
    );

    return SizedBox(
      height: 48,
      child: TextField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFFBDBDBD),
            fontWeight: FontWeight.w600,
          ),
          filled: true,
          fillColor: enabled ? Colors.white : const Color(0xFFF2F2F2),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: border,
          enabledBorder: border,
          disabledBorder: border,
          focusedBorder: border.copyWith(
            borderSide: const BorderSide(color: Color(0xFFF2B36A), width: 1),
          ),
          suffixIcon: suffixIcon == null
              ? null
              : Padding(
            padding: const EdgeInsets.only(right: 6),
            child: IconTheme(
              data: const IconThemeData(color: Color(0xFFBDBDBD)),
              child: suffixIcon!,
            ),
          ),
        ),
      ),
    );
  }
}
