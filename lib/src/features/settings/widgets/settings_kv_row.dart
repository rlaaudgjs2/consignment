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

  static const _labelStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.0,
    color: Color(0xFF9A9A9A),
  );

  static const _valueStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    height: 1.0,
    color: Color(0xFF333333),
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 110, child: Text(label, style: _labelStyle)),
        Expanded(
          child: Text(
            value,
            style: valueStyle ?? _valueStyle,
          ),
        ),
      ],
    );
  }
}
