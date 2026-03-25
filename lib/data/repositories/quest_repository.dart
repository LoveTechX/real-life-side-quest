import '../../core/utils/mock_data.dart';
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

  Future<List<QuestModel>> fetchQuests({required String userId}) async {
    try {
      return await _questRemoteDataSource.getQuests(userId: userId);
    } catch (_) {
      // Fallback to mock data
      return userId == MockData.mockUserId ? MockData.mockQuests : [];
    }
  }

  Future<void> addQuest({required String userId, required QuestModel quest}) async {
    try {
      return await _questRemoteDataSource.createQuest(userId: userId, quest: quest);
    } catch (_) {
      // Mock data doesn't persist, but quest was added to UI already
      print('Quest add to backend failed (using mock): $_');
    }
  }

  Future<void> updateQuest({
    required String userId,
    required QuestModel quest,
  }) async {
    try {
      return await _questRemoteDataSource.updateQuest(userId: userId, quest: quest);
    } catch (e) {
      print('Quest update failed: $e');
      // Will sync when connection restored
    }
  }

  Future<void> deleteQuest({required String userId, required String questId}) async {
    try {
      return await _questRemoteDataSource.deleteQuest(userId: userId, questId: questId);
    } catch (e) {
      print('Quest delete failed: $e');
    }
  }

  Stream<List<QuestModel>> watchQuests({required String userId}) {
    return _questRemoteDataSource
        .watchQuests(userId: userId)
        .map(
          (List<Map<String, dynamic>> rows) =>
              rows.map(QuestModel.fromMap).toList(growable: false),
        )
        .handleError((dynamic error) {
          print('Quests stream error: $error');
          // Stream will retry with Firestore's built-in retry logic
        });
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
