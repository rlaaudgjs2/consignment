import 'package:flutter/material.dart';

import 'package:consignment/core/data/complete/domain/driving_history.dart';

class DrivingHistoryTableTemplate extends StatelessWidget {
  final List<DrivingHistory> histories;

  const DrivingHistoryTableTemplate({
    super.key,
    required this.histories,
  });

  @override
  Widget build(BuildContext context) {
    const dividerColor = Color(0xFFF2F2F2);
    const headerTextColor = Color(0xFF828282);
    const bodyTextColor = Color(0xFF333333);

    // 헤더
    const headerStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.0,
      color: headerTextColor,
    );

    // 좌측 날짜/시간
    const leftSmallStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.0,
      color: bodyTextColor,
    );

    // 출발지/도착지
    const titleStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.15,
      color: bodyTextColor,
    );

    const subStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.15,
      color: bodyTextColor,
    );

    // 요금
    const priceStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.0,
      color: bodyTextColor,
    );

    // ---- 핵심: 간격 조절 값 ----
    const double headerVerticalPadding = 10; // 기존 12보다 약간 축소
    const double rowVerticalPadding = 10; // 기존 14 -> 축소
    const double dateTimeGap = 4; // 기존 6 -> 축소
    const double titleToSubGap = 6; // 기존 8 -> 축소

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: headerVerticalPadding),
            child: Row(
              children: [
                SizedBox(width: 72, child: Text('일자', style: headerStyle)),
                Expanded(child: Text('출발지  →  도착지', style: headerStyle)),
                const SizedBox(width: 12),
                SizedBox(
                  width: 84,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text('요금', style: headerStyle),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: dividerColor),

          ...histories.map((h) {
            final dateText = _formatMMDD(h.startedAt);
            final timeText = _formatHHmm(h.startedAt);
            final priceText = _formatPrice(h.price);

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: rowVerticalPadding),
                  child: Row(
                    // 전체 row를 세로 중앙 정렬
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 72,
                        // 왼쪽 날짜/시간도 “row 중앙” 기준으로 배치
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(dateText, style: leftSmallStyle),
                            const SizedBox(height: dateTimeGap),
                            Text(timeText, style: leftSmallStyle),
                          ],
                        ),
                      ),

                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(h.startTitle, style: titleStyle),
                            const SizedBox(height: titleToSubGap),
                            Row(
                              children: [
                                const Text('→  ', style: TextStyle(color: headerTextColor)),
                                Expanded(
                                  child: Text(
                                    h.endAddress,
                                    style: subStyle,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      SizedBox(
                        width: 84,
                        // ✅ 핵심: 요금도 세로 중앙
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(priceText, style: priceStyle),
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

  String _formatHHmm(DateTime dt) {
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }

  String _formatPrice(int price) {
    final s = price.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final idxFromEnd = s.length - i;
      buf.write(s[i]);
      if (idxFromEnd > 1 && idxFromEnd % 3 == 1) {
        buf.write(',');
      }
    }
    return '${buf.toString()}원';
  }
}
