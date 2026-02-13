import 'package:flutter/material.dart';
import 'package:consignment/src/features/order/widgets/order_type_chip.dart';
import 'package:consignment/core/data/domain/order_call.dart';

class DrivingFeeDetailModal extends StatelessWidget {
  const DrivingFeeDetailModal({
    super.key,
    required this.orderType,
    this.tags = const <String>[],
    required this.dateTimeText,
    required this.titleText, // 예: "운행수수료"
    required this.amountWon, // 예: -22000
    required this.orderNo,
    required this.startAddress,
    required this.endAddress,
    required this.fareText, // 예: "110,000원"
  });

  final OrderType orderType;
  final List<String> tags;

  final String dateTimeText;
  final String titleText;
  final int amountWon;

  final String orderNo;
  final String startAddress;
  final String endAddress;
  final String fareText;

  static Future<void> show(
      BuildContext context, {
        required OrderType orderType,
        List<String> tags = const <String>[],
        required String dateTimeText,
        required String titleText,
        required int amountWon,
        required String orderNo,
        required String startAddress,
        required String endAddress,
        required String fareText,
      }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (_) => DrivingFeeDetailModal(
        orderType: orderType,
        tags: tags,
        dateTimeText: dateTimeText,
        titleText: titleText,
        amountWon: amountWon,
        orderNo: orderNo,
        startAddress: startAddress,
        endAddress: endAddress,
        fareText: fareText,
      ),
    );
  }

  static const Color _divider = Color(0xFFEEEEEE);
  static const Color _primary = Color(0xFFF2B36A);

  static const Color _minus = Color(0xFFFF6B57);
  static const Color _plus = Color(0xFF2F80ED);

  String _formatWon(int won) {
    final bool neg = won < 0;
    final int abs = won.abs();
    final String s = abs.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (m) => ',',
    );
    return '${neg ? '-' : ''}$s원';
  }

  @override
  Widget build(BuildContext context) {
    final bool isMinus = amountWon < 0;

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
            _KVRow(label: '일자', value: dateTimeText),
            _KVRow(label: '내역', value: titleText),
            _KVRow(
              label: '입/출금',
              value: _formatWon(amountWon),
              valueColor: isMinus ? _minus : _plus,
            ),
            _KVRow(label: '오더번호', value: orderNo),
            _KVRow(label: '출발', value: startAddress),
            _KVRow(label: '도착', value: endAddress),
            _KVRow(label: '요금', value: fareText),

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
  const _KVRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

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
              style: TextStyle(
                fontSize: 18,
                color: valueColor ?? _text,
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
