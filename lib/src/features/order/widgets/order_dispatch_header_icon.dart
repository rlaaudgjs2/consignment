import 'package:flutter/material.dart';

/// 디테일/탭에서 공통으로 쓰는
/// "차량 + 위에서 내려오는 화살표" 아이콘
class OrderDispatchHeaderIcon extends StatelessWidget {
  const OrderDispatchHeaderIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    final Color color = iconTheme.color ?? Colors.white;
    final double size = iconTheme.size ?? 28.0;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 차량 아이콘
          Positioned(
            bottom: 2,
            child: Icon(
              Icons.directions_car,
              color: color,
              size: size * 0.75, // 24기준 18 정도
            ),
          ),
          // 위에서 아래로 가리키는 화살표
          Positioned(
            top: -8,
            child: Icon(
              Icons.arrow_drop_down,
              color: color,
              size: size * 0.9,
            ),
          ),
        ],
      ),
    );
  }
}
