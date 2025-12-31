// dispatch_bottom_buttons.dart
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: buttonWidth,
          height: 48,
          child: OutlinedButton(
            onPressed: onTapNavi,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFFBB35F)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              '내비연동 (길안내)',
              style: TextStyle(
                color: Color(0xFFFBB35F),
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
              backgroundColor: const Color(0xFFFBB35F),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              '완료',
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }
}
