import 'package:consignment/core/data/domain/dispatch.dart';

class DispatchDto {
  final int id;
  final String status;
  final int charge;
  final String startLocation;
  final String destinationLocation;
  final String clientPhoneNumber;
  final String memo;
  final String call;
  final String service;
  final String paymentMethod;
  final String tollType;
  final int officeId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime assignedAt;

  const DispatchDto({
    required this.id,
    required this.status,
    required this.charge,
    required this.startLocation,
    required this.destinationLocation,
    required this.clientPhoneNumber,
    required this.memo,
    required this.call,
    required this.service,
    required this.paymentMethod,
    required this.tollType,
    required this.officeId,
    required this.createdAt,
    required this.updatedAt,
    required this.assignedAt,
  });

  factory DispatchDto.fromJson(Map<String, dynamic> json) {
    return DispatchDto(
      id: json['id'] as int,
      status: (json['status'] as String?) ?? '',
      charge: (json['charge'] as num?)?.toInt() ?? 0,
      startLocation: (json['startLocation'] as String?) ?? '',
      destinationLocation: (json['destinationLocation'] as String?) ?? '',
      clientPhoneNumber: (json['clientPhoneNumber'] as String?) ?? '',
      memo: (json['memo'] as String?) ?? '',
      call: (json['call'] as String?) ?? '',
      service: (json['service'] as String?) ?? '',
      paymentMethod: (json['paymentMethod'] as String?) ?? '',
      tollType: (json['tollType'] as String?) ?? '',
      officeId: (json['officeId'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      assignedAt: DateTime.parse(json['assignedAt'] as String),
    );
  }

  /// ✅ DTO -> Entity (Dispatch) 변환을 DTO 내부에 둔다
  Dispatch toEntity() {
    return Dispatch(
      id: id,
      active: true, // current-dispatch는 "현재 배차중" 개념이므로 true로 둠
      callType: _mapCallType(call),
      charge: charge,
      clientPhoneNumber: clientPhoneNumber,
      createdAt: createdAt,
      destinationLocation: destinationLocation,
      officeId: officeId,
      service: _mapService(service),
      startLocation: startLocation,
      status: DispatchStatus.fromCode(status),
      transporterId: null, // current-dispatch 응답에 없으니 null
    );
  }

  DispatchCallType _mapCallType(String v) {
    // Swagger 예: INTERNAL
    switch (v.toUpperCase()) {
      case 'INTERNAL':
      case 'INTEGRATED':
        return DispatchCallType.integrated;
      default:
        return DispatchCallType.integrated;
    }
  }

  DispatchService _mapService(String v) {
    // Swagger 예: DELIVERY
    // 네 enum에는 driver만 있으니 일단 driver로 매핑
    switch (v.toUpperCase()) {
      case 'DELIVERY':
      case 'DRIVER':
        return DispatchService.driver;
      default:
        return DispatchService.driver;
    }
  }

  static DispatchDto mock() {
    return DispatchDto(
      id: 1,
      status: 'ASSIGNED',
      charge: 75000,
      startLocation: '신사동 그린파크 아파트',
      destinationLocation: '신사동 504-11',
      clientPhoneNumber: '010-1234-5678',
      memo: '학교 비밀번호 1234',
      call: 'INTERNAL',
      service: 'DELIVERY',
      paymentMethod: 'CASH',
      tollType: 'HIPASS',
      officeId: 1,
      createdAt: DateTime.parse('2024-01-15T10:00:00'),
      updatedAt: DateTime.parse('2024-01-15T10:00:00'),
      assignedAt: DateTime.parse('2024-01-15T10:05:00'),
    );
  }

}
