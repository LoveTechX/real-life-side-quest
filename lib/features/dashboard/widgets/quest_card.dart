import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';
import '../../../data/models/quest_model.dart';

class QuestCard extends StatelessWidget {
  const QuestCard({super.key, required this.quest});

  final QuestModel quest;

  @override
  Widget build(BuildContext context) {
    final Color badgeColor = quest.isCompleted
        ? Colors.green.shade600
        : AppColors.secondary;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  quest.title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '+${quest.xpReward} XP',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: badgeColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            quest.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary.withValues(alpha: 0.75),
            ),
          ),
        ],
      ),
    );
  }
}
