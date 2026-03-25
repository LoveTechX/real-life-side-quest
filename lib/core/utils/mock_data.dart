import '../../data/models/quest_model.dart';
import '../../data/models/user_model.dart';

class MockData {
  MockData._();

  static const String mockUserId = 'mock_user_123';

  static const UserModel mockUser = UserModel(
    id: mockUserId,
    name: 'Adventure Hero',
    level: 5,
    xp: 1250,
    streak: 7,
  );

  static final List<QuestModel> mockQuests = [
    const QuestModel(
      id: '1',
      title: 'Morning Workout',
      description: 'Complete 30 minutes of exercise',
      xpReward: 50,
      isCompleted: false,
      type: QuestType.daily,
    ),
    const QuestModel(
      id: '2',
      title: 'Read a Chapter',
      description: 'Read one chapter of your current book',
      xpReward: 30,
      isCompleted: false,
      type: QuestType.daily,
    ),
    const QuestModel(
      id: '3',
      title: 'Learn a New Skill',
      description: 'Spend 1 hour learning something new',
      xpReward: 75,
      isCompleted: true,
      type: QuestType.main,
    ),
  ];
}
