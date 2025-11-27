import 'package:flutter/material.dart';
import 'package:consignment/core/config/assets.dart';
import 'package:consignment/features/order/domain/entities/order_call.dart';

class OrderDetailView extends StatelessWidget {
  final OrderCall call;
  final VoidCallback onTapCancel;
  final ValueChanged<OrderCall> onTapDispatch;

  const OrderDetailView({
    super.key,
    required this.call,
    required this.onTapCancel,
    required this.onTapDispatch,
  });

  @override
  Widget build(BuildContext context) {
    final bool isConsign = call.type == OrderType.consign;

    // 상단 배너 색
    final Color headerColor = isConsign
        ? const Color(0xFF09AF81) // 탁송 초록
        : const Color(0xFFFF8A76); // 대리 코랄

    final String headerText =
    isConsign ? '탁송 배차 하시겠습니까?' : '대리 배차 하시겠습니까?';

    // 업무 칩 아이콘
    final String typeChipAsset =
    isConsign ? AppIcons.orderTagTaksong : AppIcons.orderTagDaeri;

    // ----- 하단 버튼 width 계산 (화면 크기 대응) -----
    const double horizontalPadding = 24; // 좌우 패딩
    const double buttonGap = 16; // 취소 / 배차 사이 간격 (고정)
    const double baseCancelWidth = 120; // 피그마 기준
    const double baseDispatchWidth = 215; // 피그마 기준
    const double baseTotalWidth = baseCancelWidth + baseDispatchWidth; // 335

    final double screenWidth = MediaQuery.of(context).size.width;
    final double availableWidth =
        screenWidth - horizontalPadding * 2 - buttonGap;

    // 화면에 맞게 스케일링
    final double scale = availableWidth / baseTotalWidth;
    final double cancelButtonWidth = baseCancelWidth * scale;
    final double dispatchButtonWidth = baseDispatchWidth * scale;

    return Column(
      children: [
        // 상단 초록/코랄 배너
        Container(
          height: 44,
          width: double.infinity,
          color: headerColor,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Image.asset(
                AppIcons.orderDispatch,
                width: 24,
                height: 24,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Text(
                headerText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        // 내용 영역
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 탁송/대리 칩 + 우측 상단 태그들
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      typeChipAsset,
                      height: 24,
                    ),
                    _DetailTagsRow(tags: call.tags),
                  ],
                ),
                const SizedBox(height: 16),

                _rowLabelValue('출발지', call.startAddress),
                const SizedBox(height: 10),
                _rowLabelValue('도착지', call.endAddress),
                const SizedBox(height: 10),
                _rowLabelValue('요금', _formatPrice(call.price)),
                const SizedBox(height: 10),
                _rowLabelValue('기타', '원천징수 ${call.feeRate}% 차감'),
                const SizedBox(height: 32),
                RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: '고객님과의 직선 거리는 ',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF333333),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: '${call.distanceKm.toStringAsFixed(1)}km',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xFF333333),
                          fontWeight: FontWeight.w700, // 숫자+km 굵게
                        ),
                      ),
                      const TextSpan(
                        text: ' 입니다.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF333333),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // 하단 버튼 영역 (비율 유지 + 화면 대응)
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: cancelButtonWidth,
                child: OutlinedButton(
                  onPressed: onTapCancel,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color(0xFFFF8A76),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    '취소',
                    style: TextStyle(
                      color: Color(0xFFFF8A76),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: buttonGap),
              SizedBox(
                width: dispatchButtonWidth,
                child: ElevatedButton(
                  onPressed: () => onTapDispatch(call),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFBB35F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    '배차',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _rowLabelValue(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 48,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF828282),
            ),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xFF333333),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  String _formatPrice(int price) {
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

/// 디테일 화면 우측 상단 태그들 ("카드 | 하이패스" 등)
class _DetailTagsRow extends StatelessWidget {
  final List<String> tags;

  const _DetailTagsRow({required this.tags});

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
