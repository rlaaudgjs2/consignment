import 'package:flutter/material.dart';
import 'package:consignment/core/data/domain/order_call.dart';
import 'package:consignment/core/data/repositories/order_repository_impl.dart';

class OrderViewModel extends ChangeNotifier {
  final OrderRepositoryImpl _repository;

  OrderViewModel({
    required OrderRepositoryImpl repository,
  }) : _repository = repository;

  // ---------- 거리 필터 상태 ----------
  final List<int> distanceOptions = const [1, 5, 10, 20, 50, 100];

  int _selectedDistance = 50;
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
    loadOrderCalls(); // 거리 바뀌면 목록 재조회
  }

  // ---------- 오더 리스트 상태 ----------
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
    // TODO: 현재 위치 설정
    debugPrint('현재 위치 설정하기 클릭');
  }

  Future<void> onTapDispatch(OrderCall call) async {
    // TODO: 배차 API 호출
    debugPrint('배차 요청: ${call.startAddress} → ${call.endAddress}');
    _selectedCall = null;
    notifyListeners();
  }

  // ---------- 데이터 로딩 ----------
  Future<void> loadOrderCalls() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.getOrderCalls(
        maxDistanceKm: _selectedDistance,
      );
      _calls = result;
    } catch (e) {
      _errorMessage = '오더를 불러올 수 없습니다.';
      _calls = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
