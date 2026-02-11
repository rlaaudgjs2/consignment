import 'package:flutter/material.dart';

class StepItem extends StatelessWidget {
  final String stepLabel; // e.g. "STEP 1"
  final Widget content;

  const StepItem({
    super.key,
    required this.stepLabel,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    const sub = Color(0xFF828282);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2F2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              stepLabel,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: sub,
              ),
            ),
          ),
          const SizedBox(height: 8),
          content,
          const SizedBox(height: 14),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF2F2F2)),
        ],
      ),
    );
  }
}
