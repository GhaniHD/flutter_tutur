import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'dart:io';

// api provider
class ApiProvider {
  static final ApiProvider _instance = ApiProvider._internal();
  factory ApiProvider() => _instance;
  ApiProvider._internal();

// create dio instance
  final dio = Dio();

// configure dio
  void configureDio() {
    dio.options = BaseOptions(
      baseUrl: 'https://api.example.com',
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 3),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

// log request and response
    if (kDebugMode) {
      dio.interceptors
          .add(LogInterceptor(responseBody: true,
          requestBody: true,
        ));
      }
    }


// upload file 
Future<dynamic> upluoadFile(String endpoint, File file,{Map<String, dynamic>? data}) async {
  try {
   String fileName = file.path.split('/').last;
   FormData formData = FormData.fromMap({
     'image': await MultipartFile.fromFile(
      file.path,
      filename: fileName
      ),
     if (data != null) ...data,
   });

   final response = await dio.post(
    endpoint, 
    data: formData,
    options : Options(
      headers: {
      'content-Type' : 'multipart/form-data',
      },
    ),
  );
    return response.data;
  } catch (e) {
    throw _handleError(e);
  }
}

// get
  Future<dynamic> get(String endpoint) async {
    try {
      final response = await dio.get(endpoint);
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

// post
  Future<dynamic> post(String path, dynamic data) async {
    try {
      final response = await ApiProvider().dio.post(path, data: data);
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

// put
  Future<dynamic> put(String path, dynamic data) async {
    try {
      final response = await ApiProvider().dio.put(path, data: data);
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

// delete
  Future<dynamic> delete(String path) async {
    try {
      final response = await ApiProvider().dio.delete(path);
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

// error handling
  String _handleError(dynamic error) {
    if (error is DioError) {
      switch (error.type) {
        case DioErrorType.connectionTimeout: 
        case DioErrorType.sendTimeout:
        case DioErrorType.receiveTimeout:
          return 'Connection timeout with server';
        case DioErrorType.badResponse:
          return 'Received invalid status code: ${error.response?.statusCode}';
          default:
          return 'network error';
     }
    }
    return 'unexpected error';
  }
}
