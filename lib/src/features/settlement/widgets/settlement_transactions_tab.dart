import 'package:flutter/material.dart';

/// 입출금 내역 한 줄 데이터 모델 (임시)
/// - 실제 API/Entity가 생기면 이 모델을 제거하고 해당 타입으로 바꿔 끼우면 됩니다.
class SettlementTransaction {
  final DateTime date; // 거래 일자
  final int amount; // 입금(+), 출금(-)
  final int balance; // 잔액
  final String description; // 내역

  const SettlementTransaction({
    required this.date,
    required this.amount,
    required this.balance,
    required this.description,
  });

  bool get isDeposit => amount > 0;
}

/// ✅ 입출금 내역 테이블 템플릿
/// - DrivingHistoryTableTemplate 스타일(폰트/간격/디바이더/정렬) 기반
class SettlementTransactionsTableTemplate extends StatelessWidget {
  final List<SettlementTransaction> transactions;

  const SettlementTransactionsTableTemplate({
    super.key,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    const dividerColor = Color(0xFFF2F2F2);
    const headerTextColor = Color(0xFF828282);
    const bodyTextColor = Color(0xFF333333);

    // 입금/출금 컬러 (스크린샷 감성: 입금=파랑, 출금=빨강)
    const depositColor = Color(0xFF2F80ED);
    const withdrawColor = Color(0xFFFF5A5A);

    // 헤더 스타일
    const headerStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.0,
      color: headerTextColor,
    );

    // 바디 스타일
    const bodyStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.0,
      color: bodyTextColor,
    );

    // 내역(우측) 스타일 (길면 말줄임)
    const descStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.0,
      color: bodyTextColor,
    );

    // ---- 간격 조절 값 (DrivingHistoryTableTemplate와 톤 맞춤) ----
    const double headerVerticalPadding = 10;
    const double rowVerticalPadding = 10;

    // 컬럼 폭 (스크린샷 비율 참고)
    const double colDateW = 64;   // "11/09"
    const double colAmtW = 84;    // "-8,400"
    const double colBalW = 84;    // "55,414"
    const double gap = 10;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Header
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

          // Rows
          ...transactions.map((t) {
            final dateText = _formatMMDD(t.date);
            final amountText = _formatSignedNumber(t.amount);
            final balanceText = _formatNumber(t.balance);
            final amountColor = t.isDeposit ? depositColor : withdrawColor;

            return Column(
              children: [
                Padding(
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

class SettlementTransactionsTab extends StatelessWidget {
  const SettlementTransactionsTab({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: viewmodel 연동 시 여기 mock 제거하고,
    //       SettlementViewModel의 transactions (or state) 를 주입해서 렌더링하면 됩니다.
    final mock = <SettlementTransaction>[
      SettlementTransaction(
        date: DateTime(2025, 11, 9),
        amount: -8400,
        balance: 55414,
        description: '특정날자동공제',
      ),
      SettlementTransaction(
        date: DateTime(2025, 11, 8),
        amount: -8400,
        balance: 63814,
        description: '특정날자동공제',
      ),
      SettlementTransaction(
        date: DateTime(2025, 11, 7),
        amount: -8400,
        balance: 72214,
        description: '특정날자동공제',
      ),
      SettlementTransaction(
        date: DateTime(2025, 11, 6),
        amount: 20000,
        balance: 80614,
        description: '타사입금',
      ),
      SettlementTransaction(
        date: DateTime(2025, 11, 5),
        amount: -8400,
        balance: 60614,
        description: '특정날자동공제',
      ),
      SettlementTransaction(
        date: DateTime(2025, 11, 4),
        amount: -459,
        balance: 69041,
        description: '산재보험',
      ),
      SettlementTransaction(
        date: DateTime(2025, 11, 4),
        amount: -394,
        balance: 69473,
        description: '고용보험',
      ),
      SettlementTransaction(
        date: DateTime(2025, 11, 6),
        amount: 28804,
        balance: 69867,
        description: '타사입금',
      ),
    ];

    // 리스트가 비어있을 때 대응(원하면 디자인 더 맞춰줄 수 있음)
    if (mock.isEmpty) {
      return const Center(
        child: Text(
          '입출금 내역이 없습니다.',
          style: TextStyle(fontSize: 16, color: Color(0xFF828282)),
        ),
      );
    }

    return SingleChildScrollView(
      child: SettlementTransactionsTableTemplate(transactions: mock),
    );
  }
}
