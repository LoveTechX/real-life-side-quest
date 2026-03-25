import 'package:flutter/material.dart';

import '../../../data/models/quest_model.dart';

class QuestTile extends StatelessWidget {
  const QuestTile({
    super.key,
    required this.quest,
    required this.onToggleCompleted,
  });

  final QuestModel quest;
  final ValueChanged<QuestModel> onToggleCompleted;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        title: Text(
          quest.title,
          style: TextStyle(
            decoration: quest.isCompleted ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '${quest.description} • ${quest.type.name} • +${quest.xpReward} XP',
        ),
        trailing: Checkbox(
          value: quest.isCompleted,
          onChanged: quest.isCompleted ? null : (_) => onToggleCompleted(quest),
        ),
      ),
    );
  }
}
