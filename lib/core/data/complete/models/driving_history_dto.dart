import '../domain/driving_history.dart';

class DrivingHistoryDto {
  final String startedAtIso;
  final String startTitle;
  final String endAddress;
  final int price;

  const DrivingHistoryDto({
    required this.startedAtIso,
    required this.startTitle,
    required this.endAddress,
    required this.price,
  });

  factory DrivingHistoryDto.fromJson(Map<String, dynamic> json) {
    return DrivingHistoryDto(
      startedAtIso: (json['startedAt'] as String?) ?? '',
      startTitle: (json['startTitle'] as String?) ?? '',
      endAddress: (json['endAddress'] as String?) ?? '',
      price: (json['price'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startedAt': startedAtIso,
      'startTitle': startTitle,
      'endAddress': endAddress,
      'price': price,
    };
  }

  DrivingHistory toEntity() {
    final parsed = DateTime.tryParse(startedAtIso) ?? DateTime(1970, 1, 1);
    return DrivingHistory(
      startedAt: parsed,
      startTitle: startTitle,
      endAddress: endAddress,
      price: price,
    );
  }
}
