import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:consignment/src/features/login/viewmodels/login_view_model.dart';
import 'package:consignment/src/features/login/widgets/login_logo.dart';
import 'package:consignment/src/features/login/widgets/phone_input_field.dart';
import 'package:consignment/src/features/login/widgets/confirm_button.dart';

import 'package:consignment/src/features/root/pages/root_tab_page.dart';
import 'package:consignment/core/widgets/app_toast.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static const Color _blackTextColor = Color(0xFF3B3B3B);

  void _onConfirmPressed(BuildContext context, LoginViewModel vm) {
    if (!vm.isValidPhone) {
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
    return ChangeNotifierProvider<LoginViewModel>(
      create: (_) => LoginViewModel(),
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
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: ConfirmButton(
              enabled: vm.isValidPhone,
              onPressed: () => _onConfirmPressed(context, vm),
            ),
          );
        },
      ),
    );
  }
}
