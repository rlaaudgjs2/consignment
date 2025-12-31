import 'package:flutter/material.dart';

class LoginLogo extends StatelessWidget {
  const LoginLogo({super.key});

  static const Color _mainColor = Color(0xFFFBB35F);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'MOBI',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 44,
          fontWeight: FontWeight.w700,
          fontFamily: 'Tsukimi Rounded',
          height: 1.0,
          letterSpacing: 0,
          color: _mainColor,
        ),
      ),
    );
  }
}
