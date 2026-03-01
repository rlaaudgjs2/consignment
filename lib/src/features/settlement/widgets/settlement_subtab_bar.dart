import 'package:flutter/material.dart';
import '../viewmodels/settlement_viewmodel.dart';
import 'package:consignment/src/theme/settlement_style.dart';

class SettlementSubTabBar extends StatelessWidget {
  final SettlementSubTab activeTab;
  final ValueChanged<SettlementSubTab> onTap;

  const SettlementSubTabBar({
    super.key,
    required this.activeTab,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).extension<SettlementStyle>();
    assert(style != null, 'SettlementStyle이 ThemeData.extensions에 등록되어야 합니다.');
    final s = style!;

    Widget buildItem(String label, SettlementSubTab tab) {
      final selected = activeTab == tab;

      return Expanded(
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => onTap(tab),
          child: Container(
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? s.subTabSelectedBg : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.0,
                color: selected ? s.subTabSelectedText : s.subTabUnselectedText,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      height: 40,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: s.subTabBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          buildItem('일별 수입', SettlementSubTab.dailyIncome),
          buildItem('입출금 내역', SettlementSubTab.transactions),
          buildItem('내 지갑', SettlementSubTab.wallet),
        ],
      ),
    );
  }
}
