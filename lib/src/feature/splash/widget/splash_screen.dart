import 'dart:async';

import 'package:dlchat/src/core/common/extensions/extensions.dart';
import 'package:dlchat/src/core/constant/generated/assets.gen.dart';
import 'package:dlchat/src/core/resources/resources.dart';
import 'package:dlchat/src/core/router/routes.dart';
import 'package:dlchat/src/feature/splash/bloc/splash_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class const SplashScreen({super.key}) extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState() extends State<SplashScreen> {
  late final SplashBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = SplashBloc(
      appStateRepository: context.dependencies.appStateRepository,
      authenticationRepository: context.dependencies.authenticationRepository,
      packageInfo: context.dependencies.packageInfo,
      userRepository: context.dependencies.userRepository,
      onboardingRepository: context.dependencies.onboardingRepository,
    )..add(const SplashEvent.start());
  }

  @override
  void dispose() {
    unawaited(_bloc.close());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      bloc: _bloc,
      listener: (context, state) {
        switch (state) {
          case final SplashFailure s:
            if (s.route == Routes.updateApp) {
              context.goNamed(Routes.updateApp.name, queryParameters: {'latestVersion': s.latestVersion});
            } else {
              context.goNamed(s.route.name);
            }
          case final SplashSuccess s:
            context.goNamed(s.route.name);
          default:
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            DecoratedBox(
              decoration: const BoxDecoration(gradient: LinearGradient(colors: AppColors.gradientDLChat)),
              child: Center(
                child: SizedBox.square(dimension: 240, child: SvgPicture.asset(Assets.svg.dlchatSplash.path)),
              ),
            ),
            SizedBox.expand(child: ColoredBox(color: AppColors.white.withValues(alpha: 0.3))),
          ],
        ),
      ),
    );
  }
}
