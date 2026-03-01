import 'package:flutter/material.dart';
import 'package:consignment/core/data/domain/settlement_transaction.dart';
import 'package:consignment/src/theme/settlement_transactions_style.dart';

class SettlementTransactionsTableTemplate extends StatelessWidget {
  final List<SettlementTransaction> transactions;
  final ValueChanged<SettlementTransaction>? onTapRow;

  const SettlementTransactionsTableTemplate({
    super.key,
    required this.transactions,
    this.onTapRow,
  });

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<SettlementTransactionsStyle>();

    // ✅ extension 누락시에도 크래시 안 나게 fallback 제공
    final style = ext ??
        const SettlementTransactionsStyle(
          dividerColor: Color(0xFFEDEDED),
          headerStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.0,
            color: Color(0xFF828282),
          ),
          bodyStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.0,
            color: Color(0xFF333333),
          ),
          descStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.0,
            color: Color(0xFF333333),
          ),
          depositColor: Color(0xFF2F80ED),
          withdrawColor: Color(0xFFFF5A5A),
        );

    const double headerVerticalPadding = 10;
    const double rowVerticalPadding = 10;

    const double colDateW = 64;
    const double colAmtW = 84;
    const double colBalW = 84;
    const double gap = 10;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: headerVerticalPadding),
            child: Row(
              children: [
                SizedBox(width: colDateW, child: Text('일자', style: style.headerStyle)),
                const SizedBox(width: gap),
                SizedBox(
                  width: colAmtW,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text('입/출금', style: style.headerStyle),
                  ),
                ),
                const SizedBox(width: gap),
                SizedBox(
                  width: colBalW,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text('잔액', style: style.headerStyle),
                  ),
                ),
                const SizedBox(width: gap),
                Expanded(child: Text('내역', style: style.headerStyle)),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1, color: style.dividerColor),

          ...transactions.map((t) {
            final dateText = _formatMMDD(t.date);
            final amountText = _formatSignedNumber(t.amount);
            final balanceText = _formatNumber(t.balance);
            final amountColor = t.isDeposit ? style.depositColor : style.withdrawColor;

            final row = Padding(
              padding: const EdgeInsets.symmetric(vertical: rowVerticalPadding),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: colDateW,
                    child: Text(dateText, style: style.bodyStyle),
                  ),
                  const SizedBox(width: gap),
                  SizedBox(
                    width: colAmtW,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        amountText,
                        style: style.bodyStyle.copyWith(color: amountColor),
                      ),
                    ),
                  ),
                  const SizedBox(width: gap),
                  SizedBox(
                    width: colBalW,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(balanceText, style: style.bodyStyle),
                    ),
                  ),
                  const SizedBox(width: gap),
                  Expanded(
                    child: Text(
                      t.description,
                      style: style.descStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );

            final content = (onTapRow == null)
                ? row
                : InkWell(
              onTap: () => onTapRow?.call(t),
              child: row,
            );

            return Column(
              children: [
                content,
                Divider(height: 1, thickness: 1, color: style.dividerColor),
              ],
            );
          }),
        ],
      ),
    );
  }

  String _formatMMDD(DateTime dt) {
    final mm = dt.month.toString().padLeft(2, '0');
    final dd = dt.day.toString().padLeft(2, '0');
    return '$mm/$dd';
  }

  String _formatSignedNumber(int v) {
    final sign = v >= 0 ? '' : '-';
    final abs = v.abs();
    return '$sign${_formatNumber(abs)}';
  }

  String _formatNumber(int v) {
    final s = v.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final idxFromEnd = s.length - i;
      buf.write(s[i]);
      if (idxFromEnd > 1 && idxFromEnd % 3 == 1) {
        buf.write(',');
      }
    }
    return buf.toString();
  }
}
