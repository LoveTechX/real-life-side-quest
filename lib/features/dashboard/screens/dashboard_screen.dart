import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/utils/mock_data.dart';
import '../../../data/models/xp_model.dart';
import '../controller/dashboard_controller.dart';
import 'home_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late DashboardController _controller;

  @override
  void initState() {
    super.initState();
    _controller = DashboardController(userId: MockData.mockUserId);
    _controller.loadDashboard();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DashboardController>.value(
      value: _controller,
      child: Consumer<DashboardController>(
        builder: (BuildContext context, DashboardController controller, _) {
          if (controller.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (controller.errorMessage != null) {
            return Scaffold(
              body: Center(
                child: Text(controller.errorMessage ?? 'An error occurred'),
              ),
            );
          }

          if (controller.user == null) {
            return const Scaffold(
              body: Center(child: Text('Failed to load user data')),
            );
          }

          return HomeScreen(
            user: controller.user!,
            xp: controller.xp ?? const XpModel(currentXP: 0, requiredXP: 100),
            todaysQuests: controller.todaysQuests,
            onQuestComplete: controller.completeQuest,
            onAddQuest: (title, description, xpReward, type) {
              controller.addQuest(
                title: title,
                description: description,
                xpReward: xpReward,
                type: type,
              );
            },
          );
        },
      ),
    );
  }
}
