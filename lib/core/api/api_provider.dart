import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

class ApiProvider {
  static final ApiProvider _instance = ApiProvider._internal();
  factory ApiProvider() => _instance;
  ApiProvider._internal();

  final dio = Dio();
  String? _token;

  // Dummy token for testing
  static const String _dummyToken = 'dummy-token';

  Future<void> init() async {
    _token = _dummyToken;
    await configureDio();
  }

  Future<String?> getToken() async {
    return _token ?? _dummyToken;
  }

  Future<void> configureDio() async {
    final token = await getToken();

    dio.options = BaseOptions(
      baseUrl: 'http://127.0.0.1:8000/api',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(
        responseBody: true,
        requestBody: true,
      ));
    }

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await getToken();
        options.headers['Authorization'] = 'Bearer $token';
        return handler.next(options);
      },
    ));
  }

  Future<dynamic> postFormData(String path, FormData formData) async {
    try {
      final token = await getToken();
      final response = await dio.post(
        path,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<dynamic> post(String path, dynamic data) async {
    try {
      final token = await getToken();
      final response = await dio.post(
        path,
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<dynamic> get(String path) async {
    try {
      final token = await getToken();
      final response = await dio.get(
        path,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<dynamic> put(String path, dynamic data) async {
    try {
      final token = await getToken();
      final response = await dio.put(
        path,
        data: data,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<dynamic> delete(String path) async {
    try {
      final token = await getToken();
      final response = await dio.delete(
        path,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Koneksi timeout, silakan coba lagi';
        case DioExceptionType.badResponse:
          if (error.response?.data != null) {
            if (error.response?.data['error'] != null) {
              return error.response?.data['error'];
            } else if (error.response?.data['message'] != null) {
              return error.response?.data['message'];
            }
          }
          return 'Terjadi kesalahan pada server';
        default:
          return 'Terjadi kesalahan jaringan';
      }
    }
    return 'Terjadi kesalahan yang tidak diketahui';
  }
}
