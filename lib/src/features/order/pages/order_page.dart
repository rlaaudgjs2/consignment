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
        final theme = Theme.of(context);
        final cs = theme.colorScheme;

        final bg = cs.surface;
        final border = cs.outlineVariant;
        final text = cs.onSurface;
        final selected = cs.primary;

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
                    color: bg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: border, width: 1),
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
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: border,
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: Text(
                            '$km km',
                            style: TextStyle(
                              fontSize: 16,
                              color: isSelected ? selected : text.withOpacity(0.85),
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
    final cs = Theme.of(context).colorScheme;

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

        // ✅ divider 하드코딩 제거
        Divider(height: 1, color: cs.outlineVariant),

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
      context.read<OrderViewModel>().loadOrderCalls(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OrderViewModel>();
    final cs = Theme.of(context).colorScheme;

    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

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
        child: Center(
          child: Text(
            '주변에 조회 가능한 오더가 없습니다.',
            style: TextStyle(
              fontSize: 16,
              color: cs.onSurface.withOpacity(0.7),
            ),
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
    final cs = Theme.of(context).colorScheme;

    final cardBg = cs.surface;
    final cardBorder = cs.outlineVariant;
    final titleColor = cs.onSurface;
    final bodyColor = cs.onSurface.withOpacity(0.85);

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
                color: cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: cardBorder),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '요청이 실패했습니다.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 10),

                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 220),
                    child: SingleChildScrollView(
                      child: SelectableText(
                        message,
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.35,
                          color: bodyColor,
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
                            side: BorderSide(color: cardBorder),
                            foregroundColor: titleColor,
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
