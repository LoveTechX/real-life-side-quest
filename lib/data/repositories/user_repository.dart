import '../../core/utils/mock_data.dart';
import '../../core/utils/xp_calculator.dart';
import '../datasources/remote/user_remote_ds.dart';
import '../models/user_model.dart';

class UserRepository {
  UserRepository({UserRemoteDataSource? userRemoteDataSource})
    : _userRemoteDataSource = userRemoteDataSource ?? UserRemoteDataSource();

  final UserRemoteDataSource _userRemoteDataSource;

  Future<UserModel?> getUserById(String userId) async {
    try {
      return await _userRemoteDataSource.fetchUser(userId);
    } catch (_) {
      // Fallback to mock data
      return userId == MockData.mockUserId ? MockData.mockUser : null;
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      return await _userRemoteDataSource.updateUser(user);
    } catch (e) {
      print('User update failed: $e');
      // Will sync when connection restored
    }
  }

  Future<UserModel> applyQuestReward({
    required UserModel user,
    required int rewardXp,
    bool incrementStreak = false,
  }) async {
    final int totalXp = XpCalculator.addXP(
      currentXP: user.xp,
      gainedXP: rewardXp,
    );
    final int nextLevel = XpCalculator.calculateLevel(totalXP: totalXp);

    final UserModel updatedUser = user.copyWith(
      xp: totalXp,
      level: nextLevel,
      streak: incrementStreak ? user.streak + 1 : user.streak,
    );

    try {
      await _userRemoteDataSource.updateUser(updatedUser);
    } catch (e) {
      print('User reward sync failed: $e');
      // UI still shows the update, will sync when connection restored
    }
    
    return updatedUser;
  }
}
