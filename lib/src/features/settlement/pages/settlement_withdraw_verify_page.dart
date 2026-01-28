import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:consignment/core/data/domain/settlement_withdraw_session.dart';
import 'package:consignment/core/data/repositories/settlement_repository.dart';
import '../viewmodels/settlement_withdraw_verify_viewmodel.dart';

class SettlementWithdrawVerifyPage extends StatefulWidget {
  final SettlementRepository repository;
  final SettlementWithdrawSession session;

  const SettlementWithdrawVerifyPage({
    super.key,
    required this.repository,
    required this.session,
  });

  @override
  State<SettlementWithdrawVerifyPage> createState() => _SettlementWithdrawVerifyPageState();
}

class _SettlementWithdrawVerifyPageState extends State<SettlementWithdrawVerifyPage> {
  static const _bg = Color(0xFFF6F6F6);
  static const _text = Color(0xFF333333);
  static const _sub = Color(0xFF828282);
  static const _primary = Color(0xFFF2B36A);

  late final TextEditingController _phoneController;
  late final TextEditingController _codeController;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: '010-1234-5678');
    _codeController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettlementWithdrawVerifyViewModel>(
      create: (_) => SettlementWithdrawVerifyViewModel(
        repository: widget.repository,
        session: widget.session,
      )..setPhoneNumber(_phoneController.text),
      child: _SettlementWithdrawVerifyView(
        phoneController: _phoneController,
        codeController: _codeController,
      ),
    );
  }
}

class _SettlementWithdrawVerifyView extends StatelessWidget {
  final TextEditingController phoneController;
  final TextEditingController codeController;

  const _SettlementWithdrawVerifyView({
    required this.phoneController,
    required this.codeController,
  });

  static const _bg = Color(0xFFF6F6F6);
  static const _text = Color(0xFF333333);
  static const _sub = Color(0xFF828282);
  static const _primary = Color(0xFFF2B36A);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SettlementWithdrawVerifyViewModel>();
    final session = vm.session;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 16,
        title: const Text(
          '출금인증',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 1.0,
            color: _text,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            if (vm.isLoading) const LinearProgressIndicator(minHeight: 2),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '출금 정보',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        height: 1.0,
                        color: _sub,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${session.bankName} : ${session.accountNumber}\n'
                          '예금주 : ${session.depositorName}\n'
                          '금액 : ${_money(session.amount)}원',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 1.35,
                        color: _text,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '위의 정보로 출금을 시도합니다.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                        color: _text,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'SMS 인증시 SMS금액 ${vm.smsFeeAmount}원이 차감됩니다.',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                        color: Color(0xFFFF7A6B),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 44,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F1F1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.centerLeft,
                            child: TextField(
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              onChanged: vm.setPhoneNumber,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isCollapsed: true,
                              ),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                height: 1.0,
                                color: _sub,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          height: 44,
                          child: OutlinedButton(
                            onPressed: vm.isLoading
                                ? null
                                : () async {
                              final result = await context.read<SettlementWithdrawVerifyViewModel>().requestSms();
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(result.message)),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: _primary, width: 1.2),
                              foregroundColor: _primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'SMS 인증',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                height: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    if (vm.errorMessage != null)
                      Text(
                        vm.errorMessage!,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                          color: Color(0xFFE53935),
                        ),
                      ),

                    const SizedBox(height: 18),

                    const Text(
                      '인증번호 입력',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        height: 1.0,
                        color: _text,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F1F1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.centerLeft,
                      child: TextField(
                        controller: codeController,
                        keyboardType: TextInputType.number,
                        onChanged: vm.setCode,
                        decoration: const InputDecoration(
                          hintText: '인증번호 입력',
                          hintStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            height: 1.0,
                            color: Color(0xFFBDBDBD),
                          ),
                          border: InputBorder.none,
                          isCollapsed: true,
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.0,
                          color: _text,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: OutlinedButton(
                          onPressed: vm.isLoading ? null : () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: _primary, width: 1.2),
                            foregroundColor: _primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            '취소',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              height: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: vm.canSubmit
                              ? () async {
                            final result = await context.read<SettlementWithdrawVerifyViewModel>().submit();
                            if (!context.mounted) return;

                            showDialog<void>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('출금 요청'),
                                content: Text(result.message),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // dialog close
                                      if (result.success) {
                                        Navigator.of(context).pop(); // verify close
                                        Navigator.of(context).pop(); // request close
                                      }
                                    },
                                    child: const Text('확인'),
                                  ),
                                ],
                              ),
                            );
                          }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primary,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: const Color(0xFFE6E6E6),
                            disabledForegroundColor: const Color(0xFFBDBDBD),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            '출금',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              height: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _money(int v) {
    final s = v.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final idxFromEnd = s.length - i;
      buf.write(s[i]);
      if (idxFromEnd > 1 && idxFromEnd % 3 == 1) buf.write(',');
    }
    return buf.toString();
  }
}
