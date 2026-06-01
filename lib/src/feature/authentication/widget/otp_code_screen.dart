import 'dart:async';
import 'dart:io';

import 'package:dlchat/src/core/common/extensions/extensions.dart';
import 'package:dlchat/src/core/common/layout/layout.dart';
import 'package:dlchat/src/core/constant/generated/fonts.gen.dart';
import 'package:dlchat/src/core/resources/resources.dart';
import 'package:dlchat/src/core/router/routes.dart';
import 'package:dlchat/src/feature/authentication/bloc/otp_code/otp_code_bloc.dart';
import 'package:dlchat/src/feature/onboarding/data/onboarding_repository.dart';
import 'package:dlchat/src/feature/shared_widgets/base/app_bar.dart';
import 'package:dlchat/src/feature/shared_widgets/base/snack_bar.dart';
import 'package:dlchat/src/feature/shared_widgets/button/countdown_button.dart';
import 'package:dlchat/src/feature/shared_widgets/custom/gradient_painter.dart';
import 'package:dlchat/src/feature/shared_widgets/loading/full_screen_loading.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

class const OtpCodeScreen({required final String phone, super.key}) extends StatefulWidget {
  @override
  State<OtpCodeScreen> createState() => _OtpCodeScreenState();
}

class _OtpCodeScreenState() extends State<OtpCodeScreen> {
  late final _codeController = TextEditingController();
  late final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSizeScope.of(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BlocConsumer<OtpCodeBloc, OtpCodeState>(
        listener: (context, state) async {
          switch (state) {
            case final OtpCodeFailure s:
              _codeController.clear();
              showCustomAppException(context, s.exception);
            case final OtpCodeSuccess _:
              final GoRouter router = GoRouter.of(context);
              final IOnboardingRepository onboardingRepository = context.dependencies.onboardingRepository;
              await Future<void>.delayed(const Duration(milliseconds: 300)).then((value) async {
                if (kIsWeb || Platform.isMacOS || Platform.isWindows) {
                  final bool isHideOnboarding = await onboardingRepository.isHideOnboarding();
                  if (!isHideOnboarding) {
                    router.goNamed(Routes.onboarding.name);
                    return;
                  }
                }
                router.goNamed(Routes.home.name);
              });
            default:
          }
        },
        builder: (context, state) {
          return FullScreenLoading(
            inProgress: state.inProgress,
            child: Scaffold(
              appBar: buildPlatformAppBar(
                context,
                title: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => context.goNamed(Routes.signIn.name),
                  child: const MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Text('DLCHAT', style: AppTypography.headerMedium),
                  ),
                ),
              ),
              extendBodyBehindAppBar: true,
              body: ChatGradient(
                children: [
                  SafeArea(
                    child: Center(
                      child: Column(
                        children: [
                          if (windowSize.isCompact) const SizedBox(height: 16) else const Spacer(),
                          const Text(
                            'Введите код',
                            style: TextStyle(fontFamily: FontFamily.sFNSExpanded, fontSize: 24),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Код придёт в течение минуты на номер\n',
                                    style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                                  ),
                                  TextSpan(
                                    text: formatAsPhoneNumber(widget.phone) ?? '',
                                    style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Center(
                            child: _OtpTextField(controller: _codeController, focusNode: _focusNode),
                          ),
                          if (windowSize.isCompact) const Spacer() else const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            child: CountdownButton(
                              onPressed: () => context.read<OtpCodeBloc>().add(const OtpCodeEvent.resend()),
                            ),
                          ),
                          if (windowSize.isCompact) const SizedBox(height: 16) else const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class const _OtpTextField({required final TextEditingController controller, required final FocusNode focusNode})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSizeScope.of(context);
    final defaultPinTheme = PinTheme(
      width: windowSize.maybeMap(compact: () => 44, orElse: () => 52),
      height: windowSize.maybeMap(compact: () => 58, orElse: () => 72),
      textStyle: AppTypography.headerSemibold,
      decoration: BoxDecoration(color: AppColors.bgInputPrimary, borderRadius: BorderRadius.circular(6)),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Pinput(
        length: 6,
        controller: controller,
        focusNode: focusNode,
        autofocus: true,
        showCursor: false,
        onChanged: (code) {
          if (code.length == 6) {
            context.read<OtpCodeBloc>().add(
              OtpCodeEvent.verifyPressed(
                code,
                '${MediaQuery.sizeOf(context).width.toInt()}x${MediaQuery.sizeOf(context).height.toInt()}',
              ),
            );
          }
        },
        defaultPinTheme: defaultPinTheme,
        focusedPinTheme: defaultPinTheme,
      ),
    );
  }
}
