import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import '../../core/api/api_provider.dart';
import '../services/firebase_auth_service.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuthService _auth = FirebaseAuthService();
  final ApiProvider _apiProvider = ApiProvider();
  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;

  Future<bool> updatePassword(String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _apiProvider.put('/user/update-password', {
        'user_id': _user?.id,
        'password': password,
      });

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<bool> updatePhoto(File photo) async {
    _isLoading = true;
    notifyListeners();

    try {
      String fileName = photo.path.split('/').last;
      FormData formData;

      if (kIsWeb) {
        final bytes = await photo.readAsBytes();
        formData = FormData.fromMap({
          'user_id': _user?.id,
          'photo': MultipartFile.fromBytes(
            bytes,
            filename: fileName,
            contentType: MediaType('image', 'jpeg'),
          ),
        });
      } else {
        formData = FormData.fromMap({
          'user_id': _user?.id,
          'photo': await MultipartFile.fromFile(
            photo.path,
            filename: fileName,
          ),
        });
      }

      final response = await _apiProvider.postFormData('/user/update-photo', formData);
      _user = UserModel.fromJson(response.data);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<bool> updateProfile(String name, String email) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiProvider.put('/user/update', {
        'user_id': _user?.id,
        'name': name,
        'email': email,
      });

      _user = UserModel.fromJson(response);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _auth.login(email, password);
      _isLoading = false;
      notifyListeners();
      return _user != null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _auth.register(name, email, password);
      _isLoading = false;
      notifyListeners();
      return _user != null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<bool> loginWithGoogle() async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _auth.signInWithGoogle();
      _isLoading = false;
      notifyListeners();
      return _user != null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _auth.logout();
      _user = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}