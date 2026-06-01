import 'dart:async';

import 'package:dlchat/src/core/common/analytics/analytics_reporter.dart';

extension type AnalyticsEventReporter(List<AnalyticsReporter> reporters) {
  Future<void> logEvent(AnalyticsEvent event) async {
    final eventFutures = <Future<void>>[];
    for (final AnalyticsReporter reporter in reporters) {
      eventFutures.add(reporter.logEvent(event));
    }
    await eventFutures.wait;
  }
}

/// События аналитики приложения
abstract class AnalyticsEvents() {
  // Установка и первичные события
  static const install = AnalyticsEvent('install');
  static const firstOpen = AnalyticsEvent('first_open');
  static const onboardingComplete = AnalyticsEvent('onboarding_complete');

  // События авторизации
  static const registration = AnalyticsEvent('registration');

  // События подписки
  static const subscriptionStart = AnalyticsEvent('subscription_start');
  static const subscriptionRenewal = AnalyticsEvent('subscription_renewal');
  static const trialStart = AnalyticsEvent('trial_start');
  static const trialToPaid = AnalyticsEvent('trial_to_paid');

  // События использования функций
  static const chatUsed = AnalyticsEvent('chat_used');

  // События использования агентов
  static const usedAnalyst = AnalyticsEvent('used_analyst');
  static const usedTranslator = AnalyticsEvent('used_translator');
  static const usedNutritionist = AnalyticsEvent('used_nutritionist');
  static const usedTeacher = AnalyticsEvent('used_teacher');
  static const usedSmm = AnalyticsEvent('used_smm');
  static const usedLawyer = AnalyticsEvent('used_lawyer');
  static const usedDesigner = AnalyticsEvent('used_designer');
  static const usedBusinessAssistant = AnalyticsEvent('used_business_assistant');
  static const usedCopywriter = AnalyticsEvent('used_copywriter');
  static const usedOther = AnalyticsEvent('used_other');

  // Пример события с параметрами
  static AnalyticsEvent subscriptionStarted(String subscriptionType, num price) => AnalyticsEvent(
    'subscription_start',
    parameters: {StringAnalyticsParameter('type', subscriptionType), NumberAnalyticsParameter('price', price)},
  );
}
