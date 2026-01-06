import 'package:consignment/core/data/domain/order_call.dart';

OrderType parseOrderType(String typeLabel) {
  switch (typeLabel) {
    case '탁송':
      return OrderType.consign;
    case '대리':
      return OrderType.proxy;
    default:
      return OrderType.proxy; // 안전 기본값
  }
}
