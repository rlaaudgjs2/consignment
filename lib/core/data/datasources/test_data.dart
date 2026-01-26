import 'package:consignment/core/data/domain/order_call.dart';
import 'package:consignment/core/data/models/driving_history_dto.dart';
import 'package:consignment/core/data/models/driving_history_detail_dto.dart';
import 'package:consignment/core/data/models/order_call_dto.dart';
import 'package:consignment/core/data/models/settings_my_info_dto.dart';
import 'package:consignment/core/data/models/settings_notice_dto.dart';
import 'package:consignment/core/data/models/settlement_daily_summary_dto.dart';
import 'package:consignment/core/data/models/settlement_transaction_dto.dart';
import 'package:consignment/core/data/models/settlement_transaction_detail_dto.dart';
import 'package:consignment/core/data/models/settlement_wallet_dto.dart';
import 'package:consignment/core/data/models/dispatch_dto.dart';
import 'package:consignment/core/data/models/settlement_withdraw_info_dto.dart';
import 'package:consignment/core/data/models/settlement_withdraw_session_dto.dart';
import 'package:consignment/core/data/models/settlement_withdraw_submit_result_dto.dart';
import 'package:consignment/core/data/models/settlement_withdraw_sms_result_dto.dart';

class TestData {
  const TestData._();

  // -------------------------
  // Complete
  // -------------------------
  static const List<DrivingHistoryDto> drivingHistoryList = <DrivingHistoryDto>[
    DrivingHistoryDto(
      id: 'SALM251124',
      startedAtIso: '2025-11-22T14:15:00',
      startAddress: '부안상서면부장1길 23',
      endAddress: '수원평동, 임광모터스',
      price: 110000,
    ),
    DrivingHistoryDto(
      id: 'SALM251125',
      startedAtIso: '2025-11-22T18:00:00',
      startAddress: '광화문 그레이힐스오피스텔',
      endAddress: '종로구 890-12',
      price: 65000,
    ),
    DrivingHistoryDto(
      id: 'SALM251126',
      startedAtIso: '2025-11-22T13:10:00',
      startAddress: '홍대입구 에코타운 주택',
      endAddress: '송파동 345-67',
      price: 120000,
    ),
    DrivingHistoryDto(
      id: 'SALM251127',
      startedAtIso: '2025-11-22T19:20:00',
      startAddress: '서초동 퍼플힐스오피스텔',
      endAddress: '삼성동 789-01',
      price: 80000,
    ),
  ];

  static const Map<String, DrivingHistoryDetailDto> drivingHistoryDetailMap =
  <String, DrivingHistoryDetailDto>{
    'SALM251124': DrivingHistoryDetailDto(
      id: 'SALM251124',
      orderType: OrderType.consign,
      tags: <String>['즉후', '경유', '하이패스'],
      clientName: '태) (주)대리GO',
      situationRoom: '16887141',
      startAddress: '부안상서면부장1길 23',
      endAddress: '수원평동, 임광모터스',
      fareWon: 110000,
      fareTypeText: '완)후불',
      orderNo: 'SALM251124',
      receivedAtText: '11:43',
      dispatchedAtText: '11:48',
      completedAtText: '15:19',
      carModel: '소나타',
      carNumber: '123가 1234',
    ),
    'SALM251125': DrivingHistoryDetailDto(
      id: 'SALM251125',
      orderType: OrderType.consign,
      tags: <String>['즉후'],
      clientName: '(주)예시발주처',
      situationRoom: '00000000',
      startAddress: '광화문 그레이힐스오피스텔',
      endAddress: '종로구 890-12',
      fareWon: 65000,
      fareTypeText: '완)후불',
      orderNo: 'SALM251125',
      receivedAtText: '18:01',
      dispatchedAtText: '18:05',
      completedAtText: '18:45',
      carModel: '그랜저',
      carNumber: '11가 1111',
    ),
    'SALM251126': DrivingHistoryDetailDto(
      id: 'SALM251126',
      orderType: OrderType.proxy,
      tags: <String>['경유'],
      clientName: '(주)예시발주처',
      situationRoom: '00000000',
      startAddress: '홍대입구 에코타운 주택',
      endAddress: '송파동 345-67',
      fareWon: 120000,
      fareTypeText: '완)후불',
      orderNo: 'SALM251126',
      receivedAtText: '13:11',
      dispatchedAtText: '13:14',
      completedAtText: '14:10',
      carModel: 'K5',
      carNumber: '22나 2222',
    ),
    'SALM251127': DrivingHistoryDetailDto(
      id: 'SALM251127',
      orderType: OrderType.consign,
      tags: <String>['하이패스'],
      clientName: '(주)예시발주처',
      situationRoom: '00000000',
      startAddress: '서초동 퍼플힐스오피스텔',
      endAddress: '삼성동 789-01',
      fareWon: 80000,
      fareTypeText: '완)후불',
      orderNo: 'SALM251127',
      receivedAtText: '19:21',
      dispatchedAtText: '19:25',
      completedAtText: '20:05',
      carModel: '아반떼',
      carNumber: '33다 3333',
    ),
  };

  static DrivingHistoryDetailDto emptyDrivingHistoryDetail(String id) {
    return DrivingHistoryDetailDto(
      id: id,
      orderType: OrderType.consign,
      tags: const <String>[],
      clientName: '-',
      situationRoom: '-',
      startAddress: '-',
      endAddress: '-',
      fareWon: 0,
      fareTypeText: '-',
      orderNo: id,
      receivedAtText: '-',
      dispatchedAtText: '-',
      completedAtText: '-',
      carModel: '-',
      carNumber: '-',
    );
  }

  // -------------------------
  // Dispatch
  // -------------------------
  static DispatchDto dispatchMock() => DispatchDto.mock();

  // -------------------------
  // Order (Dispatch List)
  // -------------------------
  /// dispatch-list API 응답 스키마에 맞춘 목데이터
  /// - serviceType: DELIVERY(탁송), DRIVER(대리)
  /// - status: OPEN/ASSIGNED/COMPLETED/CANCELED
  static List<OrderCallDto> orderCallsMock() {
    return <OrderCallDto>[
      const OrderCallDto(
        id: 1,
        serviceType: 'DELIVERY',
        charge: 90000,
        startLocation: '강남구 456-78',
        destinationLocation: '서초동 123-45',
        status: 'OPEN',
        distanceKm: 4.5,
        tags: <String>['카드', '하이패스'],
      ),
      const OrderCallDto(
        id: 2,
        serviceType: 'DELIVERY',
        charge: 80000,
        startLocation: '서초동 그랜드오피스텔',
        destinationLocation: '강남구 789-01',
        status: 'ASSIGNED',
        distanceKm: 6.0,
        tags: <String>['즉후', '경유', '톨별'],
      ),
      const OrderCallDto(
        id: 3,
        serviceType: 'DRIVER',
        charge: 100000,
        startLocation: '여의도 리버뷰 오피스텔',
        destinationLocation: '송파구 올림픽로 789',
        status: 'OPEN',
        distanceKm: 7.1,
        tags: <String>['현금', '톨포'],
      ),
    ];
  }

  // -------------------------
  // Settings
  // -------------------------
  static Future<SettingsMyInfoDto> myInfoMock() async {
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

  static const List<SettingsNoticeDto> noticesMock = <SettingsNoticeDto>[
    SettingsNoticeDto(
      title: '시스템 점검 안내',
      date: '2025-12-27',
      body: '시스템 점검이 예정되어 있습니다.\n점검 시간 동안 일부 기능이 제한될 수 있습니다.',
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

  // -------------------------
  // Settlement
  // -------------------------
  static const SettlementDailySummaryDto dailySummaryMock = SettlementDailySummaryDto(
    callCount: 4,
    drivingFee: 360000,
    commissionFee: 72000,
    etcDeduction: 360109,
    totalDeposit: 408804,
    totalIncome: -72109,
  );

  static const List<SettlementTransactionDto> transactionsMock = <SettlementTransactionDto>[
    SettlementTransactionDto(
      id: 'tx_20251109_0',
      date: '2025-11-09',
      amount: -8400,
      balance: 55414,
      description: '특정날자동공제',
    ),
    SettlementTransactionDto(
      id: 'tx_20251108_0',
      date: '2025-11-08',
      amount: -8400,
      balance: 63814,
      description: '특정날자동공제',
    ),
    SettlementTransactionDto(
      id: 'tx_20251107_0',
      date: '2025-11-07',
      amount: -8400,
      balance: 72214,
      description: '특정날자동공제',
    ),
    SettlementTransactionDto(
      id: 'tx_20251106_0',
      date: '2025-11-06',
      amount: 20000,
      balance: 80614,
      description: '타사입금',
    ),
    SettlementTransactionDto(
      id: 'tx_20251105_0',
      date: '2025-11-05',
      amount: -8400,
      balance: 60614,
      description: '특정날자동공제',
    ),
    SettlementTransactionDto(
      id: 'tx_20251104_0',
      date: '2025-11-04',
      amount: -459,
      balance: 69041,
      description: '산재보험',
    ),
    SettlementTransactionDto(
      id: 'tx_20251104_1',
      date: '2025-11-04',
      amount: -394,
      balance: 69473,
      description: '고용보험',
    ),
    SettlementTransactionDto(
      id: 'tx_20251106_1',
      date: '2025-11-06',
      amount: 28804,
      balance: 69867,
      description: '타사입금',
    ),
  ];

  static SettlementTransactionDetailDto transactionDetailMock(String id) {
    if (id == 'tx_fee_SALM251124') {
      return const SettlementTransactionDetailDto(
        id: 'tx_fee_SALM251124',
        type: 'drivingFee',
        dateTimeText: '2025-11-24 11:48:55',
        titleText: '운행수수료',
        amountWon: -22000,
        balanceWon: 0,
        orderTypeText: '탁송',
        tags: <String>['즉후', '경유', '하이패스'],
        orderNo: 'SALM251124',
        startAddress: '부안상서면부장1길11',
        endAddress: '수원평동, 임광모터스',
        fareWon: 110000,
        noteText: null,
      );
    }

    return SettlementTransactionDetailDto(
      id: id,
      type: 'etc',
      dateTimeText: '2025-11-24 11:48:55',
      titleText: '특정일자자동공제',
      amountWon: -8400,
      balanceWon: 0,
      orderTypeText: null,
      tags: const <String>[],
      orderNo: null,
      startAddress: null,
      endAddress: null,
      fareWon: null,
      noteText: '보험료',
    );
  }

  static const SettlementWalletDto walletMock = SettlementWalletDto(
    currentBalance: 55414,
  );

  static SettlementWithdrawInfoDto withdrawInfoMock() {
    return SettlementWithdrawInfoDto(
      availableAmount: 50000,
      bankName: '카카오뱅크',
      maskedAccountNumber: '333318715****',
      depositorName: '김규원',
      unitAmount: 10000,
      feeAmount: 300,
    );
  }

  static SettlementWithdrawSessionDto withdrawSessionMock(int amount) {
    return SettlementWithdrawSessionDto(
      sessionId: 'sess_${DateTime.now().millisecondsSinceEpoch}',
      bankName: '카카오뱅크',
      accountNumber: '3333187153307',
      depositorName: '김규원',
      amount: amount,
    );
  }

  static SettlementWithdrawSmsResultDto withdrawSmsMock(String phoneNumber) {
    final normalized = phoneNumber.replaceAll('-', '').trim();
    if (normalized.length < 10) {
      return const SettlementWithdrawSmsResultDto(
        success: false,
        message: '전화번호를 확인해주세요.',
        smsFeeAmount: 20,
      );
    }
    return const SettlementWithdrawSmsResultDto(
      success: true,
      message: 'SMS 인증번호를 발송했습니다.',
      smsFeeAmount: 20,
    );
  }

  static SettlementWithdrawSubmitResultDto withdrawSubmitMock(String code) {
    if (code.trim().length < 4) {
      return const SettlementWithdrawSubmitResultDto(
        success: false,
        message: '인증번호를 확인해주세요.',
        receiptId: null,
      );
    }
    return SettlementWithdrawSubmitResultDto(
      success: true,
      message: '출금 요청이 접수되었습니다.',
      receiptId: 'rcpt_${DateTime.now().millisecondsSinceEpoch}',
    );
  }
}
