class SettlementWithdrawInfo {
  final int availableAmount; // 출금가능 금액
  final String bankName;
  final String maskedAccountNumber; // 333318715****
  final String depositorName;
  final int unitAmount; // 10000 단위
  final int feeAmount; // 300원

  const SettlementWithdrawInfo({
    required this.availableAmount,
    required this.bankName,
    required this.maskedAccountNumber,
    required this.depositorName,
    required this.unitAmount,
    required this.feeAmount,
  });
}
