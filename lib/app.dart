import 'package:flutter/material.dart';

import 'core/constants/strings.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_routes.dart';

class RealLifeSideQuestApp extends StatelessWidget {
  const RealLifeSideQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      navigatorKey: AppRoutes.navigatorKey,
      initialRoute: AppRoutes.initialRoute,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      onUnknownRoute: AppRoutes.onUnknownRoute,
    );
  }
}
