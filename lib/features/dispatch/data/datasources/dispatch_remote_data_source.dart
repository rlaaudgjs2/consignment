import 'package:consignment/features/dispatch/data/models/dispatch_dto.dart';

/// 서버(or mock)에서 dispatch 데이터를 가져오는 data source
abstract class DispatchRemoteDataSource {
  Future<DispatchDto?> fetchCurrentDispatch();
}

/// 아직 실제 API 없으니까, 테스트용 mock data source
class MockDispatchRemoteDataSource implements DispatchRemoteDataSource {
  @override
  Future<DispatchDto?> fetchCurrentDispatch() async {
    // 약간의 지연을 줘서 FutureBuilder 로딩 상태도 테스트 가능
    await Future<void>.delayed(const Duration(milliseconds: 300));

    // 배차가 없는 상태를 테스트하고 싶으면 여기서 null 리턴
    // return null;

    // 배차가 있는 상태 (mock 데이터)
    return DispatchDto.mock();
  }
}
