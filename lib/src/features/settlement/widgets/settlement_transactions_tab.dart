import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/settlement_viewmodel.dart';
import 'settlement_transactions_table_template.dart';

class SettlementTransactionsTab extends StatelessWidget {
  const SettlementTransactionsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SettlementViewModel>();

    if (vm.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (vm.errorMessage != null) {
      return Center(
        child: Text(
          vm.errorMessage!,
          style: const TextStyle(fontSize: 16, color: Color(0xFF828282)),
        ),
      );
    }

    if (vm.transactions.isEmpty) {
      return const Center(
        child: Text(
          '입출금 내역이 없습니다.',
          style: TextStyle(fontSize: 16, color: Color(0xFF828282)),
        ),
      );
    }

    return SingleChildScrollView(
      child: SettlementTransactionsTableTemplate(
        transactions: vm.transactions,
        onTapRow: (tx) => vm.openTransactionDetailModal(context, tx: tx),
      ),
    );
  }
}
