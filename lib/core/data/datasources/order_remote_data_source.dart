import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:consignment/core/data/models/order_call_dto.dart';
import 'package:consignment/core/data/network/api_client.dart';
import 'package:consignment/core/data/network/api_exception.dart';
import 'package:consignment/src/components/app_toast.dart';

abstract class OrderRemoteDataSource {
  Future<List<OrderCallDto>> fetchOrderCalls({
    required BuildContext context,
    List<String>? status,
  });

  Future<Map<String, dynamic>> assignDispatch({
    required BuildContext context,
    required int dispatchId,
    int? transporterId,
  });
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final ApiClient _api;

  /// status 원인 분리용: status 없이 먼저 한 번 호출해보는 probe
  final bool enableNoStatusProbe;

  /// ApiClient interceptor 토스트 로깅 활성화
  final bool debugToast;

  const OrderRemoteDataSourceImpl(
      this._api, {
        this.enableNoStatusProbe = true,
        this.debugToast = true,
      });

  static const String _listPath = '/api/v1/transporter/dispatch-list';
  static const String _assignPathBase = '/api/v1/transporter/dispatch-assign';

  @override
  Future<List<OrderCallDto>> fetchOrderCalls({
    required BuildContext context,
    List<String>? status,
  }) async {
    final query = <String, dynamic>{};
    if (status != null && status.isNotEmpty) {
      query['status'] = status; // ?status=OPEN&status=ASSIGNED
    }

    if (enableNoStatusProbe && (status != null && status.isNotEmpty)) {
      await _probeWithoutStatus(context);
    }

    try {
      final res = await _api.get(
        _listPath,
        queryParameters: query.isEmpty ? null : query,
        toastContext: context,
        debugTag: 'dispatch-list(main)',
        debugToast: debugToast,
      );

      final body = res.data;

      AppToast.show(context, 'dispatch-list(main) 응답 타입: ${body.runtimeType}');
      AppToast.show(context, 'dispatch-list(main) 응답 일부: ${_short(body)}');

      if (body is! Map<String, dynamic>) {
        throw const ApiException(message: '서버 응답 형식이 Map이 아닙니다.');
      }

      final dynamic data1 = body['data'];
      final dynamic data2 =
      (body['result'] is Map) ? (body['result'] as Map)['content'] : null;

      final dynamic list = (data1 is List) ? data1 : (data2 is List ? data2 : null);

      if (list is! List) {
        AppToast.show(
          context,
          '파싱 실패: data=${data1.runtimeType}, result.content=${data2.runtimeType}',
        );
        throw const ApiException(message: '배차 리스트 데이터(List)를 찾지 못했습니다.');
      }

      return list
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .map(OrderCallDto.fromJson)
          .toList();
    } catch (e) {
      AppToast.show(context, 'dispatch-list(main) 호출 실패: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> assignDispatch({
    required BuildContext context,
    required int dispatchId,
    int? transporterId,
  }) async {
    final path = '$_assignPathBase/$dispatchId';

    final query = <String, dynamic>{};
    if (transporterId != null) {
      // Swagger에 transporter object가 뜨지만, 실무적으로는 transporterId로 받는 경우가 대부분
      query['transporterId'] = transporterId;
    }

    try {
      final res = await _api.patch(
        path,
        queryParameters: query.isEmpty ? null : query,
        data: null, // 바디 없는 PATCH (서버가 바디 요구하면 여기 조정)
        toastContext: context,
        debugTag: 'dispatch-assign',
        debugToast: debugToast,
      );

      final body = res.data;

      AppToast.show(context, 'dispatch-assign 응답 타입: ${body.runtimeType}');
      AppToast.show(context, 'dispatch-assign 응답 일부: ${_short(body)}');

      if (body is! Map<String, dynamic>) {
        throw const ApiException(message: '배차할당 응답 형식이 Map이 아닙니다.');
      }

      final data = body['data'];
      if (data is! Map) {
        throw const ApiException(message: '배차할당 응답 data가 Map이 아닙니다.');
      }

      return Map<String, dynamic>.from(data as Map);
    } on ApiException {
      rethrow;
    } catch (e) {
      AppToast.show(context, 'dispatch-assign 호출 실패: $e');
      rethrow;
    }
  }

  Future<void> _probeWithoutStatus(BuildContext context) async {
    try {
      AppToast.show(context, '[probe] status 없이 1회 호출로 원인 분리 시작');

      final res = await _api.get(
        _listPath,
        toastContext: context,
        debugTag: 'dispatch-list(probe-no-status)',
        debugToast: debugToast,
      );

      final body = res.data;
      AppToast.show(context, '[probe] 성공. 응답 타입: ${body.runtimeType}');
      AppToast.show(context, '[probe] 응답 일부: ${_short(body)}');
    } catch (e) {
      AppToast.show(context, '[probe] 실패: $e', duration: const Duration(seconds: 5));
    }
  }

  String _short(dynamic v) {
    try {
      final s = jsonEncode(v);
      if (s.length <= 250) return s;
      return '${s.substring(0, 250)}...';
    } catch (_) {
      final s = v.toString();
      if (s.length <= 250) return s;
      return '${s.substring(0, 250)}...';
    }
  }
}
