import 'package:flutter/material.dart';
import 'package:consignment/features/order/domain/entities/order_call.dart';
import 'package:consignment/features/order/domain/repositories/order_repository.dart';
import 'package:consignment/features/order/data/repositories/order_repository_impl.dart';
import 'package:consignment/features/order/data/datasources/order_remote_data_source.dart';
import 'package:consignment/features/order/presentation/widgets/order_filter_bar.dart';
import 'package:consignment/features/order/presentation/pages/order_list_view.dart';
import 'package:consignment/features/order/presentation/pages/order_detail_view.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  // ---------- 레포지토리 ----------
  late final OrderRepository _repository;

  @override
  void initState() {
    super.initState();
    _repository = OrderRepositoryImpl(
      remote: MockOrderRemoteDataSource(),
    );
  }

  // ---------- 거리 필터 상태 ----------
  final List<int> _distanceOptions = [1, 5, 10, 20, 50, 100];

  int _selectedDistance = 50;
  bool _isDistanceDropdownOpen = false;

  /// 거리 버튼 위치 측정을 위한 키
  final GlobalKey _distanceButtonKey = GlobalKey();

  OverlayEntry? _distanceOverlayEntry;

  String get _distanceLabel => '$_selectedDistance km 이내';

  // ---------- 오더 리스트 / 상세 상태 ----------
  OrderCall? _selectedCall;

  bool get _isDetailMode => _selectedCall != null;

  // ---------- 액션들 ----------

  void _onTapLocation() {
    // TODO: 현재 위치 설정
    debugPrint('현재 위치 설정하기 클릭');
  }

  void _toggleDistanceDropdown() {
    if (_isDistanceDropdownOpen) {
      _removeDistanceDropdown();
    } else {
      _showDistanceDropdown();
    }
  }

  void _showDistanceDropdown() {
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
                onTap: _removeDistanceDropdown,
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
                    children: _distanceOptions.map((km) {
                      final bool isSelected = km == _selectedDistance;
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedDistance = km;
                          });
                          _removeDistanceDropdown();
                        },
                        child: Container(
                          height: 60, // 피그마: 각 옵션 120 x 60
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

    setState(() {
      _isDistanceDropdownOpen = true;
    });
  }

  void _removeDistanceDropdown() {
    _distanceOverlayEntry?.remove();
    _distanceOverlayEntry = null;

    if (mounted) {
      setState(() {
        _isDistanceDropdownOpen = false;
      });
    }
  }

  // 리스트에서 콜 하나 클릭
  void _handleSelectCall(OrderCall call) {
    _removeDistanceDropdown(); // 상세 진입 시 드롭다운 닫기
    setState(() {
      _selectedCall = call;
    });
  }

  // 상세에서 취소
  void _handleCancel() {
    setState(() {
      _selectedCall = null;
    });
  }

  // 상세에서 배차 버튼
  void _handleDispatch(OrderCall call) {
    // TODO: 배차 API 호출
    debugPrint('배차 요청: ${call.startAddress} → ${call.endAddress}');
    setState(() {
      _selectedCall = null;
    });
  }

  @override
  void dispose() {
    _removeDistanceDropdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 상세 모드에서는 피그마 스샷처럼 필터바 없이 “배차 확인 화면”만 보이도록 함.
    if (_isDetailMode) {
      return OrderDetailView(
        call: _selectedCall!,
        onTapCancel: _handleCancel,
        onTapDispatch: _handleDispatch,
      );
    }

    // 기본: 필터바 + (거리 기준으로 fetch한) 콜 리스트
    return Column(
      children: [
        OrderFilterBar(
          onTapLocation: _onTapLocation,
          onTapDistance: _toggleDistanceDropdown,
          distanceLabel: _distanceLabel,
          isDistanceOpen: _isDistanceDropdownOpen,
          distanceButtonKey: _distanceButtonKey,
        ),
        const Divider(height: 1, color: Color(0xFFE0E0E0)),
        Expanded(
          child: FutureBuilder<List<OrderCall>>(
            future: _repository.getOrderCalls(
              maxDistanceKm: _selectedDistance,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(
                  child: Text('오더를 불러올 수 없습니다.'),
                );
              }

              final calls = snapshot.data ?? [];

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
                onTapCall: _handleSelectCall,
              );
            },
          ),
        ),
      ],
    );
  }
}
