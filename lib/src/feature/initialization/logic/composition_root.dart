import 'dart:io';

// TODO(all): deffer imports
import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:carapacik_dio_logger/carapacik_dio_logger.dart';
import 'package:clock/clock.dart';
import 'package:dio/dio.dart';
import 'package:dlchat/src/core/common/common.dart';
import 'package:dlchat/src/core/components/prefs_storage/prefs_storage.dart';
import 'package:dlchat/src/core/components/rest_client/authentication_interceptor.dart';
import 'package:dlchat/src/core/components/secure_storage/app_secure_storage.dart';
import 'package:dlchat/src/core/constant/constants.dart';
import 'package:dlchat/src/core/router/navigator_holder.dart';
import 'package:dlchat/src/feature/authentication/bloc/authentication/authentication_bloc.dart';
import 'package:dlchat/src/feature/authentication/data/authentication_repository.dart';
import 'package:dlchat/src/feature/authentication/model/user.dart';
import 'package:dlchat/src/feature/chat/data/chat_repository.dart';
import 'package:dlchat/src/feature/chat/data/request_counter_repository.dart';
import 'package:dlchat/src/feature/home/data/tutorial_repository.dart';
import 'package:dlchat/src/feature/initialization/initialization.dart';
import 'package:dlchat/src/feature/onboarding/data/onboarding_repository.dart';
import 'package:dlchat/src/feature/payment/data/payment_repository.dart';
import 'package:dlchat/src/feature/settings/bloc/app_settings_bloc.dart';
import 'package:dlchat/src/feature/settings/data/app_settings_datasource.dart';
import 'package:dlchat/src/feature/settings/data/app_settings_repository.dart';
import 'package:dlchat/src/feature/settings/model/app_settings.dart';
import 'package:dlchat/src/feature/system/data/app_state_repository.dart';
import 'package:dlchat/src/feature/system/data/device_info_repository.dart';
import 'package:dlchat/src/feature/transcription/data/transcription_repository.dart';
import 'package:dlchat/src/feature/user/data/user_repository.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rest_client/auth/auth_client.dart';
import 'package:rest_client/rest_client.dart';
import 'package:retrofit/retrofit.dart' as retrofit;
import 'package:shared_preferences/shared_preferences.dart';

/// {@template composition_root}
/// A place where top-level dependencies are initialized.
/// {@endtemplate}
///
/// {@template composition_process}
/// Composition of dependencies is a process of creating and configuring
/// instances of classes that are required for the application to work.
/// {@endtemplate}
final class const CompositionRoot({
  /// Application configuration.
  required final ApplicationConfig config,

  /// Logger used to log information during composition process.
  required final Logger logger,
}) {
  /// {@macro composition_root}
  this;

  /// Composes dependencies and returns the result of composition.
  Future<CompositionResult> compose() async {
    final Stopwatch stopwatch = clock.stopwatch()..start();

    logger.info('Initializing dependencies...');

    // Create the dependencies container using functions.
    final DependenciesContainer dependencies = await createDependenciesContainer(config, logger);

    stopwatch.stop();
    logger.info('Dependencies initialized successfully in ${stopwatch.elapsedMilliseconds} ms.');

    return CompositionResult(dependencies: dependencies, millisecondsSpent: stopwatch.elapsedMilliseconds);
  }
}

/// {@template composition_result}
/// Result of composition.
///
/// {@macro composition_process}
/// {@endtemplate}
final class const CompositionResult({
  /// The dependencies container.
  required final DependenciesContainer dependencies,

  /// The number of milliseconds spent composing dependencies.
  required final int millisecondsSpent,
}) {
  /// {@macro composition_result}
  this;

  @override
  String toString() =>
      'CompositionResult('
      'dependencies: $dependencies, '
      'millisecondsSpent: $millisecondsSpent'
      ')';
}

/// Creates the full dependencies container.
Future<DependenciesContainer> createDependenciesContainer(ApplicationConfig config, Logger logger) async {
  // Create or obtain the shared preferences instance.
  final sharedPreferences = SharedPreferencesAsync();
  final prefsStorage = PrefsStorage(sharedPreferences: sharedPreferences);
  final appSecureStorage = AppSecureStorage(
    secureStorage: const FlutterSecureStorage(
      // aOptions: AndroidOptions(preferencesKeyPrefix: 'dlchat'),
      // iOptions: IOSOptions(
      //   accessibility: KeychainAccessibility.first_unlock_this_device,
      //   accountName: 'flutter_secure_storage_service_dlchat',
      // ),
    ),
  );
  // Get package info.
  final PackageInfo packageInfo = await PackageInfo.fromPlatform();

  // Create the AppSettingsBloc using shared preferences.
  final AppSettingsBloc appSettingsBloc = await createAppSettingsBloc(sharedPreferences);

  // network
  final httpClient =
      Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 20),
            receiveTimeout: const Duration(seconds: 60),
            preserveHeaderCase: true,
            baseUrl: config.apiUrl,
          ),
        )
        ..transformer = BackgroundTransformer()
        ..interceptors.addAll([
          if (kDebugMode) const CarapacikDioLogger(requestHeader: false, responseHeader: false, showCurl: false),
        ]);
  final restClient = RestClient(dio: httpClient, baseUrl: config.apiUrl);

  // Authentication
  // Start
  final User seededUser = await appSecureStorage.authenticationDataSource.getUser();
  final IAuthenticationRepository authenticationRepository = AuthenticationRepository(
    authenticationDataSource: appSecureStorage.authenticationDataSource,
    authClient: restClient.authClient,
    seedValue: seededUser,
    clearStorages: () async => await [appSecureStorage.remove(), prefsStorage.remove()].wait,
  );

  httpClient.interceptors.add(
    AuthenticationInterceptor<InterceptorTokens>(
      getTokens: () async => authenticationRepository.currentUser.mapOrNull(
        authenticated: (user) => InterceptorTokens(access: user.accessToken, refresh: user.refreshToken),
      ),
      expireTokens: () async => await authenticationRepository.signOut(),
      setTokens: (data) async => await authenticationRepository.updateUser(
        User.authenticated(accessToken: data.access, refreshToken: data.refresh),
      ),
      refreshTokens: (dio) async => await AuthClient(dio).refresh().then(
        (response) => retrofit.HttpResponse(
          InterceptorTokens(access: response.data.result.accessToken, refresh: response.data.result.refreshToken),
          response.response,
        ),
      ),
      pathsToRefresh: ['/token/refresh', '/auth/logout'],
      connectionError: NavigatorHolder.showServerErrorScreen,
    ),
  );

  final IUserRepository userRepository = UserRepository(
    accountClient: restClient.accountClient,
    userDataSource: prefsStorage.userDataSource,
    clearStorages: () async => await [appSecureStorage.remove(), prefsStorage.remove()].wait,
  );
  final authenticationBloc = AuthenticationBloc(
    authenticationRepository: authenticationRepository,
    initialState: AuthenticationState.idle(seededUser),
  );
  const IDeviceInfoRepository deviceInfoRepository = DeviceInfoRepository();
  final IOnboardingRepository onboardingRepository = OnboardingRepository(
    onboardingDataSource: prefsStorage.onboardingDataSource,
  );
  final IAppStateRepository appStateRepository = AppStateRepository(stateClient: restClient.stateClient);
  final ITranscriptionsRepository transcriptionsRepository = TranscriptionsRepository(
    transcriptionsClient: restClient.transcriptionsClient,
    sendFileClient: restClient.sendFileClient,
  );
  final IChatRepository chatRepository = ChatRepository(
    chatClient: restClient.chatClient,
    chatV2Client: restClient.chatV2Client,
    sendFileClient: restClient.sendFileClient,
  );
  final IPaymentRepository paymentRepository = PaymentRepository(
    paymentClient: restClient.paymentClient,
    subscriptionClient: restClient.subscriptionClient,
  );
  final ITutorialRepository tutorialRepository = TutorialRepository(
    tutorialDataSource: prefsStorage.tutorialDataSource,
  );
  final requestCounterRepository = RequestCounterRepository(
    requestCounterDataSource: prefsStorage.requestCounterDataSource,
  );
  final reporters = <AnalyticsReporter>[];

  if (kIsWeb || Platform.isMacOS || Platform.isWindows) {
    final appMetricaApiAnalyticsReporter = AppMetricaApiAnalyticsReporter(
      logger: logger,
      metricsClient: restClient.metricsClient,
    );
    reporters.add(appMetricaApiAnalyticsReporter);
  } else if (Platform.isIOS || Platform.isAndroid) {
    await AppMetrica.activate(AppMetricaConfig(config.appMetricaKey));
    reporters.add(AppMetricaAnalyticsReporter(logger: logger));
  }

  return DependenciesContainer(
    logger: logger,
    config: config,
    packageInfo: packageInfo,
    reporters: AnalyticsEventReporter(reporters),
    appSettingsBloc: appSettingsBloc,
    authenticationBloc: authenticationBloc,
    authenticationRepository: authenticationRepository,
    appStateRepository: appStateRepository,
    deviceInfoRepository: deviceInfoRepository,
    onboardingRepository: onboardingRepository,
    paymentRepository: paymentRepository,
    userRepository: userRepository,
    chatRepository: chatRepository,
    tutorialRepository: tutorialRepository,
    transcriptionsRepository: transcriptionsRepository,
    requestCounterRepository: requestCounterRepository,
  );
}

/// Creates an instance of [Logger] and attaches any provided observers.
Logger createAppLogger({List<LogObserver> observers = const []}) {
  final logger = Logger();

  for (final observer in observers) {
    logger.addObserver(observer);
  }

  return logger;
}

/// Creates an instance of [ErrorReporter] (using Sentry) and initializes it if needed.
Future<ErrorReporter> createErrorReporter(ApplicationConfig config) async {
  final errorReporter = SentryErrorReporter(sentryDsn: config.sentryDsn, environment: config.environment.value);

  if (config.sentryDsn.isNotEmpty) {
    await errorReporter.initialize();
  }

  return errorReporter;
}

/// Creates an instance of [AppSettingsBloc].
///
/// The [AppSettingsBloc] is initialized at startup to load the app settings from local storage.
Future<AppSettingsBloc> createAppSettingsBloc(SharedPreferencesAsync sharedPreferences) async {
  final appSettingsRepository = AppSettingsRepositoryImpl(
    datasource: AppSettingsDatasourceImpl(sharedPreferences: sharedPreferences),
  );

  final AppSettings? appSettings = await appSettingsRepository.getAppSettings();
  final initialState = AppSettingsState.idle(appSettings: appSettings);

  return AppSettingsBloc(appSettingsRepository: appSettingsRepository, initialState: initialState);
}
