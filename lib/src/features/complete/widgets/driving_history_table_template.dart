import 'package:flutter/material.dart';

import 'package:consignment/core/data/domain/driving_history.dart';

class DrivingHistoryTableTemplate extends StatelessWidget {
  final List<DrivingHistory> histories;
  final ValueChanged<String> onTapHistory;

  const DrivingHistoryTableTemplate({
    super.key,
    required this.histories,
    required this.onTapHistory,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final dividerColor = cs.outlineVariant.withOpacity(0.7);
    final headerTextColor = cs.onSurface.withOpacity(0.6);
    final bodyTextColor = cs.onSurface;

    // 헤더
    final headerStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      height: 1.0,
      color: headerTextColor,
    );

    // 좌측 날짜/시간
    final leftSmallStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.0,
      color: bodyTextColor,
    );

    // 출발지/도착지
    final titleStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.15,
      color: bodyTextColor,
    );

    final subStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.15,
      color: bodyTextColor,
    );

    // 요금
    final priceStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.0,
      color: bodyTextColor,
    );

    // ---- 간격 조절 값 ----
    const double headerVerticalPadding = 10;
    const double rowVerticalPadding = 10;
    const double dateTimeGap = 4;
    const double titleToSubGap = 6;

    if (histories.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Center(
          child: Text(
            '운행 내역이 없습니다.',
            style: TextStyle(color: headerTextColor),
          ),
        ),
      );
    }

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
          Divider(height: 1, thickness: 1, color: dividerColor),

          ...histories.map((h) {
            final dateText = _formatMMDD(h.startedAt);
            final timeText = _formatHHmm(h.startedAt);
            final priceText = _formatPrice(h.price);

            return InkWell(
              onTap: () => onTapHistory(h.id),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: rowVerticalPadding),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 72,
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
                              Text(h.startAddress, style: titleStyle),
                              const SizedBox(height: titleToSubGap),
                              Row(
                                children: [
                                  Text('→  ', style: TextStyle(color: headerTextColor)),
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
                            child: Text(priceText, style: priceStyle),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1, thickness: 1, color: dividerColor),
                ],
              ),
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
