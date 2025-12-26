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

    const headerStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.0,
      color: headerTextColor,
      // fontFamily: 'Pretendard',
    );

    const leftSmallStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.0,
      color: bodyTextColor,
      // fontFamily: 'Pretendard',
    );

    const titleStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.2,
      color: bodyTextColor,
      // fontFamily: 'Pretendard',
    );

    const subStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.2,
      color: headerTextColor,
      // fontFamily: 'Pretendard',
    );

    const priceStyle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 1.0,
      color: bodyTextColor,
      // fontFamily: 'Pretendard',
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
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
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 72,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(dateText, style: leftSmallStyle),
                            const SizedBox(height: 6),
                            Text(timeText, style: leftSmallStyle),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(h.startTitle, style: titleStyle),
                            const SizedBox(height: 8),
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
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(priceText, style: priceStyle),
                          ),
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
