import 'dart:async';

import '../../../core/base/base_controller.dart';
import '../../../core/utils/xp_calculator.dart';
import '../../../data/models/quest_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/xp_model.dart';
import '../../../data/repositories/quest_repository.dart';
import '../../../data/repositories/user_repository.dart';

class DashboardController extends BaseController {
  DashboardController({
    required this.userId,
    UserRepository? userRepository,
    QuestRepository? questRepository,
  }) : _userRepository = userRepository ?? UserRepository(),
       _questRepository = questRepository ?? QuestRepository();

  final String userId;
  final UserRepository _userRepository;
  final QuestRepository _questRepository;

  UserModel? _user;
  List<QuestModel> _todaysQuests = <QuestModel>[];
  StreamSubscription<List<QuestModel>>? _questsSubscription;

  UserModel? get user => _user;
  List<QuestModel> get todaysQuests =>
      List<QuestModel>.unmodifiable(_todaysQuests);
  XpModel? get xp =>
      _user == null ? null : XpCalculator.progressFromTotalXp(_user!.xp);

  Future<void> loadDashboard() async {
    setLoading(true);
    try {
      final UserModel? loadedUser = await _userRepository.getUserById(userId);
      if (loadedUser == null) {
        setError('Unable to load user data.');
        return;
      }

      _user = loadedUser;
      clearError(notify: false);
      
      // Setup real-time quest listener instead of one-time fetch
      _setupQuestListener();
      
      emit();
    } catch (_) {
      setError('Failed to load dashboard. Please try again.');
    } finally {
      setLoading(false);
    }
  }

  void _setupQuestListener() {
    // Cancel previous subscription if exists
    _questsSubscription?.cancel();
    
    // Listen to real-time quest changes from Firestore
    _questsSubscription = _questRepository.watchQuests(userId: userId).listen(
      (List<QuestModel> quests) {
        _todaysQuests = quests
            .where((QuestModel quest) {
              return quest.type == QuestType.daily || !quest.isCompleted;
            })
            .toList(growable: false);
        emit();
      },
      onError: (dynamic error) {
        print('Real-time quest sync error: $error');
        setError('Failed to sync quests.');
      },
    );
  }

  @override
  void dispose() {
    _questsSubscription?.cancel();
    super.dispose();
  }

  Future<void> refresh() {
    return loadDashboard();
  }

  Future<void> completeQuest(QuestModel quest) async {
    if (quest.isCompleted || _user == null) {
      return;
    }

    try {
      // Optimistically update UI
      _user = _user!.copyWith(xp: _user!.xp + quest.xpReward);
      _todaysQuests = _todaysQuests
          .map((QuestModel q) => q.id == quest.id ? q.copyWith(isCompleted: true) : q)
          .toList(growable: false);
      emit();

      // Persist updates to backend
      final UserModel updatedUser = await _questRepository.completeQuest(
        userId: userId,
        quest: quest,
        currentUser: _user!,
        incrementStreak: false,
      );

      // Update with backend response (XP confirmed)
      _user = updatedUser;
      emit();
    } catch (e) {
      print('Quest completion sync error: $e');
      // UI still shows changes, data will sync when connection restored
    }
  }

  Future<void> addQuest({
    required String title,
    required String description,
    required int xpReward,
    QuestType type = QuestType.side,
  }) async {
    final String id = DateTime.now().microsecondsSinceEpoch.toString();
    final QuestModel newQuest = QuestModel(
      id: id,
      title: title,
      description: description,
      xpReward: xpReward,
      type: type,
      isCompleted: false,
    );

    try {
      // Optimistically add to UI (will be confirmed by real-time listener)
      _todaysQuests = <QuestModel>[newQuest, ..._todaysQuests];
      emit();

      // Persist to Firestore
      await _questRepository.addQuest(userId: userId, quest: newQuest);
    } catch (e) {
      print('Quest add sync error: $e');
      // UI shows the quest, it will sync when connection restored
    }
  }
}
