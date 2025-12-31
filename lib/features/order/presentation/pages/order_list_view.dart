import 'package:flutter/material.dart';
import 'package:consignment/features/order/domain/entities/order_call.dart';
import 'package:consignment/features/order/presentation/widgets/order_call_card.dart';
import 'package:consignment/features/order/presentation/widgets/order_type_chip.dart';

class OrderListView extends StatelessWidget {
  final List<OrderCall> calls;
  final ValueChanged<OrderCall> onTapCall;

  const OrderListView({
    super.key,
    required this.calls,
    required this.onTapCall,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      itemCount: calls.length,
      separatorBuilder: (_, __) => const SizedBox(height: 0),
      itemBuilder: (context, index) {
        final call = calls[index];

        final bool isConsign = call.type == OrderType.consign;
        final String typeLabel = isConsign ? '탁송' : '대리';

        final Widget typeChip = OrderTypeChip(type: call.type);

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onTapCall(call),
          child: OrderCallCard(
            typeLabel: typeLabel,
            typeChip: typeChip,
            startAddress: call.startAddress,
            endAddress: call.endAddress,
            distanceKm: call.distanceKm,
            tags: call.tags,
            price: call.price,
          ),
        );
      },
    );
  }
}
