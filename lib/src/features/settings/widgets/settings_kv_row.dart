import 'package:flutter/material.dart';

class SettingsKvRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? valueStyle;

  const SettingsKvRow({
    super.key,
    required this.label,
    required this.value,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final labelStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.0,
      color: cs.onSurface.withOpacity(0.55),
    );

    final defaultValueStyle = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w700,
      height: 1.0,
      color: cs.onSurface,
    );

    return Row(
      children: [
        SizedBox(width: 110, child: Text(label, style: labelStyle)),
        Expanded(
          child: Text(
            value,
            style: valueStyle ?? defaultValueStyle,
          ),
        ),
      ],
    );
  }
}
