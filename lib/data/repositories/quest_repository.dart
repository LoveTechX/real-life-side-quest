import '../datasources/remote/quest_remote_ds.dart';
import '../models/quest_model.dart';
import '../models/user_model.dart';
import 'user_repository.dart';

class QuestRepository {
  QuestRepository({
    QuestRemoteDataSource? questRemoteDataSource,
    UserRepository? userRepository,
  }) : _questRemoteDataSource =
           questRemoteDataSource ?? QuestRemoteDataSource(),
       _userRepository = userRepository ?? UserRepository();

  final QuestRemoteDataSource _questRemoteDataSource;
  final UserRepository _userRepository;

  Future<List<QuestModel>> fetchQuests({required String userId}) {
    return _questRemoteDataSource.getQuests(userId: userId);
  }

  Future<void> addQuest({required String userId, required QuestModel quest}) {
    return _questRemoteDataSource.createQuest(userId: userId, quest: quest);
  }

  Future<void> updateQuest({
    required String userId,
    required QuestModel quest,
  }) {
    return _questRemoteDataSource.updateQuest(userId: userId, quest: quest);
  }

  Future<void> deleteQuest({required String userId, required String questId}) {
    return _questRemoteDataSource.deleteQuest(userId: userId, questId: questId);
  }

  Stream<List<QuestModel>> watchQuests({required String userId}) {
    return _questRemoteDataSource
        .watchQuests(userId: userId)
        .map(
          (List<Map<String, dynamic>> rows) =>
              rows.map(QuestModel.fromMap).toList(growable: false),
        );
  }

  Future<UserModel> completeQuest({
    required String userId,
    required QuestModel quest,
    required UserModel currentUser,
    bool incrementStreak = true,
  }) async {
    if (quest.isCompleted) {
      return currentUser;
    }

    final QuestModel completedQuest = quest.copyWith(isCompleted: true);
    await _questRemoteDataSource.updateQuest(
      userId: userId,
      quest: completedQuest,
    );

    return _userRepository.applyQuestReward(
      user: currentUser,
      rewardXp: quest.xpReward,
      incrementStreak: incrementStreak,
    );
  }
}
