import 'package:consignment/core/data/datasources/test_data.dart';
import 'package:consignment/core/data/models/order_call_dto.dart';

/// Order(콜 목록) 전용 RemoteDataSource
///
/// 현재는 TestData 기반 구현.
/// 추후 실제 API 연결 시 이 파일 내부 구현만 교체하면 됨.
class OrderRemoteDataSource {
  const OrderRemoteDataSource();

  Future<List<OrderCallDto>> fetchOrderCalls({
    required int maxDistanceKm,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final list = TestData.orderCallsMock();
    return list
        .where((dto) => (dto.distanceKm ?? double.infinity) <= maxDistanceKm)
        .toList();
  }
}
