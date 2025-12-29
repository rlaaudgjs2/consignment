class SettlementDailySummary {
  final int callCount;
  final int drivingFee;
  final int commissionFee;
  final int etcDeduction;
  final int totalDeposit;
  final int totalIncome;

  const SettlementDailySummary({
    required this.callCount,
    required this.drivingFee,
    required this.commissionFee,
    required this.etcDeduction,
    required this.totalDeposit,
    required this.totalIncome,
  });
}
