import 'dart:convert';

import 'package:dlchat/src/core/common/analytics/analytics_reporter.dart';
import 'package:logger/logger.dart';
import 'package:rest_client/metrics/metrics_client.dart';

/// {@template app_metrica_api_analytics_reporter}
/// An implementation of [AnalyticsReporter] that reports events to Firebase
/// Analytics.
/// {@endtemplate}
final class const AppMetricaApiAnalyticsReporter({
  /// The logger used to log events locally for debugging.
  required final Logger logger,
  required final MetricsClient metricsClient,
}) implements AnalyticsReporter {
  /// {@macro app_metrica_api_analytics_reporter}
  this;

  @override
  Future<void> logEvent(AnalyticsEvent event) async {
    logger.trace('Logging analytics event: $event');

    final Iterable<MapEntry<String, Object>> parameters = event.parameters.map(
      (parameter) => MapEntry(parameter.name, parameter.value),
    );
    if (parameters.isNotEmpty) {
      await metricsClient.sendEvent(eventName: event.name, eventJson: json.encode(Map.fromEntries(parameters)));
    } else {
      await metricsClient.sendEvent(eventName: event.name);
    }
  }
}
