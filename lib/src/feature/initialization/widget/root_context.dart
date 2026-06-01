import 'package:dlchat/src/core/common/layout/layout.dart';
import 'package:dlchat/src/feature/authentication/widget/authentication_scope.dart';
import 'package:dlchat/src/feature/initialization/logic/composition_root.dart';
import 'package:dlchat/src/feature/initialization/widget/bloc_scope.dart';
import 'package:dlchat/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:dlchat/src/feature/initialization/widget/material_context.dart';
import 'package:dlchat/src/feature/settings/widget/settings_scope.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// {@template app}
/// [RootContext] is an entry point to the application.
///
/// If a scope doesn't depend on any inherited widget returned by
/// [MaterialApp] or [WidgetsApp], like [Directionality] or [Theme],
/// and it should be available in the whole application, it can be
/// placed here.
/// {@endtemplate}
class const RootContext({
  /// The result from the [CompositionRoot].
  required final CompositionResult compositionResult,
  super.key,
}) extends StatelessWidget {
  /// {@macro app}
  this;

  @override
  Widget build(BuildContext context) {
    return DefaultAssetBundle(
      bundle: SentryAssetBundle(),
      child: DependenciesScope(
        dependencies: compositionResult.dependencies,
        child: const AuthenticationScope(
          child: SettingsScope(
            child: BlocScope(child: WindowSizeScope(child: MaterialContext())),
          ),
        ),
      ),
    );
  }
}
