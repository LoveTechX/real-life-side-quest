import '../datasources/remote/auth_remote_ds.dart';
import '../datasources/remote/user_remote_ds.dart';
import '../models/user_model.dart';

class AuthRepository {
  AuthRepository({
    AuthRemoteDataSource? authRemoteDataSource,
    UserRemoteDataSource? userRemoteDataSource,
  }) : _authRemoteDataSource = authRemoteDataSource ?? AuthRemoteDataSource(),
       _userRemoteDataSource = userRemoteDataSource ?? UserRemoteDataSource();

  final AuthRemoteDataSource _authRemoteDataSource;
  final UserRemoteDataSource _userRemoteDataSource;

  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    final userCredential = await _authRemoteDataSource.signIn(
      email: email,
      password: password,
    );

    final String uid = userCredential.user?.uid ?? '';
    if (uid.isEmpty) {
      return null;
    }

    return _userRemoteDataSource.fetchUser(uid);
  }

  Future<UserModel> signup({
    required String email,
    required String password,
    required String name,
  }) async {
    final userCredential = await _authRemoteDataSource.signUp(
      email: email,
      password: password,
    );

    final String uid = userCredential.user?.uid ?? '';
    if (uid.isEmpty) {
      throw StateError('User id is missing after signup');
    }

    final UserModel user = UserModel(id: uid, name: name);
    await _userRemoteDataSource.saveUser(user);
    return user;
  }

  Future<void> logout() {
    return _authRemoteDataSource.signOut();
  }

  String? getCurrentUserId() {
    return _authRemoteDataSource.getCurrentUserId();
  }
}
