import 'package:consignment/core/data/datasources/test_data.dart';
import 'package:consignment/core/data/models/dispatch_dto.dart';

/// Dispatch(배차) 전용 RemoteDataSource
///
/// 현재는 TestData 기반 구현.
/// 추후 실제 API 연결 시 이 파일 내부 구현만 교체하면 됨.
class DispatchRemoteDataSource {
  const DispatchRemoteDataSource();

  Future<DispatchDto?> fetchCurrentDispatch() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return TestData.dispatchMock();
  }
}
