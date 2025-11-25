import 'package:flutter/material.dart';
import 'package:consignment/core/config/screen_config.dart';
import 'package:consignment/core/config/assets.dart';

class RootTabPage extends StatefulWidget {
  const RootTabPage({super.key});

  @override
  State<RootTabPage> createState() => _RootTabPageState();
}

class _RootTabPageState extends State<RootTabPage> {
  int _currentIndex = 0;

  void _onTabTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: _buildTopTabBar(context),
          ),
          Expanded(
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildTopTabBar(BuildContext context) {
    final double tabHeight = ScreenConfig.safeH(context, 68);
    final double iconSize = ScreenConfig.w(context, 24); // 피그마 24x24
    final double fontSize = ScreenConfig.font(context, 12);
    final double horizontalPadding = ScreenConfig.w(context, 24);

    return Container(
      height: tabHeight,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE0E0E0),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _TopTabItem(
            activeAsset: AppIcons.tabOrderActive,
            inactiveAsset: AppIcons.tabOrderInactive,
            label: '오더',
            isSelected: _currentIndex == 0,
            iconSize: iconSize,
            fontSize: fontSize,
            onTap: () => _onTabTap(0),
          ),
          _TopTabItem(
            activeAsset: AppIcons.tabDispatchActive,
            inactiveAsset: AppIcons.tabDispatchInactive,
            label: '배차',
            isSelected: _currentIndex == 1,
            iconSize: iconSize,
            fontSize: fontSize,
            onTap: () => _onTabTap(1),
          ),
          _TopTabItem(
            activeAsset: AppIcons.tabCompleteActive,
            inactiveAsset: AppIcons.tabCompleteInactive,
            label: '완료',
            isSelected: _currentIndex == 2,
            iconSize: iconSize,
            fontSize: fontSize,
            onTap: () => _onTabTap(2),
          ),
          _TopTabItem(
            activeAsset: AppIcons.tabSettlementActive,
            inactiveAsset: AppIcons.tabSettlementInactive,
            label: '정산',
            isSelected: _currentIndex == 3,
            iconSize: iconSize,
            fontSize: fontSize,
            onTap: () => _onTabTap(3),
          ),
          _TopTabItem(
            activeAsset: AppIcons.tabSettingsActive,
            inactiveAsset: AppIcons.tabSettingsInactive,
            label: '설정',
            isSelected: _currentIndex == 4,
            iconSize: iconSize,
            fontSize: fontSize,
            onTap: () => _onTabTap(4),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return const Center(
          child: Text(
            '오더 탭 내용',
            style: TextStyle(color: Colors.red, fontSize: 32),
          ),
        );
      case 1:
        return const Center(child: Text('배차 탭 내용'));
      case 2:
        return const Center(child: Text('완료 탭 내용'));
      case 3:
        return const Center(child: Text('정산 탭 내용'));
      case 4:
        return const Center(child: Text('설정 탭 내용'));
      default:
        return const SizedBox.shrink();
    }
  }
}

class _TopTabItem extends StatelessWidget {
  final String activeAsset;
  final String inactiveAsset;
  final String label;
  final bool isSelected;
  final double iconSize;
  final double fontSize;
  final VoidCallback onTap;

  const _TopTabItem({
    required this.activeAsset,
    required this.inactiveAsset,
    required this.label,
    required this.isSelected,
    required this.iconSize,
    required this.fontSize,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color selectedColor = const Color(0xFFFBB35F); // main 컬러
    final Color unselectedColor = const Color(0xFF828282); // gray_3

    final Color color = isSelected ? selectedColor : unselectedColor;
    final String asset = isSelected ? activeAsset : inactiveAsset;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            asset,
            width: iconSize,
            height: iconSize,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
