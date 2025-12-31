import 'package:flutter/material.dart';

class SettlementEtcDetailModal extends StatelessWidget {
  const SettlementEtcDetailModal({
    super.key,
    required this.dateTimeText,
    required this.titleText, // 예: "특정일자동공제" / "가상계좌" / "후불입금" / "산재보험" 등
    required this.amountWon, // 예: -8400 / 50000
    this.noteLabel = '특이사항',
    this.noteText, // 예: "보험료" 또는 "T)엠케이모빌리티 적요:..." 등
  });

  final String dateTimeText;
  final String titleText;
  final int amountWon;

  final String noteLabel;
  final String? noteText;

  static Future<void> show(
      BuildContext context, {
        required String dateTimeText,
        required String titleText,
        required int amountWon,
        String noteLabel = '특이사항',
        String? noteText,
      }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (_) => SettlementEtcDetailModal(
        dateTimeText: dateTimeText,
        titleText: titleText,
        amountWon: amountWon,
        noteLabel: noteLabel,
        noteText: noteText,
      ),
    );
  }

  static const Color _text = Color(0xFF333333);
  static const Color _sub = Color(0xFF828282);
  static const Color _divider = Color(0xFFEEEEEE);
  static const Color _primary = Color(0xFFF2B36A);

  // 스샷의 빨간 출금 / 파란 입금 느낌을 맞춘 값
  static const Color _minus = Color(0xFFFF6B57);
  static const Color _plus = Color(0xFF2F80ED);

  String _formatWon(int won) {
    final bool neg = won < 0;
    final int abs = won.abs();

    final String formatted = abs.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (m) => ',',
    );

    return '${neg ? '-' : ''}$formatted원';
  }

  @override
  Widget build(BuildContext context) {
    final bool isMinus = amountWon < 0;
    final bool hasNote = (noteText != null && noteText!.trim().isNotEmpty);

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
            const SizedBox(height: 4),
            const Divider(height: 1, color: _divider),
            const SizedBox(height: 12),

            _KVRow(label: '일자', value: dateTimeText),
            _KVRow(label: '내역', value: titleText),
            _KVRow(
              label: '입/출금',
              value: _formatWon(amountWon),
              valueColor: isMinus ? _minus : _plus,
            ),
            if (hasNote) _KVRow(label: noteLabel, value: noteText!),

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
  const _ConfirmButton({
    required this.text,
    required this.onPressed,
  });

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
