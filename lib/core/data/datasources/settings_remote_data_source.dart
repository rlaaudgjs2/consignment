import 'package:consignment/core/data/datasources/test_data.dart';
import 'package:consignment/core/data/models/settings_my_info_dto.dart';
import 'package:consignment/core/data/models/settings_notice_dto.dart';

/// Settings 전용 RemoteDataSource
///
/// 현재는 TestData 기반 구현.
/// 추후 실제 API 연결 시 이 파일 내부 구현만 교체하면 됨.
class SettingsRemoteDataSource {
  const SettingsRemoteDataSource();

  Future<SettingsMyInfoDto> fetchMyInfo() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return TestData.myInfoMock();
  }

  Future<List<SettingsNoticeDto>> fetchNotices() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return TestData.noticesMock;
  }
}
