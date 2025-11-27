import 'package:flutter/foundation.dart';

/// 오더 종류: 탁송 / 대리
enum OrderType {
  consign, // 탁송
  proxy,   // 대리
}

/// 오더(콜) 정보 엔티티
///
/// 지금은 UI용 필드만 넣어두고,
/// 나중에 서버 연동할 때 id, 시간, 차종 등 필드들을 여기로 확장하면 됨.
@immutable
class OrderCall {
  final OrderType type;
  final String startAddress;      // 출발지
  final String endAddress;        // 도착지
  final double distanceKm;        // 기사 → 출발지 거리 (리스트에 4.5km 이런 거)
  final List<String> tags;        // "카드", "하이패스", "경유" ...
  final int price;                // 금액(원)
  final double feeRate;           // 원천징수 비율 (예: 3.3)

  const OrderCall({
    required this.type,
    required this.startAddress,
    required this.endAddress,
    required this.distanceKm,
    required this.tags,
    required this.price,
    required this.feeRate,
  });
}
