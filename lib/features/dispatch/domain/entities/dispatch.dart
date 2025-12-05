import 'package:flutter/foundation.dart';

/// call_type: 'INTEGRATED' 같은 값
enum DispatchCallType {
  integrated, // 통합 콜 (탁송/대리 통합 등)
  // 필요해지면 여기에 케이스 추가 (e.g. consign, proxy ...)
}

/// service: 'DRIVER' 같은 값
enum DispatchService {
  driver, // 기사 서비스
  // 추후 필요 시 추가
}

/// status: 'OPEN', 'ASSIGNED', 'ONGOING', 'DONE' 등으로 확장 예정
enum DispatchStatus {
  open,      // 콜은 열려 있지만 아직 배차 X
  assigned,  // 배차 완료 (기사에게 할당됨)
  ongoing,   // 기사 진행중
  done,      // 완료
  cancelled; // 취소

  /// DB 문자열 → enum 변환 헬퍼
  static DispatchStatus fromCode(String code) {
    switch (code.toUpperCase()) {
      case 'OPEN':
        return DispatchStatus.open;
      case 'ASSIGNED':
        return DispatchStatus.assigned;
      case 'ONGOING':
        return DispatchStatus.ongoing;
      case 'DONE':
        return DispatchStatus.done;
      case 'CANCELLED':
        return DispatchStatus.cancelled;
      default:
        return DispatchStatus.open;
    }
  }

  String get code {
    switch (this) {
      case DispatchStatus.open:
        return 'OPEN';
      case DispatchStatus.assigned:
        return 'ASSIGNED';
      case DispatchStatus.ongoing:
        return 'ONGOING';
      case DispatchStatus.done:
        return 'DONE';
      case DispatchStatus.cancelled:
        return 'CANCELLED';
    }
  }
}

/// dispatch 테이블 한 행에 대응하는 엔티티
///
/// INSERT 예시:
/// INSERT INTO public.dispatch
/// (id, active, call_type, charge, client_phone_number, created_at,
///  destination_location, office_id, service, start_location, status, transporter_id)
/// VALUES
/// (11, false, 'INTEGRATED', 40000, '010-7777-8888',
///  '2025-11-13 11:00:00.000000', '서울시 금천구 가산동 444', 1,
///  'DRIVER', '인천시 연수구 송도동 333', 'OPEN', null);
@immutable
class Dispatch {
  final int id;
  final bool active;                // true면 현재 살아있는 dispatch
  final DispatchCallType callType;  // INTEGRATED ...
  final int charge;                 // 요금 (원)
  final String clientPhoneNumber;   // 고객 연락처
  final DateTime createdAt;         // 접수 시간
  final String destinationLocation; // 도착지 주소
  final int officeId;               // 소속 사무실 id
  final DispatchService service;    // DRIVER ...
  final String startLocation;       // 출발지 주소
  final DispatchStatus status;      // OPEN / ASSIGNED ...
  final int? transporterId;         // 배차된 기사 id (없으면 null)

  const Dispatch({
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

  /// 나중에 API 응답(혹은 DB row JSON)을 받을 때 쓸 수 있는 fromJson 예시
  factory Dispatch.fromJson(Map<String, dynamic> json) {
    return Dispatch(
      id: json['id'] as int,
      active: json['active'] as bool,
      callType: _parseCallType(json['call_type'] as String),
      charge: json['charge'] as int,
      clientPhoneNumber: json['client_phone_number'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      destinationLocation: json['destination_location'] as String,
      officeId: json['office_id'] as int,
      service: _parseService(json['service'] as String),
      startLocation: json['start_location'] as String,
      status: DispatchStatus.fromCode(json['status'] as String),
      transporterId: json['transporter_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'active': active,
      'call_type': _callTypeToCode(callType),
      'charge': charge,
      'client_phone_number': clientPhoneNumber,
      'created_at': createdAt.toIso8601String(),
      'destination_location': destinationLocation,
      'office_id': officeId,
      'service': _serviceToCode(service),
      'start_location': startLocation,
      'status': status.code,
      'transporter_id': transporterId,
    };
  }

  /// 지금 백엔드에서 만든 mock row를 그대로 Dart mock으로 옮긴 버전
  ///
  /// UI 작업할 때는 이걸 한 개 들고 있다가,
  /// 나중에 실제 API 붙일 때 여기만 지우고 repository 연동하면 됨.
  factory Dispatch.mock() {
    return Dispatch(
      id: 11,
      active: true,
      callType: DispatchCallType.integrated,
      charge: 40000,
      clientPhoneNumber: '010-7777-8888',
      createdAt: DateTime.parse('2025-11-13 11:00:00.000000'),
      destinationLocation: '서울시 금천구 가산동 444',
      officeId: 1,
      service: DispatchService.driver,
      startLocation: '인천시 연수구 송도동 333',
      status: DispatchStatus.assigned,
      transporterId: null,
    );
  }

  /// 현재 이 dispatch가 "배차중(기사에게 할당되어 진행 중)"인지를 간단히 계산하는 getter
  /// 추후 실제 비즈니스 로직에 맞게 조건만 바꿔주면 됨.
  bool get isOngoing =>
      active && (status == DispatchStatus.assigned || status == DispatchStatus.ongoing);

  // ---- private helpers ----

  static DispatchCallType _parseCallType(String code) {
    switch (code.toUpperCase()) {
      case 'INTEGRATED':
        return DispatchCallType.integrated;
      default:
        return DispatchCallType.integrated;
    }
  }

  static String _callTypeToCode(DispatchCallType type) {
    switch (type) {
      case DispatchCallType.integrated:
        return 'INTEGRATED';
    }
  }

  static DispatchService _parseService(String code) {
    switch (code.toUpperCase()) {
      case 'DRIVER':
        return DispatchService.driver;
      default:
        return DispatchService.driver;
    }
  }

  static String _serviceToCode(DispatchService service) {
    switch (service) {
      case DispatchService.driver:
        return 'DRIVER';
    }
  }
}
