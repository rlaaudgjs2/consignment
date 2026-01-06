import 'package:consignment/core/data/datasources/test_data.dart';
import 'package:consignment/core/data/models/driving_history_detail_dto.dart';
import 'package:consignment/core/data/models/driving_history_dto.dart';

/// Complete(운행내역) 전용 RemoteDataSource
///
/// 현재는 TestData 기반 구현.
/// 추후 실제 API 연결 시 이 파일 내부 구현만 교체하면 됨.
class CompleteRemoteDataSource {
  const CompleteRemoteDataSource();

  Future<List<DrivingHistoryDto>> fetchDrivingHistories({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return TestData.drivingHistoryList;
  }

  Future<DrivingHistoryDetailDto> fetchDrivingHistoryDetail({
    required String id,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return TestData.drivingHistoryDetailMap[id] ??
        TestData.emptyDrivingHistoryDetail(id);
  }
}
