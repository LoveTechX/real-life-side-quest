import '../../core/utils/xp_calculator.dart';
import '../datasources/remote/user_remote_ds.dart';
import '../models/user_model.dart';

class UserRepository {
  UserRepository({UserRemoteDataSource? userRemoteDataSource})
    : _userRemoteDataSource = userRemoteDataSource ?? UserRemoteDataSource();

  final UserRemoteDataSource _userRemoteDataSource;

  Future<UserModel?> getUserById(String userId) {
    return _userRemoteDataSource.fetchUser(userId);
  }

  Future<void> updateUser(UserModel user) {
    return _userRemoteDataSource.updateUser(user);
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

    await _userRemoteDataSource.updateUser(updatedUser);
    return updatedUser;
  }
}
