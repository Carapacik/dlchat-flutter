import 'package:dlchat/src/core/common/extensions/extensions.dart';
import 'package:dlchat/src/core/common/layout/layout.dart';
import 'package:dlchat/src/core/common/store_validation.dart';
import 'package:dlchat/src/core/constant/generated/assets.gen.dart';
import 'package:dlchat/src/core/resources/resources.dart';
import 'package:dlchat/src/core/router/routes.dart';
import 'package:dlchat/src/feature/authentication/bloc/authentication/authentication_bloc.dart';
import 'package:dlchat/src/feature/authentication/widget/authentication_scope.dart';
import 'package:dlchat/src/feature/payment/bloc/binding_cards/binding_cards_bloc.dart';
import 'package:dlchat/src/feature/payment/bloc/frozen_rates/frozen_rates_bloc.dart';
import 'package:dlchat/src/feature/payment/bloc/payment/payment_bloc.dart';
import 'package:dlchat/src/feature/payment/bloc/rates/rates_bloc.dart';
import 'package:dlchat/src/feature/payment/bloc/remaining/remaining_bloc.dart';
import 'package:dlchat/src/feature/payment/bloc/user_rate/user_rate_bloc.dart';
import 'package:dlchat/src/feature/payment/model/rate.dart';
import 'package:dlchat/src/feature/payment/model/user_rate.dart';
import 'package:dlchat/src/feature/payment/widget/rate_card.dart';
import 'package:dlchat/src/feature/profile/bloc/profile_bloc.dart';
import 'package:dlchat/src/feature/shared_widgets/base/app_bar.dart';
import 'package:dlchat/src/feature/shared_widgets/button/circle_icon_button.dart';
import 'package:dlchat/src/feature/shared_widgets/button/filled_button.dart';
import 'package:dlchat/src/feature/shared_widgets/button/filled_tonal_button.dart';
import 'package:dlchat/src/feature/shared_widgets/button/rate_badge.dart';
import 'package:dlchat/src/feature/shared_widgets/loading/shimmer.dart';
import 'package:dlchat/src/feature/shared_widgets/modal/alert_dialog.dart';
import 'package:dlchat/src/feature/shared_widgets/modal/bottom_sheet.dart';
import 'package:dlchat/src/feature/user/data/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class const SettingsScreen({super.key}) extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState() extends State<SettingsScreen> {
  late final IUserRepository _userRepository = context.dependencies.userRepository;

  String? _phone;

  @override
  void initState() {
    super.initState();
    context.read<BindingCardsBloc>().add(const BindingCardsEvent.start());
    context.read<FrozenRatesBloc>().add(const FrozenRatesEvent.start());
    context.read<RatesBloc>().add(const RatesEvent.start());
    context.read<RemainingBloc>().add(const RemainingEvent.start());

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final String? phone = await _userRepository.phone;
      setState(() {
        _phone = phone;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSizeScope.of(context);
    return Scaffold(
      appBar: buildPlatformAppBar(
        context,
        automaticallyImplyLeading: false,
        titleText: 'Настройки',
        actions: [const RateBadge()],
      ),
      body: ListView(
        padding: windowSize.isLargeOrLarger
            ? EdgeInsets.fromLTRB(24, 24, 24, 24 + MediaQuery.paddingOf(context).bottom)
            : EdgeInsets.fromLTRB(16, 8, 16, 24 + MediaQuery.paddingOf(context).bottom),
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text('ОСНОВНОЕ', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _SettingsBlock(
              tiles: [
                _TextTileWidget(
                  title: formatAsPhoneNumber(_phone ?? '') ?? '',
                  icon: Assets.svg.settingsPerson.svg(height: 44),
                ),
              ],
            ),
          ),
          if (!StoreValidation.hidePayments(context, _phone))
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: BlocBuilder<PaymentBloc, PaymentState>(
                builder: (context, paymentState) {
                  return BlocBuilder<RemainingBloc, RemainingState>(
                    builder: (context, remainingState) {
                      return BlocBuilder<UserRateBloc, UserRateState>(
                        builder: (context, state) {
                          if (state.inProgress) {
                            return const _RateLoad();
                          }
                          if (paymentState case final PaymentProcessing _) {
                            return const _RateLoad();
                          }
                          if (state.userRate == null) {
                            return const _DefaultRateWidget();
                          }
                          final rate = Rate.fromUserRate(state.userRate!);
                          return RateCard(
                            onTap: () async => await context.pushNamedX(Routes.rates.name),
                            rate: rate,
                            remaining: remainingState.remaining,
                            expiredAt: state.userRate?.expiredAt,
                            isSelectable: false,
                            autoCharge: state.userRate?.autoCharge ?? false,
                            needShowRenewal: true,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          if (!StoreValidation.hidePayments(context, _phone))
            BlocBuilder<FrozenRatesBloc, FrozenRatesState>(
              builder: (context, state) {
                final FrozenRatesBloc frozenBloc = context.read<FrozenRatesBloc>();
                if (state.rates.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _SettingsBlock(
                    tiles: [
                      _TextTileWidget(
                        title: 'Замороженные подписки',
                        icon: Assets.svg.doc.svg(),
                        onTap: () async => await showCustomModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return BlocProvider.value(
                              value: frozenBloc,
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Expanded(
                                        child: Text('Замороженные подписки', style: AppTypography.bodySemibold),
                                      ),
                                      CircleIconButton(
                                        icon: const Icon(Icons.close, color: AppColors.black),
                                        padding: 8,
                                        onPressed: () => Navigator.of(context).pop(),
                                      ),
                                    ],
                                  ),
                                  ListView.separated(
                                    shrinkWrap: true,
                                    primary: false,
                                    physics: const NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    itemCount: state.rates.length,
                                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                                    itemBuilder: (context, index) {
                                      final UserRate rate = state.rates[index];
                                      final int? frozenDays = rate.frozenAt != null && rate.expiredAt != null
                                          ? rate.expiredAt!.difference(rate.frozenAt!).inDays
                                          : null;
                                      return DecoratedBox(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: AppColors.bgPrimary,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(rate.name, style: AppTypography.bodyMedium),
                                              if (frozenDays != null)
                                                Text(
                                                  'Остаток: $frozenDays дней',
                                                  style: AppTypography.bodySettingsRegularText.copyWith(
                                                    color: AppColors.textSecondary,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          if (!StoreValidation.hidePayments(context, _phone))
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _SettingsBlock(
                tiles: [
                  _TextTileWidget(
                    title: 'Привязанные карты',
                    icon: Assets.svg.settingsCards.svg(height: 44),
                    onTap: () async => await context.pushNamedX(Routes.bingingCards.name),
                  ),
                ],
              ),
            ),
          _SettingsBlock(
            title: 'ПОДДЕРЖКА',
            tiles: [
              _TextTileWidget(
                title: 'FAQ',
                icon: Assets.svg.settingsFaq.svg(),
                onTap: () async => await context.pushNamedX(Routes.faq.name),
              ),
              _TextTileWidget(
                title: 'Политика конфиденциальности',
                icon: Assets.svg.settingsPolicy.svg(),
                onTap: () async => await launchUrl(Uri.parse('https://diglab.ru/dlchat/privacy-policy/')),
              ),
            ],
          ),
          if (!windowSize.isLargeOrLarger) ...[
            const SizedBox(height: 32),
            CustomFilledTonalButton(text: 'Выйти', onPressed: () async => await _showLogoutAccountDialog(context)),
            const SizedBox(height: 8),
            CustomFilledTonalButton(
              text: 'Удалить аккаунт',
              textColor: AppColors.error,
              onPressed: () async => await _showDeleteAccountDialog(context),
            ),
          ],
          const SizedBox(height: 24),
          Center(
            child: Text('DLChat', style: AppTypography.bodyRegular.copyWith(color: AppColors.iconSecondary)),
          ),
          Center(
            child: Text(
              'Версия ${context.dependencies.packageInfo.version}',
              style: AppTypography.bodyRegular.copyWith(color: AppColors.iconSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showLogoutAccountDialog(BuildContext context) => showCustomAlertDialog(
    context: context,
    title: 'Выйти из аккаунта',
    subTitle: 'Вы действительно хотите выйти из аккаунта?',
    actionText: 'Выйти',
    actionTextColor: AppColors.error,
    action: () {
      AuthenticationScope.of(context).add(const AuthenticationEvent.signOutPressed());
      context.goNamedX(Routes.signIn.name);
    },
  );

  Future<void> _showDeleteAccountDialog(BuildContext context) => showCustomAlertDialog(
    context: context,
    title: 'Удалить аккаунт?',
    subTitle:
        'Если вы хотите удалить свой аккаунт, пожалуйста, учтите, что все ваши данные будут безвозвратно удалены.',
    actionText: 'Удалить аккаунт',
    actionTextColor: AppColors.error,
    action: () {
      context.read<ProfileBloc>().add(const ProfileEvent.deleteAccount());
      context.goNamedX(Routes.signIn.name);
    },
  );
}

class const _DefaultRateWidget() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: const BorderRadius.all(Radius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: DecoratedBox(
        decoration: BoxDecoration(color: AppColors.bgSecondary, borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Нет активного тарифа', style: AppTypography.bodySemibold),
              CustomFilledButton(
                text: 'Выбрать тариф',
                height: 44,
                onPressed: () async => await context.pushNamedX(Routes.rates.name),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class const _SettingsBlock({required final List<Widget> tiles, final String? title}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(title!, style: const TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          ),
        DecoratedBox(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: AppColors.white),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(children: tiles),
          ),
        ),
      ],
    );
  }
}

class const _TextTileWidget({required final String title, required final Widget icon, final VoidCallback? onTap})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            spacing: 8,
            children: [
              icon,
              Expanded(child: Text(title, style: AppTypography.bodyMedium)),
              if (onTap != null)
                SvgPicture.asset(
                  Assets.svg.chevronRight.path,
                  height: 24,
                  width: 24,
                  colorFilter: const ColorFilter.mode(AppColors.bgPrimary, BlendMode.srcIn),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class const _RateLoad() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ShimmerLoading(
        inProgress: true,
        child: SizedBox(
          height: 120,
          width: double.infinity,
          child: DecoratedBox(decoration: BoxDecoration(borderRadius: BorderRadius.circular(24))),
        ),
      ),
    );
  }
}
