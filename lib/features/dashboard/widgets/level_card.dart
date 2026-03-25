import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';
import '../../../data/models/user_model.dart';

class LevelCard extends StatelessWidget {
  const LevelCard({super.key, required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primary.withOpacity(0.15),
            child: Text(
              '${user.level}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Level ${user.level}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${user.name} • Streak ${user.streak}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
