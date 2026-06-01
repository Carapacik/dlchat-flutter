import 'package:dlchat/src/core/common/extensions/extensions.dart';
import 'package:dlchat/src/core/router/navigator_holder.dart';
import 'package:dlchat/src/core/router/path_params.dart';
import 'package:dlchat/src/core/router/routes.dart';
import 'package:dlchat/src/feature/authentication/bloc/otp_code/otp_code_bloc.dart';
import 'package:dlchat/src/feature/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:dlchat/src/feature/authentication/widget/authentication_scope.dart';
import 'package:dlchat/src/feature/authentication/widget/otp_code_screen.dart';
import 'package:dlchat/src/feature/authentication/widget/sign_in_screen.dart';
import 'package:dlchat/src/feature/chat/bloc/audio_message/audio_message_bloc.dart';
import 'package:dlchat/src/feature/chat/bloc/chat/chat_bloc.dart';
import 'package:dlchat/src/feature/chat/model/text_field_padding.dart';
import 'package:dlchat/src/feature/chat/widget/chat_screen.dart';
import 'package:dlchat/src/feature/chats/widget/chats_screen.dart';
import 'package:dlchat/src/feature/home/widget/home_screen.dart';
import 'package:dlchat/src/feature/home/widget/main_screen.dart';
import 'package:dlchat/src/feature/nutritionist/widget/nutritionist_filling_data_screen.dart';
import 'package:dlchat/src/feature/nutritionist/widget/nutritionist_onboarding_screen.dart';
import 'package:dlchat/src/feature/onboarding/widget/onboarding_screen.dart';
import 'package:dlchat/src/feature/payment/widget/binding_cards_screen.dart';
import 'package:dlchat/src/feature/payment/widget/payment_result_screen.dart';
import 'package:dlchat/src/feature/payment/widget/payment_webview.dart';
import 'package:dlchat/src/feature/payment/widget/rates_screen.dart';
import 'package:dlchat/src/feature/settings/widget/faq_screen.dart';
import 'package:dlchat/src/feature/settings/widget/settings_screen.dart';
import 'package:dlchat/src/feature/splash/widget/splash_screen.dart';
import 'package:dlchat/src/feature/system/widget/connection_error_screen.dart';
import 'package:dlchat/src/feature/system/widget/technical_error_screen.dart';
import 'package:dlchat/src/feature/system/widget/update_app_screen.dart';
import 'package:dlchat/src/feature/transcription/bloc/detail_transcription/detail_transcription_bloc.dart';
import 'package:dlchat/src/feature/transcription/bloc/transcriptions/transcriptions_bloc.dart';
import 'package:dlchat/src/feature/transcription/widget/detail_transcription_screen.dart';
import 'package:dlchat/src/feature/transcription/widget/transcriptions_list_screen.dart';
import 'package:dlchat/src/feature/transcription/widget/transcriptions_onboarding_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

mixin RouterStateMixin<T extends StatefulWidget> on State<T> {
  late final GoRouter router;

  final GlobalKey<NavigatorState> _rootKey = NavigatorHolder.rootNavigatorKey;
  final _shellNavigatorHomeScreenKey = GlobalKey<NavigatorState>(debugLabel: 'home');
  final _shellNavigatorChatScreenKey = GlobalKey<NavigatorState>(debugLabel: 'chats');
  final _shellNavigatorSettingsScreenKey = GlobalKey<NavigatorState>(debugLabel: 'settings');
  final GlobalKey<State<StatefulWidget>> _mainScreenKey = GlobalKey(debugLabel: 'main');

  @override
  void initState() {
    super.initState();
    router = GoRouter(
      navigatorKey: _rootKey,
      debugLogDiagnostics: kDebugMode,
      initialLocation: Routes.splash.path,
      restorationScopeId: 'ru.diglab.DLChat',
      redirect: (context, state) {
        final bool isAuthenticated = AuthenticationScope.userOf(context, listen: false).isAuthenticated;
        final List<String> unAuthScreens = [
          '/',
          Routes.splash.path,
          Routes.onboarding.path,
          Routes.signIn.path,
          '${Routes.signIn.path}/${Routes.otpCode.path}',
          Routes.connectionError.path,
          Routes.technicalError.path,
          Routes.updateApp.path,
        ];
        if (unAuthScreens.contains(state.fullPath?.split('?').first)) {
          return null;
        }
        if (!isAuthenticated) {
          return Routes.splash.path;
        }
        return null;
      },
      errorBuilder: (context, state) => const TechnicalErrorScreen(knownError: true),
      routes: [
        GoRoute(
          name: Routes.splash.name,
          path: Routes.splash.path,
          pageBuilder: (context, state) => const NoTransitionPage(child: SplashScreen()),
          parentNavigatorKey: _rootKey,
        ),
        GoRoute(
          name: Routes.onboarding.name,
          path: Routes.onboarding.path,
          builder: (context, state) => const OnboardingScreen(),
          parentNavigatorKey: _rootKey,
        ),
        GoRoute(
          name: Routes.signIn.name,
          path: Routes.signIn.path,
          parentNavigatorKey: _rootKey,
          builder: (context, state) => BlocProvider(
            create: (context) => SignInBloc(authenticationRepository: context.dependencies.authenticationRepository),
            child: const SignInScreen(),
          ),
          routes: [
            GoRoute(
              name: Routes.otpCode.name,
              path: Routes.otpCode.path,
              builder: (context, state) {
                final String phone = state.uri.queryParameters['phone'] ?? '';
                return BlocProvider(
                  create: (context) => OtpCodeBloc(
                    phone: phone,
                    authenticationRepository: context.dependencies.authenticationRepository,
                    userRepository: context.dependencies.userRepository,
                    deviceInfoRepository: context.dependencies.deviceInfoRepository,
                    packageInfo: context.dependencies.packageInfo,
                  ),
                  child: OtpCodeScreen(phone: phone),
                );
              },
            ),
          ],
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) =>
              MainScreen(navigationShell: navigationShell, key: _mainScreenKey),
          branches: [
            StatefulShellBranch(
              navigatorKey: _shellNavigatorHomeScreenKey,
              routes: [
                GoRoute(
                  name: Routes.home.name,
                  path: Routes.home.path,
                  pageBuilder: (context, state) => const NoTransitionPage(child: HomeScreen()),
                  routes: [
                    GoRoute(
                      name: Routes.chatNested.name,
                      path: Routes.chatNested.path,
                      builder: (context, state) {
                        final String chatId = state.pathParameters[RouteParams.id.path]!;
                        return MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create: (context) => ChatBloc(
                                chatRepository: context.dependencies.chatRepository,
                                requestCounterRepository: context.dependencies.requestCounterRepository,
                              )..add(ChatEvent.start(chatId)),
                            ),
                            BlocProvider(
                              create: (context) => AudioMessageBloc(
                                authenticationRepository: context.dependencies.authenticationRepository,
                                chatRepository: context.dependencies.chatRepository,
                                chatId: chatId,
                              ),
                            ),
                            ChangeNotifierProvider(create: (_) => TextFieldPadding()),
                          ],
                          child: ChatScreen(mainScreenKey: _mainScreenKey),
                        );
                      },
                    ),
                    GoRoute(
                      name: Routes.transcriptionsOnboardingNested.name,
                      path: Routes.transcriptionsOnboardingNested.path,
                      builder: (context, state) => const TranscriptionsOnboardingScreen(),
                    ),
                    GoRoute(
                      name: Routes.transcriptionsNested.name,
                      path: Routes.transcriptionsNested.path,
                      builder: (context, state) => MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            lazy: false,
                            create: (context) => TranscriptionsBloc(
                              transcriptionsRepository: context.dependencies.transcriptionsRepository,
                              chatRepository: context.dependencies.chatRepository,
                            ),
                          ),
                        ],
                        child: const TranscriptionsScreen(),
                      ),
                      routes: [
                        GoRoute(
                          name: Routes.detailTranscriptionNested.name,
                          path: Routes.detailTranscriptionNested.path,
                          builder: (context, state) => BlocProvider(
                            lazy: false,
                            create: (context) => DetailTranscriptionBloc(
                              transcriptionId: state.pathParameters['id']!,
                              transcriptionsRepository: context.dependencies.transcriptionsRepository,
                            ),
                            child: DetailTranscriptionScreen(name: state.uri.queryParameters['name'] ?? ''),
                          ),
                        ),
                      ],
                    ),
                    GoRoute(
                      name: Routes.nutritionistFillingDataNested.name,
                      path: Routes.nutritionistFillingDataNested.path,
                      builder: (context, state) => const NutritionistFillingDataScreen(),
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _shellNavigatorChatScreenKey,
              routes: [
                GoRoute(
                  name: Routes.chats.name,
                  path: Routes.chats.path,
                  pageBuilder: (context, state) => const NoTransitionPage(child: ChatsScreen()),
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: _shellNavigatorSettingsScreenKey,
              routes: [
                GoRoute(
                  name: Routes.settings.name,
                  path: Routes.settings.path,
                  pageBuilder: (context, state) => const NoTransitionPage(child: SettingsScreen()),
                  routes: [
                    GoRoute(
                      name: Routes.bingingCardsNested.name,
                      path: Routes.bingingCardsNested.path,
                      builder: (context, state) => const BindingCardsScreen(),
                    ),
                    GoRoute(
                      name: Routes.faqNested.name,
                      path: Routes.faqNested.path,
                      builder: (context, state) => const FaqScreen(),
                    ),
                    GoRoute(
                      name: Routes.ratesNested.name,
                      path: Routes.ratesNested.path,
                      builder: (context, state) => const RatesScreen(),
                      routes: [
                        GoRoute(
                          name: Routes.paymentWebViewNested.name,
                          path: Routes.paymentWebViewNested.path,
                          builder: (context, state) => PaymentWebView(url: state.uri.queryParameters['url']!),
                        ),
                        GoRoute(
                          name: Routes.paymentResultNested.name,
                          path: Routes.paymentResultNested.path,
                          builder: (context, state) =>
                              PaymentResultScreen(successResult: state.pathParameters['result']! == 'success'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          name: Routes.bingingCards.name,
          path: Routes.bingingCards.path,
          parentNavigatorKey: _rootKey,
          builder: (context, state) => const BindingCardsScreen(),
        ),
        GoRoute(
          name: Routes.faq.name,
          path: Routes.faq.path,
          parentNavigatorKey: _rootKey,
          builder: (context, state) => const FaqScreen(),
        ),
        GoRoute(
          name: Routes.chat.name,
          path: Routes.chat.path,
          parentNavigatorKey: _rootKey,
          builder: (context, state) {
            final String chatId = state.pathParameters[RouteParams.id.path]!;
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => ChatBloc(
                    chatRepository: context.dependencies.chatRepository,
                    requestCounterRepository: context.dependencies.requestCounterRepository,
                  )..add(ChatEvent.start(chatId)),
                ),
                BlocProvider(
                  create: (context) => AudioMessageBloc(
                    authenticationRepository: context.dependencies.authenticationRepository,
                    chatRepository: context.dependencies.chatRepository,
                    chatId: chatId,
                  ),
                ),
                ChangeNotifierProvider(create: (_) => TextFieldPadding()),
              ],
              child: const ChatScreen(),
            );
          },
        ),
        GoRoute(
          name: Routes.rates.name,
          path: Routes.rates.path,
          parentNavigatorKey: _rootKey,
          builder: (context, state) => const RatesScreen(),
          routes: [
            GoRoute(
              name: Routes.paymentWebView.name,
              path: Routes.paymentWebView.path,
              parentNavigatorKey: _rootKey,
              builder: (context, state) => PaymentWebView(url: state.uri.queryParameters['url']!),
            ),
            GoRoute(
              name: Routes.paymentResult.name,
              path: Routes.paymentResult.path,
              parentNavigatorKey: _rootKey,
              builder: (context, state) =>
                  PaymentResultScreen(successResult: state.pathParameters['result']! == 'success'),
            ),
          ],
        ),
        GoRoute(
          name: Routes.transcriptionsOnboarding.name,
          path: Routes.transcriptionsOnboarding.path,
          builder: (context, state) => const TranscriptionsOnboardingScreen(),
          parentNavigatorKey: _rootKey,
        ),
        GoRoute(
          name: Routes.transcriptions.name,
          path: Routes.transcriptions.path,
          builder: (context, state) => MultiBlocProvider(
            providers: [
              BlocProvider(
                lazy: false,
                create: (context) => TranscriptionsBloc(
                  transcriptionsRepository: context.dependencies.transcriptionsRepository,
                  chatRepository: context.dependencies.chatRepository,
                ),
              ),
            ],
            child: const TranscriptionsScreen(),
          ),
          parentNavigatorKey: _rootKey,
        ),
        GoRoute(
          name: Routes.detailTranscription.name,
          path: Routes.detailTranscription.path,
          builder: (context, state) => BlocProvider(
            lazy: false,
            create: (context) => DetailTranscriptionBloc(
              transcriptionId: state.pathParameters['id']!,
              transcriptionsRepository: context.dependencies.transcriptionsRepository,
            ),
            child: DetailTranscriptionScreen(name: state.uri.queryParameters['name'] ?? ''),
          ),
          parentNavigatorKey: _rootKey,
        ),
        GoRoute(
          name: Routes.nutritionistOnboarding.name,
          path: Routes.nutritionistOnboarding.path,
          builder: (context, state) => const NutritionistOnboardingScreen(),
          parentNavigatorKey: _rootKey,
        ),
        GoRoute(
          name: Routes.nutritionistFillingData.name,
          path: Routes.nutritionistFillingData.path,
          builder: (context, state) => const NutritionistFillingDataScreen(),
          parentNavigatorKey: _rootKey,
        ),
        GoRoute(
          name: Routes.connectionError.name,
          path: Routes.connectionError.path,
          parentNavigatorKey: _rootKey,
          pageBuilder: (context, state) => const NoTransitionPage(child: ConnectionErrorScreen()),
        ),
        GoRoute(
          name: Routes.technicalError.name,
          path: Routes.technicalError.path,
          parentNavigatorKey: _rootKey,
          pageBuilder: (context, state) => NoTransitionPage(
            child: TechnicalErrorScreen(
              knownError: bool.tryParse(state.uri.queryParameters['knownError'] ?? '') ?? false,
            ),
          ),
        ),
        GoRoute(
          name: Routes.updateApp.name,
          path: Routes.updateApp.path,
          parentNavigatorKey: _rootKey,
          pageBuilder: (context, state) =>
              NoTransitionPage(child: UpdateAppScreen(latestVersion: state.uri.queryParameters['latestVersion']!)),
        ),
      ],
    );
  }
}
