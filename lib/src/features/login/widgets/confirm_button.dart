import 'package:flutter/material.dart';

class ConfirmButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onPressed;

  const ConfirmButton({
    super.key,
    required this.enabled,
    required this.onPressed,
  });

  static const Color _mainColor = Color(0xFFFBB35F);

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          0,
          20,
          16 + bottomInset,
        ),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: enabled ? onPressed : null,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: _mainColor,
              disabledBackgroundColor: _mainColor.withOpacity(0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              '확인',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Pretendard',
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
