import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/settlement_viewmodel.dart';
import 'settlement_daily_summary_template.dart';
import 'package:consignment/src/theme/settlement_style.dart';

class SettlementDailyIncomeTab extends StatelessWidget {
  const SettlementDailyIncomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SettlementViewModel>();
    final summary = vm.dailySummary;

    // ✅ 조회 전/데이터 없음 상태 처리
    if (summary == null) {
      return const Center(
        child: Text(
          '조회 버튼을 눌러 일별 수입을 불러오세요.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.2,
            color: Color(0xFF828282),
          ),
        ),
      );
    }

    // ✅ ThemeExtension 가져오되, 누락돼도 앱 안죽게 fallback 제공
    final settlementStyle = Theme.of(context).extension<SettlementStyle>();
    final cardBg = settlementStyle?.dailyCardBg ?? const Color(0xFF000000);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
          decoration: BoxDecoration(
            color: cardBg, // ✅ 흰색 제거 + 검은색 고정
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.transparent, width: 0),
          ),
          child: SettlementDailySummaryTemplate(
            callCount: summary.callCount,
            drivingFee: summary.drivingFee,
            commissionFee: summary.commissionFee,
            etcDeduction: summary.etcDeduction,
            totalDeposit: summary.totalDeposit,
            totalIncome: summary.totalIncome,
            onTapDetailsCallCount: () {
              debugPrint('수행콜수 상세 클릭');
            },
            onTapDetailsCommission: () {
              debugPrint('운행 수수료 상세 클릭');
            },
            onTapDetailsEtcDeduction: () {
              debugPrint('기타 공제액 상세 클릭');
            },
            onTapDetailsTotalDeposit: () {
              debugPrint('총 입금액 상세 클릭');
            },
          ),
        ),
      ),
    );
  }
}
