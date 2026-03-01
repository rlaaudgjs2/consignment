import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:consignment/core/data/repositories/auth_repository.dart';
import 'package:consignment/core/data/repositories/health_repository.dart';

import 'package:consignment/src/features/login/viewmodels/login_view_model.dart';
import 'package:consignment/src/features/login/widgets/login_logo.dart';
import 'package:consignment/src/features/login/widgets/phone_input_field.dart';
import 'package:consignment/src/features/login/widgets/confirm_button.dart';

import 'package:consignment/src/features/root/pages/root_tab_page.dart';
import 'package:consignment/src/components/app_toast.dart';

// ✅ 추가: 임시 회원가입 페이지 import
import 'package:consignment/src/features/login/pages/temp_signup_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static const Color _blackTextColor = Color(0xFF3B3B3B);
  static const Color _primary = Color(0xFFF2B36A);

  Future<void> _onPingPressed(BuildContext context, LoginViewModel vm) async {
    if (vm.isPinging) return;

    final message = await vm.ping();

    if (!context.mounted) return;

    if (message != null && message.isNotEmpty) {
      AppToast.show(context, '서버 연결 OK: $message');
    } else {
      AppToast.show(context, vm.errorMessage ?? '서버 연결에 실패했습니다.');
    }
  }

  Future<void> _onConfirmPressed(BuildContext context, LoginViewModel vm) async {
    if (!vm.isValidPhone) {
      AppToast.show(context, '올바른 전화번호를 입력해주세요.');
      return;
    }

    if (vm.isLoading) return;

    final ok = await vm.login();

    if (!context.mounted) return;

    if (ok) {
      AppToast.show(context, '로그인 되었습니다.');

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const RootTabPage(),
        ),
      );
    } else {
      AppToast.show(context, vm.errorMessage ?? '로그인에 실패했습니다.');
    }
  }

  void _goTempSignup(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TempSignupPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginViewModel>(
      create: (ctx) => LoginViewModel(
        authRepository: ctx.read<AuthRepository>(),
        healthRepository: ctx.read<HealthRepository>(),
      ),
      child: Builder(
        builder: (context) {
          final vm = context.watch<LoginViewModel>();

          return Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(
                  bottom: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 80),
                    const LoginLogo(),
                    const SizedBox(height: 56),
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
                    PhoneInputField(
                      controller: vm.phoneController,
                      hasText: vm.hasText,
                      onClear: vm.clearPhone,
                    ),

                    // ✅ 추가: 전화번호 입력 필드 바로 아래 "임시 회원가입" 밑줄 텍스트
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () => _goTempSignup(context),
                        borderRadius: BorderRadius.circular(6),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 6),
                          child: Text(
                            '임시 회원가입',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: _primary,
                              decoration: TextDecoration.underline,
                              decorationThickness: 1.2,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ✅ 서버 연결 테스트 버튼 (개발용)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: vm.isPinging ? null : () => _onPingPressed(context, vm),
                        child: Text(
                          vm.isPinging ? '서버 연결 확인 중...' : '서버 연결 테스트',
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    if (vm.isLoading) ...[
                      const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ],
                ),
              ),
            ),
            bottomNavigationBar: ConfirmButton(
              enabled: vm.isValidPhone && !vm.isLoading,
              onPressed: () => _onConfirmPressed(context, vm),
            ),
          );
        },
      ),
    );
  }
}
