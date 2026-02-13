import 'package:flutter/material.dart';
import 'package:consignment/core/data/domain/dispatch_assign_result.dart';
import 'package:consignment/core/data/domain/order_call.dart';
import 'package:consignment/core/data/repositories/order_repository.dart';
import 'package:consignment/src/components/app_toast.dart';

class OrderDetailViewModel extends ChangeNotifier {
  final OrderRepository _repository;

  bool _isLoading = false;
  String? _errorMessage;
  DispatchAssignResult? _assignResult;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DispatchAssignResult? get assignResult => _assignResult;

  OrderDetailViewModel({
    required OrderRepository repository,
  }) : _repository = repository;

  Future<bool> assignDispatch({
    required BuildContext context,
    required OrderCall call,
    int? transporterId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _assignResult = null;
    notifyListeners();

    try {
      final int dispatchId = call.id;

      final result = await _repository.assignDispatch(
        context: context,
        dispatchId: dispatchId,
        transporterId: transporterId,
      );

      _assignResult = result;

      AppToast.show(
        context,
        '배차 완료 (dispatcherId=${result.dispatcherId}, transporterId=${result.transporterId})',
      );

      debugPrint("배차 완료 : dispatcherId=${result.dispatcherId}, transporterId=${result.transporterId}");
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint("배차 실패 : $_errorMessage");
      AppToast.show(context, '배차 실패: $_errorMessage', duration: const Duration(seconds: 4));
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
