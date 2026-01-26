import 'package:flutter/material.dart';

import 'package:consignment/core/data/domain/order_call.dart';
import 'package:consignment/core/data/repositories/order_repository.dart';
import 'package:consignment/core/data/network/api_exception.dart';

class OrderViewModel extends ChangeNotifier {
  final OrderRepository _repository;

  OrderViewModel({
    required OrderRepository repository,
  }) : _repository = repository;

  // ---------- 거리 필터 상태 ----------
  final List<int> distanceOptions = const [1, 5, 10, 20, 50, 100, 200];

  int _selectedDistance = 200;
  int get selectedDistance => _selectedDistance;

  bool _isDistanceDropdownOpen = false;
  bool get isDistanceDropdownOpen => _isDistanceDropdownOpen;

  String get distanceLabel => '$_selectedDistance km 이내';

  void setDistanceDropdownOpen(bool isOpen) {
    _isDistanceDropdownOpen = isOpen;
    notifyListeners();
  }

  void selectDistance(int km) {
    _selectedDistance = km;
    notifyListeners();
    _applyDistanceFilter();
  }

  // ---------- 오더 리스트 상태 ----------
  List<OrderCall> _allCalls = [];
  List<OrderCall> _calls = [];

  List<OrderCall> get calls => _calls;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // ---------- 상세 모드 상태 ----------
  OrderCall? _selectedCall;
  OrderCall? get selectedCall => _selectedCall;

  bool get isDetailMode => _selectedCall != null;

  void selectCall(OrderCall call) {
    _selectedCall = call;
    notifyListeners();
  }

  void cancelDetail() {
    _selectedCall = null;
    notifyListeners();
  }

  // ---------- 액션들 ----------
  void onTapLocation() {
    debugPrint('현재 위치 설정하기 클릭');
  }

  Future<void> onTapDispatch(OrderCall call) async {
    debugPrint('배차 요청: ${call.startLocation} → ${call.destinationLocation}');
    _selectedCall = null;
    notifyListeners();
  }

  // ---------- 데이터 로딩 ----------
  Future<void> loadOrderCalls(BuildContext context) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.getOrderCalls(context: context);

      _allCalls = result;
      _applyDistanceFilter();

      // 성공 시 오류 메시지 제거
      _errorMessage = null;
      notifyListeners();
    } on ApiException catch (e) {
      // ✅ 화면에 그대로 보여줄 메시지 구성
      _errorMessage = _buildUiErrorMessage(e);

      _allCalls = [];
      _calls = [];
      notifyListeners();
    } catch (e) {
      _errorMessage = '요청이 실패했습니다.\n(${e.toString()})';
      _allCalls = [];
      _calls = [];
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _buildUiErrorMessage(ApiException e) {
    // 사용자에게 보여줄 최소 메시지
    final http = e.httpStatus;
    final base = (http != null)
        ? '요청이 실패했습니다. (HTTP $http)'
        : '요청이 실패했습니다.';

    // 디버그 정보(필요하면 유지, 아니면 주석/삭제)
    final detail = <String>[
      if (e.method != null || e.path != null)
        'REQ: ${e.method ?? '-'} ${e.path ?? '-'}',
      if (e.appStatusCode != null) 'APP_CODE: ${e.appStatusCode}',
      if (e.message.isNotEmpty) 'MSG: ${e.message}',
      if (e.raw != null) 'RAW: ${e.raw}',
    ].join('\n');

    // 화면에는 위에서부터 “한 줄 요약 + 상세” 형태로 노출
    return detail.isEmpty ? base : '$base\n\n$detail';
  }

  void _applyDistanceFilter() {
    final maxKm = _selectedDistance.toDouble();
    _calls = _allCalls.where((c) => c.distanceKm <= maxKm).toList(growable: false);
    notifyListeners();
  }
}
