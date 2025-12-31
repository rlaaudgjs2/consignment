import 'package:consignment/core/data/order/domain/order_call.dart';

import '../models/driving_history_dto.dart';
import '../models/driving_history_detail_dto.dart';

abstract class CompleteRemoteDataSource {
  Future<List<DrivingHistoryDto>> fetchDrivingHistories({
    required DateTime startDate,
    required DateTime endDate,
  });

  // ✅ 변경: Entity -> DTO
  Future<DrivingHistoryDetailDto> fetchDrivingHistoryDetail({
    required String id,
  });
}

class MockCompleteRemoteDataSource implements CompleteRemoteDataSource {
  static const List<DrivingHistoryDto> _mockList = <DrivingHistoryDto>[
    DrivingHistoryDto(
      id: 'SALM251124',
      startedAtIso: '2025-11-22T14:15:00',
      startAddress: '부안상서면부장1길 23',
      endAddress: '수원평동, 임광모터스',
      price: 110000,
    ),
    DrivingHistoryDto(
      id: 'SALM251125',
      startedAtIso: '2025-11-22T18:00:00',
      startAddress: '광화문 그레이힐스오피스텔',
      endAddress: '종로구 890-12',
      price: 65000,
    ),
    DrivingHistoryDto(
      id: 'SALM251126',
      startedAtIso: '2025-11-22T13:10:00',
      startAddress: '홍대입구 에코타운 주택',
      endAddress: '송파동 345-67',
      price: 120000,
    ),
    DrivingHistoryDto(
      id: 'SALM251127',
      startedAtIso: '2025-11-22T19:20:00',
      startAddress: '서초동 퍼플힐스오피스텔',
      endAddress: '삼성동 789-01',
      price: 80000,
    ),
  ];

  // ✅ 변경: Map<String, DrivingHistoryDetailDto>
  static const Map<String, DrivingHistoryDetailDto> _mockDetailMap =
  <String, DrivingHistoryDetailDto>{
    'SALM251124': DrivingHistoryDetailDto(
      id: 'SALM251124',
      orderType: OrderType.consign,
      tags: <String>['즉후', '경유', '하이패스'],
      clientName: '태) (주)대리GO',
      situationRoom: '16887141',
      startAddress: '부안상서면부장1길 23',
      endAddress: '수원평동, 임광모터스',
      fareWon: 110000,
      fareTypeText: '완)후불',
      orderNo: 'SALM251124',
      receivedAtText: '11:43',
      dispatchedAtText: '11:48',
      completedAtText: '15:19',
      carModel: '소나타',
      carNumber: '123가 1234',
    ),
    'SALM251125': DrivingHistoryDetailDto(
      id: 'SALM251125',
      orderType: OrderType.consign,
      tags: <String>['즉후'],
      clientName: '(주)예시발주처',
      situationRoom: '00000000',
      startAddress: '광화문 그레이힐스오피스텔',
      endAddress: '종로구 890-12',
      fareWon: 65000,
      fareTypeText: '완)후불',
      orderNo: 'SALM251125',
      receivedAtText: '18:01',
      dispatchedAtText: '18:05',
      completedAtText: '18:45',
      carModel: '그랜저',
      carNumber: '11가 1111',
    ),
    'SALM251126': DrivingHistoryDetailDto(
      id: 'SALM251126',
      orderType: OrderType.proxy,
      tags: <String>['경유'],
      clientName: '(주)예시발주처',
      situationRoom: '00000000',
      startAddress: '홍대입구 에코타운 주택',
      endAddress: '송파동 345-67',
      fareWon: 120000,
      fareTypeText: '완)후불',
      orderNo: 'SALM251126',
      receivedAtText: '13:11',
      dispatchedAtText: '13:14',
      completedAtText: '14:10',
      carModel: 'K5',
      carNumber: '22나 2222',
    ),
    'SALM251127': DrivingHistoryDetailDto(
      id: 'SALM251127',
      orderType: OrderType.consign,
      tags: <String>['하이패스'],
      clientName: '(주)예시발주처',
      situationRoom: '00000000',
      startAddress: '서초동 퍼플힐스오피스텔',
      endAddress: '삼성동 789-01',
      fareWon: 80000,
      fareTypeText: '완)후불',
      orderNo: 'SALM251127',
      receivedAtText: '19:21',
      dispatchedAtText: '19:25',
      completedAtText: '20:05',
      carModel: '아반떼',
      carNumber: '33다 3333',
    ),
  };

  @override
  Future<List<DrivingHistoryDto>> fetchDrivingHistories({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return _mockList;
  }

  @override
  Future<DrivingHistoryDetailDto> fetchDrivingHistoryDetail({
    required String id,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));

    final dto = _mockDetailMap[id];
    if (dto == null) {
      return DrivingHistoryDetailDto(
        id: id,
        orderType: OrderType.consign,
        tags: const <String>[],
        clientName: '-',
        situationRoom: '-',
        startAddress: '-',
        endAddress: '-',
        fareWon: 0,
        fareTypeText: '-',
        orderNo: id,
        receivedAtText: '-',
        dispatchedAtText: '-',
        completedAtText: '-',
        carModel: '-',
        carNumber: '-',
      );
    }
    return dto;
  }
}
