import 'package:flutter/material.dart';

import 'package:consignment/core/data/domain/dispatch.dart';
import 'package:consignment/core/data/network/api_exception.dart';
import 'package:consignment/core/data/repositories/dispatch_repository_impl.dart';
import 'package:consignment/src/components/app_toast.dart';

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

  Future<void> loadCurrentDispatch(BuildContext context) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _dispatch = await _repository.getCurrentDispatch(
        toastContext: context,
        debugToast: true,
      );
    } on ApiException catch (e) {
      _errorMessage =
      '배차 정보를 불러오지 못했습니다. (HTTP: ${e.httpStatus ?? '-'})\n${e.message}';
    } catch (e) {
      _errorMessage = '배차 정보를 불러오지 못했습니다.\n$e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void onTapNavi(BuildContext context) {
    // TODO: 내비 연동
    AppToast.show(context, '내비연동은 추후 구현 예정입니다.');
  }

  Future<void> onTapComplete(BuildContext context) async {
    final d = _dispatch;
    if (d == null) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.completeDispatch(
        dispatchId: d.id,
        toastContext: context,
        debugToast: true,
      );

      AppToast.show(context, '배차 완료 처리되었습니다.');
      // ✅ 완료 후 현재 배차 다시 조회 (없으면 null → "배차 없음" 화면)
      _dispatch = await _repository.getCurrentDispatch(
        toastContext: context,
        debugToast: true,
      );
    } on ApiException catch (e) {
      _errorMessage =
      '배차 완료 처리 실패 (HTTP: ${e.httpStatus ?? '-'})\n${e.message}';
    } catch (e) {
      _errorMessage = '배차 완료 처리 실패\n$e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> onTapCancelDispatch(BuildContext context) async {
    final d = _dispatch;
    if (d == null) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.cancelDispatch(
        dispatchId: d.id,
        toastContext: context,
        debugToast: true,
      );

      AppToast.show(context, '배차 취소 처리되었습니다.');
      // ✅ 취소 후 현재 배차 다시 조회
      _dispatch = await _repository.getCurrentDispatch(
        toastContext: context,
        debugToast: true,
      );
    } on ApiException catch (e) {
      _errorMessage =
      '배차 취소 처리 실패 (HTTP: ${e.httpStatus ?? '-'})\n${e.message}';
    } catch (e) {
      _errorMessage = '배차 취소 처리 실패\n$e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
