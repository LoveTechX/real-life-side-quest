import 'package:firebase_auth/firebase_auth.dart';

import 'firebase_service.dart';

class AuthService {
  AuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    await FirebaseService.instance.initialize();
    return _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signup({
    required String email,
    required String password,
  }) async {
    await FirebaseService.instance.initialize();
    return _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    await FirebaseService.instance.initialize();
    await _auth.signOut();
  }

  // Backward-compatible aliases.
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) {
    return login(email: email, password: password);
  }

  Future<void> signOut() {
    return logout();
  }
}
