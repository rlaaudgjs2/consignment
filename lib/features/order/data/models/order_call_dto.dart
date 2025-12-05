import 'package:consignment/features/order/domain/entities/order_call.dart';

class OrderCallDto {
  final OrderType type;
  final String startAddress;
  final String endAddress;
  final double distanceKm;
  final List<String> tags;
  final int price;
  final double feeRate;

  OrderCallDto({
    required this.type,
    required this.startAddress,
    required this.endAddress,
    required this.distanceKm,
    required this.tags,
    required this.price,
    required this.feeRate,
  });

  /// DTO → Entity
  OrderCall toEntity() {
    return OrderCall(
      type: type,
      startAddress: startAddress,
      endAddress: endAddress,
      distanceKm: distanceKm,
      tags: tags,
      price: price,
      feeRate: feeRate,
    );
  }
}
