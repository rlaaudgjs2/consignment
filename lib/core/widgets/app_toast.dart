// lib/core/widgets/app_toast.dart
import 'dart:async';
import 'package:flutter/material.dart';

class AppToast {
  AppToast._(); // 인스턴스 생성 막기

  /// 간단하게 호출하는 정적 메서드
  /// 사용 예) AppToast.show(context, '오더를 완료했습니다.');
  static void show(
      BuildContext context,
      String message, {
        Duration duration = const Duration(seconds: 2),
      }) {
    final overlay = Overlay.of(context);
    if (overlay == null) return;

    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => _ToastOverlay(
        message: message,
        onFinish: () => entry.remove(),
        duration: duration,
      ),
    );

    overlay.insert(entry);
  }
}

class _ToastOverlay extends StatefulWidget {
  final String message;
  final VoidCallback onFinish;
  final Duration duration;

  const _ToastOverlay({
    super.key,
    required this.message,
    required this.onFinish,
    required this.duration,
  });

  @override
  State<_ToastOverlay> createState() => _ToastOverlayState();
}

class _ToastOverlayState extends State<_ToastOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _opacity = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    // 등장
    _controller.forward();

    // duration 동안 보여주고 → 페이드아웃 → 제거
    Timer(widget.duration, () async {
      if (!mounted) return;
      await _controller.reverse();
      widget.onFinish();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomPadding = mediaQuery.padding.bottom;

    return IgnorePointer(
      ignoring: true, // 토스트 위 터치 통과
      child: Material(
        type: MaterialType.transparency,
        child: SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: bottomPadding + 32, // 하단 제스처바 위로 약간 띄우기
              ),
              child: FadeTransition(
                opacity: _opacity,
                child: _ToastContainer(message: widget.message),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ToastContainer extends StatelessWidget {
  final String message;

  const _ToastContainer({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Figma: Width Fill(287px) → 가로 꽉 차게하되 maxWidth 제한
      constraints: const BoxConstraints(
        maxWidth: 400, // 태블릿 대비 여유
      ),
      padding: const EdgeInsets.all(16), // Padding 16px
      decoration: BoxDecoration(
        color: const Color(0xFF3B3B3B).withOpacity(0.95), // 95% 불투명
        borderRadius: BorderRadius.circular(8), // Radius 8px
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1.3,
        ),
      ),
    );
  }
}
