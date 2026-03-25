import '../../models/user_model.dart';
import '../../../core/services/firestore_service.dart';

class UserRemoteDataSource {
  UserRemoteDataSource({FirestoreService? firestoreService})
    : _firestoreService = firestoreService ?? FirestoreService();

  final FirestoreService _firestoreService;

  String _userPath(String userId) => 'users/$userId';

  Future<UserModel?> fetchUser(String userId) async {
    final Map<String, dynamic>? data = await _firestoreService.getDocument(
      path: _userPath(userId),
    );

    if (data == null) {
      return null;
    }

    return UserModel.fromMap(<String, dynamic>{'id': userId, ...data});
  }

  Future<void> saveUser(UserModel user) {
    return _firestoreService.setDocument(
      path: _userPath(user.id),
      data: user.toMap(),
    );
  }

  Future<void> updateUser(UserModel user) {
    return _firestoreService.updateDocument(
      path: _userPath(user.id),
      data: user.toMap(),
    );
  }
}
