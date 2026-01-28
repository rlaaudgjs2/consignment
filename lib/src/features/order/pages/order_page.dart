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
    final renderBox = _distanceButtonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _distanceOverlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _removeDistanceDropdown();
                  viewModel.setDistanceDropdownOpen(false);
                },
              ),
            ),
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
                    border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
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
                              bottom: BorderSide(color: Color(0xFFE0E0E0), width: 0.5),
                            ),
                          ),
                          child: Text(
                            '$km km',
                            style: TextStyle(
                              fontSize: 16,
                              color: isSelected ? const Color(0xFFFBB35F) : const Color(0xFF4F4F4F),
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
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

    if (viewModel.isDetailMode) {
      final OrderCall call = viewModel.selectedCall!;
      return OrderDetailView(
        call: call,
        onTapCancel: viewModel.cancelDetail,
        onTapDispatch: (call) => viewModel.onTapDispatch(context, call),
      );
    }

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
            onCloseDropdown: () {
              _removeDistanceDropdown();
              viewModel.setDistanceDropdownOpen(false);
            },
          ),
        ),
      ],
    );
  }
}

class _OrderListBody extends StatefulWidget {
  final void Function(OrderCall call) onTapCall;
  final VoidCallback onCloseDropdown;

  const _OrderListBody({
    required this.onTapCall,
    required this.onCloseDropdown,
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      // ✅ context 전달 필수
      context.read<OrderViewModel>().loadOrderCalls(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OrderViewModel>();

    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // ✅ 에러가 있으면 “오더 리스트 자리”에 텍스트를 길게(스크롤) 노출
    if (viewModel.errorMessage != null) {
      return _OrderErrorView(
        message: viewModel.errorMessage!,
        onRetry: () => viewModel.loadOrderCalls(context),
        onTapBackground: widget.onCloseDropdown,
      );
    }

    final calls = viewModel.calls;

    if (calls.isEmpty) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onCloseDropdown,
        child: const Center(
          child: Text(
            '주변에 조회 가능한 오더가 없습니다.',
            style: TextStyle(fontSize: 16, color: Color(0xFF828282)),
          ),
        ),
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onCloseDropdown,
      child: OrderListView(
        calls: calls,
        onTapCall: widget.onTapCall,
      ),
    );
  }
}

class _OrderErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final VoidCallback onTapBackground;

  const _OrderErrorView({
    required this.message,
    required this.onRetry,
    required this.onTapBackground,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTapBackground,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9F9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '요청이 실패했습니다.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ✅ 길면 스크롤로 “쭉” 확인 가능
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 220),
                    child: SingleChildScrollView(
                      child: SelectableText(
                        message,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.35,
                          color: Color(0xFF4F4F4F),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onRetry,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFE0E0E0)),
                            foregroundColor: const Color(0xFF333333),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('다시 시도'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
