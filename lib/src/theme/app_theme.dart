import 'package:flutter/material.dart';

import 'order_chip_style.dart';
import 'settlement_style.dart';
import 'settlement_daily_summary_style.dart';
import 'settlement_transactions_style.dart';

class AppTheme {
  static const _seed = Color(0xFFFBB35F);

  static ThemeData light() {
    final cs = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.light,
    ).copyWith(
      primary: const Color(0xFFFBB35F),
      secondary: const Color(0xFFFF8A76),
      tertiary: const Color(0xFF09AF81),

      background: Colors.white,
      surface: Colors.white,
    );

    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      colorScheme: cs,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.white,
      ),
      dividerTheme: const DividerThemeData(
        thickness: 1,
        color: Color(0xFFEDEDED),
      ),

      extensions: const [
        OrderChipStyle(
          background: Color(0xFFF6F6F4),
          textColor: Color(0xFF828282),
          consignIconColor: Color(0xFF09AF81),
          proxyIconColor: Color(0xFFFF8A76),
        ),

        SettlementDailySummaryStyle(
          labelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.0,
            color: Color(0xFF333333),
          ),
          valueStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.0,
            color: Color(0xFF3B3B3B),
          ),
          negativeColor: Color(0xFFFF6D5E),
          detailBorderColor: Color(0xFFDADADA),
          detailTextStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1.0,
            color: Color(0xFF828282),
          ),
        ),

        // ✅ SettlementStyle - 라이트 (dailyCardBg 추가 필수)
        SettlementStyle(
          subTabBackground: Color(0xFFF6F6F4),   // 선택 안됨 배경
          subTabSelectedBg: Color(0xFFFFFFFF),   // 선택 됨 배경 (기존 FBB35F였던 자리)
          subTabUnselectedText: Color(0xFF828282),
          subTabSelectedText: Color(0xFF3B3B3B),

          walletCardBg: Color(0xFFF6F6F6),
          walletTitleText: Color(0xFF333333),
          walletAmountText: Color(0xFFFBB35F),

          withdrawButtonBg: Color(0xFFFBB35F),
          withdrawButtonText: Color(0xFFFFFFFF),

          // ✅ 추가된 required 파라미터
          dailyCardBg: Color(0xFFFFFFFF),
        ),

        // ✅ 입출금 내역 테이블 스타일 - 라이트
        SettlementTransactionsStyle(
          dividerColor: Color(0xFFEDEDED),
          headerStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.0,
            color: Color(0xFF828282),
          ),
          bodyStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.0,
            color: Color(0xFF333333),
          ),
          descStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.0,
            color: Color(0xFF333333),
          ),
          depositColor: Color(0xFF2F80ED),
          withdrawColor: Color(0xFFFF5A5A),
        ),
      ],

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFBB35F),
          foregroundColor: const Color(0xFF3B3B3B),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 1.0,
          ),
        ),
      ),
    );
  }

  static ThemeData dark() {
    final cs = ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.dark,
    ).copyWith(
      background: const Color(0xFF000000),
      surface: const Color(0xFF000000),
    );

    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme: cs,
      scaffoldBackgroundColor: const Color(0xFF000000),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0F0F0F),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      dividerTheme: const DividerThemeData(
        thickness: 1,
        color: Color(0xFF222222),
      ),

      extensions: const [
        OrderChipStyle(
          background: Color(0xFF3B3B3B),
          textColor: Color(0xFFF6F6F4),
          consignIconColor: Color(0xFF09AF81),
          proxyIconColor: Color(0xFFFF8A76),
        ),

        SettlementDailySummaryStyle(
          labelStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.0,
            color: Color(0xFFF6F6F4),
          ),
          valueStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.0,
            color: Color(0xFFF6F6F4),
          ),
          negativeColor: Color(0xFFFF6D5E),
          detailBorderColor: Color(0xFFDADADA),
          detailTextStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1.0,
            color: Color(0xFFDADADA),
          ),
        ),

        // ✅ SettlementStyle - 다크 (dailyCardBg 추가 필수)
        SettlementStyle(
          subTabBackground: Color(0xFF3B3B3B),   // 선택 안됨 배경
          subTabSelectedBg: Color(0xFFFBB35F),   // 선택 됨 배경
          subTabUnselectedText: Color(0xFFDADADA),
          subTabSelectedText: Color(0xFF3B3B3B),

          walletCardBg: Color(0xFF3B3B3B),
          walletTitleText: Color(0xFFF6F6F4),
          walletAmountText: Color(0xFFFBB35F),

          withdrawButtonBg: Color(0xFFFBB35F),
          withdrawButtonText: Color(0xFF3B3B3B),

          // ✅ 추가된 required 파라미터
          dailyCardBg: Color(0xFF000000),
        ),

        // ✅ 입출금 내역 테이블 스타일 - 다크
        SettlementTransactionsStyle(
          dividerColor: Color(0xFF222222),
          headerStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.0,
            color: Color(0xFFDADADA),
          ),
          bodyStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.0,
            color: Color(0xFFF6F6F4),
          ),
          descStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.0,
            color: Color(0xFFF6F6F4),
          ),
          depositColor: Color(0xFF2F80ED),
          withdrawColor: Color(0xFFFF5A5A),
        ),
      ],

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFBB35F),
          foregroundColor: const Color(0xFF3B3B3B),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 1.0,
          ),
        ),
      ),
    );
  }
}
