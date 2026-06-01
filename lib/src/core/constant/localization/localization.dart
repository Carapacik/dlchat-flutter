import 'package:dlchat/src/core/constant/localization/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// {@template localization}
/// Localization class which is used to localize app.
/// This class provides handy methods and tools.
/// {@endtemplate}
final class Localization._({
  /// Locale which is currently used.
  required final Locale locale,
}) extends AppLocalizations {
  /// {@macro localization}
  this;

  /// {@macro localization}
  static const localizationDelegate = _LocalizationDelegate(AppLocalizationDelegate());

  /// List of supported locales.
  static List<Locale> get supportedLocales => const AppLocalizationDelegate().supportedLocales;

  /// List of localization delegates.
  static List<LocalizationsDelegate<void>> get localizationDelegates => [
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    Localization.localizationDelegate,
  ];

  /// {@macro localization}
  static Localization? get current => _current;

  /// {@macro localization}
  static Localization? _current;

  /// Computes the default locale.
  ///
  /// This is the locale that is used when no locale is specified.
  static Locale computeDefaultLocale() {
    // final locale = WidgetsBinding.instance.platformDispatcher.locale;
    // if (const AppLocalizationDelegate().isSupported(locale)) {
    //   return locale;
    // }

    return const Locale('ru_RU');
  }

  /// Obtain [Localization] instance from [BuildContext].
  static Localization of(BuildContext context) =>
      Localizations.of<Localization>(context, Localization) ??
      (throw ArgumentError('No Localization found in context'));
}

final class const _LocalizationDelegate(final AppLocalizationDelegate _delegate)
    extends LocalizationsDelegate<Localization> {
  @override
  bool isSupported(Locale locale) => _delegate.isSupported(locale);

  @override
  Future<Localization> load(Locale locale) =>
      AppLocalizations.load(locale).then((value) => Localization._current = Localization._(locale: locale));

  @override
  bool shouldReload(_LocalizationDelegate old) => false;
}
