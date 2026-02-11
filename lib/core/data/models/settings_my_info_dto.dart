import 'package:consignment/core/data/domain/settings_my_info.dart';

class SettingsMyInfoDto {
  final String? driverPhoneNumber;
  final String? driverName;
  final String? officeName;
  final String? officePhoneNumber;

  final String? chargeAccountNumber;
  final String? chargeBankName;
  final String? chargeDepositorName;

  final String? insuranceOwnerName;
  final SettingsInsuranceDto? proxyInsurance;
  final SettingsInsuranceDto? consignInsurance;

  const SettingsMyInfoDto({
    this.driverPhoneNumber,
    this.driverName,
    this.officeName,
    this.officePhoneNumber,
    this.chargeAccountNumber,
    this.chargeBankName,
    this.chargeDepositorName,
    this.insuranceOwnerName,
    this.proxyInsurance,
    this.consignInsurance,
  });

  factory SettingsMyInfoDto.fromJson(Map<String, dynamic> json) {
    return SettingsMyInfoDto(
      driverPhoneNumber: json['driverPhoneNumber'] as String?,
      driverName: json['driverName'] as String?,
      officeName: json['officeName'] as String?,
      officePhoneNumber: json['officePhoneNumber'] as String?,
      chargeAccountNumber: json['chargeAccountNumber'] as String?,
      chargeBankName: json['chargeBankName'] as String?,
      chargeDepositorName: json['chargeDepositorName'] as String?,
      insuranceOwnerName: json['insuranceOwnerName'] as String?,
      proxyInsurance: json['proxyInsurance'] is Map<String, dynamic>
          ? SettingsInsuranceDto.fromJson(
        json['proxyInsurance'] as Map<String, dynamic>,
      )
          : null,
      consignInsurance: json['consignInsurance'] is Map<String, dynamic>
          ? SettingsInsuranceDto.fromJson(
        json['consignInsurance'] as Map<String, dynamic>,
      )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'driverPhoneNumber': driverPhoneNumber,
      'driverName': driverName,
      'officeName': officeName,
      'officePhoneNumber': officePhoneNumber,
      'chargeAccountNumber': chargeAccountNumber,
      'chargeBankName': chargeBankName,
      'chargeDepositorName': chargeDepositorName,
      'insuranceOwnerName': insuranceOwnerName,
      'proxyInsurance': proxyInsurance?.toJson(),
      'consignInsurance': consignInsurance?.toJson(),
    };
  }

  SettingsMyInfo toEntity() {
    return SettingsMyInfo(
      driverPhoneNumber: driverPhoneNumber ?? '',
      driverName: driverName ?? '',
      officeName: officeName ?? '',
      officePhoneNumber: officePhoneNumber ?? '',
      chargeAccountNumber: chargeAccountNumber ?? '',
      chargeBankName: chargeBankName ?? '',
      chargeDepositorName: chargeDepositorName ?? '',
      insuranceOwnerName: insuranceOwnerName ?? '',
      proxyInsurance: (proxyInsurance ?? const SettingsInsuranceDto()).toEntity(),
      consignInsurance: (consignInsurance ?? const SettingsInsuranceDto()).toEntity(),
    );
  }
}

class SettingsInsuranceDto {
  final String? typeLabel;
  final String? startDate;
  final String? endDate;
  final String? companyName;
  final String? policyNumber;

  const SettingsInsuranceDto({
    this.typeLabel,
    this.startDate,
    this.endDate,
    this.companyName,
    this.policyNumber,
  });

  factory SettingsInsuranceDto.fromJson(Map<String, dynamic> json) {
    return SettingsInsuranceDto(
      typeLabel: json['typeLabel'] as String?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      companyName: json['companyName'] as String?,
      policyNumber: json['policyNumber'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'typeLabel': typeLabel,
      'startDate': startDate,
      'endDate': endDate,
      'companyName': companyName,
      'policyNumber': policyNumber,
    };
  }

  SettingsInsurance toEntity() {
    return SettingsInsurance(
      typeLabel: typeLabel ?? '',
      startDate: startDate ?? '',
      endDate: endDate ?? '',
      companyName: companyName ?? '',
      policyNumber: policyNumber ?? '',
    );
  }
}
