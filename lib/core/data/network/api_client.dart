import 'package:dio/dio.dart';

import '../../config/env.dart';
import 'api_exception.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options = BaseOptions(
      baseUrl: Env.apiBaseUrl,
      connectTimeout: Env.connectTimeout,
      receiveTimeout: Env.receiveTimeout,
      headers: <String, dynamic>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
  }

  Future<Response<dynamic>> get(
      String path, {
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    } catch (_) {
      throw const ApiException(message: '알 수 없는 네트워크 오류가 발생했습니다.');
    }
  }

  Future<Response<dynamic>> post(
      String path, {
        Object? data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _mapDioException(e);
    } catch (_) {
      throw const ApiException(message: '알 수 없는 네트워크 오류가 발생했습니다.');
    }
  }

  ApiException _mapDioException(DioException e) {
    final status = e.response?.statusCode;

    final serverMessage = () {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        final msg = data['message'];
        if (msg is String && msg.isNotEmpty) return msg;
      }
      return null;
    }();

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return ApiException(
          message: serverMessage ?? '네트워크가 불안정합니다. 잠시 후 다시 시도해주세요.',
          httpStatus: status,
        );
      case DioExceptionType.badResponse:
        return ApiException(
          message: serverMessage ?? '요청이 실패했습니다. (HTTP $status)',
          httpStatus: status,
        );
      case DioExceptionType.cancel:
        return ApiException(
          message: serverMessage ?? '요청이 취소되었습니다.',
          httpStatus: status,
        );
      case DioExceptionType.badCertificate:
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        return ApiException(
          message: serverMessage ?? '서버와 연결할 수 없습니다. 네트워크 상태를 확인해주세요.',
          httpStatus: status,
        );
    }
  }
}
