// dispatch_middle_buttons.dart
import 'package:flutter/material.dart';

class DispatchMiddleButtons extends StatelessWidget {
  const DispatchMiddleButtons({super.key});

  @override
  Widget build(BuildContext context) {
    Widget buildOutlined(String label,
        {Color? textColor, Color? borderColor, VoidCallback? onTap}) {
      return OutlinedButton(
        onPressed: onTap ?? () {},
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: borderColor ?? const Color(0xFFE0E0E0)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: textColor ?? const Color(0xFF4F4F4F),
          ),
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: buildOutlined('출발지도')),
            const SizedBox(width: 12),
            Expanded(child: buildOutlined('픽업/지원')),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: buildOutlined('갱신')),
            const SizedBox(width: 12),
            Expanded(
              child: buildOutlined(
                '배차취소',
                textColor: const Color(0xFFE95353),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
