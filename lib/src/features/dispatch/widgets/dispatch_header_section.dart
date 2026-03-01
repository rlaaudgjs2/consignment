import 'package:flutter/material.dart';
import 'package:consignment/core/data/domain/dispatch.dart';
import 'package:consignment/src/features/order/widgets/order_type_chip.dart';
import 'package:consignment/core/data/domain/order_call.dart';

class DispatchHeaderSection extends StatelessWidget {
  final Dispatch dispatch;

  const DispatchHeaderSection({super.key, required this.dispatch});

  @override
  Widget build(BuildContext context) {
    const List<String> tags = ['현장', '톨별'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OrderTypeChip(
          type: dispatch.callType == DispatchCallType.integrated
              ? OrderType.consign
              : OrderType.proxy,
        ),
        _DetailTagsRow(tags: tags),
      ],
    );
  }
}

class _DetailTagsRow extends StatelessWidget {
  final List<String> tags;

  const _DetailTagsRow({required this.tags});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (tags.isEmpty) return const SizedBox.shrink();

    final textStyle = TextStyle(
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
          Text(tags[i], style: textStyle),
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
