import 'package:flutter/material.dart';

class RouteTracker extends NavigatorObserver {
  RouteTracker(this._onChanged);
  final VoidCallback _onChanged;
  final List<Route> stack = [];

  void _refresh() =>
      WidgetsBinding.instance.addPostFrameCallback((_) => _onChanged());

  @override
  void didPush(Route route, Route? previousRoute) {
    stack.add(route);
    _refresh();
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    stack.remove(route);
    _refresh();
    super.didPop(route, previousRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    stack.remove(route);
    _refresh();
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    if (oldRoute != null) stack.remove(oldRoute);
    if (newRoute != null) stack.add(newRoute);
    _refresh();
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }
}
