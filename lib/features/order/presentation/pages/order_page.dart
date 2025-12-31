import 'package:flutter/material.dart';
import 'package:consignment/features/order/presentation/widgets/order_filter_bar.dart';
import 'package:consignment/features/order/presentation/widgets/order_call_card.dart';
import 'package:consignment/core/config/assets.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final List<int> _distanceOptions = [1, 5, 10, 20, 50, 100];

  int _selectedDistance = 50;
  bool _isDistanceDropdownOpen = false;

  // 거리 버튼의 위치를 얻기 위한 키
  final GlobalKey _distanceButtonKey = GlobalKey();

  OverlayEntry? _distanceOverlayEntry;

  String get _distanceLabel => '$_selectedDistance km 이내';

  // 더미 콜 데이터
  final List<OrderCallDummy> _calls = [
    OrderCallDummy(
      typeLabel: '탁송',
      typeChipAsset: AppIcons.orderTagTaksong,
      startAddress: '강남구 456-78',
      endAddress: '서초동 123-45',
      distanceKm: 4.5,
      tags: ['카드', '하이패스'],
      price: 90000,
    ),
    OrderCallDummy(
      typeLabel: '탁송',
      typeChipAsset: AppIcons.orderTagTaksong,
      startAddress: '서초동 그랜드오피스텔',
      endAddress: '강남구 789-01',
      distanceKm: 6.0,
      tags: ['즉후', '경유', '톨별'],
      price: 80000,
    ),
    OrderCallDummy(
      typeLabel: '대리',
      typeChipAsset: AppIcons.orderTagDaeri,
      startAddress: '여의도 리버뷰 오피스텔',
      endAddress: '송파구 올림픽로 789',
      distanceKm: 7.1,
      tags: ['현금', '톨포'],
      price: 100000,
    ),
  ];

  void _onTapLocation() {
    // TODO: 현재 위치 설정 BottomSheet / 권한 요청 등으로 연결
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
            // 바깥 클릭 시 닫히도록 전체 영역 터치 레이어
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _removeDistanceDropdown,
              ),
            ),
            // 거리 버튼 바로 아래의 드롭다운
            Positioned(
              left: offset.dx,
              top: offset.dy + size.height,
              width: size.width, // 120과 같음
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
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
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

  @override
  void dispose() {
    _removeDistanceDropdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          child: ListView.separated(
            padding: const EdgeInsets.only(top: 8, bottom: 16),
            itemCount: _calls.length,
            separatorBuilder: (_, __) => const SizedBox(height: 0),
            itemBuilder: (context, index) {
              final call = _calls[index];
              return OrderCallCard(
                typeLabel: call.typeLabel,
                typeChipAsset: call.typeChipAsset,
                startAddress: call.startAddress,
                endAddress: call.endAddress,
                distanceKm: call.distanceKm,
                tags: call.tags,
                price: call.price,
              );
            },
          ),
        ),
      ],
    );
  }
}

/// 나중에 domain/entities 쪽으로 이동할 예정인 임시 모델
class OrderCallDummy {
  final String typeLabel;
  final String typeChipAsset;
  final String startAddress;
  final String endAddress;
  final double distanceKm;
  final List<String> tags;
  final int price;

  OrderCallDummy({
    required this.typeLabel,
    required this.typeChipAsset,
    required this.startAddress,
    required this.endAddress,
    required this.distanceKm,
    required this.tags,
    required this.price,
  });
}