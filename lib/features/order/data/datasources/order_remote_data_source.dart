// features/order/data/datasources/order_remote_data_source.dart

import 'package:consignment/features/order/domain/entities/order_call.dart';
import 'package:consignment/features/order/data/models/order_call_dto.dart';

abstract class OrderRemoteDataSource {
  Future<List<OrderCallDto>> fetchOrderCalls({
    required int maxDistanceKm,
  });
}

/// Mock 데이터 (향후 API 연동 시 교체)
class MockOrderRemoteDataSource implements OrderRemoteDataSource {
  @override
  Future<List<OrderCallDto>> fetchOrderCalls({
    required int maxDistanceKm,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final mockList = [
      OrderCallDto(
        type: OrderType.consign,
        startAddress: '강남구 456-78',
        endAddress: '서초동 123-45',
        distanceKm: 4.5,
        tags: ['카드', '하이패스'],
        price: 90000,
        feeRate: 3.3,
      ),
      OrderCallDto(
        type: OrderType.consign,
        startAddress: '서초동 그랜드오피스텔',
        endAddress: '강남구 789-01',
        distanceKm: 6.0,
        tags: ['즉후', '경유', '톨별'],
        price: 80000,
        feeRate: 3.3,
      ),
      OrderCallDto(
        type: OrderType.proxy,
        startAddress: '여의도 리버뷰 오피스텔',
        endAddress: '송파구 올림픽로 789',
        distanceKm: 7.1,
        tags: ['현금', '톨포'],
        price: 100000,
        feeRate: 3.3,
      ),
    ];

    // 거리 필터 적용
    return mockList.where((dto) => dto.distanceKm <= maxDistanceKm).toList();
  }
}
