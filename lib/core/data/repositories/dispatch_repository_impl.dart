import 'package:flutter/material.dart';

import 'package:consignment/core/data/datasources/dispatch_remote_data_source.dart';
import 'package:consignment/core/data/domain/dispatch.dart';
import 'package:consignment/core/data/models/dispatch_cancel_result_dto.dart';
import 'package:consignment/core/data/models/dispatch_complete_result_dto.dart';

class DispatchRepositoryImpl {
  final DispatchRemoteDataSource remote;

  DispatchRepositoryImpl({required this.remote});

  Future<Dispatch?> getCurrentDispatch({
    BuildContext? toastContext,
    bool debugToast = false,
  }) async {
    final dto = await remote.fetchCurrentDispatch(
      toastContext: toastContext,
      debugToast: debugToast,
    );
    if (dto == null) return null;
    return dto.toEntity(); // ✅ dto 안에 toEntity() 넣어놨음
  }

  Future<DispatchCompleteResultDto> completeDispatch({
    required int dispatchId,
    BuildContext? toastContext,
    bool debugToast = false,
  }) {
    return remote.completeDispatch(
      dispatchId: dispatchId,
      toastContext: toastContext,
      debugToast: debugToast,
    );
  }

  Future<DispatchCancelResultDto> cancelDispatch({
    required int dispatchId,
    BuildContext? toastContext,
    bool debugToast = false,
  }) {
    return remote.cancelDispatch(
      dispatchId: dispatchId,
      toastContext: toastContext,
      debugToast: debugToast,
    );
  }
}
