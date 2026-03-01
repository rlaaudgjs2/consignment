import 'package:flutter/material.dart';

@immutable
class SettlementTransactionsStyle extends ThemeExtension<SettlementTransactionsStyle> {
  // 테이블 구분선
  final Color dividerColor;

  // 헤더(일자/입출금/잔액/내역)
  final TextStyle headerStyle;

  // 본문(날짜/잔액/기본 텍스트)
  final TextStyle bodyStyle;

  // 내역(description)
  final TextStyle descStyle;

  // 입금/출금 금액 색
  final Color depositColor;
  final Color withdrawColor;

  const SettlementTransactionsStyle({
    required this.dividerColor,
    required this.headerStyle,
    required this.bodyStyle,
    required this.descStyle,
    required this.depositColor,
    required this.withdrawColor,
  });

  @override
  SettlementTransactionsStyle copyWith({
    Color? dividerColor,
    TextStyle? headerStyle,
    TextStyle? bodyStyle,
    TextStyle? descStyle,
    Color? depositColor,
    Color? withdrawColor,
  }) {
    return SettlementTransactionsStyle(
      dividerColor: dividerColor ?? this.dividerColor,
      headerStyle: headerStyle ?? this.headerStyle,
      bodyStyle: bodyStyle ?? this.bodyStyle,
      descStyle: descStyle ?? this.descStyle,
      depositColor: depositColor ?? this.depositColor,
      withdrawColor: withdrawColor ?? this.withdrawColor,
    );
  }

  @override
  SettlementTransactionsStyle lerp(ThemeExtension<SettlementTransactionsStyle>? other, double t) {
    if (other is! SettlementTransactionsStyle) return this;
    return SettlementTransactionsStyle(
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t)!,
      headerStyle: TextStyle.lerp(headerStyle, other.headerStyle, t)!,
      bodyStyle: TextStyle.lerp(bodyStyle, other.bodyStyle, t)!,
      descStyle: TextStyle.lerp(descStyle, other.descStyle, t)!,
      depositColor: Color.lerp(depositColor, other.depositColor, t)!,
      withdrawColor: Color.lerp(withdrawColor, other.withdrawColor, t)!,
    );
  }
}
