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
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final titleStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w800,
      height: 1.0,
      color: cs.onSurface,
    );

    final dateStyle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w700,
      height: 1.0,
      color: cs.onSurface.withOpacity(0.45),
    );

    final bodyStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.45,
      color: cs.onSurface.withOpacity(0.85),
    );

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: theme.dividerColor, width: 1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(title, style: titleStyle)),
                Icon(
                  expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  size: 22,
                  color: cs.onSurface.withOpacity(0.35),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(date, style: dateStyle),
            if (expanded) ...[
              const SizedBox(height: 14),
              Text(body, style: bodyStyle),
            ],
          ],
        ),
      ),
    );
  }
}
