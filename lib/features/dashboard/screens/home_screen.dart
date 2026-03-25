import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';
import '../../../data/models/quest_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/xp_model.dart';
import '../widgets/level_card.dart';
import '../widgets/quest_card.dart';
import '../widgets/xp_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.user,
    required this.xp,
    required this.todaysQuests,
  });

  final UserModel user;
  final XpModel xp;
  final List<QuestModel> todaysQuests;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Welcome, ${user.name}'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              LevelCard(user: user),
              const SizedBox(height: 12),
              XpBar(xp: xp),
              const SizedBox(height: 18),
              Text(
                "Today's Quests",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: todaysQuests.isEmpty
                    ? Center(
                        child: Text(
                          'No quests yet for today.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      )
                    : ListView.builder(
                        itemCount: todaysQuests.length,
                        itemBuilder: (BuildContext context, int index) {
                          return QuestCard(quest: todaysQuests[index]);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
