import 'package:dlchat/src/core/common/persisted_entry.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Типы туториалов или информационных экранов
enum TutorialType() {
  changelog,
  dlSearch,
  // Добавляйте новые типы здесь
}

/// {@template tutorial_storage_datasource}
/// [ITutorialDataSource] - точка входа к хранилищу данных о показанных туториалах.
///
/// Используется для сохранения и получения информации о том, какие туториалы
/// или информационные экраны были показаны пользователю.
/// {@endtemplate}
abstract interface class ITutorialDataSource() {
  /// Получить версию последнего показанного changelog
  Future<String?> getLastShownVersion();

  /// Установить версию показанного changelog
  Future<void> setLastShownVersion(String version);

  /// Проверить, был ли показан определенный туториал
  Future<bool?> wasTutorialShown(TutorialType type);

  /// Отметить туториал как показанный
  Future<void> markTutorialAsShown(TutorialType type);

  /// Очистить все сохраненные данные
  Future<void> removeAll();
}

final class TutorialDataSource({required final SharedPreferencesAsync sharedPreferences})
    implements ITutorialDataSource {
  late final _lastShownVersion = StringPreferencesEntry(
    sharedPreferences: sharedPreferences,
    key: 'tutorial_storage.changelog_version',
  );

  String _getTutorialKey(TutorialType type) => 'tutorial_storage.${type.name}_shown';

  @override
  Future<String?> getLastShownVersion() => _lastShownVersion.read();

  @override
  Future<void> setLastShownVersion(String version) => _lastShownVersion.set(version);

  @override
  Future<bool?> wasTutorialShown(TutorialType type) async =>
      await BoolPreferencesEntry(sharedPreferences: sharedPreferences, key: _getTutorialKey(type)).read();

  @override
  Future<void> markTutorialAsShown(TutorialType type) async {
    final entity = BoolPreferencesEntry(sharedPreferences: sharedPreferences, key: _getTutorialKey(type));
    await entity.set(true);
  }

  @override
  Future<void> removeAll() async {
    await _lastShownVersion.remove();
    for (final TutorialType type in TutorialType.values) {
      await sharedPreferences.remove(_getTutorialKey(type));
    }
  }
}
