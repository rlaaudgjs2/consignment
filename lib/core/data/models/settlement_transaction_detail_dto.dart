import 'package:consignment/core/data/domain/settlement_transaction_detail.dart';
import 'package:consignment/core/data/domain/order_call.dart';

class SettlementTransactionDetailDto {
  final String id;

  /// ✅ 서버는 보통 문자열로 내려줌: "drivingFee" | "etc"
  final String type;

  final String dateTimeText;
  final String titleText;
  final int amountWon;
  final int? balanceWon;

  // drivingFee 전용(있을 수도/없을 수도)
  final String? orderTypeText; // "탁송" | "대리" 등
  final List<String> tags;
  final String? orderNo;
  final String? startAddress;
  final String? endAddress;
  final int? fareWon; // 원 단위
  final String? fareText; // "110,000원" 같은 문자열이 필요하면 서버가 주거나 여기서 포맷

  // etc 전용
  final String? noteText;

  const SettlementTransactionDetailDto({
    required this.id,
    required this.type,
    required this.dateTimeText,
    required this.titleText,
    required this.amountWon,
    this.balanceWon,
    this.orderTypeText,
    this.tags = const <String>[],
    this.orderNo,
    this.startAddress,
    this.endAddress,
    this.fareWon,
    this.fareText,
    this.noteText,
  });

  SettlementTransactionDetail toEntity() {
    final SettlementTransactionDetailType parsedType = _parseType(type);

    return SettlementTransactionDetail(
      id: id,
      type: parsedType,
      dateTimeText: dateTimeText,
      titleText: titleText,
      amountWon: amountWon,
      orderType: _parseOrderType(orderTypeText),
      tags: tags,
      orderNo: orderNo,
      startAddress: startAddress,
      endAddress: endAddress,
      fareText: fareText ?? _formatWonNullable(fareWon),
      noteText: noteText,
    );
  }

  SettlementTransactionDetailType _parseType(String v) {
    switch (v) {
      case 'drivingFee':
        return SettlementTransactionDetailType.drivingFee;
      case 'etc':
      default:
        return SettlementTransactionDetailType.etc;
    }
  }

  OrderType? _parseOrderType(String? v) {
    if (v == null) return null;
    // 프로젝트에서 실제로 쓰는 텍스트 규칙에 맞춰 조정
    if (v.contains('탁송')) return OrderType.consign;
    if (v.contains('대리')) return OrderType.proxy;
    return null;
  }

  String? _formatWonNullable(int? won) {
    if (won == null) return null;
    final s = won.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final idxFromEnd = s.length - i;
      buf.write(s[i]);
      if (idxFromEnd > 1 && idxFromEnd % 3 == 1) buf.write(',');
    }
    return '${buf.toString()}원';
  }
}
