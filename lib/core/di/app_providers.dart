import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../data/network/api_client.dart';

import '../data/datasources/auth_remote_data_source.dart';
import '../data/datasources/token_local_data_source.dart';
import '../data/datasources/health_remote_data_source.dart';

import '../data/repositories/auth_repository.dart';
import '../data/repositories/health_repository.dart';

List<SingleChildWidget> appProviders = [
  Provider<ApiClient>(
    create: (_) => ApiClient(),
  ),

  // ===== Auth =====
  Provider<AuthRemoteDataSource>(
    create: (context) => AuthRemoteDataSourceImpl(context.read<ApiClient>()),
  ),
  Provider<TokenLocalDataSource>(
    create: (_) => SecureTokenLocalDataSource(),
  ),
  Provider<AuthRepository>(
    create: (context) => AuthRepository(
      remote: context.read<AuthRemoteDataSource>(),
      local: context.read<TokenLocalDataSource>(),
    ),
  ),

  // ===== Health =====
  Provider<HealthRemoteDataSource>(
    create: (context) => HealthRemoteDataSourceImpl(context.read<ApiClient>()),
  ),
  Provider<HealthRepository>(
    create: (context) => HealthRepository(
      remote: context.read<HealthRemoteDataSource>(),
    ),
  ),
];
