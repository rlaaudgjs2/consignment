import 'package:flutter/material.dart';
import 'package:consignment/features/dispatch/domain/entities/dispatch.dart';
import 'package:consignment/features/order/presentation/widgets/order_type_chip.dart';
import 'package:consignment/features/order/domain/entities/order_call.dart';

/// 배차 탭 루트 페이지
class DispatchPage extends StatelessWidget {
  const DispatchPage({super.key});

  // TODO: 실제 API 연동 시 제거하고, Provider/Bloc 등으로 주입받기
  Dispatch? get _mockDispatch => Dispatch(
    id: 11,
    active: false,
    callType: DispatchCallType.integrated,
    charge: 40000,
    clientPhoneNumber: '010-7777-8888',
    createdAt: DateTime.parse('2025-11-13 11:00:00.000000'),
    destinationLocation: '서울시 금천구 가산동 444',
    officeId: 1,
    service: DispatchService.driver,
    startLocation: '인천시 연수구 송도동 333',
    status: DispatchStatus.open,
    transporterId: null,
  );

  @override
  Widget build(BuildContext context) {
    final dispatch = _mockDispatch;

    if (dispatch == null) {
      return const Center(
        child: Text(
          '배차 된 오더가 없습니다.',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF828282),
          ),
        ),
      );
    }

    return DispatchDetailView(
      dispatch: dispatch,
      onTapNavi: () {
        // TODO: 내비 연동(길안내) 기능 연결
      },
      onTapComplete: () {
        // TODO: 배차 완료 처리 API 연동
      },
      onTapCancelDispatch: () {
        // TODO: 배차 취소 API 연동
      },
    );
  }
}

/// 배차 중인 오더 상세 화면 (피그마 "탭 화면/배차" 기준)
class DispatchDetailView extends StatelessWidget {
  final Dispatch dispatch;
  final VoidCallback onTapNavi;
  final VoidCallback onTapComplete;
  final VoidCallback onTapCancelDispatch;

  const DispatchDetailView({
    super.key,
    required this.dispatch,
    required this.onTapNavi,
    required this.onTapComplete,
    required this.onTapCancelDispatch,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: 요금구분/태그/차종/차량번호/오더정보는 실제 필드 생기면 교체
    const String fareType = '완)후불';
    const List<String> tags = ['현장', '톨별'];
    const String carModel = '소나타';
    const String carNumber = '12가1234';
    const String orderInfo =
        '오더번호 : ABCD251011\n1번 기사님 : 010-1234-5678로 연락드리세요';

    final String chargeText = _formatPrice(dispatch.charge);
    final String createdTimeText = _formatTime(dispatch.createdAt);

    final double screenWidth = MediaQuery.of(context).size.width;
    const double horizontalPadding = 24;
    const double gap = 16;

    // 양쪽 패딩 + 버튼 사이 간격을 제외한 나머지를 반반 나누기
    final double buttonWidth =
        (screenWidth - horizontalPadding * 2 - gap) / 2;

    return Column(
      children: [
        // 상단 상태바 아래 전체 내용
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 탁송/대리 칩 + 우측 상단 태그들
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OrderTypeChip(
                      type: dispatch.callType == DispatchCallType.integrated
                          ? OrderType.consign
                          : OrderType.proxy,
                    ),
                    _DetailTagsRow(tags: tags),
                  ],
                ),
                const SizedBox(height: 20),

                _rowLabelValue('출발지', dispatch.startLocation),
                const SizedBox(height: 10),
                _rowLabelValue('도착지', dispatch.destinationLocation),
                const SizedBox(height: 10),
                _rowLabelValue('요금', chargeText),
                const SizedBox(height: 10),
                _rowLabelValue('요금구분', fareType),
                const SizedBox(height: 10),
                _rowLabelValue('오더정보', orderInfo),
                const SizedBox(height: 10),
                _rowLabelValue('접수시간', createdTimeText),
                const SizedBox(height: 10),
                _rowLabelValue('차종', carModel),
                const SizedBox(height: 10),
                _rowLabelValue('차량번호', carNumber),
                const SizedBox(height: 24),

                // 중간 버튼 4개 (출발지도 / 픽업지원 / 갱신 / 배차취소)
                _buildMiddleButtons(),
              ],
            ),
          ),
        ),

        // 하단 큰 버튼 영역 (내비연동 / 완료)
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Row(
            // spaceBetween 쓰지 말고, 우리가 gap 을 직접 넣자
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: buttonWidth,
                height: 48,
                child: OutlinedButton(
                  onPressed: onTapNavi,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color(0xFFFBB35F),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    '내비연동 (길안내)',
                    style: TextStyle(
                      color: Color(0xFFFBB35F),
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: gap),
              SizedBox(
                width: buttonWidth,
                height: 48,
                child: ElevatedButton(
                  onPressed: onTapComplete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFBB35F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    '완료',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

      ],
    );
  }

  /// 출발지도 / 픽업지원 / 갱신 / 배차취소 버튼 영역
  Widget _buildMiddleButtons() {
    Widget buildOutlined(String label, {Color? textColor, Color? borderColor}) {
      return OutlinedButton(
        onPressed: () {
          // TODO: 각각의 기능 연결 (출발지도/픽업지원/갱신/배차취소)
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: borderColor ?? const Color(0xFFE0E0E0),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: textColor ?? const Color(0xFF4F4F4F),
          ),
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: buildOutlined('출발지도'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: buildOutlined('픽업/지원'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: buildOutlined('갱신'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: buildOutlined(
                '배차취소',
                textColor: const Color(0xFFE95353),
                borderColor: const Color(0xFFE0E0E0),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _rowLabelValue(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF828282),
            ),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xFF333333),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  static String _formatPrice(int price) {
    final s = price.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final indexFromEnd = s.length - i;
      buffer.write(s[i]);
      if (indexFromEnd > 1 && indexFromEnd % 3 == 1) {
        buffer.write(',');
      }
    }
    return '$buffer원';
  }

  /// createdAt 문자열에서 HH:mm만 뽑는 간단 포맷터
  static String _formatTime(DateTime createdAt) {
    final hh = createdAt.hour.toString().padLeft(2, '0');
    final mm = createdAt.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }
}

/// 디테일 화면 우측 상단 태그들 ("현장 | 톨별" 등)
class _DetailTagsRow extends StatelessWidget {
  final List<String> tags;

  const _DetailTagsRow({required this.tags});

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < tags.length; i++) ...[
          Text(
            tags[i],
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF828282),
            ),
          ),
          if (i != tags.length - 1)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                '|',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFFBDBDBD),
                ),
              ),
            ),
        ],
      ],
    );
  }
}
