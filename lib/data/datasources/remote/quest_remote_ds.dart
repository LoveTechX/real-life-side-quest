import '../../models/quest_model.dart';
import '../../../core/services/firestore_service.dart';

class QuestRemoteDataSource {
  QuestRemoteDataSource({FirestoreService? firestoreService})
    : _firestoreService = firestoreService ?? FirestoreService();

  final FirestoreService _firestoreService;

  String _questPath(String userId, String questId) =>
      'users/$userId/quests/$questId';

  String _questCollectionPath(String userId) => 'users/$userId/quests';

  Future<List<QuestModel>> getQuests({required String userId}) async {
    final List<Map<String, dynamic>> rows = await watchQuests(
      userId: userId,
    ).first;
    return rows.map(QuestModel.fromMap).toList(growable: false);
  }

  Future<void> createQuest({
    required String userId,
    required QuestModel quest,
  }) {
    return _firestoreService.setDocument(
      path: _questPath(userId, quest.id),
      data: quest.toMap(),
      merge: false,
    );
  }

  Future<void> updateQuest({
    required String userId,
    required QuestModel quest,
  }) {
    return _firestoreService.updateDocument(
      path: _questPath(userId, quest.id),
      data: quest.toMap(),
    );
  }

  Future<void> deleteQuest({required String userId, required String questId}) {
    return _firestoreService.deleteDocument(path: _questPath(userId, questId));
  }

  Stream<List<Map<String, dynamic>>> watchQuests({required String userId}) {
    return _firestoreService.watchCollection(
      collectionPath: _questCollectionPath(userId),
      orderByField: 'title',
    );
  }
}
