import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:consignment/core/data/repositories/settlement_repository.dart';
import '../pages/settlement_withdraw_request_page.dart';
import '../viewmodels/settlement_viewmodel.dart';
import 'package:consignment/src/theme/settlement_style.dart';

class SettlementWalletTab extends StatelessWidget {
  const SettlementWalletTab({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SettlementViewModel>();
    final style = Theme.of(context).extension<SettlementStyle>();
    assert(style != null, 'SettlementStyle이 ThemeData.extensions에 등록되어야 합니다.');
    final s = style!;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: s.walletCardBg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '현재 잔액',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.0,
                      color: s.walletTitleText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    vm.walletBalanceText,
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      height: 1.0,
                      color: s.walletAmountText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () async {
                  final repo = context.read<SettlementRepository>();
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SettlementWithdrawRequestPage(repository: repo),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: s.withdrawButtonBg,
                  foregroundColor: s.withdrawButtonText,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  '출금하기',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    height: 1.0,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
