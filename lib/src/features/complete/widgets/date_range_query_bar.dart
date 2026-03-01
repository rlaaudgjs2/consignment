import 'package:flutter/material.dart';

class DateRangeQueryBar extends StatelessWidget {
  final String startDateText;
  final String endDateText;

  final VoidCallback onTapStartDate;
  final VoidCallback onTapEndDate;
  final VoidCallback onTapQuery;

  const DateRangeQueryBar({
    super.key,
    required this.startDateText,
    required this.endDateText,
    required this.onTapStartDate,
    required this.onTapEndDate,
    required this.onTapQuery,
  });

  static const double _kBarHeight = 48;
  static const double _kControlHeight = 32;

  static const double _kDateGroupWidth = 280;
  static const double _kDateWidth = 138;
  static const double _kQueryWidth = 80;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: _kBarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: _kDateGroupWidth,
              height: _kControlHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _DateDropdownBox(
                    width: _kDateWidth,
                    height: _kControlHeight,
                    text: startDateText,
                    onTap: onTapStartDate,
                  ),
                  _DateDropdownBox(
                    width: _kDateWidth,
                    height: _kControlHeight,
                    text: endDateText,
                    onTap: onTapEndDate,
                  ),
                ],
              ),
            ),
            _QueryButton(
              width: _kQueryWidth,
              height: _kControlHeight,
              onTap: onTapQuery,
            ),
          ],
        ),
      ),
    );
  }
}

class _DateDropdownBox extends StatelessWidget {
  final double width;
  final double height;
  final String text;
  final VoidCallback onTap;

  const _DateDropdownBox({
    required this.width,
    required this.height,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final borderColor = cs.outlineVariant;
    final textColor = cs.onSurface.withOpacity(0.7);
    final arrowColor = cs.primary;

    final textStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.0,
      color: textColor,
    );

    final borderRadius = BorderRadius.circular(8);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          debugPrint('DateDropdownBox tapped(debugPrint): $text');
          // ignore: avoid_print
          print('DateDropdownBox tapped: $text');
          onTap();
        },
        borderRadius: borderRadius,
        child: Ink(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: borderRadius,
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      text,
                      style: textStyle,
                      maxLines: 1,
                      softWrap: false,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_drop_down,
                  size: 20,
                  color: arrowColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QueryButton extends StatelessWidget {
  final double width;
  final double height;
  final VoidCallback onTap;

  const _QueryButton({
    required this.width,
    required this.height,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final bgColor = cs.primary;
    final textColor = cs.onPrimary;

    final textStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.0,
      color: textColor,
    );

    final borderRadius = BorderRadius.circular(8);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('조회 버튼 탭'),
              duration: Duration(seconds: 1),
            ),
          );
          debugPrint('QueryButton tapped(debugPrint)');
          // ignore: avoid_print
          print('QueryButton tapped');
          onTap();
        },
        borderRadius: borderRadius,
        child: Ink(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: borderRadius,
          ),
          child: Center(
            child: Text('조회', style: textStyle),
          ),
        ),
      ),
    );
  }
}
