import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SettlementDailySummaryTemplate extends StatelessWidget {
  final int callCount;
  final int drivingFee;
  final int commissionFee;
  final int etcDeduction;
  final int totalDeposit;
  final int totalIncome;

  /// 디자인상 "상세" 버튼이 있는 줄만 버튼을 보여줄지,
  /// 아니면 전부 동일 handler로 처리할지 정책에 따라 분리할 수 있음.
  /// 지금은 너가 준 형태를 유지하되, "상세 버튼 자리"는 항상 확보한다.
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
    const labelStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.0,
      color: Color(0xFF333333),
    );

    const valueStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      height: 1.0,
      color: Color(0xFF3B3B3B),
    );

    final totalIncomeStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.0,
      color: totalIncome < 0 ? const Color(0xFFFF6D5E) : const Color(0xFF333333),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _RowItem(
          label: '수행콜수',
          value: '$callCount 건',
          labelStyle: labelStyle,
          valueStyle: valueStyle,
          trailing: _buildDetailButton(onTapDetailsCallCount),
        ),
        const SizedBox(height: 14),

        _RowItem(
          label: '운행료',
          value: _money(drivingFee),
          labelStyle: labelStyle,
          valueStyle: valueStyle,
          // ✅ 버튼은 없지만 "자리"는 반드시 확보
          trailing: _buildDetailPlaceholder(),
        ),
        const SizedBox(height: 14),

        _RowItem(
          label: '운행 수수료',
          value: _money(commissionFee),
          labelStyle: labelStyle,
          valueStyle: valueStyle,
          trailing: _buildDetailButton(onTapDetailsCommission),
        ),
        const SizedBox(height: 14),

        _RowItem(
          label: '기타 공제액',
          value: _money(etcDeduction),
          labelStyle: labelStyle,
          valueStyle: valueStyle,
          trailing: _buildDetailButton(onTapDetailsEtcDeduction),
        ),
        const SizedBox(height: 14),

        _RowItem(
          label: '총 입금액',
          value: _money(totalDeposit),
          labelStyle: labelStyle,
          valueStyle: valueStyle,
          trailing: _buildDetailButton(onTapDetailsTotalDeposit),
        ),
        const SizedBox(height: 18),

        _RowItem(
          label: '총 수입',
          value: _money(totalIncome),
          labelStyle: labelStyle,
          valueStyle: totalIncomeStyle,
          // ✅ 총 수입은 버튼 없음(자리만)
          trailing: _buildDetailPlaceholder(),
        ),
      ],
    );
  }

  Widget _buildDetailPlaceholder() {
    // ✅ 버튼이 없는 줄도 동일한 trailing 폭을 확보해서 value 정렬 기준선을 고정
    return const SizedBox(
      width: _kDetailButtonWidth,
      height: _kDetailButtonHeight,
    );
  }

  Widget _buildDetailButton(VoidCallback? onTap) {
    if (onTap == null) {
      // 버튼이 "없는" 상태라면 자리만
      return _buildDetailPlaceholder();
    }

    return SizedBox(
      width: _kDetailButtonWidth,
      height: _kDetailButtonHeight,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFDADADA), width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.zero,
        ),
        child: const Text(
          '상세',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 1.0,
            color: Color(0xFF828282),
          ),
        ),
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

  // ✅ 라벨(좌측) 컬럼 폭: 원하는 만큼 조절
  static const double _kLabelWidth = 120;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ✅ 라벨은 "폭을 확보"하고, 텍스트는 "우측정렬"
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

        const SizedBox(width: 16), // 라벨과 값 사이 간격(디자인에 맞춰 조절)

        // ✅ 값은 trailing(상세 버튼) 바로 왼쪽에서 right-align
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

        // trailing(상세 버튼/placeholder)
        trailing,
      ],
    );
  }
}