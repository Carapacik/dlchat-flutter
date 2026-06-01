import 'dart:async';

import 'package:dlchat/src/core/router/routes.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Bad
///
/// Provides a way to keep a reference of the [NavigatorState] globally.
class NavigatorHolder() {
  static final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

  static void showServerErrorScreen() {
    final BuildContext context = rootNavigatorKey.currentState!.context;
    if (!context.mounted) {
      return;
    }
    final RouteMatch lastMatch = GoRouter.of(context).routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : GoRouter.of(context).routerDelegate.currentConfiguration;
    final location = matchList.uri.toString();
    if (location != Routes.connectionError.path) {
      unawaited(context.pushNamed(Routes.connectionError.name));
    }
  }
}
