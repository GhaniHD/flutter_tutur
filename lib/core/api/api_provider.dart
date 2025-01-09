import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ApiProvider {
  static final ApiProvider _instance = ApiProvider._internal();
  factory ApiProvider() => _instance;
  ApiProvider._internal();

  final Dio dio = Dio();
  String? _token;

  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000/api';
    }
    return 'http://10.0.2.2:8000/api';
  }

  Future<void> init() async {
    _token = await FirebaseAuth.instance.currentUser?.getIdToken();
    await configureDio();
  }

  Future<String?> getToken() async {
    return _token ?? await FirebaseAuth.instance.currentUser?.getIdToken();
  }

  Future<void> configureDio() async {
    final token = await getToken();

    dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
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
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

  Future<Response> postFormData(String path, FormData formData) async {
    try {
      final response = await dio.post(
        path,
        data: formData,
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
          },
          sendTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
        ),
      );
      return response;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<dynamic> post(String path, dynamic data) async {
    try {
      final response = await dio.post(
        path,
        data: data,
        options: Options(
          headers: {
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

  Future<dynamic> get(String path, [Map<String, dynamic>? params]) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: params,
      );
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<dynamic> put(String path, dynamic data) async {
    try {
      final response = await dio.put(
        path,
        data: data,
        options: Options(
          headers: {
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
      final response = await dio.delete(
        path,
        options: Options(
          headers: {
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
