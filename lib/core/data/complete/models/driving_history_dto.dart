import '../domain/driving_history.dart';

class DrivingHistoryDto {
  final String id; // ✅ 추가
  final String startedAtIso;
  final String startAddress;
  final String endAddress;
  final int price;

  const DrivingHistoryDto({
    required this.id,
    required this.startedAtIso,
    required this.startAddress,
    required this.endAddress,
    required this.price,
  });

  factory DrivingHistoryDto.fromJson(Map<String, dynamic> json) {
    return DrivingHistoryDto(
      id: (json['id'] as String?) ?? '',
      startedAtIso: (json['startedAt'] as String?) ?? '',
      startAddress: (json['startAddress'] as String?) ?? '',
      endAddress: (json['endAddress'] as String?) ?? '',
      price: (json['price'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startedAt': startedAtIso,
      'startAddress': startAddress,
      'endAddress': endAddress,
      'price': price,
    };
  }

  DrivingHistory toEntity() {
    final parsed = DateTime.tryParse(startedAtIso) ?? DateTime(1970, 1, 1);
    return DrivingHistory(
      id: id,
      startedAt: parsed,
      startAddress: startAddress,
      endAddress: endAddress,
      price: price,
    );
  }
}
