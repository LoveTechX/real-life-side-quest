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
    this.onQuestComplete,
    this.onAddQuest,
  });

  final UserModel user;
  final XpModel xp;
  final List<QuestModel> todaysQuests;
  final Function(QuestModel)? onQuestComplete;
  final Function(String title, String description, int xpReward, QuestType type)? onAddQuest;

  void _showAddQuestDialog(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController xpController = TextEditingController(text: '50');
    QuestType selectedType = QuestType.side;

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Add New Quest'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: xpController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'XP Reward',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButton<QuestType>(
                      value: selectedType,
                      isExpanded: true,
                      items: QuestType.values
                          .map(
                            (QuestType type) => DropdownMenuItem(
                              value: type,
                              child: Text(type.name),
                            ),
                          )
                          .toList(),
                      onChanged: (QuestType? value) {
                        if (value != null) {
                          setState(() {
                            selectedType = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    final String title = titleController.text.trim();
                    final String description = descriptionController.text.trim();
                    final int xpReward = int.tryParse(xpController.text) ?? 50;

                    if (title.isNotEmpty && description.isNotEmpty) {
                      onAddQuest?.call(title, description, xpReward, selectedType);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Add Quest'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('Welcome, ${user.name}'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddQuestDialog(context),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              LevelCard(user: user),
              const SizedBox(height: 16),
              XpBar(xp: xp),
              const SizedBox(height: 24),
              Text(
                "Today's Quests",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: todaysQuests.isEmpty
                    ? Center(
                        child: Text(
                          'No quests yet for today.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textPrimary.withOpacity(0.6),
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: todaysQuests.length,
                        itemBuilder: (BuildContext context, int index) {
                          final QuestModel quest = todaysQuests[index];
                          return QuestCard(
                            quest: quest,
                            onComplete: !quest.isCompleted
                                ? () => onQuestComplete?.call(quest)
                                : null,
                          );
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
