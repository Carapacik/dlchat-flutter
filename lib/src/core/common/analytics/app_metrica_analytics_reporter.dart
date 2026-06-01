import 'dart:convert';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:dlchat/src/core/common/analytics/analytics_reporter.dart';
import 'package:logger/logger.dart';

/// {@template app_metrica_analytics_reporter}
/// An implementation of [AnalyticsReporter] that reports events to Firebase
/// Analytics.
/// {@endtemplate}
final class const AppMetricaAnalyticsReporter({
  /// The logger used to log events locally for debugging.
  required final Logger logger,
}) implements AnalyticsReporter {
  /// {@macro app_metrica_analytics_reporter}
  this;

  @override
  Future<void> logEvent(AnalyticsEvent event) async {
    logger.trace('Logging analytics event: $event');

    final Iterable<MapEntry<String, Object>> parameters = event.parameters.map(
      (parameter) => MapEntry(parameter.name, parameter.value),
    );
    if (parameters.isNotEmpty) {
      await AppMetrica.reportEventWithJson(event.name, json.encode(Map.fromEntries(parameters)));
    } else {
      await AppMetrica.reportEvent(event.name);
    }
  }
}
