import 'package:dlchat/src/feature/settings/data/app_settings_datasource.dart';
import 'package:dlchat/src/feature/settings/model/app_settings.dart';

/// {@template app_settings_repository}
/// [AppSettingsRepository] sets and gets app settings.
/// {@endtemplate}
abstract interface class AppSettingsRepository() {
  /// Set app settings
  Future<void> setAppSettings(AppSettings appSettings);

  /// Load [AppSettings] from the source of truth.
  Future<AppSettings?> getAppSettings();
}

/// {@macro app_settings_repository}
final class const AppSettingsRepositoryImpl({
  /// The instance of [AppSettingsDatasource] used to read and write values.
  required final AppSettingsDatasource datasource,
}) implements AppSettingsRepository {
  /// {@macro app_settings_repository}
  this;

  @override
  Future<AppSettings?> getAppSettings() => datasource.getAppSettings();

  @override
  Future<void> setAppSettings(AppSettings appSettings) => datasource.setAppSettings(appSettings);
}
