import 'package:consignment/core/data/domain/dispatch.dart';
import 'package:consignment/core/data/datasources/dispatch_remote_data_source.dart';

class DispatchRepositoryImpl {
  final DispatchRemoteDataSource remote;

  DispatchRepositoryImpl({required this.remote});

  Future<Dispatch?> getCurrentDispatch() async {
    final dto = await remote.fetchCurrentDispatch();
    if (dto == null) return null;
    return dto.toEntity();
  }
}
