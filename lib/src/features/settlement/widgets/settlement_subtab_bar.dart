import 'package:flutter/material.dart';

import '../viewmodels/settlement_viewmodel.dart';

class SettlementSubTabBar extends StatelessWidget {
  final SettlementSubTab activeTab;
  final ValueChanged<SettlementSubTab> onTap;

  const SettlementSubTabBar({
    super.key,
    required this.activeTab,
    required this.onTap,
  });

  static const double _kWidth = 343;
  static const double _kItemHeight = 34;
  static const double _kPadding = 2;
  static const double _kHeight = _kItemHeight + _kPadding * 2;





  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF2F2F2);
    const selectedBg = Colors.white;
    const border = Color(0xFFE0E0E0);
    const selectedColor = Color(0xFFFBB35F);
    const unselectedColor = Color(0xFF828282);

    Widget buildItem(String label, SettlementSubTab tab) {
      final bool selected = activeTab == tab;

      return Expanded(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => onTap(tab),
            child: Container(
              height: _kItemHeight,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? selectedBg : Colors.transparent,
                borderRadius: BorderRadius.circular(_kHeight / 2),
              ),
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.0,
                  color: selected ? selectedColor : unselectedColor,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: _kWidth,
      height: _kHeight,
      child: Container(
        padding: const EdgeInsets.all(_kPadding),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            buildItem('일별 수입', SettlementSubTab.dailyIncome),
            buildItem('입출금 내역', SettlementSubTab.transactions),
            buildItem('내 지갑', SettlementSubTab.wallet),
          ],
        ),
      ),
    );
  }
}
