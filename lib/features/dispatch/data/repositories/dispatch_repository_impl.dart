import 'package:consignment/features/dispatch/domain/entities/dispatch.dart';
import 'package:consignment/features/dispatch/domain/repositories/dispatch_repository.dart';
import 'package:consignment/features/dispatch/data/datasources/dispatch_remote_data_source.dart';

class DispatchRepositoryImpl implements DispatchRepository {
  final DispatchRemoteDataSource remote;

  DispatchRepositoryImpl({required this.remote});

  @override
  Future<Dispatch?> getCurrentDispatch() async {
    final dto = await remote.fetchCurrentDispatch();
    if (dto == null) return null;
    return dto.toEntity();
  }
}
