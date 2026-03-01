import 'package:flutter/material.dart';

class SettingsMenuTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const SettingsMenuTile({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.0,
                  color: cs.onSurface,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 22,
              color: cs.onSurface.withOpacity(0.35),
            ),
          ],
        ),
      ),
    );
  }
}
