import 'package:flutter/material.dart';

import 'route_names.dart';

class AppRoutes {
  AppRoutes._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static const String initialRoute = RouteNames.splash;

  static final Map<String, WidgetBuilder> _routeBuilders =
      <String, WidgetBuilder>{
        RouteNames.splash: (_) => const _ArchitecturePlaceholderPage(),
        RouteNames.login: (_) => const _ArchitecturePlaceholderPage(),
        RouteNames.signup: (_) => const _ArchitecturePlaceholderPage(),
        RouteNames.home: (_) => const _ArchitecturePlaceholderPage(),
        RouteNames.quests: (_) => const _ArchitecturePlaceholderPage(),
        RouteNames.profile: (_) => const _ArchitecturePlaceholderPage(),
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
      builder: (_) => const _ArchitecturePlaceholderPage(),
      settings: settings,
    );
  }
}

class _ArchitecturePlaceholderPage extends StatelessWidget {
  const _ArchitecturePlaceholderPage();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
