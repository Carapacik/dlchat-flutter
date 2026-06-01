import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:dlchat/src/core/common/version.dart';
import 'package:dlchat/src/core/exception/exception_handler.dart';
import 'package:dlchat/src/core/router/routes.dart';
import 'package:dlchat/src/feature/authentication/data/authentication_repository.dart';
import 'package:dlchat/src/feature/onboarding/data/onboarding_repository.dart';
import 'package:dlchat/src/feature/system/data/app_state_repository.dart';
import 'package:dlchat/src/feature/system/model/app_state.dart';
import 'package:dlchat/src/feature/user/data/user_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

part 'splash_bloc.freezed.dart';
part 'splash_event.dart';
part 'splash_state.dart';

final class SplashBloc({
  required final IAuthenticationRepository _authenticationRepository,
  required final IAppStateRepository _appStateRepository,
  required final PackageInfo _packageInfo,
  required final IUserRepository _userRepository,
  required final IOnboardingRepository _onboardingRepository,
}) extends Bloc<SplashEvent, SplashState> {
  this : super(const SplashState.processing()) {
    on<_SplashStarted>(_start);
  }

  Future<void> _start(_SplashStarted event, Emitter<SplashState> emitter) async {
    emitter(const SplashState.processing());
    final bool hasInternet = await InternetConnection().hasInternetAccess;
    if (!hasInternet) {
      emitter(const SplashState.failure(Routes.connectionError));
      return;
    }
    var appStates = <AppState>[];
    await ExceptionHandler.handle(() async {
      appStates = await _appStateRepository.state;
    }, onError: (exception, stackTrace) => emitter(const SplashState.failure(Routes.technicalError)));
    final AppState? appState = appStates.firstOrNull;
    if (appState != null) {
      final String appVersion = _packageInfo.version;
      if (appStates.firstWhereOrNull((v) => v.latestVersion == appVersion)?.technicalWorks ?? false) {
        emitter(const SplashState.failure(Routes.technicalError));
        return;
      }
      if (compareVersions(appVersion, appState.latestSupportedVersion) == -1) {
        emitter(SplashState.failure(Routes.updateApp, latestVersion: appState.latestSupportedVersion));
        return;
      }
      if (appStates.firstWhereOrNull((v) => v.latestVersion == appVersion)?.onValidation ?? false) {
        _appStateRepository.setOnValidation();
      }
      if (compareVersions(appVersion, appState.latestVersion) == -1) {
        _appStateRepository.setUpdateAvailable();
      }
    }

    final bool isHideOnboarding = await _onboardingRepository.isHideOnboarding();
    final String? accessToken = _authenticationRepository.currentUser.accessToken;
    if (accessToken != null) {
      await ExceptionHandler.handle(() async {
        await _authenticationRepository.refreshUser();
        emitter(SplashState.success(_routeResult(isAuth: true, isHideOnboarding: isHideOnboarding)));
      });
    } else {
      await _authenticationRepository.signOut();
      await _userRepository.removeLocalUser();
      emitter(SplashState.failure(_routeResult(isAuth: false, isHideOnboarding: isHideOnboarding)));
    }
  }

  Routes _routeResult({required bool isAuth, required bool isHideOnboarding}) {
    final bool isDesktop = kIsWeb || Platform.isMacOS || Platform.isWindows || Platform.isLinux;
    if (isHideOnboarding) {
      return isAuth ? Routes.home : Routes.signIn;
    }
    return isAuth
        ? Routes.onboarding
        : isDesktop
        ? Routes.signIn
        : Routes.onboarding;
  }
}
