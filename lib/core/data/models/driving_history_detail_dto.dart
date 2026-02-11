import 'package:consignment/core/data/domain/order_call.dart';
import '../domain/driving_history_detail.dart';

class DrivingHistoryDetailDto {
  final String id;

  final OrderType orderType;
  final List<String> tags;

  final String clientName;
  final String situationRoom;

  final String startAddress;
  final String endAddress;

  final int fareWon;
  final String fareTypeText;

  final String orderNo;

  final String receivedAtText;
  final String dispatchedAtText;
  final String completedAtText;

  final String carModel;
  final String carNumber;

  const DrivingHistoryDetailDto({
    required this.id,
    required this.orderType,
    required this.tags,
    required this.clientName,
    required this.situationRoom,
    required this.startAddress,
    required this.endAddress,
    required this.fareWon,
    required this.fareTypeText,
    required this.orderNo,
    required this.receivedAtText,
    required this.dispatchedAtText,
    required this.completedAtText,
    required this.carModel,
    required this.carNumber,
  });

  /// 서버 enum이 문자열로 온다고 가정: "consign" | "proxy"
  /// 이미 서버가 숫자/다른 방식이면 여기만 맞추면 됨.
  factory DrivingHistoryDetailDto.fromJson(Map<String, dynamic> json) {
    final typeRaw = (json['orderType'] as String?) ?? 'consign';
    final OrderType orderType = (typeRaw == 'proxy') ? OrderType.proxy : OrderType.consign;

    final tagsRaw = json['tags'];
    final List<String> tags = (tagsRaw is List)
        ? tagsRaw.map((e) => e.toString()).toList()
        : const <String>[];

    return DrivingHistoryDetailDto(
      id: (json['id'] as String?) ?? '',
      orderType: orderType,
      tags: tags,
      clientName: (json['clientName'] as String?) ?? '',
      situationRoom: (json['situationRoom'] as String?) ?? '',
      startAddress: (json['startAddress'] as String?) ?? '',
      endAddress: (json['endAddress'] as String?) ?? '',
      fareWon: (json['fareWon'] as int?) ?? 0,
      fareTypeText: (json['fareTypeText'] as String?) ?? '',
      orderNo: (json['orderNo'] as String?) ?? '',
      receivedAtText: (json['receivedAtText'] as String?) ?? '',
      dispatchedAtText: (json['dispatchedAtText'] as String?) ?? '',
      completedAtText: (json['completedAtText'] as String?) ?? '',
      carModel: (json['carModel'] as String?) ?? '',
      carNumber: (json['carNumber'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderType': (orderType == OrderType.proxy) ? 'proxy' : 'consign',
      'tags': tags,
      'clientName': clientName,
      'situationRoom': situationRoom,
      'startAddress': startAddress,
      'endAddress': endAddress,
      'fareWon': fareWon,
      'fareTypeText': fareTypeText,
      'orderNo': orderNo,
      'receivedAtText': receivedAtText,
      'dispatchedAtText': dispatchedAtText,
      'completedAtText': completedAtText,
      'carModel': carModel,
      'carNumber': carNumber,
    };
  }

  DrivingHistoryDetail toEntity() {
    return DrivingHistoryDetail(
      id: id,
      orderType: orderType,
      tags: List<String>.unmodifiable(tags),
      clientName: clientName,
      situationRoom: situationRoom,
      startAddress: startAddress,
      endAddress: endAddress,
      price: fareWon,
      fareTypeText: fareTypeText,
      orderNo: orderNo,
      receivedAtText: receivedAtText,
      dispatchedAtText: dispatchedAtText,
      completedAtText: completedAtText,
      carModel: carModel,
      carNumber: carNumber,
    );
  }
}
