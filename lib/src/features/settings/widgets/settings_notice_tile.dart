import 'package:flutter/material.dart';

class SettingsNoticeTile extends StatelessWidget {
  final String title;
  final String date;
  final String body;
  final bool expanded;
  final VoidCallback onTap;

  const SettingsNoticeTile({
    super.key,
    required this.title,
    required this.date,
    required this.body,
    required this.expanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const divider = Color(0xFFEAEAEA);
    const sub = Color(0xFFBDBDBD);
    const text = Color(0xFF333333);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: divider, width: 1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      height: 1.0,
                      color: text,
                    ),
                  ),
                ),
                Icon(
                  expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  size: 22,
                  color: const Color(0xFFBDBDBD),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              date,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                height: 1.0,
                color: sub,
              ),
            ),
            if (expanded) ...[
              const SizedBox(height: 14),
              Text(
                body,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.45,
                  color: text,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
