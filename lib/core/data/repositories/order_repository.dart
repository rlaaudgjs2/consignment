import 'package:consignment/core/data/datasources/order_remote_data_source.dart';
import 'package:consignment/core/data/domain/dispatch_assign_result.dart';
import 'package:consignment/core/data/domain/order_call.dart';
import 'package:flutter/cupertino.dart';

class OrderRepository {
  final OrderRemoteDataSource _remote;

  const OrderRepository({
    required OrderRemoteDataSource remote,
  }) : _remote = remote;

  Future<List<OrderCall>> getOrderCalls({
    required BuildContext context,
    List<OrderStatus>? status,
  }) async {
    final statusStrings = status
        ?.map((s) {
      switch (s) {
        case OrderStatus.open:
          return 'OPEN';
        case OrderStatus.assigned:
          return 'ASSIGNED';
        case OrderStatus.completed:
          return 'COMPLETED';
        case OrderStatus.canceled:
          return 'CANCELED';
      }
    })
        .toList();

    final dtoList =
    await _remote.fetchOrderCalls(context: context, status: statusStrings);
    return dtoList.map((dto) => dto.toEntity()).toList();
  }

  Future<DispatchAssignResult> assignDispatch({
    required BuildContext context,
    required int dispatchId,
    int? transporterId,
  }) async {
    final data = await _remote.assignDispatch(
      context: context,
      dispatchId: dispatchId,
      transporterId: transporterId,
    );

    final dispatcherId = (data['dispatcherId'] as num?)?.toInt() ?? 0;
    final transporterIdRes = (data['transporterId'] as num?)?.toInt() ?? 0;

    return DispatchAssignResult(
      dispatcherId: dispatcherId,
      transporterId: transporterIdRes,
    );
  }
}
