import 'package:flutter/material.dart';

class OrderCallCard extends StatelessWidget {
  final String typeLabel;
  final Widget typeChip;
  final String startAddress;
  final String endAddress;
  final double distanceKm;
  final List<String> tags;
  final int price;

  const OrderCallCard({
    super.key,
    required this.typeLabel,
    required this.typeChip,
    required this.startAddress,
    required this.endAddress,
    required this.distanceKm,
    required this.tags,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final titleStyle = TextStyle(
      fontSize: 16,
      color: cs.onSurface,
      fontWeight: FontWeight.w500,
    );

    final subStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: cs.onSurface.withOpacity(0.6),
    );

    final arrowStyle = TextStyle(
      fontSize: 13,
      color: cs.onSurface.withOpacity(0.6),
    );

    final priceStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: cs.onSurface,
    );

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: Material(
            color: cs.surface,
            borderRadius: BorderRadius.circular(4),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [typeChip],
                      ),
                      const Spacer(),
                      _TagsRow(tags: tags),
                    ],
                  ),

                  const SizedBox(height: 3),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(text: startAddress, style: titleStyle),
                              const WidgetSpan(child: SizedBox(width: 4)),
                              TextSpan(
                                text: '${distanceKm.toStringAsFixed(1)}km',
                                style: subStyle,
                              ),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 2),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Text('→ ', style: arrowStyle),
                            Expanded(
                              child: Text(
                                endAddress,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: titleStyle,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(_formatPrice(price), style: priceStyle),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Divider(
            height: 0,
            thickness: 1,
            color: cs.outlineVariant,
          ),
        ),
      ],
    );
  }

  static String _formatPrice(int price) {
    final s = price.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final indexFromEnd = s.length - i;
      buffer.write(s[i]);
      if (indexFromEnd > 1 && indexFromEnd % 3 == 1) {
        buffer.write(',');
      }
    }
    return '${buffer.toString()}원';
  }
}

class _TagsRow extends StatelessWidget {
  final List<String> tags;

  const _TagsRow({required this.tags});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (tags.isEmpty) return const SizedBox.shrink();

    final tagStyle = TextStyle(
      fontSize: 14,
      color: cs.onSurface.withOpacity(0.6),
    );

    final dividerStyle = TextStyle(
      fontSize: 14,
      color: cs.onSurface.withOpacity(0.35),
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < tags.length; i++) ...[
          Text(tags[i], style: tagStyle),
          if (i != tags.length - 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text('|', style: dividerStyle),
            ),
        ],
      ],
    );
  }
}
