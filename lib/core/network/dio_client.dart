import 'package:dio/dio.dart';
import 'api_exception.dart';

class DioClient {
  late Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (error, handler) {
          return handler.next(error);
        },
      ),
    );
  }

  Future<dynamic> get(String url, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      throw ApiException(
        message: e.message ?? 'Unknown error',
        statusCode: e.response?.statusCode,
        error: e,
      );
    }
  }

  Future<dynamic> post(String url, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      throw ApiException(
        message: e.message ?? 'Unknown error',
        statusCode: e.response?.statusCode,
        error: e,
      );
    }
  }

  Future<dynamic> put(String url, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      throw ApiException(
        message: e.message ?? 'Unknown error',
        statusCode: e.response?.statusCode,
        error: e,
      );
    }
  }

  Future<dynamic> delete(String url, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      throw ApiException(
        message: e.message ?? 'Unknown error',
        statusCode: e.response?.statusCode,
        error: e,
      );
    }
  }
}
