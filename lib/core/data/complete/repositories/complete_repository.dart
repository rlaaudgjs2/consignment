import '../datasources/complete_remote_data_source.dart';
import '../domain/driving_history.dart';

class CompleteRepository {
  final CompleteRemoteDataSource remote;

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
}
