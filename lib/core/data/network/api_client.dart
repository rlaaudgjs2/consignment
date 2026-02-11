import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:consignment/core/data/datasources/token_local_data_source.dart';
import 'package:consignment/src/components/app_toast.dart';
import '../../config/env.dart';
import 'api_exception.dart';

class ApiClient {
  final Dio _dio;
  final TokenLocalDataSource _tokenLocal;

  ApiClient({
    Dio? dio,
    required TokenLocalDataSource tokenLocal,
  })  : _dio = dio ?? Dio(),
        _tokenLocal = tokenLocal {
    _dio.options = BaseOptions(
      baseUrl: Env.apiBaseUrl,
      connectTimeout: Env.connectTimeout,
      receiveTimeout: Env.receiveTimeout,
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // ✅ Authorization 자동 주입
          String? authPreview;
          try {
            final accessToken = await _tokenLocal.readAccessToken();
            final grantType = await _tokenLocal.readGrantType();

            if (accessToken != null &&
                accessToken.isNotEmpty &&
                grantType != null &&
                grantType.isNotEmpty) {
              options.headers['Authorization'] = '$grantType $accessToken';
              authPreview = _maskAuth('$grantType $accessToken');
            }
          } catch (_) {
            // 토큰 읽기 실패해도 요청은 진행
          }

          // ✅ (선택) 실기기 토스트 로깅
          _toastRequestIfEnabled(options, authPreview);

          handler.next(options);
        },
        onResponse: (response, handler) {
          _toastResponseIfEnabled(response);
          handler.next(response);
        },
        onError: (e, handler) {
          _toastErrorIfEnabled(e);
          handler.next(e);
        },
      ),
    );
  }

  Future<Response<dynamic>> get(
      String path, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        BuildContext? toastContext,
        String? debugTag,
        bool debugToast = false,
      }) async {
    try {
      final mergedOptions = _mergeDebugOptions(
        options,
        toastContext: toastContext,
        debugTag: debugTag,
        debugToast: debugToast,
      );

      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: mergedOptions,
      );
    } on DioException catch (e) {
      throw _mapDioException(e, method: 'GET', path: path);
    } catch (_) {
      throw ApiException(
        message: '알 수 없는 네트워크 오류가 발생했습니다.',
        method: 'GET',
        path: path,
      );
    }
  }

  Future<Response<dynamic>> post(
      String path, {
        Object? data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        BuildContext? toastContext,
        String? debugTag,
        bool debugToast = false,
      }) async {
    try {
      final mergedOptions = _mergeDebugOptions(
        options,
        toastContext: toastContext,
        debugTag: debugTag,
        debugToast: debugToast,
      );

      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: mergedOptions,
      );
    } on DioException catch (e) {
      throw _mapDioException(e, method: 'POST', path: path);
    } catch (_) {
      throw ApiException(
        message: '알 수 없는 네트워크 오류가 발생했습니다.',
        method: 'POST',
        path: path,
      );
    }
  }

  Future<Response<dynamic>> patch(
      String path, {
        Object? data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        BuildContext? toastContext,
        String? debugTag,
        bool debugToast = false,
      }) async {
    try {
      final mergedOptions = _mergeDebugOptions(
        options,
        toastContext: toastContext,
        debugTag: debugTag,
        debugToast: debugToast,
      );

      return await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: mergedOptions,
      );
    } on DioException catch (e) {
      throw _mapDioException(e, method: 'PATCH', path: path);
    } catch (_) {
      throw ApiException(
        message: '알 수 없는 네트워크 오류가 발생했습니다.',
        method: 'PATCH',
        path: path,
      );
    }
  }


  Options _mergeDebugOptions(
      Options? base, {
        required BuildContext? toastContext,
        required String? debugTag,
        required bool debugToast,
      }) {
    final extra = <String, dynamic>{...(base?.extra ?? {})};
    if (debugToast && toastContext != null) {
      extra['_debugToast'] = true;
      extra['_toastContext'] = toastContext;
      if (debugTag != null && debugTag.isNotEmpty) {
        extra['_debugTag'] = debugTag;
      }
    }

    return (base ?? Options()).copyWith(extra: extra);
  }

  void _toastRequestIfEnabled(RequestOptions options, String? authPreview) {
    final extra = options.extra;
    final enabled = extra['_debugToast'] == true;
    final ctx = extra['_toastContext'];

    if (!enabled || ctx is! BuildContext) return;

    final tag = (extra['_debugTag'] is String) ? extra['_debugTag'] as String : null;

    final method = options.method;
    final uri = options.uri.toString();
    final authStr = (authPreview != null) ? 'AUTH: $authPreview' : 'AUTH: <none>';

    final msg = '''
${tag != null ? '[$tag] ' : ''}REQ
$method $uri
$authStr
'''.trim();

    AppToast.show(ctx, msg, duration: const Duration(seconds: 4));
  }

  void _toastResponseIfEnabled(Response response) {
    final extra = response.requestOptions.extra;
    final enabled = extra['_debugToast'] == true;
    final ctx = extra['_toastContext'];

    if (!enabled || ctx is! BuildContext) return;

    final tag = (extra['_debugTag'] is String) ? extra['_debugTag'] as String : null;

    final status = response.statusCode;
    final uri = response.requestOptions.uri.toString();
    final bodyShort = _short(response.data);

    final msg = '''
${tag != null ? '[$tag] ' : ''}RES
HTTP: $status
$uri
BODY: $bodyShort
'''.trim();

    AppToast.show(ctx, msg, duration: const Duration(seconds: 4));
  }

  void _toastErrorIfEnabled(DioException e) {
    final extra = e.requestOptions.extra;
    final enabled = extra['_debugToast'] == true;
    final ctx = extra['_toastContext'];

    if (!enabled || ctx is! BuildContext) return;

    final tag = (extra['_debugTag'] is String) ? extra['_debugTag'] as String : null;

    final status = e.response?.statusCode;
    final uri = e.requestOptions.uri.toString();
    final type = e.type.toString();
    final rawShort = _short(e.response?.data);

    final msg = '''
${tag != null ? '[$tag] ' : ''}ERR
TYPE: $type
HTTP: ${status ?? '-'}
$uri
RAW: $rawShort
'''.trim();

    AppToast.show(ctx, msg, duration: const Duration(seconds: 5));
  }

  ApiException _mapDioException(
      DioException e, {
        required String method,
        required String path,
      }) {
    final status = e.response?.statusCode;
    final raw = e.response?.data;

    String? serverMessage;
    int? appCode;

    if (raw is Map<String, dynamic>) {
      final msg = raw['message'];
      if (msg is String && msg.isNotEmpty) serverMessage = msg;

      final code = raw['code'] ?? raw['statusCode'];
      if (code is int) appCode = code;
      if (code is String) appCode = int.tryParse(code);
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return ApiException(
          message: serverMessage ?? '네트워크가 불안정합니다. 잠시 후 다시 시도해주세요.',
          httpStatus: status,
          appStatusCode: appCode,
          raw: raw,
          method: method,
          path: path,
        );

      case DioExceptionType.badResponse:
        return ApiException(
          message: serverMessage ?? '요청이 실패했습니다. (HTTP $status)',
          httpStatus: status,
          appStatusCode: appCode,
          raw: raw,
          method: method,
          path: path,
        );

      case DioExceptionType.cancel:
        return ApiException(
          message: serverMessage ?? '요청이 취소되었습니다.',
          httpStatus: status,
          appStatusCode: appCode,
          raw: raw,
          method: method,
          path: path,
        );

      case DioExceptionType.badCertificate:
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        return ApiException(
          message: serverMessage ?? '서버와 연결할 수 없습니다. 네트워크 상태를 확인해주세요.',
          httpStatus: status,
          appStatusCode: appCode,
          raw: raw,
          method: method,
          path: path,
        );
    }
  }

  static String _maskAuth(String authHeader) {
    // 예: "Bearer abcdef...." -> "Bearer abcdef...(len=xxx)"
    final parts = authHeader.split(' ');
    if (parts.length < 2) return '<invalid-auth>';

    final scheme = parts.first;
    final token = parts.sublist(1).join(' ');
    if (token.length <= 12) return '$scheme $token';

    final head = token.substring(0, 6);
    final tail = token.substring(token.length - 4);
    return '$scheme $head...$tail(len=${token.length})';
  }

  static String _short(dynamic v) {
    if (v == null) return '<null>';
    try {
      final s = jsonEncode(v);
      if (s.length <= 260) return s;
      return '${s.substring(0, 260)}...';
    } catch (_) {
      final s = v.toString();
      if (s.length <= 260) return s;
      return '${s.substring(0, 260)}...';
    }
  }
}
