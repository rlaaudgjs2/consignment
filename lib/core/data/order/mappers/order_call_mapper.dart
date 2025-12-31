import 'package:consignment/core/data/order/domain/order_call.dart';
import 'package:consignment/core/data/order/models/order_call_dto.dart';

extension OrderCallDtoMapper on OrderCallDto {
  OrderCall toEntity() {
    return OrderCall(
      type: type ?? OrderType.consign,
      startAddress: startAddress ?? '',
      endAddress: endAddress ?? '',
      distanceKm: distanceKm ?? 0.0,
      tags: tags ?? const [],
      price: price ?? 0,
      feeRate: feeRate ?? 0.0,
    );
  }
}
