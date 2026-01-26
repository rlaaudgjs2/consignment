import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../data/network/api_client.dart';

import '../data/datasources/auth_remote_data_source.dart';
import '../data/datasources/token_local_data_source.dart';
import '../data/datasources/health_remote_data_source.dart';
import '../data/datasources/order_remote_data_source.dart';

import '../data/repositories/auth_repository.dart';
import '../data/repositories/health_repository.dart';
import '../data/repositories/order_repository.dart';

import 'package:consignment/core/data/datasources/location_remote_data_source.dart';
import 'package:consignment/core/data/repositories/location_repository.dart';

List<SingleChildWidget> appProviders = [
  Provider<TokenLocalDataSource>(
    create: (_) => SecureTokenLocalDataSource(),
  ),

  Provider<ApiClient>(
    create: (context) => ApiClient(
      tokenLocal: context.read<TokenLocalDataSource>(),
    ),
  ),

  // ===== Auth =====
  Provider<AuthRemoteDataSource>(
    create: (context) => AuthRemoteDataSourceImpl(
      context.read<ApiClient>(),
    ),
  ),
  Provider<AuthRepository>(
    create: (context) => AuthRepository(
      remote: context.read<AuthRemoteDataSource>(),
      local: context.read<TokenLocalDataSource>(),
    ),
  ),

  // ===== Health =====
  Provider<HealthRemoteDataSource>(
    create: (context) => HealthRemoteDataSourceImpl(
      context.read<ApiClient>(),
    ),
  ),
  Provider<HealthRepository>(
    create: (context) => HealthRepository(
      remote: context.read<HealthRemoteDataSource>(),
    ),
  ),

  // ===== Order (Dispatch List) =====
  Provider<OrderRemoteDataSource>(
    create: (context) => OrderRemoteDataSourceImpl(
      context.read<ApiClient>(),
    ),
  ),
  Provider<OrderRepository>(
    create: (context) => OrderRepository(
      remote: context.read<OrderRemoteDataSource>(),
    ),
  ),

  // ===== Location (NEW) =====
  Provider<LocationRemoteDataSource>(
    create: (context) => LocationRemoteDataSourceImpl(context.read<ApiClient>()),
  ),
  Provider<LocationRepository>(
    create: (context) => LocationRepository(
      remote: context.read<LocationRemoteDataSource>(),
    ),
  ),
];
