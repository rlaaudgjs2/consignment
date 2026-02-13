import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:consignment/src/features/order/pages/order_page.dart';
import 'package:consignment/src/features/dispatch/pages/dispatch_page.dart';
import 'package:consignment/src/features/complete/pages/complete_page.dart';
import 'package:consignment/src/features/settlement/pages/settlement_page.dart';
import 'package:consignment/src/features/settings/pages/settings_page.dart';

import 'package:consignment/src/features/order/widgets/order_dispatch_header_icon.dart';

import 'package:consignment/src/features/order/viewmodels/order_view_model.dart';
import 'package:consignment/src/features/order/viewmodels/location_view_model.dart';
import 'package:consignment/src/features/dispatch/viewmodels/dispatch_view_model.dart';

import 'package:consignment/core/data/repositories/order_repository.dart';
import 'package:consignment/core/data/repositories/location_repository.dart';
import 'package:consignment/core/data/repositories/dispatch_repository_impl.dart';

class RootTabPage extends StatelessWidget {
  const RootTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<OrderViewModel>(
          create: (context) => OrderViewModel(
            repository: context.read<OrderRepository>(),
          ),
        ),
        ChangeNotifierProvider<LocationViewModel>(
          create: (context) => LocationViewModel(
            repository: context.read<LocationRepository>(),
          ),
        ),
        ChangeNotifierProvider<DispatchViewModel>(
          create: (context) => DispatchViewModel(
            repository: context.read<DispatchRepositoryImpl>(),
          )..loadCurrentDispatch(context),
        ),
      ],
      child: const _RootTabScaffold(),
    );
  }
}

class _RootTabScaffold extends StatefulWidget {
  const _RootTabScaffold();

  @override
  State<_RootTabScaffold> createState() => _RootTabScaffoldState();
}

class _RootTabScaffoldState extends State<_RootTabScaffold> {
  int _currentIndex = 0;

  static const double _kTopTabHeight = 68.0;
  static const double _kTopTabIconSize = 24.0;
  static const double _kTopTabFontSize = 12.0;
  static const double _kTopTabHorizontalPadding = 24;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      // 위치 추적 시작
      final locationVm = context.read<LocationViewModel>();
      await locationVm.startTracking(context);

      // 위치 업데이트 이후 오더 로딩
      await context.read<OrderViewModel>().loadOrderCalls(context);
    });
  }

  void _onTabTap(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopTabBar(),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildTopTabBar() {
    return Container(
      height: _kTopTabHeight,
      padding: const EdgeInsets.symmetric(horizontal: _kTopTabHorizontalPadding),
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
            iconWidget: const Icon(Icons.list_alt, size: 24),
            label: '오더',
            isSelected: _currentIndex == 0,
            iconSize: _kTopTabIconSize,
            fontSize: _kTopTabFontSize,
            onTap: () => _onTabTap(0),
          ),
          _TopTabItem(
            iconWidget: const OrderDispatchHeaderIcon(),
            label: '배차',
            isSelected: _currentIndex == 1,
            iconSize: _kTopTabIconSize,
            fontSize: _kTopTabFontSize,
            onTap: () => _onTabTap(1),
          ),
          _TopTabItem(
            iconWidget: const Icon(Icons.check_circle, size: 24),
            label: '완료',
            isSelected: _currentIndex == 2,
            iconSize: _kTopTabIconSize,
            fontSize: _kTopTabFontSize,
            onTap: () => _onTabTap(2),
          ),
          _TopTabItem(
            iconWidget: const Icon(Icons.account_balance_wallet, size: 24),
            label: '정산',
            isSelected: _currentIndex == 3,
            iconSize: _kTopTabIconSize,
            fontSize: _kTopTabFontSize,
            onTap: () => _onTabTap(3),
          ),
          _TopTabItem(
            iconWidget: const Icon(Icons.settings, size: 24),
            label: '설정',
            isSelected: _currentIndex == 4,
            iconSize: _kTopTabIconSize,
            fontSize: _kTopTabFontSize,
            onTap: () => _onTabTap(4),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return const OrderPage();
      case 1:
        return const DispatchPage();
      case 2:
        return const CompletePage();
      case 3:
        return const SettlementPage();
      case 4:
        return const SettingsPage();
      default:
        return const SizedBox.shrink();
    }
  }
}

class _TopTabItem extends StatelessWidget {
  final Widget iconWidget;
  final String label;
  final bool isSelected;
  final double iconSize;
  final double fontSize;
  final VoidCallback onTap;

  const _TopTabItem({
    required this.iconWidget,
    required this.label,
    required this.isSelected,
    required this.iconSize,
    required this.fontSize,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const Color selectedColor = Color(0xFFFBB35F);
    const Color unselectedColor = Color(0xFF828282);
    final Color color = isSelected ? selectedColor : unselectedColor;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconTheme(
            data: IconThemeData(size: 24, color: color),
            child: iconWidget,
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: fontSize, color: color)),
        ],
      ),
    );
  }
}
