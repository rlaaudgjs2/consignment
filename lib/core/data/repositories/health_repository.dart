import '../datasources/health_remote_data_source.dart';

class HealthRepository {
  final HealthRemoteDataSource _remote;

  const HealthRepository({required HealthRemoteDataSource remote})
      : _remote = remote;

  Future<String> ping() => _remote.ping();
}
