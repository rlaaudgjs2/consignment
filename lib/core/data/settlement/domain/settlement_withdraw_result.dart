class SettlementWithdrawSmsResult {
  final bool success;
  final String message;
  final int smsFeeAmount; // 예: 20원

  const SettlementWithdrawSmsResult({
    required this.success,
    required this.message,
    required this.smsFeeAmount,
  });
}

class SettlementWithdrawSubmitResult {
  final bool success;
  final String message;
  final String? receiptId; // 성공 시 영수증/요청ID

  const SettlementWithdrawSubmitResult({
    required this.success,
    required this.message,
    this.receiptId,
  });
}
