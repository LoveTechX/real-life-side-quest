import '../../../core/base/base_controller.dart';
import '../../../data/models/quest_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/quest_repository.dart';

class QuestController extends BaseController {
  QuestController({
    required this.userId,
    required UserModel currentUser,
    QuestRepository? questRepository,
  }) : _currentUser = currentUser,
       _questRepository = questRepository ?? QuestRepository();

  final String userId;
  final QuestRepository _questRepository;

  UserModel _currentUser;
  List<QuestModel> _quests = <QuestModel>[];

  UserModel get currentUser => _currentUser;
  List<QuestModel> get quests => List<QuestModel>.unmodifiable(_quests);

  void setCurrentUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  Future<bool> fetchQuests() async {
    setLoading(true);
    try {
      _quests = await _questRepository.fetchQuests(userId: userId);
      clearError(notify: false);
      notifyListeners();
      return true;
    } catch (_) {
      setError('Failed to load quests. Pull to retry.');
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> addQuest({
    required String title,
    required String description,
    required int xpReward,
    required QuestType type,
  }) async {
    final String id = DateTime.now().microsecondsSinceEpoch.toString();
    final QuestModel quest = QuestModel(
      id: id,
      title: title.trim(),
      description: description.trim(),
      xpReward: xpReward,
      type: type,
    );

    setLoading(true);
    try {
      await _questRepository.addQuest(userId: userId, quest: quest);
      _quests = <QuestModel>[quest, ..._quests];
      clearError(notify: false);
      notifyListeners();
      return true;
    } catch (_) {
      setError('Failed to add quest. Please try again.');
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> completeQuest(QuestModel quest) async {
    if (quest.isCompleted) {
      return false;
    }

    setLoading(true);
    try {
      final UserModel updatedUser = await _questRepository.completeQuest(
        userId: userId,
        quest: quest,
        currentUser: _currentUser,
      );
      _currentUser = updatedUser;
      _quests = _quests
          .map(
            (QuestModel value) => value.id == quest.id
                ? value.copyWith(isCompleted: true)
                : value,
          )
          .toList(growable: false);
      clearError(notify: false);
      notifyListeners();
      return true;
    } catch (_) {
      setError('Failed to complete quest. Please try again.');
      return false;
    } finally {
      setLoading(false);
    }
  }
}
