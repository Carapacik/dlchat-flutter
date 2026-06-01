import 'package:dlchat/src/core/constant/localization/localization.dart';
import 'package:dlchat/src/core/router/router_state_mixin.dart';
import 'package:dlchat/src/feature/settings/model/app_settings.dart';
import 'package:dlchat/src/feature/settings/model/app_theme.dart';
import 'package:dlchat/src/feature/settings/widget/settings_scope.dart';
import 'package:dlchat/src/feature/shared_widgets/common/internet_connection_overlay.dart';
import 'package:flutter/material.dart';

/// {@template material_context}
/// [MaterialContext] is an entry point to the material context.
///
/// This widget sets locales, themes and routing.
/// {@endtemplate}
class const MaterialContext({super.key}) extends StatefulWidget {
  /// {@macro material_context}
  this;

  @override
  State<MaterialContext> createState() => _MaterialContextState();
}

class _MaterialContextState() extends State<MaterialContext> with WidgetsBindingObserver, RouterStateMixin {
  // This global key is needed for [MaterialApp]
  // to work properly when Widgets Inspector is enabled.
  static final GlobalKey<State<StatefulWidget>> _globalKey = GlobalKey(debugLabel: 'MaterialContext');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppSettings settings = SettingsScope.settingsOf(context);

    final AppTheme theme = settings.appTheme ?? AppTheme.defaultTheme;

    final ThemeData lightTheme = theme.buildThemeData(Brightness.light);
    final ThemeData darkTheme = theme.buildThemeData(Brightness.dark);
    final ThemeMode themeMode = theme.themeMode;

    return MaterialApp.router(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      onGenerateTitle: (context) => 'DLChat',
      locale: settings.locale ?? const Locale('ru_RU'),
      localizationsDelegates: Localization.localizationDelegates,
      supportedLocales: Localization.supportedLocales,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) => MediaQuery.withNoTextScaling(
        key: _globalKey,
        child: InternetConnectionOverlay(child: child!),
      ),
    );
  }
}
