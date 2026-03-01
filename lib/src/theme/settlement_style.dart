import 'package:flutter/material.dart';

@immutable
class SettlementStyle extends ThemeExtension<SettlementStyle> {
  final Color subTabBackground;     // #3B3B3B
  final Color subTabSelectedBg;     // #FBB35F
  final Color subTabUnselectedText; // #DADADA
  final Color subTabSelectedText;   // 선택된 탭 텍스트

  final Color walletCardBg;         // #3B3B3B
  final Color walletTitleText;      // #F6F6F4
  final Color walletAmountText;     // #FBB35F

  final Color withdrawButtonBg;     // #FBB35F
  final Color withdrawButtonText;   // #3B3B3B

  // ✅ 추가: 일별 수입 카드 배경 (요구: 그냥 검은색)
  final Color dailyCardBg;          // #000000

  const SettlementStyle({
    required this.subTabBackground,
    required this.subTabSelectedBg,
    required this.subTabUnselectedText,
    required this.subTabSelectedText,
    required this.walletCardBg,
    required this.walletTitleText,
    required this.walletAmountText,
    required this.withdrawButtonBg,
    required this.withdrawButtonText,
    required this.dailyCardBg,
  });

  @override
  SettlementStyle copyWith({
    Color? subTabBackground,
    Color? subTabSelectedBg,
    Color? subTabUnselectedText,
    Color? subTabSelectedText,
    Color? walletCardBg,
    Color? walletTitleText,
    Color? walletAmountText,
    Color? withdrawButtonBg,
    Color? withdrawButtonText,
    Color? dailyCardBg,
  }) {
    return SettlementStyle(
      subTabBackground: subTabBackground ?? this.subTabBackground,
      subTabSelectedBg: subTabSelectedBg ?? this.subTabSelectedBg,
      subTabUnselectedText: subTabUnselectedText ?? this.subTabUnselectedText,
      subTabSelectedText: subTabSelectedText ?? this.subTabSelectedText,
      walletCardBg: walletCardBg ?? this.walletCardBg,
      walletTitleText: walletTitleText ?? this.walletTitleText,
      walletAmountText: walletAmountText ?? this.walletAmountText,
      withdrawButtonBg: withdrawButtonBg ?? this.withdrawButtonBg,
      withdrawButtonText: withdrawButtonText ?? this.withdrawButtonText,
      dailyCardBg: dailyCardBg ?? this.dailyCardBg,
    );
  }

  @override
  SettlementStyle lerp(ThemeExtension<SettlementStyle>? other, double t) {
    if (other is! SettlementStyle) return this;

    return SettlementStyle(
      subTabBackground: Color.lerp(subTabBackground, other.subTabBackground, t)!,
      subTabSelectedBg: Color.lerp(subTabSelectedBg, other.subTabSelectedBg, t)!,
      subTabUnselectedText: Color.lerp(subTabUnselectedText, other.subTabUnselectedText, t)!,
      subTabSelectedText: Color.lerp(subTabSelectedText, other.subTabSelectedText, t)!,
      walletCardBg: Color.lerp(walletCardBg, other.walletCardBg, t)!,
      walletTitleText: Color.lerp(walletTitleText, other.walletTitleText, t)!,
      walletAmountText: Color.lerp(walletAmountText, other.walletAmountText, t)!,
      withdrawButtonBg: Color.lerp(withdrawButtonBg, other.withdrawButtonBg, t)!,
      withdrawButtonText: Color.lerp(withdrawButtonText, other.withdrawButtonText, t)!,
      dailyCardBg: Color.lerp(dailyCardBg, other.dailyCardBg, t)!,
    );
  }
}
