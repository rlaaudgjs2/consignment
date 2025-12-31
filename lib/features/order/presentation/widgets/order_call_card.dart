import 'package:flutter/material.dart';

/// 오더 탭에서 사용하는 콜 카드 하나를 그리는 위젯.
/// 피그마 기준 레이아웃을 따르되, 높이는 고정하지 않고 내용에 따라 늘어나게 함.
class OrderCallCard extends StatelessWidget {
  final String typeLabel; // "탁송" / "대리"
  final Widget typeChip; // 탁송/대리 칩 아이콘 png
  final String startAddress; // 출발지
  final String endAddress; // 도착지
  final double distanceKm; // 출발지까지 거리 (예: 4.5)
  final List<String> tags; // 상단 오른쪽 태그들 ("카드", "하이패스", "경유", ...)
  final int price; // 금액 (원)

  const OrderCallCard({
    super.key,
    required this.typeLabel,
    required this.typeChip,
    required this.startAddress,
    required this.endAddress,
    required this.distanceKm,
    required this.tags,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 콜 카드 본체
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1줄: [칩]        | [태그들]
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 왼쪽: 탁송/대리 칩
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          typeChip,
                        ],
                      ),
                      const Spacer(),
                      _TagsRow(tags: tags),
                    ],
                  ),

                  const SizedBox(height: 3),

                  // 2줄: 출발지 + 거리
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: startAddress,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF333333),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const WidgetSpan(
                                child: SizedBox(width: 4),
                              ),
                              TextSpan(
                                text: '${distanceKm.toStringAsFixed(1)}km',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF828282),
                                ),
                              ),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 2),

                  // 3줄: 도착지  |  금액
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 왼쪽: -> 도착지
                      Expanded(
                        child: Row(
                          children: [
                            const Text(
                              '→ ',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF828282),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                endAddress,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF333333),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 오른쪽: 금액
                      Text(
                        _formatPrice(price),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // 카드 아래 구분선 (카드와 같은 width)
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Divider(
            height: 0,
            thickness: 1,
            color: Color(0xFFF2F2F2),
          ),
        ),
      ],
    );
  }

  static String _formatPrice(int price) {
    // 간단 포맷: 90000 -> "90,000원"
    final s = price.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final indexFromEnd = s.length - i;
      buffer.write(s[i]);
      if (indexFromEnd > 1 && indexFromEnd % 3 == 1) {
        buffer.write(',');
      }
    }
    return '${buffer.toString()}원';
  }
}

/// 상단 오른쪽 태그 영역: "카드 | 하이패스 | 경유" 이런 형태
class _TagsRow extends StatelessWidget {
  final List<String> tags;

  const _TagsRow({required this.tags});

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < tags.length; i++) ...[
          Text(
            tags[i],
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF828282),
            ),
          ),
          if (i != tags.length - 1)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                '|',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFFBDBDBD),
                ),
              ),
            ),
        ],
      ],
    );
  }
}
