import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import '../../core/api/api_provider.dart';
import 'auth_service.dart';

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final ApiProvider _apiProvider = ApiProvider();

  @override
  Stream<UserModel?> get currentUser => _auth.authStateChanges().asyncMap((user) async {
    if (user == null) return null;

    try {
      final response = await _apiProvider.get('/user');
      return UserModel.fromJson(response['user']);
    } catch (e) {
      return null;
    }
  });

  @override
  Future<UserModel?> login(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await _apiProvider.init();
        final response = await _apiProvider.get('/user', {'user_id': userCredential.user!.uid});
        return UserModel.fromJson(response);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel?> register(String name, String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await _apiProvider.init();
        final response = await _apiProvider.post('/user/add', {
          'name': name,
          'email': email,
          'firebase_uid': userCredential.user!.uid,
        });
        return UserModel.fromJson(response['user']);
      }
      return null;
    } catch (e) {
      print('Register Error: $e');
      rethrow;
    }
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        await _apiProvider.init();
        try {
          final response = await _apiProvider.get('/user');
          return UserModel.fromJson(response);
        } catch (e) {
          final response = await _apiProvider.post('/user/add', {
            'name': user.displayName ?? '',
            'email': user.email ?? '',
            'firebase_uid': user.uid,
          });
          return UserModel.fromJson(response['user']);
        }
      }
      return null;
    } catch (e) {
      print('Google Sign In Error: $e');
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }
}