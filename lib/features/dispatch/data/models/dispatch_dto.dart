import 'package:consignment/features/dispatch/domain/entities/dispatch.dart';

/// 서버(또는 DB)에서 내려오는 dispatch row 에 대응하는 DTO
class DispatchDto {
  final int id;
  final bool active;
  final String callType;
  final int charge;
  final String clientPhoneNumber;
  final String createdAt; // ISO date string
  final String destinationLocation;
  final int officeId;
  final String service;
  final String startLocation;
  final String status;
  final int? transporterId;

  const DispatchDto({
    required this.id,
    required this.active,
    required this.callType,
    required this.charge,
    required this.clientPhoneNumber,
    required this.createdAt,
    required this.destinationLocation,
    required this.officeId,
    required this.service,
    required this.startLocation,
    required this.status,
    required this.transporterId,
  });

  factory DispatchDto.fromJson(Map<String, dynamic> json) {
    return DispatchDto(
      id: json['id'] as int,
      active: json['active'] as bool,
      callType: json['call_type'] as String,
      charge: json['charge'] as int,
      clientPhoneNumber: json['client_phone_number'] as String,
      createdAt: json['created_at'] as String,
      destinationLocation: json['destination_location'] as String,
      officeId: json['office_id'] as int,
      service: json['service'] as String,
      startLocation: json['start_location'] as String,
      status: json['status'] as String,
      transporterId: json['transporter_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'active': active,
    'call_type': callType,
    'charge': charge,
    'client_phone_number': clientPhoneNumber,
    'created_at': createdAt,
    'destination_location': destinationLocation,
    'office_id': officeId,
    'service': service,
    'start_location': startLocation,
    'status': status,
    'transporter_id': transporterId,
  };

  /// DTO -> 도메인 엔티티 변환
  Dispatch toEntity() {
    return Dispatch(
      id: id,
      active: active,
      callType: DispatchCallType.integrated, // 지금은 하나라 고정
      charge: charge,
      clientPhoneNumber: clientPhoneNumber,
      createdAt: DateTime.parse(createdAt),
      destinationLocation: destinationLocation,
      officeId: officeId,
      service: DispatchService.driver,
      startLocation: startLocation,
      status: DispatchStatus.fromCode(status),
      transporterId: transporterId,
    );
  }

  /// 테스트용 mock 데이터
  factory DispatchDto.mock() {
    return DispatchDto(
      id: 11,
      active: true,
      callType: 'INTEGRATED',
      charge: 40000,
      clientPhoneNumber: '010-7777-8888',
      createdAt: '2025-11-13 11:00:00.000000',
      destinationLocation: '서울시 금천구 가산동 444',
      officeId: 1,
      service: 'DRIVER',
      startLocation: '인천시 연수구 송도동 333',
      status: 'ASSIGNED',
      transporterId: null,
    );
  }
}
