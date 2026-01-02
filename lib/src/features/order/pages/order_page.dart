import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:consignment/core/data/domain/order_call.dart';
import 'package:consignment/src/features/order/viewmodels/order_view_model.dart';
import 'package:consignment/src/features/order/widgets/order_filter_bar.dart';
import 'package:consignment/src/features/order/pages/order_list_view.dart';
import 'package:consignment/src/features/order/pages/order_detail_view.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  /// 거리 버튼 위치 측정을 위한 키 (UI 전용)
  final GlobalKey _distanceButtonKey = GlobalKey();

  OverlayEntry? _distanceOverlayEntry;

  @override
  void dispose() {
    _removeDistanceDropdown();
    super.dispose();
  }

  void _toggleDistanceDropdown(OrderViewModel viewModel) {
    if (viewModel.isDistanceDropdownOpen) {
      _removeDistanceDropdown();
      viewModel.setDistanceDropdownOpen(false);
    } else {
      _showDistanceDropdown(viewModel);
      viewModel.setDistanceDropdownOpen(true);
    }
  }

  void _showDistanceDropdown(OrderViewModel viewModel) {
    final renderBox =
    _distanceButtonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _distanceOverlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // 바깥 영역 터치 시 닫힘
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _removeDistanceDropdown();
                  viewModel.setDistanceDropdownOpen(false);
                },
              ),
            ),

            // 거리 버튼 바로 아래 드롭다운
            Positioned(
              left: offset.dx,
              top: offset.dy + size.height,
              width: size.width,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFE0E0E0),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: viewModel.distanceOptions.map((km) {
                      final bool isSelected = km == viewModel.selectedDistance;
                      return InkWell(
                        onTap: () {
                          viewModel.selectDistance(km);
                          _removeDistanceDropdown();
                          viewModel.setDistanceDropdownOpen(false);
                        },
                        child: Container(
                          height: 60,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xFFE0E0E0),
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: Text(
                            '$km km',
                            style: TextStyle(
                              fontSize: 16,
                              color: isSelected
                                  ? const Color(0xFFFBB35F)
                                  : const Color(0xFF4F4F4F),
                              fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_distanceOverlayEntry!);
  }

  void _removeDistanceDropdown() {
    _distanceOverlayEntry?.remove();
    _distanceOverlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OrderViewModel>();

    // 상세 모드
    if (viewModel.isDetailMode) {
      final OrderCall call = viewModel.selectedCall!;
      return OrderDetailView(
        call: call,
        onTapCancel: viewModel.cancelDetail,
        onTapDispatch: viewModel.onTapDispatch,
      );
    }

    // 목록 모드
    return Column(
      children: [
        OrderFilterBar(
          onTapLocation: viewModel.onTapLocation,
          onTapDistance: () => _toggleDistanceDropdown(viewModel),
          distanceLabel: viewModel.distanceLabel,
          isDistanceOpen: viewModel.isDistanceDropdownOpen,
          distanceButtonKey: _distanceButtonKey,
        ),
        const Divider(height: 1, color: Color(0xFFE0E0E0)),
        Expanded(
          child: _OrderListBody(
            onTapCall: (call) {
              _removeDistanceDropdown();
              viewModel.setDistanceDropdownOpen(false);
              viewModel.selectCall(call);
            },
          ),
        ),
      ],
    );
  }
}

class _OrderListBody extends StatefulWidget {
  final void Function(OrderCall call) onTapCall;

  const _OrderListBody({
    required this.onTapCall,
  });

  @override
  State<_OrderListBody> createState() => _OrderListBodyState();
}

class _OrderListBodyState extends State<_OrderListBody> {
  bool _loadedOnce = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_loadedOnce) return;
    _loadedOnce = true;

    // 최초 1회 로딩 트리거
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<OrderViewModel>().loadOrderCalls();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OrderViewModel>();

    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.errorMessage != null) {
      return Center(
        child: Text(viewModel.errorMessage!),
      );
    }

    final calls = viewModel.calls;

    if (calls.isEmpty) {
      return const Center(
        child: Text(
          '주변에 조회 가능한 오더가 없습니다.',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF828282),
          ),
        ),
      );
    }

    return OrderListView(
      calls: calls,
      onTapCall: widget.onTapCall,
    );
  }
}
