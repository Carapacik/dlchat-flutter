import 'package:dlchat/src/core/components/prefs_storage/onboarding/onboarding_datasource.dart';

abstract interface class IOnboardingRepository() {
  Future<void> setHideOnboarding();

  Future<bool> isHideOnboarding();

  Future<void> setHideVoiceOnboarding();

  Future<bool> isHideVoiceOnboarding();

  Future<void> setHideAssistantNutritionOnboarding();

  Future<bool> isHideAssistantNutritionOnboarding();
}

class const OnboardingRepository({required final IOnboardingDataSource _onboardingDataSource})
    implements IOnboardingRepository {
  @override
  Future<void> setHideOnboarding() => _onboardingDataSource.setHideOnboarding();

  @override
  Future<bool> isHideOnboarding() => _onboardingDataSource.isHideOnboarding().then((value) => value ?? false);

  @override
  Future<void> setHideVoiceOnboarding() => _onboardingDataSource.setHideVoiceOnboarding();

  @override
  Future<bool> isHideVoiceOnboarding() => _onboardingDataSource.isHideVoiceOnboarding().then((value) => value ?? false);

  @override
  Future<void> setHideAssistantNutritionOnboarding() => _onboardingDataSource.setHideAssistantNutritionOnboarding();

  @override
  Future<bool> isHideAssistantNutritionOnboarding() =>
      _onboardingDataSource.isHideAssistantNutritionOnboarding().then((value) => value ?? false);
}
