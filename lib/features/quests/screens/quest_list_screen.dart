import 'package:flutter/material.dart';

import '../controller/quest_controller.dart';
import '../../../data/models/quest_model.dart';
import 'add_quest_screen.dart';
import '../widgets/quest_tile.dart';

class QuestListScreen extends StatefulWidget {
  const QuestListScreen({super.key, required this.controller});

  final QuestController controller;

  @override
  State<QuestListScreen> createState() => _QuestListScreenState();
}

class _QuestListScreenState extends State<QuestListScreen> {
  static const double _pagePadding = 16;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_refresh);
    widget.controller.fetchQuests();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _onQuestCompleted(QuestModel quest) async {
    final bool success = await widget.controller.completeQuest(quest);
    if (!mounted || success) {
      return;
    }

    final String message =
        widget.controller.errorMessage ?? 'Unable to complete quest.';
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _onRefresh() async {
    await widget.controller.fetchQuests();
  }

  Future<void> _openAddQuest() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AddQuestScreen(controller: widget.controller),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Today\'s Quests')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddQuest,
        icon: const Icon(Icons.add),
        label: const Text('Add Quest'),
      ),
      body: widget.controller.isLoading && widget.controller.quests.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView(
                padding: const EdgeInsets.all(_pagePadding),
                children: <Widget>[
                  Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(
                        'Level ${widget.controller.currentUser.level}',
                      ),
                      subtitle: Text(
                        'XP ${widget.controller.currentUser.xp} • Streak ${widget.controller.currentUser.streak}',
                      ),
                    ),
                  ),
                  if (widget.controller.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        widget.controller.errorMessage!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  if (widget.controller.quests.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 32),
                      child: Center(
                        child: Text('No quests yet. Add one to begin.'),
                      ),
                    )
                  else
                    ...widget.controller.quests.map(
                      (quest) => QuestTile(
                        quest: quest,
                        onToggleCompleted: _onQuestCompleted,
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
