import 'package:flutter/material.dart';

@immutable
class OrderChipStyle extends ThemeExtension<OrderChipStyle> {
  final Color background;
  final Color textColor;
  final Color consignIconColor; // 탁송
  final Color proxyIconColor;   // 대리

  const OrderChipStyle({
    required this.background,
    required this.textColor,
    required this.consignIconColor,
    required this.proxyIconColor,
  });

  @override
  OrderChipStyle copyWith({
    Color? background,
    Color? textColor,
    Color? consignIconColor,
    Color? proxyIconColor,
  }) {
    return OrderChipStyle(
      background: background ?? this.background,
      textColor: textColor ?? this.textColor,
      consignIconColor: consignIconColor ?? this.consignIconColor,
      proxyIconColor: proxyIconColor ?? this.proxyIconColor,
    );
  }

  @override
  OrderChipStyle lerp(ThemeExtension<OrderChipStyle>? other, double t) {
    if (other is! OrderChipStyle) return this;
    return OrderChipStyle(
      background: Color.lerp(background, other.background, t)!,
      textColor: Color.lerp(textColor, other.textColor, t)!,
      consignIconColor: Color.lerp(consignIconColor, other.consignIconColor, t)!,
      proxyIconColor: Color.lerp(proxyIconColor, other.proxyIconColor, t)!,
    );
  }
}