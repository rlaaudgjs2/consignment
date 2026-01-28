class SettingsMyInfo {
  final String driverPhoneNumber;
  final String driverName;
  final String officeName;
  final String officePhoneNumber;

  final String chargeAccountNumber;
  final String chargeBankName;
  final String chargeDepositorName;

  // 보험 가입자명
  final String insuranceOwnerName;

  // 보험 2종(대리/탁송)
  final SettingsInsurance proxyInsurance;
  final SettingsInsurance consignInsurance;

  const SettingsMyInfo({
    required this.driverPhoneNumber,
    required this.driverName,
    required this.officeName,
    required this.officePhoneNumber,
    required this.chargeAccountNumber,
    required this.chargeBankName,
    required this.chargeDepositorName,
    required this.insuranceOwnerName,
    required this.proxyInsurance,
    required this.consignInsurance,
  });

  // UI에서 리스트 렌더링 편하게 쓰는 getter (선택)
  List<SettingsInsurance> get insurances => [proxyInsurance, consignInsurance];
}

class SettingsInsurance {
  final String typeLabel; // "대리" | "탁송"
  final String startDate; // "2025-10-09"
  final String endDate;   // "2026-10-31"
  final String companyName;
  final String policyNumber;

  const SettingsInsurance({
    required this.typeLabel,
    required this.startDate,
    required this.endDate,
    required this.companyName,
    required this.policyNumber,
  });
}
