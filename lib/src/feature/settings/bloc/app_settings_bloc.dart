import 'package:dlchat/src/feature/settings/data/app_settings_repository.dart';
import 'package:dlchat/src/feature/settings/model/app_settings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

/// {@template app_settings_bloc}
/// A [Bloc] that handles [AppSettings].
/// {@endtemplate}
final class AppSettingsBloc({
  required final AppSettingsRepository _appSettingsRepository,
  required AppSettingsState initialState,
}) extends Bloc<AppSettingsEvent, AppSettingsState> {
  /// {@macro app_settings_bloc}
  this : super(initialState) {
    on<AppSettingsEvent>(
      (event, emit) async => await switch (event) {
        final _UpdateAppSettingsEvent e => _updateAppSettings(e, emit),
      },
    );
  }

  Future<void> _updateAppSettings(_UpdateAppSettingsEvent event, Emitter<AppSettingsState> emit) async {
    try {
      emit(_LoadingAppSettingsState(appSettings: state.appSettings));
      await _appSettingsRepository.setAppSettings(event.appSettings);
      emit(_IdleAppSettingsState(appSettings: event.appSettings));
    } on Object catch (error) {
      emit(_ErrorAppSettingsState(appSettings: event.appSettings, error: error));
    }
  }
}

/// States for the [AppSettingsBloc].
@immutable
sealed class const AppSettingsState({
  /// Application locale.
  final AppSettings? appSettings,
}) {
  /// The app settings are idle.
  const factory idle({AppSettings? appSettings}) = _IdleAppSettingsState;

  /// The app settings are loading.
  const factory loading({AppSettings? appSettings}) = _LoadingAppSettingsState;

  /// The app settings have an error.
  const factory error({required Object error, AppSettings? appSettings}) = _ErrorAppSettingsState;
}

final class const _IdleAppSettingsState({super.appSettings}) extends AppSettingsState {
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is _IdleAppSettingsState && other.appSettings == appSettings;
  }

  @override
  int get hashCode => appSettings.hashCode;

  @override
  String toString() => 'SettingsState.idle(appSettings: $appSettings)';
}

final class const _LoadingAppSettingsState({super.appSettings}) extends AppSettingsState {
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is _LoadingAppSettingsState && other.appSettings == appSettings;
  }

  @override
  int get hashCode => appSettings.hashCode;

  @override
  String toString() => 'SettingsState.loading(appSettings: $appSettings)';
}

final class const _ErrorAppSettingsState({
  /// The error.
  required final Object error,
  super.appSettings,
}) extends AppSettingsState {
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is _ErrorAppSettingsState && other.appSettings == appSettings && other.error == error;
  }

  @override
  int get hashCode => Object.hash(appSettings, error);

  @override
  String toString() => 'SettingsState.error(appSettings: $appSettings, error: $error)';
}

/// Events for the [AppSettingsBloc].
sealed class const AppSettingsEvent() {
  /// Update the app settings.
  const factory updateAppSettings({required AppSettings appSettings}) = _UpdateAppSettingsEvent;
}

final class const _UpdateAppSettingsEvent({
  /// The theme to update.
  required final AppSettings appSettings,
}) extends AppSettingsEvent {
  @override
  String toString() => 'SettingsEvent.updateAppSettings(appSettings: $appSettings)';
}
