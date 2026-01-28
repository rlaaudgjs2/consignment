import '../data/network/api_client.dart';
import '../data/datasources/auth_remote_data_source.dart';
import '../data/datasources/token_local_data_source.dart';
import '../data/repositories/auth_repository.dart';

/// Auth 관련 객체 조립 전용
class AuthDI {
  static AuthRepository createRepository() {
    final tokenLocalDataSource = SecureTokenLocalDataSource();

    final apiClient = ApiClient(
      tokenLocal: tokenLocalDataSource,
    );

    final authRemoteDataSource = AuthRemoteDataSourceImpl(apiClient);

    return AuthRepository(
      remote: authRemoteDataSource,
      local: tokenLocalDataSource,
    );
  }
}
