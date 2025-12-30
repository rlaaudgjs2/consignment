import 'package:consignment/core/data/settings/models/settings_my_info_dto.dart';
import 'package:consignment/core/data/settings/models/settings_notice_dto.dart';

abstract class SettingsRemoteDataSource {
  Future<SettingsMyInfoDto> fetchMyInfo();
  Future<List<SettingsNoticeDto>> fetchNotices();
}

/// ✅ API 붙이기 전 Mock
class MockSettingsRemoteDataSource implements SettingsRemoteDataSource {
  @override
  Future<SettingsMyInfoDto> fetchMyInfo() async {
    await Future.delayed(const Duration(milliseconds: 250));

    return const SettingsMyInfoDto(
      driverPhoneNumber: '010-1234-5678',
      driverName: '김규원',
      officeName: '모비탁송',
      officePhoneNumber: '1811-2823',
      chargeAccountNumber: '082-0665729-7271',
      chargeBankName: '기업은행',
      chargeDepositorName: '아이콘 김규원',
      insuranceOwnerName: '김규원',
      proxyInsurance: SettingsInsuranceDto(
        typeLabel: '대리',
        startDate: '2025-10-09',
        endDate: '2026-10-31',
        companyName: '롯데(대리)',
        policyNumber: 'SA20257877260000',
      ),
      consignInsurance: SettingsInsuranceDto(
        typeLabel: '탁송',
        startDate: '2025-10-09',
        endDate: '2026-10-31',
        companyName: '롯데(탁송)',
        policyNumber: 'SA20257877260000',
      ),
    );
  }

  @override
  Future<List<SettingsNoticeDto>> fetchNotices() async {
    await Future.delayed(const Duration(milliseconds: 250));

    return const [
      SettingsNoticeDto(
        title: '시스템 점검 안내',
        date: '2025-12-27',
        body:
        '시스템 점검이 예정되어 있습니다.\n'
            '점검 시간 동안 일부 기능이 제한될 수 있습니다.',
      ),
      SettingsNoticeDto(
        title: '시스템 복구 안내',
        date: '2025-12-27',
        body: '시스템 복구가 완료되었습니다.\n정상적으로 이용 가능합니다.',
      ),
      SettingsNoticeDto(
        title: '서비스 안내',
        date: '2025-12-27',
        body:
        '안녕하세요 모비 입니다.\n'
            '모비 서비스와 관련해 회원님께 알려드립니다.\n\n'
            '최근 외부사이트의 ID와 비밀번호 정보를 확보한 후 여러 서비스에 로그인하여 '
            '무차별적으로 스팸 게시글을 등록하거나 채팅을 발송하는 사례가 급증하고 있습니다.\n\n'
            '계정 정보에 이메일 계정을 등록해 놓으신 회원분 중 타 사이트와 비밀번호를 동일하게 설정하신 경우 '
            '이러한 피해를 추가로 입으실 수 있으니 아래 절차를 꼭 진행해주시기 바랍니다.',
      ),
      SettingsNoticeDto(
        title: '서비스 안내',
        date: '2025-12-27',
        body: '추가 안내 사항입니다.',
      ),
    ];
  }
}
