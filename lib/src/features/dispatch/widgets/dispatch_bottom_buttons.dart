import 'package:flutter/material.dart';

class DispatchBottomButtons extends StatelessWidget {
  final double buttonWidth;
  final double gap;
  final VoidCallback onTapNavi;
  final VoidCallback onTapComplete;

  const DispatchBottomButtons({
    super.key,
    required this.buttonWidth,
    required this.gap,
    required this.onTapNavi,
    required this.onTapComplete,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Row(
      children: [
        SizedBox(
          width: buttonWidth,
          height: 48,
          child: OutlinedButton(
            onPressed: onTapNavi,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: cs.primary),
              foregroundColor: cs.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              '내비연동 (길안내)',
              style: TextStyle(
                color: cs.primary,
                fontSize: 15,
              ),
            ),
          ),
        ),
        SizedBox(width: gap),
        SizedBox(
          width: buttonWidth,
          height: 48,
          child: ElevatedButton(
            onPressed: onTapComplete,
            style: ElevatedButton.styleFrom(
              backgroundColor: cs.primary,
              foregroundColor: cs.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              '완료',
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }
}
