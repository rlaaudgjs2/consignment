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

  Future<void> _init() async {
    await load();
  }

  Future<void> load() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _info = await _repository.fetchMyInfo();
    } catch (_) {
      _errorMessage = '내 정보 조회 중 오류가 발생했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ✅ Page 전용 getter들 (DTO/도메인 네이밍과 일치)
  String? get driverPhoneNumber => _info?.driverPhoneNumber;
  String? get driverName => _info?.driverName;
  String? get officeName => _info?.officeName;
  String? get officePhoneNumber => _info?.officePhoneNumber;

  String? get chargeAccountNumber => _info?.chargeAccountNumber;
  String? get chargeBankName => _info?.chargeBankName;
  String? get chargeDepositorName => _info?.chargeDepositorName;

  String? get insuranceOwnerName => _info?.insuranceOwnerName;

  // ✅ 보험: 2개를 UI에서 리스트로 쓰기 좋게 제공
  List<SettingsInsurance> get insurances {
    final info = _info;
    if (info == null) return const [];
    return [info.proxyInsurance, info.consignInsurance];
  }
}
