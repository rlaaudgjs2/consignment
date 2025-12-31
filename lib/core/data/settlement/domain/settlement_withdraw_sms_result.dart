class SettlementWithdrawSmsResult {
  final bool success;
  final String message;
  final int smsFeeAmount;

  const SettlementWithdrawSmsResult({
    required this.success,
    required this.message,
    required this.smsFeeAmount,
  });
}
