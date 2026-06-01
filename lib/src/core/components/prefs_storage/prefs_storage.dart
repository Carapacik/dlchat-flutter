import 'package:dlchat/src/core/components/prefs_storage/biometrics/biometrics_data_source.dart';
import 'package:dlchat/src/core/components/prefs_storage/onboarding/onboarding_datasource.dart';
import 'package:dlchat/src/core/components/prefs_storage/request_counter/request_counter_datasource.dart';
import 'package:dlchat/src/core/components/prefs_storage/tutorial/tutorial_datasource.dart';
import 'package:dlchat/src/core/components/prefs_storage/user/user_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class PrefsStorage({required final SharedPreferencesAsync _sharedPreferences}) {
  IBiometricsDataSource? _biometricsDataSource;
  IUserDataSource? _userDataSource;
  IOnboardingDataSource? _onboardingDataSource;
  ITutorialDataSource? _tutorialDataSource;
  IRequestCounterDataSource? _requestCounterDataSource;

  IBiometricsDataSource get biometricsDataSource =>
      _biometricsDataSource ??= BiometricsDataSource(sharedPreferences: _sharedPreferences);

  IUserDataSource get userDataSource => _userDataSource ??= UserDataSource(sharedPreferences: _sharedPreferences);

  IOnboardingDataSource get onboardingDataSource =>
      _onboardingDataSource ??= OnboardingDataSource(sharedPreferences: _sharedPreferences);

  ITutorialDataSource get tutorialDataSource =>
      _tutorialDataSource ??= TutorialDataSource(sharedPreferences: _sharedPreferences);

  IRequestCounterDataSource get requestCounterDataSource =>
      _requestCounterDataSource ??= RequestCounterDataSource(sharedPreferences: _sharedPreferences);

  Future<void> remove() async {
    await [
      biometricsDataSource.remove(),
      userDataSource.remove(),
      tutorialDataSource.removeAll(),
      onboardingDataSource.removeVoiceOnboarding(),
    ].wait;
  }
}
