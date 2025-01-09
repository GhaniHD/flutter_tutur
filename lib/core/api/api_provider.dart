import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

class ApiProvider {
  // Singleton instance
  static final ApiProvider _instance = ApiProvider._internal();

  factory ApiProvider() => _instance;

  ApiProvider._internal();

  final dio = Dio();
  String? _token;

  // Dummy token for testing
  static const String _dummyToken = 'dummy-token';

  /// Inisialisasi token dan konfigurasi Dio
  Future<void> init() async {
    _token = _dummyToken;
    await configureDio();
  }

  /// Mengambil token saat ini
  Future<String?> getToken() async {
    return _token ?? _dummyToken;
  }

  /// Konfigurasi awal untuk Dio
  Future<void> configureDio() async {
    final token = await getToken();

    // Menentukan URL API berdasarkan platform
    String baseUrl = '';
    if (kIsWeb) {
      baseUrl = 'http://localhost:8000/api'; // Untuk Web
    } else {
      baseUrl = 'http://10.0.2.2:8000/api'; // Untuk Emulator
    }

    dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 7),
      receiveTimeout: const Duration(seconds: 7),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    // Interceptor untuk logging hanya pada mode debug
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(
        responseBody: true,
        requestBody: true,
      ));
    }

    // Menambahkan header Authorization secara dinamis
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await getToken();
        options.headers['Authorization'] = 'Bearer $token';
        return handler.next(options);
      },
    ));
  }

  /// Mengirim data dengan tipe multipart/form-data
  Future<dynamic> postFormData(String path, FormData formData) async {
    try {
      final response = await dio.post(
        path,
        data: formData,
        options: Options(
          headers: {
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

  /// Mengirim data JSON via POST
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

  /// Mengambil data dari server
  Future<dynamic> get(String path) async {
    try {
      final response = await dio.get(
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

  /// Mengirim data JSON via PUT
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

  /// Menghapus data
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

  /// Menangani kesalahan
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
