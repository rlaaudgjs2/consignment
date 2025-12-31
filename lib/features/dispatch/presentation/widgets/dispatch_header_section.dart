// dispatch_header_section.dart
import 'package:flutter/material.dart';
import 'package:consignment/features/dispatch/domain/entities/dispatch.dart';
import 'package:consignment/features/order/presentation/widgets/order_type_chip.dart';
import 'package:consignment/features/order/domain/entities/order_call.dart';

class DispatchHeaderSection extends StatelessWidget {
  final Dispatch dispatch;

  const DispatchHeaderSection({super.key, required this.dispatch});

  @override
  Widget build(BuildContext context) {
    // TODO: 실제 태그는 서버 값으로 바꾸기
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
    if (tags.isEmpty) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < tags.length; i++) ...[
          Text(
            tags[i],
            style: const TextStyle(fontSize: 14, color: Color(0xFF828282)),
          ),
          if (i != tags.length - 1)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                '|',
                style: TextStyle(fontSize: 14, color: Color(0xFFBDBDBD)),
              ),
            ),
        ],
      ],
    );
  }
}
