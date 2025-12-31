class SettlementTransaction {
  final DateTime date;
  final int amount; // 입금(+), 출금(-)
  final int balance;
  final String description;

  const SettlementTransaction({
    required this.date,
    required this.amount,
    required this.balance,
    required this.description,
  });

  bool get isDeposit => amount > 0;
}
