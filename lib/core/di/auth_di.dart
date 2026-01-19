import '../data/network/api_client.dart';
import '../data/datasources/auth_remote_data_source.dart';
import '../data/datasources/token_local_data_source.dart';
import '../data/repositories/auth_repository.dart';

/// Auth 관련 객체 조립 전용
class AuthDI {
  static AuthRepository createRepository() {
    final apiClient = ApiClient();

    final authRemoteDataSource =
    AuthRemoteDataSourceImpl(apiClient);

    final tokenLocalDataSource =
    SecureTokenLocalDataSource(); // 🔥 여기서 교체됨

    return AuthRepository(
      remote: authRemoteDataSource,
      local: tokenLocalDataSource,
    );
  }
}
