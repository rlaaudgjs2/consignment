import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:consignment/core/data/repositories/settlement_repository.dart';
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
    return ChangeNotifierProvider(
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

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SettlementWithdrawRequestViewModel>();
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 16,
        title: Text(
          '후불오더 출금',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: cs.onSurface,
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
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: cs.error,
                    ),
                  ),
                ),
              ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  children: [
                    if (vm.info != null)
                      _InfoCard(
                        child: Column(
                          children: [
                            _InfoRow(
                              label: '출금가능 금액',
                              value: '${_money(vm.info!.availableAmount)} 원',
                              valueStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: cs.onSurface,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Divider(color: theme.dividerColor),
                            const SizedBox(height: 14),
                            _InfoRow(label: '은행명', value: vm.info!.bankName),
                            const SizedBox(height: 14),
                            _InfoRow(label: '계좌번호', value: vm.info!.maskedAccountNumber),
                            const SizedBox(height: 14),
                            _InfoRow(label: '예금주', value: vm.info!.depositorName),
                            const SizedBox(height: 14),
                            Divider(color: theme.dividerColor),
                            const SizedBox(height: 14),
                            _AmountRow(
                              amountText: '${_money(vm.amount)}원',
                              onMinus: vm.canMinus ? vm.decrease : null,
                              onPlus: vm.canPlus ? vm.increase : null,
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
                          onPressed: vm.reset,
                          child: const Text('초기화'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: vm.info == null ? null : () async {
                            final session = await vm.createSession();
                            if (!context.mounted || session == null) return;

                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => SettlementWithdrawVerifyPage(
                                  repository: repository,
                                  session: session,
                                ),
                              ),
                            );
                          },
                          child: const Text('출금'),
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

class _InfoCard extends StatelessWidget {
  final Widget child;
  const _InfoCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
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

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: cs.onSurface.withOpacity(0.6),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: valueStyle ??
                TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
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

  const _AmountRow({
    required this.amountText,
    required this.onMinus,
    required this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        SizedBox(
          width: 110,
          child: Text(
            '금액',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: cs.onSurface.withOpacity(0.6),
            ),
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _CircleIconButton(icon: Icons.remove, onTap: onMinus),
              const SizedBox(width: 14),
              Text(
                amountText,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(width: 14),
              _CircleIconButton(icon: Icons.add, onTap: onPlus),
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

  const _CircleIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final disabled = onTap == null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: disabled ? cs.surfaceVariant : cs.primary,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 18,
          color: disabled ? cs.onSurface.withOpacity(0.4) : Colors.white,
        ),
      ),
    );
  }
}
