class DrivingHistory {
  final String id;
  final DateTime startedAt;
  final String startAddress;
  final String endAddress;
  final int price;

  const DrivingHistory({
    required this.id,
    required this.startedAt,
    required this.startAddress,
    required this.endAddress,
    required this.price,
  });
}
