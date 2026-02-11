import 'package:flutter/foundation.dart';

import 'package:consignment/core/data/domain/settings_my_info.dart';
import 'package:consignment/core/data/repositories/settings_repository.dart';

class SettingsMyInfoViewModel extends ChangeNotifier {
  final SettingsRepository _repository;

  SettingsMyInfoViewModel({
    required SettingsRepository repository,
  }) : _repository = repository {
    _init();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  SettingsMyInfo? _info;
  SettingsMyInfo? get info => _info;

  // ✅ 더미 기사코드 (나중에 _info?.driverCode 같은 필드로 대체)
  String? _driverCode = 'MOBI-0000-0000';
  String? get driverCode => _driverCode;

  // ✅ 재발급 로딩 상태(버튼 비활성)
  bool _isReissuingCode = false;
  bool get isReissuingCode => _isReissuingCode;

  Future<void> _init() async {
    await load();
  }

  Future<void> load() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _info = await _repository.fetchMyInfo();

      // TODO(백엔드 연동 시):
      // _driverCode = _info?.driverCode;
      // 지금은 더미 유지
    } catch (_) {
      _errorMessage = '내 정보 조회 중 오류가 발생했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ✅ 임시: 기사 코드 재발급(더미)
  Future<void> reissueDriverCode() async {
    if (_isReissuingCode) return;

    _isReissuingCode = true;
    notifyListeners();

    try {
      // TODO(백엔드 연동 시):
      // final newCode = await _repository.reissueDriverCode();
      // _driverCode = newCode;

      await Future.delayed(const Duration(milliseconds: 500));

      // 더미로 코드만 살짝 변경
      final now = DateTime.now();
      final mm = now.month.toString().padLeft(2, '0');
      final ss = now.second.toString().padLeft(2, '0');
      _driverCode = 'MOBI-$mm$ss-${(now.millisecond % 10000).toString().padLeft(4, '0')}';
    } catch (_) {
      _errorMessage = '기사 코드 재발급 중 오류가 발생했습니다.';
    } finally {
      _isReissuingCode = false;
      notifyListeners();
    }
  }

  // ✅ Page 전용 getter들
  String? get driverPhoneNumber => _info?.driverPhoneNumber;
  String? get driverName => _info?.driverName;
  String? get officeName => _info?.officeName;
  String? get officePhoneNumber => _info?.officePhoneNumber;

  String? get chargeAccountNumber => _info?.chargeAccountNumber;
  String? get chargeBankName => _info?.chargeBankName;
  String? get chargeDepositorName => _info?.chargeDepositorName;

  String? get insuranceOwnerName => _info?.insuranceOwnerName;

  List<SettingsInsurance> get insurances {
    final info = _info;
    if (info == null) return const [];
    return [info.proxyInsurance, info.consignInsurance];
  }
}
