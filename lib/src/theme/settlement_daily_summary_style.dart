import 'package:flutter/material.dart';

@immutable
class SettlementDailySummaryStyle extends ThemeExtension<SettlementDailySummaryStyle> {
  // Row label/value
  final TextStyle labelStyle;
  final TextStyle valueStyle;
  final Color negativeColor; // totalIncome < 0

  // "상세" 버튼
  final Color detailBorderColor;
  final TextStyle detailTextStyle;

  const SettlementDailySummaryStyle({
    required this.labelStyle,
    required this.valueStyle,
    required this.negativeColor,
    required this.detailBorderColor,
    required this.detailTextStyle,
  });

  @override
  SettlementDailySummaryStyle copyWith({
    TextStyle? labelStyle,
    TextStyle? valueStyle,
    Color? negativeColor,
    Color? detailBorderColor,
    TextStyle? detailTextStyle,
  }) {
    return SettlementDailySummaryStyle(
      labelStyle: labelStyle ?? this.labelStyle,
      valueStyle: valueStyle ?? this.valueStyle,
      negativeColor: negativeColor ?? this.negativeColor,
      detailBorderColor: detailBorderColor ?? this.detailBorderColor,
      detailTextStyle: detailTextStyle ?? this.detailTextStyle,
    );
  }

  @override
  SettlementDailySummaryStyle lerp(
      ThemeExtension<SettlementDailySummaryStyle>? other,
      double t,
      ) {
    if (other is! SettlementDailySummaryStyle) return this;

    return SettlementDailySummaryStyle(
      labelStyle: TextStyle.lerp(labelStyle, other.labelStyle, t)!,
      valueStyle: TextStyle.lerp(valueStyle, other.valueStyle, t)!,
      negativeColor: Color.lerp(negativeColor, other.negativeColor, t)!,
      detailBorderColor: Color.lerp(detailBorderColor, other.detailBorderColor, t)!,
      detailTextStyle: TextStyle.lerp(detailTextStyle, other.detailTextStyle, t)!,
    );
  }
}
