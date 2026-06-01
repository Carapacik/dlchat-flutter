import 'package:dlchat/src/core/components/prefs_storage/tutorial/tutorial_datasource.dart';

abstract interface class ITutorialRepository() {
  /// Установить версию показанного changelog
  Future<void> setLastShownVersion(String version);

  /// Получить версию последнего показанного changelog
  Future<String?> getLastShownVersion();

  /// Проверить, был ли показан определенный туториал
  Future<bool?> wasTutorialShown(TutorialType type);

  /// Отметить туториал как показанный
  Future<void> markTutorialAsShown(TutorialType type);
}

class const TutorialRepository({required final ITutorialDataSource _tutorialDataSource})
    implements ITutorialRepository {
  @override
  Future<void> setLastShownVersion(String version) => _tutorialDataSource.setLastShownVersion(version);

  @override
  Future<String?> getLastShownVersion() => _tutorialDataSource.getLastShownVersion();

  @override
  Future<bool?> wasTutorialShown(TutorialType type) => _tutorialDataSource.wasTutorialShown(type);

  @override
  Future<void> markTutorialAsShown(TutorialType type) => _tutorialDataSource.markTutorialAsShown(type);
}
