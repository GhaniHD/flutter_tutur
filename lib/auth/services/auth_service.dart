import '../models/user_model.dart';

abstract class AuthService {
  Future<UserModel?> login(String email, String password);
  Future<UserModel?> register(String name, String email, String password);
  Future<UserModel?> signInWithGoogle();
  Future<void> logout();
  Stream<UserModel?> get currentUser;
}