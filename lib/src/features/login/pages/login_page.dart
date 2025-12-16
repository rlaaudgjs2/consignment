import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:consignment/core/utils/phone_utils.dart';
import 'package:consignment/src/features/root/pages/root_tab_page.dart';
import 'package:consignment/core/widgets/app_toast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();

  // 로그인 페이지에서만 사용하는 색상 상수
  static const Color _mainColor = Color(0xFFFBB35F); // MOBI 메인 컬러
  static const Color _blackTextColor = Color(0xFF3B3B3B);
  static const Color _inputBgColor = Color(0xFFF6F6F4);
  static const Color _placeholderColor = Color(0xFFDEDBD0);
  static const Color _iconGray = Color(0xFFB3B3B3);

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(() {
      // 입력할 때마다 X 아이콘 / 버튼 활성화 상태 갱신
      setState(() {});
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  bool get _hasText => _phoneController.text.isNotEmpty;

  // core/utils/phone_utils.dart 의 유틸 활용
  bool get _isValidPhone => isValidKoreanPhone(_phoneController.text);

  void _clearPhone() {
    _phoneController.clear();
  }

  void _onConfirmPressed(BuildContext context) {
    if (!_isValidPhone) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('올바른 전화번호를 입력해주세요.')),
      // );
      AppToast.show(context, '올바른 전화번호를 입력해주세요.');
      return;
    }

    AppToast.show(context, '로그인 되었습니다.');

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const RootTabPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          // 키보드 올라와도 내용이 잘 보이도록 아래쪽 여유
          padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(
            bottom: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80), // 상단 여백 (MOBI 위치)

              // MOBI 로고
              const Center(
                child: Text(
                  'MOBI',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Tsukimi Rounded', // 폰트 없으면 제거 가능
                    height: 1.0,
                    letterSpacing: 0,
                    color: _mainColor,
                  ),
                ),
              ),
              const SizedBox(height: 56),

              // "전화번호를 입력해주세요"
              const Center(
                child: Text(
                  '전화번호를 입력해주세요',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Pretendard',
                    height: 1.0,
                    letterSpacing: 0,
                    color: _blackTextColor,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 전화번호 입력 필드
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: _inputBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    KoreanPhoneNumberFormatter(), // 공통 유틸에서 가져온 포맷터
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
                    suffixIcon: _hasText
                        ? IconButton(
                      onPressed: _clearPhone,
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
              ),

              const SizedBox(height: 40), // 밑에 살짝 여백
            ],
          ),
        ),
      ),

      // 하단 확인 버튼
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            0,
            20,
            16 + bottomInset, // 키보드 올라오면 버튼도 위로
          ),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed:
              _isValidPhone ? () => _onConfirmPressed(context) : null,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: _mainColor,
                disabledBackgroundColor: _mainColor.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                '확인',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Pretendard',
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
