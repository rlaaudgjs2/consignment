// dispatch_info_section.dart
import 'package:flutter/material.dart';
import 'package:consignment/features/dispatch/domain/entities/dispatch.dart';

class DispatchInfoSection extends StatelessWidget {
  final Dispatch dispatch;

  const DispatchInfoSection({super.key, required this.dispatch});

  @override
  Widget build(BuildContext context) {
    const String fareType = '완)후불';
    const String carModel = '소나타';
    const String carNumber = '12가1234';
    const String orderInfo =
        '오더번호 : ABCD251011\n1번 기사님 : 010-1234-5678로 연락드리세요';

    final String chargeText = _formatPrice(dispatch.charge);
    final String createdTimeText = _formatTime(dispatch.createdAt);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LabelValueRow(label: '출발지', value: dispatch.startLocation),
        const SizedBox(height: 10),
        _LabelValueRow(label: '도착지', value: dispatch.destinationLocation),
        const SizedBox(height: 10),
        _LabelValueRow(label: '요금', value: chargeText),
        const SizedBox(height: 10),
        _LabelValueRow(label: '요금구분', value: fareType),
        const SizedBox(height: 10),
        _LabelValueRow(label: '오더정보', value: orderInfo),
        const SizedBox(height: 10),
        _LabelValueRow(label: '접수시간', value: createdTimeText),
        const SizedBox(height: 10),
        _LabelValueRow(label: '차종', value: carModel),
        const SizedBox(height: 10),
        _LabelValueRow(label: '차량번호', value: carNumber),
      ],
    );
  }
}

class _LabelValueRow extends StatelessWidget {
  final String label;
  final String value;

  const _LabelValueRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, color: Color(0xFF828282)),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xFF333333),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

// 간단 포맷터들은 나중에 core/utils로 빼도 좋음
String _formatPrice(int price) {
  final s = price.toString();
  final buffer = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    final indexFromEnd = s.length - i;
    buffer.write(s[i]);
    if (indexFromEnd > 1 && indexFromEnd % 3 == 1) {
      buffer.write(',');
    }
  }
  return '$buffer원';
}

String _formatTime(DateTime createdAt) {
  final hh = createdAt.hour.toString().padLeft(2, '0');
  final mm = createdAt.minute.toString().padLeft(2, '0');
  return '$hh:$mm';
}
