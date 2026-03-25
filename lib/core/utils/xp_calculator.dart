import '../../data/models/xp_model.dart';

class XpCalculator {
  XpCalculator._();

  static const int _baseXpRequirement = 100;
  static const int _baseXpPerDifficulty = 20;

  static int calculateQuestXp({
    required int difficulty,
    double multiplier = 1.0,
  }) {
    if (difficulty <= 0) {
      return 0;
    }

    final int baseXp = difficulty * _baseXpPerDifficulty;
    return (baseXp * multiplier).round().clamp(0, 1000000);
  }

  static int addXP({required int currentXP, required int gainedXP}) {
    final int safeCurrent = currentXP < 0 ? 0 : currentXP;
    final int safeGained = gainedXP < 0 ? 0 : gainedXP;
    return (safeCurrent + safeGained).clamp(0, 2147483647);
  }

  static int calculateLevel({required int totalXP}) {
    final int safeTotal = totalXP < 0 ? 0 : totalXP;
    int level = 1;

    while (safeTotal >= _totalXpRequiredToReachLevel(level + 1)) {
      level++;
    }

    return level;
  }

  static int getXPForNextLevel({required int level}) {
    final int safeLevel = level < 1 ? 1 : level;
    return _baseXpRequirement * safeLevel;
  }

  static XpModel progressFromTotalXp(int totalXp) {
    final int safeTotalXp = totalXp < 0 ? 0 : totalXp;
    final int level = calculateLevel(totalXP: safeTotalXp);
    final int currentLevelStart = _totalXpRequiredToReachLevel(level);
    final int currentLevelXP = safeTotalXp - currentLevelStart;

    return XpModel(
      currentXP: currentLevelXP,
      requiredXP: getXPForNextLevel(level: level),
    );
  }

  static XpModel applyQuestReward({
    required int currentTotalXp,
    required int rewardXp,
  }) {
    final int nextTotal = addXP(currentXP: currentTotalXp, gainedXP: rewardXp);
    return progressFromTotalXp(nextTotal);
  }

  static int _totalXpRequiredToReachLevel(int level) {
    if (level <= 1) {
      return 0;
    }

    int total = 0;
    for (int currentLevel = 1; currentLevel < level; currentLevel++) {
      total += getXPForNextLevel(level: currentLevel);
    }
    return total;
  }
}
