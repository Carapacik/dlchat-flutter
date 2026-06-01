import 'package:dlchat/src/core/common/persisted_entry.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template onboarding_datasource}
/// [IOnboardingDataSource] is an entry point to the locale data layer.
///
/// This is used to set and get locale.
/// {@endtemplate}
abstract interface class IOnboardingDataSource() {
  Future<bool?> isHideOnboarding();

  Future<void> setHideOnboarding();

  Future<bool?> isHideVoiceOnboarding();

  Future<void> setHideVoiceOnboarding();

  Future<void> removeVoiceOnboarding();

  Future<bool?> isHideAssistantNutritionOnboarding();

  Future<void> setHideAssistantNutritionOnboarding();

  Future<void> remove();
}

final class OnboardingDataSource({required final SharedPreferencesAsync sharedPreferences})
    implements IOnboardingDataSource {
  late final _hideOnboarding = BoolPreferencesEntry(sharedPreferences: sharedPreferences, key: 'onboarding.hide');

  late final _hideVoiceOnboarding = BoolPreferencesEntry(
    sharedPreferences: sharedPreferences,
    key: 'voice.onboarding.hide',
  );

  late final _hideAssistantNutritionOnboarding = BoolPreferencesEntry(
    sharedPreferences: sharedPreferences,
    key: 'onboarding.assistant.nutrition.hide',
  );

  @override
  Future<bool?> isHideOnboarding() => _hideOnboarding.read();

  @override
  Future<bool?> isHideVoiceOnboarding() => _hideVoiceOnboarding.read();

  @override
  Future<void> setHideOnboarding() => _hideOnboarding.set(true);

  @override
  Future<void> setHideVoiceOnboarding() => _hideVoiceOnboarding.set(true);

  @override
  Future<void> removeVoiceOnboarding() => _hideVoiceOnboarding.remove();

  @override
  Future<bool?> isHideAssistantNutritionOnboarding() => _hideAssistantNutritionOnboarding.read();

  @override
  Future<void> setHideAssistantNutritionOnboarding() => _hideAssistantNutritionOnboarding.set(true);

  @override
  Future<void> remove() async {
    await _hideOnboarding.remove();
    await _hideVoiceOnboarding.remove();
  }
}
