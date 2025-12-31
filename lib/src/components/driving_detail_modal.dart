import 'package:flutter/material.dart';
import 'package:consignment/src/features/order/widgets/order_type_chip.dart';
import 'package:consignment/core/data/order/domain/order_call.dart';

class DrivingDetailModal extends StatelessWidget {
  const DrivingDetailModal({
    super.key,
    required this.orderType,
    this.tags = const <String>[],
    required this.clientName,
    required this.situationRoom,
    required this.startAddress,
    required this.endAddress,
    required this.fareText,
    required this.fareTypeText,
    required this.orderNo,
    required this.receivedAtText,
    required this.dispatchedAtText,
    required this.completedAtText,
    required this.carModel,
    required this.carNumber,
  });

  final OrderType orderType;
  final List<String> tags;

  final String clientName;
  final String situationRoom;
  final String startAddress;
  final String endAddress;

  final String fareText; // 예: "110,000원"
  final String fareTypeText; // 예: "완)후불"

  final String orderNo;
  final String receivedAtText;
  final String dispatchedAtText;
  final String completedAtText;

  final String carModel;
  final String carNumber;

  static Future<void> show(
      BuildContext context, {
        required OrderType orderType,
        List<String> tags = const <String>[],
        required String clientName,
        required String situationRoom,
        required String startAddress,
        required String endAddress,
        required String fareText,
        required String fareTypeText,
        required String orderNo,
        required String receivedAtText,
        required String dispatchedAtText,
        required String completedAtText,
        required String carModel,
        required String carNumber,
      }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (_) => DrivingDetailModal(
        orderType: orderType,
        tags: tags,
        clientName: clientName,
        situationRoom: situationRoom,
        startAddress: startAddress,
        endAddress: endAddress,
        fareText: fareText,
        fareTypeText: fareTypeText,
        orderNo: orderNo,
        receivedAtText: receivedAtText,
        dispatchedAtText: dispatchedAtText,
        completedAtText: completedAtText,
        carModel: carModel,
        carNumber: carNumber,
      ),
    );
  }

  static const Color _divider = Color(0xFFEEEEEE);
  static const Color _primary = Color(0xFFF2B36A);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 22),
      child: Container(
        width: 343,
        padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _HeaderRow(orderType: orderType, tags: tags),
            const SizedBox(height: 12),
            const Divider(height: 1, color: _divider),

            const SizedBox(height: 12),
            _KVRow(label: '발주처', value: clientName),
            _KVRow(label: '상황실', value: situationRoom),
            _KVRow(label: '출발지', value: startAddress),
            _KVRow(label: '도착지', value: endAddress),
            _KVRow(label: '요금', value: fareText),
            _KVRow(label: '요금구분', value: fareTypeText),
            _KVRow(label: '오더번호', value: orderNo),
            _KVRow(label: '접수시간', value: receivedAtText),
            _KVRow(label: '배차시간', value: dispatchedAtText),
            _KVRow(label: '완료시간', value: completedAtText),
            _KVRow(label: '차종', value: carModel),
            _KVRow(label: '차량번호', value: carNumber),

            const SizedBox(height: 16),
            _ConfirmButton(
              text: '확인',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({required this.orderType, required this.tags});

  final OrderType orderType;
  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OrderTypeChip(type: orderType),
        _TagsRow(tags: tags),
      ],
    );
  }
}

class _TagsRow extends StatelessWidget {
  const _TagsRow({required this.tags});

  final List<String> tags;

  static const Color _sub = Color(0xFF828282);
  static const Color _sep = Color(0xFFBDBDBD);

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < tags.length; i++) ...[
          Text(
            tags[i],
            style: const TextStyle(fontSize: 14, color: _sub),
          ),
          if (i != tags.length - 1)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                '|',
                style: TextStyle(fontSize: 14, color: _sep),
              ),
            ),
        ],
      ],
    );
  }
}

class _KVRow extends StatelessWidget {
  const _KVRow({required this.label, required this.value});

  final String label;
  final String value;

  static const Color _text = Color(0xFF333333);
  static const Color _sub = Color(0xFF828282);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: _sub,
                height: 1.3,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                color: _text,
                fontWeight: FontWeight.w600,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton({required this.text, required this.onPressed});

  final String text;
  final VoidCallback onPressed;

  static const Color _primary = Color(0xFFF2B36A);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
