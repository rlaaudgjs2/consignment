import 'package:consignment/src/features/order/widgets/order_dispatch_header_icon.dart';
import 'package:flutter/material.dart';
import 'package:consignment/core/data/domain/order_call.dart';
import 'package:consignment/src/features/order/widgets/order_type_chip.dart';

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
    final cs = Theme.of(context).colorScheme;
    final bool isConsign = call.serviceType == OrderType.consign;

    // ✅ 기존: 탁송 초록 / 대리 코랄을 유지하되, 테마의 primary/tertiary를 우선 활용
    // - 앱에서 consign/proxy 전용 색을 꼭 유지하고 싶으면 theme에 extension을 두는게 베스트지만
    //   지금은 최소 수정으로 theme 기반으로 가져간다.
    final Color headerColor = isConsign ? cs.tertiary : cs.secondary;
    final String headerText = isConsign ? '탁송 배차 하시겠습니까?' : '대리 배차 하시겠습니까?';

    const double horizontalPadding = 24;
    const double buttonGap = 16;
    const double baseCancelWidth = 120;
    const double baseDispatchWidth = 215;
    const double baseTotalWidth = baseCancelWidth + baseDispatchWidth;

    final double screenWidth = MediaQuery.of(context).size.width;
    final double availableWidth = screenWidth - horizontalPadding * 2 - buttonGap;

    final double scale = availableWidth / baseTotalWidth;
    final double cancelButtonWidth = baseCancelWidth * scale;
    final double dispatchButtonWidth = baseDispatchWidth * scale;

    return Container(
      color: cs.surface,
      child: Column(
        children: [
          Container(
            height: 44,
            width: double.infinity,
            color: headerColor,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                // ✅ 아이콘은 IconTheme를 따라가도록 이미 구현되어 있으니
                // 여기에서 아이콘 색만 강제하면 됨.
                IconTheme(
                  data: IconThemeData(color: cs.onPrimary, size: 24),
                  child: const OrderDispatchHeaderIcon(),
                ),
                const SizedBox(width: 8),
                Text(
                  headerText,
                  style: TextStyle(
                    color: cs.onPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OrderTypeChip(type: call.serviceType),
                      _DetailTagsRow(tags: call.tags),
                    ],
                  ),
                  const SizedBox(height: 16),

                  _rowLabelValue(context, '출발지', call.startLocation),
                  const SizedBox(height: 10),
                  _rowLabelValue(context, '도착지', call.destinationLocation),
                  const SizedBox(height: 10),
                  _rowLabelValue(context, '요금', _formatPrice(call.charge)),
                  const SizedBox(height: 10),
                  _rowLabelValue(context, '기타', '원천징수 ${call.feeRate}% 차감'),
                  const SizedBox(height: 32),

                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '고객님과의 직선 거리는 ',
                          style: TextStyle(
                            fontSize: 18,
                            color: cs.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: '${call.distanceKm.toStringAsFixed(1)}km',
                          style: TextStyle(
                            fontSize: 18,
                            color: cs.onSurface,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: ' 입니다.',
                          style: TextStyle(
                            fontSize: 18,
                            color: cs.onSurface,
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

          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Row(
              children: [
                SizedBox(
                  width: cancelButtonWidth,
                  child: OutlinedButton(
                    onPressed: onTapCancel,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: cs.error.withOpacity(0.75)),
                      foregroundColor: cs.error,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      '취소',
                      style: TextStyle(
                        color: cs.error,
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
                      backgroundColor: cs.primary,
                      foregroundColor: cs.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      '배차',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _rowLabelValue(BuildContext context, String label, String value) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 48,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: cs.onSurface.withOpacity(0.6),
            ),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 18,
              color: cs.onSurface,
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

class _DetailTagsRow extends StatelessWidget {
  final List<String> tags;

  const _DetailTagsRow({required this.tags});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (tags.isEmpty) return const SizedBox.shrink();

    final tagStyle = TextStyle(
      fontSize: 14,
      color: cs.onSurface.withOpacity(0.6),
    );

    final dividerStyle = TextStyle(
      fontSize: 14,
      color: cs.onSurface.withOpacity(0.35),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < tags.length; i++) ...[
          Text(tags[i], style: tagStyle),
          if (i != tags.length - 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text('|', style: dividerStyle),
            ),
        ],
      ],
    );
  }
}
