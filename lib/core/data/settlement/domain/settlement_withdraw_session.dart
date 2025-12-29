class SettlementWithdrawSession {
  /// 인증/출금 제출 API 호출에 필요한 세션 식별자
  final String sessionId;

  /// 화면 표시용(마스킹 해제 계좌 포함 가능)
  final String bankName;
  final String accountNumber;
  final String depositorName;
  final int amount;

  const SettlementWithdrawSession({
    required this.sessionId,
    required this.bankName,
    required this.accountNumber,
    required this.depositorName,
    required this.amount,
  });
}
