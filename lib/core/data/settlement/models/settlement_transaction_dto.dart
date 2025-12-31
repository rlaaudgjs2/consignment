import 'package:consignment/core/data/settlement/domain/settlement_transaction.dart';

class SettlementTransactionDto {
  final String? date; // "2025-11-09"
  final int? amount;
  final int? balance;
  final String? description;

  const SettlementTransactionDto({
    this.date,
    this.amount,
    this.balance,
    this.description,
  });

  factory SettlementTransactionDto.fromJson(Map<String, dynamic> json) {
    return SettlementTransactionDto(
      date: json['date'] as String?,
      amount: json['amount'] as int?,
      balance: json['balance'] as int?,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'amount': amount,
      'balance': balance,
      'description': description,
    };
  }

  SettlementTransaction toEntity() {
    final parsed = _tryParseDate(date) ?? DateTime.now();
    return SettlementTransaction(
      date: DateTime(parsed.year, parsed.month, parsed.day),
      amount: amount ?? 0,
      balance: balance ?? 0,
      description: description ?? '',
    );
  }

  DateTime? _tryParseDate(String? v) {
    if (v == null) return null;
    try {
      return DateTime.parse(v);
    } catch (_) {
      return null;
    }
  }
}
