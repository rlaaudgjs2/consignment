import 'package:flutter/material.dart';

class OrderFilterBar extends StatelessWidget {
  final VoidCallback onTapLocation;
  final VoidCallback onTapDistance;
  final String distanceLabel;
  final bool isDistanceOpen;
  final GlobalKey distanceButtonKey;

  const OrderFilterBar({
    super.key,
    required this.onTapLocation,
    required this.onTapDistance,
    required this.distanceLabel,
    required this.distanceButtonKey,
    this.isDistanceOpen = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      color: cs.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTapLocation,
              child: Row(
                children: [
                  Icon(
                    Icons.place,
                    size: 20,
                    color: cs.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '현재 위치 설정하기',
                    style: TextStyle(
                      fontSize: 14,
                      color: cs.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 12),

          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTapDistance,
            child: SizedBox(
              key: distanceButtonKey,
              width: 120,
              height: 32,
              child: Container(
                padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: cs.outlineVariant, width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        distanceLabel,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: cs.onSurface.withOpacity(0.8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      isDistanceOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      size: 20,
                      color: cs.primary,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
