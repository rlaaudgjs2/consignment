import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:consignment/core/data/settlement/repositories/settlement_repository.dart';
import '../pages/settlement_withdraw_request_page.dart';
import '../viewmodels/settlement_viewmodel.dart';

/// 내 지갑 탭 - 현재잔액 박스 + 출금 버튼
class SettlementWalletTab extends StatelessWidget {
  const SettlementWalletTab({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SettlementViewModel>();

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Column(
              children: [
                _CurrentBalanceCard(
                  balanceText: vm.walletBalanceText,
                ),
                const SizedBox(height: 18),
              ],
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
                  /// ✅ 핵심: repo를 새로 만들지 않는다.
                  final repo = context.read<SettlementRepository>();

                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => SettlementWithdrawRequestPage(
                        repository: repo,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF2B36A),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  '출금',
                  style: TextStyle(
                    fontSize: 16,
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

class _CurrentBalanceCard extends StatelessWidget {
  final String balanceText;

  const _CurrentBalanceCard({
    required this.balanceText,
  });

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF6F6F6);
    const titleColor = Color(0xFF333333);
    const amountColor = Color(0xFFF2B36A);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '현재 잔액',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.0,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            balanceText,
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w700,
              height: 1.0,
              color: amountColor,
            ),
          ),
        ],
      ),
    );
  }
}
