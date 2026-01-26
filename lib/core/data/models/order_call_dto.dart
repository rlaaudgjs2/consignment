import 'package:consignment/core/data/domain/order_call.dart';

class OrderCallDto {
  final int? id;
  final String? serviceType; // DELIVERY(탁송), DRIVER(대리)
  final int? charge;
  final String? startLocation;
  final String? destinationLocation;
  final String? status; // OPEN/ASSIGNED/COMPLETED/CANCELED
  final double? distanceKm;
  final List<String>? tags;

  const OrderCallDto({
    this.id,
    this.serviceType,
    this.charge,
    this.startLocation,
    this.destinationLocation,
    this.status,
    this.distanceKm,
    this.tags,
  });

  factory OrderCallDto.fromJson(Map<String, dynamic> json) {
    return OrderCallDto(
      id: json['id'] as int?,
      serviceType: json['serviceType'] as String?,
      charge: json['charge'] as int?,
      startLocation: json['startLocation'] as String?,
      destinationLocation: json['destinationLocation'] as String?,
      status: json['status'] as String?,
      distanceKm: (json['distanceKm'] as num?)?.toDouble(),
      tags: (json['tags'] as List?)?.whereType<String>().toList(),
    );
  }

  /// serviceType -> OrderType
  static OrderType _mapServiceTypeToOrderType(String? value) {
    switch ((value ?? '').toUpperCase()) {
      case 'DELIVERY':
        return OrderType.consign; // 탁송
      case 'DRIVER':
        return OrderType.proxy; // 대리
      default:
      // 서버가 예외 값을 주더라도 UI가 깨지지 않게 기본은 탁송으로 처리
        return OrderType.consign;
    }
  }

  /// DTO -> Domain Entity
  OrderCall toEntity() {
    return OrderCall(
      id: id ?? 0,
      serviceType: _mapServiceTypeToOrderType(serviceType),
      startLocation: startLocation ?? '',
      destinationLocation: destinationLocation ?? '',
      distanceKm: distanceKm ?? 0.0,
      tags: List<String>.unmodifiable(tags ?? const <String>[]),
      charge: charge ?? 0,
      feeRate: 0.0, // 서버 응답에 없으므로 기본값
      status: OrderStatus.fromString(status),
    );
  }
}
