import '../domain/settlement_withdraw_session.dart';

class SettlementWithdrawSessionDto {
  final String sessionId;
  final String bankName;
  final String accountNumber;
  final String depositorName;
  final int amount;

  const SettlementWithdrawSessionDto({
    required this.sessionId,
    required this.bankName,
    required this.accountNumber,
    required this.depositorName,
    required this.amount,
  });

  SettlementWithdrawSession toEntity() {
    return SettlementWithdrawSession(
      sessionId: sessionId,
      bankName: bankName,
      accountNumber: accountNumber,
      depositorName: depositorName,
      amount: amount,
    );
  }

  factory SettlementWithdrawSessionDto.fromJson(Map<String, dynamic> json) {
    return SettlementWithdrawSessionDto(
      sessionId: (json['sessionId'] ?? '') as String,
      bankName: (json['bankName'] ?? '') as String,
      accountNumber: (json['accountNumber'] ?? '') as String,
      depositorName: (json['depositorName'] ?? '') as String,
      amount: (json['amount'] ?? 0) as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'bankName': bankName,
      'accountNumber': accountNumber,
      'depositorName': depositorName,
      'amount': amount,
    };
  }
}
