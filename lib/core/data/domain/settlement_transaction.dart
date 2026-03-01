class SettlementTransaction {
  final String id; // ✅ 거래 고유 ID(필수)
  final DateTime date;
  final int amount; // 입금(+), 출금(-)
  final int balance;
  final String description;

  const SettlementTransaction({
    required this.id,
    required this.date,
    required this.amount,
    required this.balance,
    required this.description,
  });

  bool get isDeposit => amount > 0;
}
