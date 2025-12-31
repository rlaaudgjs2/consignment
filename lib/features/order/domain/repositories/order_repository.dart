// features/order/domain/repositories/order_repository.dart

import 'package:consignment/features/order/domain/entities/order_call.dart';

abstract class OrderRepository {
  Future<List<OrderCall>> getOrderCalls({
    required int maxDistanceKm,
  });
}
