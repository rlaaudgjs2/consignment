import 'package:consignment/features/dispatch/domain/entities/dispatch.dart';

/// 배차 관련 도메인 레포지토리 인터페이스
abstract class DispatchRepository {
  /// 현재 기사에게 배차된 디스패치를 한 건 가져온다.
  /// 없으면 null.
  Future<Dispatch?> getCurrentDispatch();
}
