import 'package:dlchat/src/core/resources/light_theme.dart' as lt;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// {@template app_theme}
/// An immutable class that holds properties needed
/// to build a [ThemeData] for the app.
/// {@endtemplate}
@immutable
final class const AppTheme({
  /// The type of theme to use.
  required final ThemeMode themeMode,
}) with Diagnosticable {
  /// {@macro app_theme}
  this;

  /// The default theme to use.
  static const defaultTheme = AppTheme(themeMode: ThemeMode.system);

  /// Builds a [ThemeData] based on the [themeMode].
  ///
  /// This can also be used to add additional properties to the [ThemeData],
  /// such as extensions or custom properties.
  ThemeData buildThemeData(Brightness brightness) => switch (brightness) {
    Brightness.light => lt.themeData,
    Brightness.dark => lt.themeData,
  };

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<ThemeMode>('type', themeMode));
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is AppTheme && themeMode == other.themeMode;

  @override
  @override
  int get hashCode => themeMode.hashCode;
}
