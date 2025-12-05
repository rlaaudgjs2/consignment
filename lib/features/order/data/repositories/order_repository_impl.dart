// features/order/data/repositories/order_repository_impl.dart

import 'package:consignment/features/order/domain/repositories/order_repository.dart';
import 'package:consignment/features/order/domain/entities/order_call.dart';
import 'package:consignment/features/order/data/datasources/order_remote_data_source.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remote;

  OrderRepositoryImpl({required this.remote});

  @override
  Future<List<OrderCall>> getOrderCalls({
    required int maxDistanceKm,
  }) async {
    final dtoList = await remote.fetchOrderCalls(maxDistanceKm: maxDistanceKm);
    return dtoList.map((dto) => dto.toEntity()).toList();
  }
}
