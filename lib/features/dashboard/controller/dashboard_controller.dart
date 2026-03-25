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

      final List<QuestModel> quests = await _questRepository.fetchQuests(
        userId: userId,
      );

      _user = loadedUser;
      _todaysQuests = quests
          .where((QuestModel quest) {
            return quest.type == QuestType.daily || !quest.isCompleted;
          })
          .toList(growable: false);
      clearError(notify: false);
      emit();
    } catch (_) {
      setError('Failed to load dashboard. Please try again.');
    } finally {
      setLoading(false);
    }
  }

  Future<void> refresh() {
    return loadDashboard();
  }
}
