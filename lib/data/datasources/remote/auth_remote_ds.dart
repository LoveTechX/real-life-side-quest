import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/services/auth_service.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource({AuthService? authService})
    : _authService = authService ?? AuthService();

  final AuthService _authService;

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) {
    return _authService.login(email: email, password: password);
  }

  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) {
    return _authService.signup(email: email, password: password);
  }

  Future<void> signOut() {
    return _authService.logout();
  }

  String? getCurrentUserId() {
    return _authService.currentUser?.uid;
  }
}
