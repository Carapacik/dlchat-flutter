import 'package:dlchat/src/feature/initialization/model/environment.dart';

/// Application configuration
class const ApplicationConfig() {
  /// Creates a new [ApplicationConfig] instance.
  this;

  /// The current environment.
  Environment get environment {
    String environment = const String.fromEnvironment('ENVIRONMENT').trim();

    if (environment.isNotEmpty) {
      return Environment.from(environment);
    }

    environment = const String.fromEnvironment('FLUTTER_APP_FLAVOR').trim();

    return Environment.from(environment);
  }

  String get apiUrl => const String.fromEnvironment('API_URL').trim();

  String get imageProxyUrl => const String.fromEnvironment('IMAGE_PROXY_URL').trim();

  String get telegramBotUrl => const String.fromEnvironment('TELEGRAM_BOT_URL').trim();

  String get appMetricaKey => const String.fromEnvironment('APP_METRICA_SDK_API_KEY').trim();

  String get appMetricaPostApiKey => const String.fromEnvironment('APP_METRICA_POST_API_KEY').trim();

  String get appMetricaApiAppId => const String.fromEnvironment('APP_METRICA_API_APPLICATION_ID').trim();

  String get sentryDsn => const String.fromEnvironment('SENTRY_DSN').trim();

  /// Whether Sentry is enabled.
  bool get enableSentry => sentryDsn.isNotEmpty;
}

/// {@template testing_dependencies_container}
/// A special version of [ApplicationConfig] that is used in tests.
///
/// In order to use [ApplicationConfig] in tests, it is needed to
/// extend this class and provide the dependencies that are needed for the test.
/// {@endtemplate}
base class const TestConfig() implements ApplicationConfig {
  /// {@macro testing_dependencies_container}
  this;

  @override
  Object noSuchMethod(Invocation invocation) {
    throw UnimplementedError(
      'The test tries to access ${invocation.memberName} (${invocation.runtimeType}) config option, but '
      'it was not provided. Please provide the option in the test. '
      'You can do it by extending this class and providing the option.',
    );
  }
}
