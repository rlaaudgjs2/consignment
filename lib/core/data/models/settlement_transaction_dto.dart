import '../domain/settlement_transaction.dart';

class SettlementTransactionDto {
  final String id;
  final String date; // yyyy-MM-dd (서버 스펙에 따라 바뀔 수 있음)
  final int amount;
  final int balance;
  final String description;

  const SettlementTransactionDto({
    required this.id,
    required this.date,
    required this.amount,
    required this.balance,
    required this.description,
  });

  factory SettlementTransactionDto.fromJson(Map<String, dynamic> json) {
    return SettlementTransactionDto(
      id: (json['id'] as String?) ?? '',
      date: (json['date'] as String?) ?? '',
      amount: (json['amount'] as int?) ?? 0,
      balance: (json['balance'] as int?) ?? 0,
      description: (json['description'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'amount': amount,
      'balance': balance,
      'description': description,
    };
  }

  SettlementTransaction toEntity() {
    final parsed = DateTime.tryParse(date) ?? DateTime(1970, 1, 1);
    return SettlementTransaction(
      id: id,
      date: parsed,
      amount: amount,
      balance: balance,
      description: description,
    );
  }
}
