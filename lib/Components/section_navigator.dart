import 'package:dorm_sync/Components/route_tracker.dart';
import 'package:flutter/material.dart';

class SectionNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final Map<String, WidgetBuilder> routes;
  final RouteTracker observer;
  const SectionNavigator({
    required this.navigatorKey,
    required this.routes,
    required this.observer,
  });

  @override
  Widget build(BuildContext context) => Navigator(
    key: navigatorKey,
    observers: [observer],
    initialRoute: '/',
    onGenerateRoute: (settings) {
      final builder = routes[settings.name];
      return MaterialPageRoute(
        builder: builder ?? (_) => const Scaffold(),
        settings: settings,
      );
    },
  );
}
