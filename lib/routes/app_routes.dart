import 'package:flutter/material.dart';

import '../features/dashboard/screens/dashboard_screen.dart';
import 'route_names.dart';

class AppRoutes {
  AppRoutes._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static const String initialRoute = RouteNames.home;

  static final Map<String, WidgetBuilder> _routeBuilders =
      <String, WidgetBuilder>{
        RouteNames.home: (_) => const DashboardScreen(),
        RouteNames.quests: (_) => const DashboardScreen(),
        RouteNames.profile: (_) => const DashboardScreen(),
        RouteNames.splash: (_) => const DashboardScreen(),
        RouteNames.login: (_) => const DashboardScreen(),
        RouteNames.signup: (_) => const DashboardScreen(),
      };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final WidgetBuilder? builder = _routeBuilders[settings.name];
    if (builder != null) {
      return MaterialPageRoute<void>(builder: builder, settings: settings);
    }

    return onUnknownRoute(settings);
  }

  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute<void>(
      builder: (_) => const DashboardScreen(),
      settings: settings,
    );
  }
}
