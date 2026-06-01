import 'dart:async' show runZonedGuarded;
import 'dart:io' show Platform;

import 'package:dlchat/src/core/common/common.dart'
    deferred as common
    show AppBlocObserver, ErrorReporterLogObserver, SequentialBlocTransformer;
import 'package:dlchat/src/core/common/error_reporter/error_reporter.dart';
import 'package:dlchat/src/core/components/url_strategy/url_strategy.dart' deferred as url_strategy show setUrlStrategy;
import 'package:dlchat/src/core/constant/constants.dart' deferred as constants show ApplicationConfig;
import 'package:dlchat/src/feature/initialization/initialization.dart'
    deferred as initialization
    show CompositionRoot, InitializationFailedApp, RootContext, createAppLogger, createErrorReporter;
import 'package:dlchat/src/feature/initialization/logic/composition_root.dart';
import 'package:flutter/foundation.dart' deferred as foundation show kIsWeb, kReleaseMode;
import 'package:flutter/widgets.dart'
    deferred as widgets
    show FlutterError, Size, WidgetsBinding, WidgetsFlutterBinding, runApp;
import 'package:flutter_bloc/flutter_bloc.dart' deferred as bloc show Bloc;
import 'package:logger/logger.dart' deferred as log show LogLevel, PrintingLogObserver;
import 'package:logger/logger.dart' show Logger;
import 'package:window_manager/window_manager.dart' deferred as window_manager show WindowOptions, windowManager;

/// {@template app_runner}
/// A class that is responsible for running the application.
/// {@endtemplate}
sealed class const AppRunner._() {
  /// {@macro app_runner}
  this;

  /// Initializes dependencies and launches the application within a guarded execution zone.
  static Future<void> startup() async {
    await widgets.loadLibrary();
    await log.loadLibrary();
    await foundation.loadLibrary();
    await initialization.loadLibrary();
    await constants.loadLibrary();

    final config = constants.ApplicationConfig();
    final Logger logger = initialization.createAppLogger(
      observers: [if (!foundation.kReleaseMode) log.PrintingLogObserver(logLevel: log.LogLevel.trace)],
    );

    await runZonedGuarded(() async {
      // Ensure Flutter is initialized
      widgets.WidgetsFlutterBinding.ensureInitialized();
      final ErrorReporter errorReporter = await initialization.createErrorReporter(config);
      await common.loadLibrary();
      logger.addObserver(common.ErrorReporterLogObserver(errorReporter));

      // Configure global error interception
      widgets.FlutterError.onError = logger.logFlutterError;
      widgets.WidgetsBinding.instance.platformDispatcher.onError = logger.logPlatformDispatcherError;

      // Setup bloc observer and transformer
      await bloc.loadLibrary();
      await common.loadLibrary();
      bloc.Bloc.observer = common.AppBlocObserver(logger);
      bloc.Bloc.transformer = common.SequentialBlocTransformer<Object?>().transform;

      if (foundation.kIsWeb) {
        await url_strategy.loadLibrary();
        url_strategy.setUrlStrategy();
      }

      if (!foundation.kIsWeb && Platform.isMacOS) {
        await window_manager.loadLibrary();
        await window_manager.windowManager.ensureInitialized();
        final windowOptions = window_manager.WindowOptions(
          minimumSize: widgets.Size(360, 600),
          size: widgets.Size(1280, 760),
          center: true,
          skipTaskbar: false,
        );
        await window_manager.windowManager.waitUntilReadyToShow(windowOptions, () async {
          await window_manager.windowManager.show();
          await window_manager.windowManager.focus();
        });
      }

      Future<void> launchApplication() async {
        try {
          final CompositionResult compositionResult = await initialization.CompositionRoot(
            config: config,
            logger: logger,
          ).compose();

          widgets.runApp(initialization.RootContext(compositionResult: compositionResult));
        } on Object catch (e, stackTrace) {
          logger.error('Initialization failed', error: e, stackTrace: stackTrace);
          widgets.runApp(
            initialization.InitializationFailedApp(
              error: e,
              stackTrace: stackTrace,
              onRetryInitialization: launchApplication,
            ),
          );
        }
      }

      // Launch the application
      await launchApplication();
    }, logger.logZoneError);
  }
}
