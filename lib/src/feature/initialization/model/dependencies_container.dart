import 'package:dlchat/src/core/common/analytics/analytics.dart';
import 'package:dlchat/src/core/constant/application_config.dart';
import 'package:dlchat/src/feature/authentication/bloc/authentication/authentication_bloc.dart';
import 'package:dlchat/src/feature/authentication/data/authentication_repository.dart';
import 'package:dlchat/src/feature/chat/data/chat_repository.dart';
import 'package:dlchat/src/feature/chat/data/request_counter_repository.dart';
import 'package:dlchat/src/feature/home/data/tutorial_repository.dart';
import 'package:dlchat/src/feature/onboarding/data/onboarding_repository.dart';
import 'package:dlchat/src/feature/payment/data/payment_repository.dart';
import 'package:dlchat/src/feature/settings/bloc/app_settings_bloc.dart';
import 'package:dlchat/src/feature/system/data/app_state_repository.dart';
import 'package:dlchat/src/feature/system/data/device_info_repository.dart';
import 'package:dlchat/src/feature/transcription/data/transcription_repository.dart';
import 'package:dlchat/src/feature/user/data/user_repository.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// {@template dependencies}
/// Dependencies container
/// {@endtemplate}
base class const DependenciesContainer({
  /// [Logger] instance, used to log messages.
  required final Logger logger,

  /// [ApplicationConfig] instance, contains configuration of the application.
  required final ApplicationConfig config,

  /// [PackageInfo] instance, contains information about the application.
  required final PackageInfo packageInfo,
  required final AnalyticsEventReporter reporters,
  required final AppSettingsBloc appSettingsBloc,
  required final AuthenticationBloc authenticationBloc,
  required final IAuthenticationRepository authenticationRepository,
  required final IAppStateRepository appStateRepository,
  required final IUserRepository userRepository,
  required final IChatRepository chatRepository,
  required final IDeviceInfoRepository deviceInfoRepository,
  required final IOnboardingRepository onboardingRepository,
  required final ITutorialRepository tutorialRepository,
  required final IPaymentRepository paymentRepository,
  required final ITranscriptionsRepository transcriptionsRepository,
  required final RequestCounterRepository requestCounterRepository,
}) {
  /// {@macro dependencies}
  this;

  // final ErrorTrackingManager errorTrackingManager;
}
