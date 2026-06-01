import 'dart:ui' show Locale;

import 'package:dlchat/src/feature/settings/model/app_theme.dart';
import 'package:flutter/foundation.dart';

/// {@template app_settings}
/// Application settings
/// {@endtemplate}
@immutable
class const AppSettings({
  /// The theme of the app,
  final AppTheme? appTheme,

  /// The locale of the app.
  final Locale? locale,

  /// The text scale of the app.
  final double? textScale,
}) with Diagnosticable {
  /// {@macro app_settings}
  this;

  /// Copy the [AppSettings] with new values.
  AppSettings copyWith({AppTheme? appTheme, Locale? locale, double? textScale}) => AppSettings(
    appTheme: appTheme ?? this.appTheme,
    locale: locale ?? this.locale,
    textScale: textScale ?? this.textScale,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is AppSettings && other.appTheme == appTheme && other.locale == locale && other.textScale == textScale;
  }

  @override
  int get hashCode => Object.hash(appTheme, locale, textScale);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty<AppTheme>('appTheme', appTheme))
      ..add(DiagnosticsProperty<Locale>('locale', locale))
      ..add(DoubleProperty('textScale', textScale));
    super.debugFillProperties(properties);
  }
}
