import '../models/driving_history_dto.dart';

abstract class CompleteRemoteDataSource {
  Future<List<DrivingHistoryDto>> fetchDrivingHistories({
    required DateTime startDate,
    required DateTime endDate,
  });
}

class MockCompleteRemoteDataSource implements CompleteRemoteDataSource {
  @override
  Future<List<DrivingHistoryDto>> fetchDrivingHistories({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));

    return const <DrivingHistoryDto>[
      DrivingHistoryDto(
        startedAtIso: '2025-11-22T18:00:00',
        startTitle: '광화문 그레이힐스오피스텔',
        endAddress: '종로구 890-12',
        price: 65000,
      ),
      DrivingHistoryDto(
        startedAtIso: '2025-11-22T13:10:00',
        startTitle: '홍대입구 에코타운 주택',
        endAddress: '송파동 345-67',
        price: 120000,
      ),
      DrivingHistoryDto(
        startedAtIso: '2025-11-22T19:20:00',
        startTitle: '서초동 퍼플힐스오피스텔',
        endAddress: '삼성동 789-01',
        price: 80000,
      ),
      DrivingHistoryDto(
        startedAtIso: '2025-11-22T14:15:00',
        startTitle: '강남역 스카이뷰 레지던스',
        endAddress: '압구정동 123-45',
        price: 50000,
      ),
    ];
  }
}
