import 'package:dlchat/src/core/common/layout/layout.dart';
import 'package:dlchat/src/core/resources/resources.dart';
import 'package:dlchat/src/core/router/routes.dart';
import 'package:dlchat/src/feature/authentication/bloc/sign_in/sign_in_bloc.dart';
import 'package:dlchat/src/feature/authentication/model/input_phone_data.dart';
import 'package:dlchat/src/feature/shared_widgets/base/app_bar.dart';
import 'package:dlchat/src/feature/shared_widgets/base/snack_bar.dart';
import 'package:dlchat/src/feature/shared_widgets/button/filled_button.dart';
import 'package:dlchat/src/feature/shared_widgets/custom/gradient_painter.dart';
import 'package:dlchat/src/feature/shared_widgets/loading/full_screen_loading.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class const SignInScreen({super.key}) extends StatefulWidget {
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState() extends State<SignInScreen> {
  late final TextEditingController _phoneController = TextEditingController();
  late final _phoneError = ValueNotifier<String?>(null);
  PhoneCountryData? _countryData = PhoneCodes.getPhoneCountryDataByCountryCode('RU');
  static const _countryIsoCodes = ['AZ', 'AM', 'BY', 'GE', 'KZ', 'KG', 'MD', 'RU', 'TJ', 'TM', 'UA', 'UZ'];

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneError.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSizeScope.of(context);
    final phoneTextField = _PhoneTextField(controller: _phoneController, countryData: _countryData);
    return BlocConsumer<SignInBloc, SignInState>(
      listener: (context, state) {
        switch (state) {
          case final SignInFailure s:
            showCustomAppException(context, s.exception);
          case final SignInSuccess s:
            context.goNamed(Routes.otpCode.name, queryParameters: {'phone': s.phone});
          default:
        }
      },
      builder: (context, state) {
        return FullScreenLoading(
          inProgress: state.inProgress,
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Scaffold(
              appBar: buildPlatformAppBar(
                context,
                automaticallyImplyLeading: false,
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          if (windowSize.isCompact) const SizedBox(height: 16) else const Spacer(),
                          const Text('Вход', style: AppTypography.headerMedium),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              'Войдите в существующий аккаунт\nили создайте новый',
                              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Center(
                            child: SizedBox(
                              height: 56,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 120,
                                    child: CountryDropdown(
                                      printCountryName: true,
                                      iconSize: 0,
                                      elevation: 4,
                                      initialCountryData: _countryData,
                                      filter: PhoneCodes.findCountryDatasByCountryCodes(
                                        countryIsoCodes: _countryIsoCodes,
                                      ),
                                      style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(color: AppColors.textPrimary),
                                          borderRadius: BorderRadius.circular(32),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(color: AppColors.textPrimary),
                                          borderRadius: BorderRadius.circular(32),
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                                        filled: true,
                                        fillColor: AppColors.bgInputPrimary,
                                      ),
                                      onCountrySelected: (data) => setState(() => _countryData = data),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  if (windowSize.isCompact)
                                    Expanded(child: phoneTextField)
                                  else
                                    ConstrainedBox(
                                      constraints: const BoxConstraints(maxWidth: 230),
                                      child: phoneTextField,
                                    ),
                                ],
                              ),
                            ),
                          ),
                          if (windowSize.isCompact) const Spacer() else const SizedBox(height: 32),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 375),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Продолжая, вы соглашаетесь с ',
                                    style: AppTypography.bodyRegular.copyWith(color: AppColors.textTertiary),
                                  ),
                                  TextSpan(
                                    text: 'Политикой конфиденциальности',
                                    style: AppTypography.bodyRegular.copyWith(color: AppColors.textPrimary),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async =>
                                          await launchUrl(Uri.parse('https://diglab.ru/dlchat/privacy-policy/')),
                                  ),
                                  TextSpan(
                                    text: ' и ',
                                    style: AppTypography.bodyRegular.copyWith(color: AppColors.textTertiary),
                                  ),
                                  TextSpan(
                                    text: 'Пользовательским соглашением',
                                    style: AppTypography.bodyRegular.copyWith(color: AppColors.textPrimary),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async =>
                                          await launchUrl(Uri.parse('https://diglab.ru/dlchat/user-agreement/')),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: windowSize.maybeMap(compact: () => double.infinity, orElse: () => 375),
                            child: ListenableBuilder(
                              listenable: _phoneController,
                              builder: (context, child) => CustomFilledButton(
                                onPressed: _phoneController.text.trim().isNotEmpty
                                    ? () => _onSubmitted(context, SignInType.telegram)
                                    : null,
                                text: 'Получить код в Telegram',
                              ),
                            ),
                          ),
                          if (_countryData?.countryCode == 'RU')
                            ListenableBuilder(
                              listenable: _phoneController,
                              builder: (context, child) => TextButton(
                                onPressed: _phoneController.text.trim().isNotEmpty
                                    ? () => _onSubmitted(context, SignInType.sms)
                                    : null,
                                child: const Text('Получить код в СМС', style: TextStyle(fontSize: 12)),
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
          ),
        );
      },
    );
  }

  late final List<String? Function(InputPhoneData data)> _validators = [
    (data) => _phoneError.value = data.isValidPhone(context),
  ];

  bool _validate(BuildContext context, InputPhoneData data) {
    var result = true;
    String? message;
    for (final String? Function(InputPhoneData data) validator in _validators) {
      final String? validMessage = validator(data);
      if (validMessage != null) {
        result = false;
        message = validMessage;
      }
    }
    if (message != null) {
      showErrorMessage(context, message);
    }
    return result;
  }

  void _onSubmitted(BuildContext context, SignInType type) {
    final data = InputPhoneData(
      phone: _phoneController.text.trim(),
      countryNumber: _countryData?.phoneCode ?? '',
      countryCode: _countryData?.countryCode ?? '',
      signInType: type,
    );
    if (!_validate(context, data)) {
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    context.read<SignInBloc>().add(SignInEvent.sendPhone(data.fullPhone, data.signInType));
  }
}

class const _PhoneTextField({
  required final TextEditingController controller,
  required final PhoneCountryData? countryData,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextField(
        controller: controller,
        textInputAction: TextInputAction.send,
        keyboardType: TextInputType.phone,
        style: AppTypography.bodyMedium,
        inputFormatters: [PhoneInputFormatter(defaultCountryCode: countryData?.countryCode)],
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16),
          filled: true,
          fillColor: AppColors.bgInputPrimary,
          hintText: countryData?.phoneMaskWithoutCountryCode,
          hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textTertiary),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.textPrimary),
            borderRadius: BorderRadius.circular(32),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.textPrimary),
            borderRadius: BorderRadius.circular(32),
          ),
          suffixIcon: ListenableBuilder(
            listenable: controller,
            builder: (context, child) => controller.text.isNotEmpty
                ? IconButton(
                    onPressed: controller.clear,
                    visualDensity: VisualDensity.compact,
                    splashRadius: 24,
                    icon: const Icon(Icons.close),
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}
