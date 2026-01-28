import 'package:flutter/foundation.dart';

/// 오더 종류: 탁송 / 대리
enum OrderType {
  consign, // 탁송
  proxy,   // 대리
}

/// 서버 배차 상태 (Swagger: OPEN/ASSIGNED/COMPLETED/CANCELED)
enum OrderStatus {
  open,
  assigned,
  completed,
  canceled;

  static OrderStatus fromString(String? value) {
    switch ((value ?? '').toUpperCase()) {
      case 'OPEN':
        return OrderStatus.open;
      case 'ASSIGNED':
        return OrderStatus.assigned;
      case 'COMPLETED':
        return OrderStatus.completed;
      case 'CANCELED':
        return OrderStatus.canceled;
      default:
        return OrderStatus.open;
    }
  }
}

/// 오더(콜) 정보 엔티티
@immutable
class OrderCall {
  final int id;                  // 서버 배차 id
  final OrderType serviceType;          // DELIVERY/DRIVER -> consign/proxy
  final String startLocation;     // 출발지
  final String destinationLocation;       // 도착지
  final double distanceKm;       // 기사 → 출발지 거리
  final List<String> tags;
  final int charge;               // charge
  final double feeRate;          // 현재 서버 응답에는 없음(기본값 0.0)
  final OrderStatus status;      // OPEN/ASSIGNED/COMPLETED/CANCELED

  const OrderCall({
    required this.id,
    required this.serviceType,
    required this.startLocation,
    required this.destinationLocation,
    required this.distanceKm,
    required this.tags,
    required this.charge,
    required this.feeRate,
    required this.status,
  });
}
