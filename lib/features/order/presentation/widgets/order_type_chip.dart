import 'package:flutter/material.dart';
import 'package:consignment/features/order/domain/entities/order_call.dart';

/// 오더 카드 상단에 표시되는 "탁송 / 대리" 칩 위젯
class OrderTypeChip extends StatelessWidget {
  final OrderType type;

  const OrderTypeChip({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final bool isConsign = type == OrderType.consign;

    // 색상
    const Color consignColor = Color(0xFF09AF81); // 탁송 초록
    const Color proxyColor = Color(0xFFFF8A76);   // 대리 코랄
    const Color textColor = Color(0xFF828282);    // 회색 텍스트

    final Color iconColor = isConsign ? consignColor : proxyColor;
    final String label = isConsign ? '탁송' : '대리';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Color(0xFFF6F6F4),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isConsign ? Icons.directions_car_filled : Icons.person,
            size: 18,
            color: iconColor,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
