import 'package:flutter/material.dart';
import 'package:consignment/core/data/dispatch/domain/dispatch.dart';
import 'package:consignment/core/data/dispatch/repositories/dispatch_repository_impl.dart';

class DispatchViewModel extends ChangeNotifier {
  final DispatchRepositoryImpl _repository;

  DispatchViewModel({
    required DispatchRepositoryImpl repository,
  }) : _repository = repository;

  Dispatch? _dispatch;
  Dispatch? get dispatch => _dispatch;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> loadCurrentDispatch() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _dispatch = await _repository.getCurrentDispatch();
    } catch (e) {
      _errorMessage = '배차 정보를 불러오지 못했습니다.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void onTapNavi() {
    // TODO: 내비 연동
  }

  void onTapComplete() {
    // TODO: 배차 완료 API
  }

  void onTapCancelDispatch() {
    // TODO: 배차 취소 API
  }
}
