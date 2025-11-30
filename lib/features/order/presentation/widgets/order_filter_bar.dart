import 'package:flutter/material.dart';

/// 오더 탭 상단의
/// "현재 위치 설정하기" + "거리 필터" 영역 컴포넌트.
class OrderFilterBar extends StatelessWidget {
  final VoidCallback onTapLocation;
  final VoidCallback onTapDistance;
  final String distanceLabel;
  final bool isDistanceOpen; // 필터 펼쳐져 있을 때 위 화살표로 표시

  /// 거리 버튼 위치를 계산하기 위한 키
  final GlobalKey distanceButtonKey;

  const OrderFilterBar({
    super.key,
    required this.onTapLocation,
    required this.onTapDistance,
    required this.distanceLabel,
    required this.distanceButtonKey,
    this.isDistanceOpen = false,
  });

  @override
  Widget build(BuildContext context) {
    const Color mainColor = Color(0xFFFBB35F);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Row(
        children: [
          // 왼쪽: 현재 위치 설정하기
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTapLocation,
              child: Row(
                children: [
                  const Icon(
                    Icons.place, // 기존 AppIcons.orderLocation 대체
                    size: 20,
                    color: mainColor,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '현재 위치 설정하기',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFFBB35F), // main 주황색
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 12),

          // 오른쪽: 거리 필터 버튼 (피그마 120 x 32)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTapDistance,
            child: SizedBox(
              key: distanceButtonKey, // 🔹 위치 계산용 키
              width: 120,
              height: 32,
              child: Container(
                padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8), // Radius 8px
                  border: Border.all(
                    color: const Color(0xFFE0E0E0), // Border 1px
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        distanceLabel,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF4F4F4F),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      isDistanceOpen
                          ? Icons.arrow_drop_up   // 펼쳐져 있을 때
                          : Icons.arrow_drop_down, // 닫혀 있을 때
                      size: 20,
                      color: const Color(0xFFFBB35F),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
