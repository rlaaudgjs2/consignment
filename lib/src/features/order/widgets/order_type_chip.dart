import 'package:flutter/material.dart';
import 'package:consignment/core/data/domain/order_call.dart';
import 'package:consignment/src/theme/order_chip_style.dart';

class OrderTypeChip extends StatelessWidget {
  final OrderType type;

  const OrderTypeChip({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final bool isConsign = type == OrderType.consign;
    final OrderChipStyle style = Theme.of(context).extension<OrderChipStyle>()!;

    final Color iconColor = isConsign ? style.consignIconColor : style.proxyIconColor;
    final String label = isConsign ? '탁송' : '대리';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: style.background,
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
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: style.textColor,
            ),
          ),
        ],
      ),
    );
  }
}
