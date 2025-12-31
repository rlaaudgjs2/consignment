class SettlementWithdrawSubmitResult {
  final bool success;
  final String message;
  final String? receiptId;

  const SettlementWithdrawSubmitResult({
    required this.success,
    required this.message,
    required this.receiptId,
  });
}
