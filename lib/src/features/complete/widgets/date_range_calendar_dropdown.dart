import 'package:flutter/material.dart';

import 'package:consignment/src/utils/date_range_types.dart';

class DateRangeCalendarDropdown extends StatelessWidget {
  final DateTime focusedMonth; // yyyy-mm-01
  final DateTime startDate;
  final DateTime endDate;
  final DateFieldMode mode;

  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;
  final ValueChanged<DateTime> onSelectDate;

  const DateRangeCalendarDropdown({
    super.key,
    required this.focusedMonth,
    required this.startDate,
    required this.endDate,
    required this.mode,
    required this.onPrevMonth,
    required this.onNextMonth,
    required this.onSelectDate,
  });

  static const double _kWidth = 375;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final title = (mode == DateFieldMode.start) ? '시작일 선택' : '종료일 선택';

    return Center(
      child: Container(
        width: _kWidth,
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outlineVariant, width: 1),
          boxShadow: [
            BoxShadow(
              // 라이트에서만 살짝 그림자, 다크에선 티 덜나게 약하게
              color: cs.shadow.withOpacity(0.12),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Header(
              title: title,
              monthText: _formatMonth(focusedMonth),
              onPrev: onPrevMonth,
              onNext: onNextMonth,
            ),
            const SizedBox(height: 8),
            Divider(height: 1, thickness: 1, color: cs.outlineVariant.withOpacity(0.7)),
            const SizedBox(height: 8),
            const _WeekdaysRow(),
            const SizedBox(height: 8),
            _CalendarGrid(
              focusedMonth: focusedMonth,
              startDate: startDate,
              endDate: endDate,
              onSelectDate: onSelectDate,
            ),
          ],
        ),
      ),
    );
  }

  String _formatMonth(DateTime dt) {
    final y = dt.year.toString();
    final m = dt.month.toString().padLeft(2, '0');
    return '$y-$m';
  }
}

class _Header extends StatelessWidget {
  final String title;
  final String monthText;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const _Header({
    required this.title,
    required this.monthText,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final titleStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.0,
      color: cs.onSurface.withOpacity(0.85),
    );

    final monthStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      height: 1.0,
      color: cs.onSurface,
    );

    final arrowColor = cs.onSurface.withOpacity(0.65);

    return Row(
      children: [
        Text(title, style: titleStyle),
        const Spacer(),
        IconButton(
          onPressed: onPrev,
          icon: Icon(Icons.chevron_left, color: arrowColor),
          splashRadius: 18,
        ),
        Text(monthText, style: monthStyle),
        IconButton(
          onPressed: onNext,
          icon: Icon(Icons.chevron_right, color: arrowColor),
          splashRadius: 18,
        ),
      ],
    );
  }
}

class _WeekdaysRow extends StatelessWidget {
  const _WeekdaysRow();

  final List<String> _labels = const ['일', '월', '화', '수', '목', '금', '토'];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final style = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 1.0,
      color: cs.onSurface.withOpacity(0.6),
    );

    return Row(
      children: _labels
          .map(
            (e) => Expanded(
          child: Center(child: Text(e, style: style)),
        ),
      )
          .toList(),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  final DateTime focusedMonth;
  final DateTime startDate;
  final DateTime endDate;
  final ValueChanged<DateTime> onSelectDate;

  const _CalendarGrid({
    required this.focusedMonth,
    required this.startDate,
    required this.endDate,
    required this.onSelectDate,
  });

  @override
  Widget build(BuildContext context) {
    final cells = _buildCells(focusedMonth);

    return Column(
      children: List.generate(6, (row) {
        final rowCells = cells.sublist(row * 7, row * 7 + 7);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: rowCells.map((cell) {
              return Expanded(
                child: _DayCell(
                  date: cell.date,
                  isCurrentMonth: cell.isCurrentMonth,
                  isStart: _isSameDay(cell.date, startDate),
                  isEnd: _isSameDay(cell.date, endDate),
                  isInRange: _isInRange(cell.date, startDate, endDate),
                  onTap: () => onSelectDate(cell.date),
                ),
              );
            }).toList(),
          ),
        );
      }),
    );
  }

  List<_CellData> _buildCells(DateTime month) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);

    // Sun-first offset
    final firstWeekday = firstDayOfMonth.weekday; // 1..7 (Mon..Sun)
    final leading = (firstWeekday == 7) ? 0 : firstWeekday;

    final startGridDate = firstDayOfMonth.subtract(Duration(days: leading));

    final cells = <_CellData>[];
    for (int i = 0; i < 42; i++) {
      final d = DateTime(startGridDate.year, startGridDate.month, startGridDate.day + i);
      final isCurrent = (d.month == firstDayOfMonth.month && d.year == firstDayOfMonth.year);
      cells.add(_CellData(date: d, isCurrentMonth: isCurrent));
    }
    return cells;
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isInRange(DateTime d, DateTime start, DateTime end) {
    final nd = DateTime(d.year, d.month, d.day);
    final ns = DateTime(start.year, start.month, start.day);
    final ne = DateTime(end.year, end.month, end.day);
    return nd.isAfter(ns) && nd.isBefore(ne);
  }
}

class _DayCell extends StatelessWidget {
  final DateTime date;
  final bool isCurrentMonth;
  final bool isStart;
  final bool isEnd;
  final bool isInRange;
  final VoidCallback onTap;

  const _DayCell({
    required this.date,
    required this.isCurrentMonth,
    required this.isStart,
    required this.isEnd,
    required this.isInRange,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final dayText = date.day.toString();
    final bool isSelected = isStart || isEnd;

    final Color selectedBg = cs.primary;
    final Color inRangeBg = cs.primary.withOpacity(0.18);

    final Color textColor = !isCurrentMonth
        ? cs.onSurface.withOpacity(0.35)
        : isSelected
        ? cs.onPrimary
        : cs.onSurface;

    BoxDecoration decoration;

    if (isSelected) {
      decoration = BoxDecoration(
        color: selectedBg,
        shape: BoxShape.circle,
      );
    } else if (isInRange) {
      decoration = BoxDecoration(
        color: inRangeBg,
        borderRadius: BorderRadius.circular(8),
      );
    } else {
      decoration = const BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.rectangle,
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        height: 40,
        child: Center(
          child: Container(
            width: 34,
            height: 34,
            decoration: decoration,
            alignment: Alignment.center,
            child: Text(
              dayText,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.0,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CellData {
  final DateTime date;
  final bool isCurrentMonth;

  const _CellData({
    required this.date,
    required this.isCurrentMonth,
  });
}
