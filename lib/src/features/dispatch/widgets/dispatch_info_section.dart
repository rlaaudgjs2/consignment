import 'package:flutter/material.dart';
import 'package:consignment/core/data/domain/dispatch.dart';

class DispatchInfoSection extends StatelessWidget {
  final Dispatch dispatch;

  const DispatchInfoSection({super.key, required this.dispatch});

  @override
  Widget build(BuildContext context) {
    final String chargeText = _formatPrice(dispatch.charge);
    final String createdTimeText = _formatTime(dispatch.createdAt);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LabelValueRow(label: '출발지', value: dispatch.startLocation),
        const SizedBox(height: 10),
        _LabelValueRow(label: '도착지', value: dispatch.destinationLocation),
        const SizedBox(height: 10),
        _LabelValueRow(label: '요금', value: chargeText),
        const SizedBox(height: 10),
        _LabelValueRow(label: '접수시간', value: createdTimeText),
      ],
    );
  }
}

class _LabelValueRow extends StatelessWidget {
  final String label;
  final String value;

  const _LabelValueRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 60,
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
  return '$buffer원';
}

String _formatTime(DateTime createdAt) {
  final hh = createdAt.hour.toString().padLeft(2, '0');
  final mm = createdAt.minute.toString().padLeft(2, '0');
  return '$hh:$mm';
}
