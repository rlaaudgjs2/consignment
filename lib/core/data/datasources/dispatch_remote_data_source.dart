import 'package:consignment/core/data/models/dispatch_cancel_result_dto.dart';
import 'package:consignment/core/data/models/dispatch_complete_result_dto.dart';
import 'package:consignment/core/data/models/dispatch_dto.dart';
import 'package:consignment/core/data/network/api_client.dart';
import 'package:consignment/core/data/network/api_exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

abstract class DispatchRemoteDataSource {
  Future<DispatchDto?> fetchCurrentDispatch({
    BuildContext? toastContext,
    bool debugToast = false,
  });

  Future<DispatchCompleteResultDto> completeDispatch({
    required int dispatchId,
    BuildContext? toastContext,
    bool debugToast = false,
  });

  Future<DispatchCancelResultDto> cancelDispatch({
    required int dispatchId,
    BuildContext? toastContext,
    bool debugToast = false,
  });
}

class DispatchRemoteDataSourceImpl implements DispatchRemoteDataSource {
  final ApiClient _client;

  DispatchRemoteDataSourceImpl(this._client);

  @override
  Future<DispatchDto?> fetchCurrentDispatch({
    BuildContext? toastContext,
    bool debugToast = false,
  }) async {
    try {
      final Response res = await _client.get(
        '/api/v1/transporter/current-dispatch',
        toastContext: toastContext,
        debugToast: debugToast,
        debugTag: 'current-dispatch',
      );

      final dataMap = _extractDataMap(res.data);
      if (dataMap == null) return null;

      return DispatchDto.fromJson(dataMap);
    } on ApiException catch (e) {
      // ✅ 배차 없음은 null 처리 (Swagger: 404 DISPATCH_NOT_ASSIGNED)
      if (e.httpStatus == 404) return null;
      rethrow;
    }
  }

  @override
  Future<DispatchCompleteResultDto> completeDispatch({
    required int dispatchId,
    BuildContext? toastContext,
    bool debugToast = false,
  }) async {
    final Response res = await _client.patch(
      '/api/v1/transporter/dispatch-complete/$dispatchId',
      toastContext: toastContext,
      debugToast: debugToast,
      debugTag: 'dispatch-complete',
    );

    final dataMap = _extractDataMap(res.data) ?? <String, dynamic>{};
    return DispatchCompleteResultDto.fromJson(dataMap);
  }

  @override
  Future<DispatchCancelResultDto> cancelDispatch({
    required int dispatchId,
    BuildContext? toastContext,
    bool debugToast = false,
  }) async {
    final Response res = await _client.patch(
      '/api/v1/transporter/dispatch-cancel/$dispatchId',
      toastContext: toastContext,
      debugToast: debugToast,
      debugTag: 'dispatch-cancel',
    );

    final dataMap = _extractDataMap(res.data) ?? <String, dynamic>{};
    return DispatchCancelResultDto.fromJson(dataMap);
  }

  /// 서버 공통 응답:
  /// { "statusCode": 0, "message": "...", "data": { ... } }
  Map<String, dynamic>? _extractDataMap(dynamic raw) {
    if (raw is Map<String, dynamic>) {
      final d = raw['data'];
      if (d is Map<String, dynamic>) return d;
    }
    return null;
  }
}
