import 'package:dlchat/src/core/common/extensions/extensions.dart';
import 'package:dlchat/src/feature/initialization/model/dependencies_container.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// {@template dependencies_scope}
/// A scope that provides application dependencies.
///
/// In order to use this in widget tests, you need to wrap your widget with
/// this widget and provide the dependencies. However, you should not
/// always provide the full pack of dependencies, only the ones that are
/// needed for the test. It is possible by creating a new class that extends
/// [DependenciesContainer] and overrides the dependencies that are needed for the test.
/// {@endtemplate}
class const DependenciesScope({
  required super.child,

  /// Container with dependencies.
  required final DependenciesContainer dependencies,
  super.key,
}) extends InheritedWidget {
  /// {@macro dependencies_scope}
  this;

  /// Get the dependencies from the [context].
  static DependenciesContainer of(BuildContext context) => context.inhOf<DependenciesScope>(listen: false).dependencies;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<DependenciesContainer>('dependencies', dependencies));
  }

  @override
  bool updateShouldNotify(DependenciesScope oldWidget) => !identical(dependencies, oldWidget.dependencies);
}
