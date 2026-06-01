import 'package:dlchat/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:dlchat/src/feature/settings/bloc/app_settings_bloc.dart';
import 'package:dlchat/src/feature/settings/model/app_settings.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// {@template settings_scope}
/// SettingsScope widget.
/// {@endtemplate}
class const SettingsScope({
  /// The child widget.
  required final Widget child,
  super.key,
}) extends StatefulWidget {
  /// {@macro settings_scope}
  this;

  /// Get the [AppSettingsBloc] instance.
  static AppSettingsBloc of(BuildContext context, {bool listen = true}) {
    final _InheritedSettings? settingsScope = listen
        ? context.dependOnInheritedWidgetOfExactType<_InheritedSettings>()
        : context.getInheritedWidgetOfExactType<_InheritedSettings>();
    return settingsScope!.state._appSettingsBloc;
  }

  /// Get the [AppSettings] instance.
  static AppSettings settingsOf(BuildContext context, {bool listen = true}) {
    final _InheritedSettings? settingsScope = listen
        ? context.dependOnInheritedWidgetOfExactType<_InheritedSettings>()
        : context.getInheritedWidgetOfExactType<_InheritedSettings>();
    return settingsScope!.settings ?? const AppSettings();
  }

  @override
  State<SettingsScope> createState() => _SettingsScopeState();
}

/// State for widget SettingsScope.
class _SettingsScopeState() extends State<SettingsScope> {
  late final AppSettingsBloc _appSettingsBloc;

  @override
  void initState() {
    super.initState();
    _appSettingsBloc = DependenciesScope.of(context).appSettingsBloc;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingsBloc, AppSettingsState>(
      bloc: _appSettingsBloc,
      builder: (context, state) => _InheritedSettings(settings: state.appSettings, state: this, child: widget.child),
    );
  }
}

/// {@template inherited_settings}
/// _InheritedSettings widget.
/// {@endtemplate}
class const _InheritedSettings({
  required super.child,
  required final _SettingsScopeState state,
  required final AppSettings? settings,
}) extends InheritedWidget {
  /// {@macro inherited_settings}
  this;

  @override
  bool updateShouldNotify(covariant _InheritedSettings oldWidget) => settings != oldWidget.settings;
}
