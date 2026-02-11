import 'package:flutter/material.dart';
import 'package:consignment/core/data/domain/settlement_transaction.dart';

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
    const dividerColor = Color(0xFFF2F2F2);
    const headerTextColor = Color(0xFF828282);
    const bodyTextColor = Color(0xFF333333);

    const depositColor = Color(0xFF2F80ED);
    const withdrawColor = Color(0xFFFF5A5A);

    const headerStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.0,
      color: headerTextColor,
    );

    const bodyStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.0,
      color: bodyTextColor,
    );

    const descStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.0,
      color: bodyTextColor,
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
              children: const [
                SizedBox(width: colDateW, child: Text('일자', style: headerStyle)),
                SizedBox(width: gap),
                SizedBox(
                  width: colAmtW,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text('입/출금', style: headerStyle),
                  ),
                ),
                SizedBox(width: gap),
                SizedBox(
                  width: colBalW,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text('잔액', style: headerStyle),
                  ),
                ),
                SizedBox(width: gap),
                Expanded(child: Text('내역', style: headerStyle)),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: dividerColor),

          ...transactions.map((t) {
            final dateText = _formatMMDD(t.date);
            final amountText = _formatSignedNumber(t.amount);
            final balanceText = _formatNumber(t.balance);
            final amountColor = t.isDeposit ? depositColor : withdrawColor;

            final row = Padding(
              padding: const EdgeInsets.symmetric(vertical: rowVerticalPadding),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: colDateW,
                    child: Text(dateText, style: bodyStyle),
                  ),
                  const SizedBox(width: gap),

                  SizedBox(
                    width: colAmtW,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        amountText,
                        style: bodyStyle.copyWith(color: amountColor),
                      ),
                    ),
                  ),
                  const SizedBox(width: gap),

                  SizedBox(
                    width: colBalW,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(balanceText, style: bodyStyle),
                    ),
                  ),
                  const SizedBox(width: gap),

                  Expanded(
                    child: Text(
                      t.description,
                      style: descStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );

            return Column(
              children: [
                if (onTapRow == null)
                  row
                else
                  InkWell(
                    onTap: () => onTapRow?.call(t),
                    child: row,
                  ),
                const Divider(height: 1, thickness: 1, color: dividerColor),
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
