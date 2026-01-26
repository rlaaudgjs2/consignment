import 'package:consignment/core/data/domain/order_call.dart';

class DrivingHistoryDetail {
  final String id;

  final OrderType orderType; // 탁송/대리
  final List<String> tags;   // 즉후/경유/하이패스 등

  final String clientName;
  final String situationRoom;

  final String startAddress;
  final String endAddress;

  final int price;
  final String fareTypeText;

  final String orderNo;

  final String receivedAtText;
  final String dispatchedAtText;
  final String completedAtText;

  final String carModel;
  final String carNumber;

  const DrivingHistoryDetail({
    required this.id,
    required this.orderType,
    required this.tags,
    required this.clientName,
    required this.situationRoom,
    required this.startAddress,
    required this.endAddress,
    required this.price,
    required this.fareTypeText,
    required this.orderNo,
    required this.receivedAtText,
    required this.dispatchedAtText,
    required this.completedAtText,
    required this.carModel,
    required this.carNumber,
  });
}
