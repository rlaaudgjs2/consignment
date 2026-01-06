import 'package:consignment/core/data/domain/order_call.dart';

class OrderCallDto {
  final OrderType? type;
  final String? startAddress;
  final String? endAddress;
  final double? distanceKm;
  final List<String>? tags;
  final int? price;
  final double? feeRate;

  OrderCallDto({
    this.type,
    this.startAddress,
    this.endAddress,
    this.distanceKm,
    this.tags,
    this.price,
    this.feeRate,
  });

  factory OrderCallDto.fromJson(Map<String, dynamic> json) {
    return OrderCallDto(
      type: _parseOrderType(json['type']),
      startAddress: json['start_address'] as String?,
      endAddress: json['end_address'] as String?,
      distanceKm: (json['distance_km'] as num?)?.toDouble(),
      tags: (json['tags'] as List?)?.whereType<String>().toList(),
      price: json['price'] as int?,
      feeRate: (json['fee_rate'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type?.name,
    'start_address': startAddress,
    'end_address': endAddress,
    'distance_km': distanceKm,
    'tags': tags,
    'price': price,
    'fee_rate': feeRate,
  };

  static OrderType? _parseOrderType(dynamic value) {
    if (value is String) {
      switch (value.toUpperCase()) {
        case 'CONSIGN':
          return OrderType.consign;
        case 'PROXY':
          return OrderType.proxy;
      }
    }
    return null;
  }

  /// DTO -> Domain Entity
  OrderCall toEntity() {
    return OrderCall(
      type: type ?? OrderType.consign,
      startAddress: startAddress ?? '',
      endAddress: endAddress ?? '',
      distanceKm: distanceKm ?? 0.0,
      tags: List<String>.unmodifiable(tags ?? const <String>[]),
      price: price ?? 0,
      feeRate: feeRate ?? 0.0,
    );
  }
}
