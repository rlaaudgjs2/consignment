import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:consignment/core/data/settlement/repositories/settlement_repository.dart';
import '../viewmodels/settlement_withdraw_request_viewmodel.dart';
import 'settlement_withdraw_verify_page.dart';

class SettlementWithdrawRequestPage extends StatelessWidget {
  final SettlementRepository repository;

  const SettlementWithdrawRequestPage({
    super.key,
    required this.repository,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettlementWithdrawRequestViewModel>(
      create: (_) => SettlementWithdrawRequestViewModel(repository: repository),
      child: _WithdrawRequestView(repository: repository),
    );
  }
}

class _WithdrawRequestView extends StatelessWidget {
  final SettlementRepository repository;

  const _WithdrawRequestView({
    required this.repository,
  });

  static const _bg = Color(0xFFF6F6F6);
  static const _line = Color(0xFFEAEAEA);
  static const _text = Color(0xFF333333);
  static const _subText = Color(0xFF828282);
  static const _primary = Color(0xFFF2B36A);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SettlementWithdrawRequestViewModel>();
    final info = vm.info;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 16,
        title: const Text(
          '후불오더 출금',
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
            if (vm.errorMessage != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    vm.errorMessage!,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFE53935),
                    ),
                  ),
                ),
              ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  children: [
                    if (info == null)
                      const SizedBox.shrink()
                    else
                      _InfoCard(
                        child: Column(
                          children: [
                            _InfoRow(
                              label: '출금가능 금액',
                              value: '${_money(info.availableAmount)} 원',
                              valueStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                height: 1.0,
                                color: _text,
                              ),
                            ),
                            const SizedBox(height: 14),
                            const Divider(height: 1, thickness: 1, color: _line),
                            const SizedBox(height: 14),
                            _InfoRow(label: '은행명', value: info.bankName),
                            const SizedBox(height: 14),
                            _InfoRow(label: '계좌번호', value: info.maskedAccountNumber),
                            const SizedBox(height: 14),
                            _InfoRow(label: '예금주', value: info.depositorName),
                            const SizedBox(height: 14),
                            const Divider(height: 1, thickness: 1, color: _line),
                            const SizedBox(height: 14),
                            _AmountRow(
                              amountText: '${_money(vm.amount)}원',
                              onMinus: vm.canMinus ? () => context.read<SettlementWithdrawRequestViewModel>().decrease() : null,
                              onPlus: vm.canPlus ? () => context.read<SettlementWithdrawRequestViewModel>().increase() : null,
                              primary: _primary,
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),
                    _InfoCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _NoticeBadge(text: '주의사항'),
                          const SizedBox(height: 10),
                          Text(
                            '출금액은 ${_money(info?.unitAmount ?? 10000)}원 단위로 가능합니다.\n'
                                '출금시 수수료 ${_money(info?.feeAmount ?? 0)}원은 차감하고 출금합니다.\n'
                                '은행 점검 시간을 제외하고 모두 출금 가능합니다.',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              height: 1.35,
                              color: _subText,
                            ),
                          ),
                        ],
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
                          onPressed: info == null ? null : () => context.read<SettlementWithdrawRequestViewModel>().reset(),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: _primary, width: 1.2),
                            foregroundColor: _primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            '초기화',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
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
                          onPressed: info == null
                              ? null
                              : () async {
                            final session = await context.read<SettlementWithdrawRequestViewModel>().createSession();
                            if (session == null) return;
                            if (!context.mounted) return;

                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => SettlementWithdrawVerifyPage(
                                  repository: repository,
                                  session: session,
                                ),
                              ),
                            );
                          },
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
                              fontWeight: FontWeight.w700,
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

// ---- 아래 위젯들은 기존 코드 재사용 ----
class _InfoCard extends StatelessWidget {
  final Widget child;
  const _InfoCard({required this.child});

  static const _cardBg = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? valueStyle;

  const _InfoRow({
    required this.label,
    required this.value,
    this.valueStyle,
  });

  static const _labelStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.0,
    color: Color(0xFF9A9A9A),
  );

  static const _valueStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.0,
    color: Color(0xFF333333),
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 110, child: Text(label, style: _labelStyle)),
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(value, style: valueStyle ?? _valueStyle),
          ),
        ),
      ],
    );
  }
}

class _AmountRow extends StatelessWidget {
  final String amountText;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;
  final Color primary;

  const _AmountRow({
    required this.amountText,
    required this.onMinus,
    required this.onPlus,
    required this.primary,
  });

  static const _labelStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.0,
    color: Color(0xFF9A9A9A),
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 110, child: Text('금액', style: _labelStyle)),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _CircleIconButton(icon: Icons.remove, onTap: onMinus, primary: primary),
              const SizedBox(width: 14),
              Text(
                amountText,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  height: 1.0,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(width: 14),
              _CircleIconButton(icon: Icons.add, onTap: onPlus, primary: primary),
            ],
          ),
        ),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color primary;

  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: disabled ? const Color(0xFFF1F1F1) : primary,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 18,
          color: disabled ? const Color(0xFFBDBDBD) : Colors.white,
        ),
      ),
    );
  }
}

class _NoticeBadge extends StatelessWidget {
  final String text;
  const _NoticeBadge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFF7A6B),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          height: 1.0,
          color: Colors.white,
        ),
      ),
    );
  }
}
