import 'package:consignment/core/data/domain/order_call.dart';
import 'package:consignment/core/data/datasources/order_remote_data_source.dart';

class OrderRepositoryImpl {
  final OrderRemoteDataSource remote;

  OrderRepositoryImpl({required this.remote});

  Future<List<OrderCall>> getOrderCalls({
    required int maxDistanceKm,
  }) async {
    final dtoList = await remote.fetchOrderCalls(maxDistanceKm: maxDistanceKm);
    return dtoList.map((dto) => dto.toEntity()).toList();
  }
}
