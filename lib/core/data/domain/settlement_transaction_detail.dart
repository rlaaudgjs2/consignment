import 'package:consignment/core/data/domain/order_call.dart';

enum SettlementTransactionDetailType {
  drivingFee,
  etc,
}

class SettlementTransactionDetail {
  final String id;

  /// ✅ 모달 분기 기준 (텍스트보다 강함)
  final SettlementTransactionDetailType type;

  /// 공통 표시
  final String dateTimeText; // 예: "2025-11-24 11:48:55"
  final String titleText; // 예: "운행수수료", "가상계좌", "산재보험"
  final int amountWon;

  /// drivingFee 전용
  final OrderType? orderType;
  final List<String> tags;
  final String? orderNo;
  final String? startAddress;
  final String? endAddress;
  final String? fareText;

  /// etc 전용
  final String? noteText; // 예: "보험료" / "주유비" / "기타"

  const SettlementTransactionDetail({
    required this.id,
    required this.type,
    required this.dateTimeText,
    required this.titleText,
    required this.amountWon,
    this.orderType,
    this.tags = const <String>[],
    this.orderNo,
    this.startAddress,
    this.endAddress,
    this.fareText,
    this.noteText,
  });
}
