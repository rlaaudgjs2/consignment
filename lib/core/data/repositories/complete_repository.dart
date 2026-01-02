import '../datasources/remote_data_source.dart';
import '../domain/driving_history.dart';
import '../domain/driving_history_detail.dart';

class CompleteRepository {
  final RemoteDataSource remote;

  CompleteRepository({
    required this.remote,
  });

  Future<List<DrivingHistory>> fetchDrivingHistories({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final dtos = await remote.fetchDrivingHistories(
      startDate: startDate,
      endDate: endDate,
    );

    return dtos.map((e) => e.toEntity()).toList();
  }

  // ✅ 변경: remote는 DetailDto를 주고, repo에서 Entity로 변환
  Future<DrivingHistoryDetail> fetchDrivingHistoryDetail({
    required String id,
  }) async {
    final dto = await remote.fetchDrivingHistoryDetail(id: id);
    return dto.toEntity();
  }
}
