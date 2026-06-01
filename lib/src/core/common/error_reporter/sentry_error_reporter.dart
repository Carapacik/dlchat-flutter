import 'package:dlchat/src/core/common/error_reporter/error_reporter.dart';
import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// {@template sentry_error_reporter}
/// An implementation of [ErrorReporter] that reports errors to Sentry.
/// {@endtemplate}
class const SentryErrorReporter({
  /// The Sentry DSN.
  required final String sentryDsn,

  /// The Sentry environment.
  required final String environment,
}) implements ErrorReporter {
  /// {@macro sentry_error_reporter}
  this;

  @override
  bool get isInitialized => Sentry.isEnabled;

  @override
  Future<void> initialize() async {
    await SentryFlutter.init(
      (options) => options
        ..dsn = sentryDsn
        ..tracesSampleRate = 0.5
        ..debug = kDebugMode
        ..environment = environment
        ..anrEnabled = true
        ..sendDefaultPii = true,
    );
  }

  @override
  Future<void> close() async {
    await Sentry.close();
  }

  @override
  Future<void> captureException({required Object throwable, StackTrace? stackTrace}) async {
    await Sentry.captureException(throwable, stackTrace: stackTrace);
  }
}
