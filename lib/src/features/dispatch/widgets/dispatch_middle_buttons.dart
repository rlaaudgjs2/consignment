import 'package:flutter/material.dart';

class DispatchMiddleButtons extends StatelessWidget {
  final VoidCallback onTapCancelDispatch;

  const DispatchMiddleButtons({
    super.key,
    required this.onTapCancelDispatch,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget buildOutlined(
        String label, {
          Color? textColor,
          Color? borderColor,
          VoidCallback? onTap,
        }) {
      return OutlinedButton(
        onPressed: onTap ?? () {},
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: borderColor ?? cs.outlineVariant),
          foregroundColor: textColor ?? cs.onSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: textColor ?? cs.onSurface,
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
                textColor: cs.error,
                borderColor: cs.error.withOpacity(0.6),
                onTap: onTapCancelDispatch,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
