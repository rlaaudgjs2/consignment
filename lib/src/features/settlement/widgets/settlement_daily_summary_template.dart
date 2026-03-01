import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:consignment/src/theme/settlement_daily_summary_style.dart';

class SettlementDailySummaryTemplate extends StatelessWidget {
  final int callCount;
  final int drivingFee;
  final int commissionFee;
  final int etcDeduction;
  final int totalDeposit;
  final int totalIncome;

  final VoidCallback? onTapDetailsCallCount;
  final VoidCallback? onTapDetailsCommission;
  final VoidCallback? onTapDetailsEtcDeduction;
  final VoidCallback? onTapDetailsTotalDeposit;

  const SettlementDailySummaryTemplate({
    super.key,
    required this.callCount,
    required this.drivingFee,
    required this.commissionFee,
    required this.etcDeduction,
    required this.totalDeposit,
    required this.totalIncome,
    this.onTapDetailsCallCount,
    this.onTapDetailsCommission,
    this.onTapDetailsEtcDeduction,
    this.onTapDetailsTotalDeposit,
  });

  static const double _kDetailButtonWidth = 80;
  static const double _kDetailButtonHeight = 32;

  @override
  Widget build(BuildContext context) {
    final ext = Theme.of(context).extension<SettlementDailySummaryStyle>();
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    // ✅ 혹시 extensions 등록이 빠져도 절대 안죽게 fallback
    final fallback = SettlementDailySummaryStyle(
      labelStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.0,
        color: isDark ? const Color(0xFFF6F6F4) : const Color(0xFF333333),
      ),
      valueStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 1.0,
        color: isDark ? const Color(0xFFF6F6F4) : const Color(0xFF3B3B3B),
      ),
      negativeColor: const Color(0xFFFF6D5E),
      detailBorderColor: const Color(0xFFDADADA),
      detailTextStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.0,
        color: isDark ? const Color(0xFFDADADA) : const Color(0xFF828282),
      ),
    );

    final style = ext ?? fallback;

    final totalIncomeStyle = style.valueStyle.copyWith(
      fontWeight: FontWeight.w600,
      color: totalIncome < 0 ? style.negativeColor : style.valueStyle.color,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _RowItem(
          label: '수행콜수',
          value: '$callCount 건',
          labelStyle: style.labelStyle,
          valueStyle: style.valueStyle,
          trailing: _buildDetailButton(style, onTapDetailsCallCount),
        ),
        const SizedBox(height: 14),

        _RowItem(
          label: '운행료',
          value: _money(drivingFee),
          labelStyle: style.labelStyle,
          valueStyle: style.valueStyle,
          trailing: _buildDetailPlaceholder(),
        ),
        const SizedBox(height: 14),

        _RowItem(
          label: '운행 수수료',
          value: _money(commissionFee),
          labelStyle: style.labelStyle,
          valueStyle: style.valueStyle,
          trailing: _buildDetailButton(style, onTapDetailsCommission),
        ),
        const SizedBox(height: 14),

        _RowItem(
          label: '기타 공제액',
          value: _money(etcDeduction),
          labelStyle: style.labelStyle,
          valueStyle: style.valueStyle,
          trailing: _buildDetailButton(style, onTapDetailsEtcDeduction),
        ),
        const SizedBox(height: 14),

        _RowItem(
          label: '총 입금액',
          value: _money(totalDeposit),
          labelStyle: style.labelStyle,
          valueStyle: style.valueStyle,
          trailing: _buildDetailButton(style, onTapDetailsTotalDeposit),
        ),
        const SizedBox(height: 18),

        _RowItem(
          label: '총 수입',
          value: _money(totalIncome),
          labelStyle: style.labelStyle,
          valueStyle: totalIncomeStyle,
          trailing: _buildDetailPlaceholder(),
        ),
      ],
    );
  }

  Widget _buildDetailPlaceholder() {
    return const SizedBox(
      width: _kDetailButtonWidth,
      height: _kDetailButtonHeight,
    );
  }

  Widget _buildDetailButton(SettlementDailySummaryStyle style, VoidCallback? onTap) {
    if (onTap == null) return _buildDetailPlaceholder();

    return SizedBox(
      width: _kDetailButtonWidth,
      height: _kDetailButtonHeight,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: style.detailBorderColor, width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.zero,
        ),
        child: Text('상세', style: style.detailTextStyle),
      ),
    );
  }

  String _money(int value) {
    final f = NumberFormat('#,###');
    final abs = value.abs();
    final s = f.format(abs);
    if (value < 0) return '-$s 원';
    return '$s 원';
  }
}

class _RowItem extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle labelStyle;
  final TextStyle valueStyle;
  final Widget trailing;

  const _RowItem({
    required this.label,
    required this.value,
    required this.labelStyle,
    required this.valueStyle,
    required this.trailing,
  });

  static const double _kTrailingGap = 14;
  static const double _kLabelWidth = 120;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: _kLabelWidth,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              label,
              style: labelStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              value,
              style: valueStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        const SizedBox(width: _kTrailingGap),
        trailing,
      ],
    );
  }
}
