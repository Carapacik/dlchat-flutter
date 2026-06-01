import 'package:collection/collection.dart';
import 'package:dlchat/src/core/common/extensions/extensions.dart';
import 'package:dlchat/src/core/common/layout/layout.dart';
import 'package:dlchat/src/core/resources/resources.dart';
import 'package:dlchat/src/core/router/routes.dart';
import 'package:dlchat/src/feature/payment/bloc/binding_cards/binding_cards_bloc.dart';
import 'package:dlchat/src/feature/payment/bloc/frozen_rates/frozen_rates_bloc.dart';
import 'package:dlchat/src/feature/payment/bloc/payment/payment_bloc.dart';
import 'package:dlchat/src/feature/payment/bloc/promo_code/promo_code_bloc.dart';
import 'package:dlchat/src/feature/payment/bloc/rates/rates_bloc.dart';
import 'package:dlchat/src/feature/payment/bloc/remaining/remaining_bloc.dart';
import 'package:dlchat/src/feature/payment/bloc/user_rate/user_rate_bloc.dart';
import 'package:dlchat/src/feature/payment/model/payment_method_type.dart';
import 'package:dlchat/src/feature/payment/model/payment_model.dart';
import 'package:dlchat/src/feature/payment/model/rate.dart';
import 'package:dlchat/src/feature/payment/model/special_offer.dart';
import 'package:dlchat/src/feature/payment/model/user_rate.dart';
import 'package:dlchat/src/feature/payment/widget/discount_badge.dart';
import 'package:dlchat/src/feature/payment/widget/payment_button.dart';
import 'package:dlchat/src/feature/payment/widget/payment_form_widget.dart';
import 'package:dlchat/src/feature/payment/widget/rate_card.dart';
import 'package:dlchat/src/feature/payment/widget/rate_toggle_buttons.dart';
import 'package:dlchat/src/feature/shared_widgets/base/app_bar.dart';
import 'package:dlchat/src/feature/shared_widgets/base/snack_bar.dart';
import 'package:dlchat/src/feature/shared_widgets/custom/gradient_painter.dart';
import 'package:dlchat/src/feature/shared_widgets/loading/full_screen_loading.dart';
import 'package:dlchat/src/feature/shared_widgets/loading/shimmer.dart';
import 'package:dlchat/src/feature/shared_widgets/modal/bottom_sheet.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class const RatesScreen({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSizeScope.of(context);
    return BlocBuilder<PaymentBloc, PaymentState>(
      builder: (context, state) {
        final bool fromWebView = switch (state) {
          final PaymentProcessing e => e.fromWebView,
          _ => false,
        };
        return FullScreenLoading(
          inProgress: state.inProgress,
          action: fromWebView
              ? null
              : () {
                  context.read<PaymentBloc>().add(const PaymentEvent.cancelPayment());
                },
          actionText: fromWebView ? null : 'Отменить платеж',
          text: fromWebView ? 'Платеж в обработке' : null,
          child: Scaffold(
            appBar: buildPlatformAppBar(
              context,
              titleText: 'Тарифы',
              leading: CustomBackButton(onPressed: () => context.goNamed(Routes.settings.name)),
            ),
            body: windowSize.isLargeOrLarger ? const _Body() : const RateGradient(children: [_Body()]),
          ),
        );
      },
    );
  }
}

class const _Body() extends StatefulWidget {
  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState() extends State<_Body> {
  late final _scrollController = ScrollController();
  Rate? _selectedRate;
  SpecialOffer? _selectedSpecialOffer;
  var _isSelectedUserRate = false;
  var _discount = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSizeScope.of(context);
    final UserRateBloc userRateBloc = context.watch<UserRateBloc>();
    final UserRate? userRate = userRateBloc.state.userRate;

    final RatesBloc ratesBloc = context.watch<RatesBloc>();
    final RatesState ratesState = ratesBloc.state;
    final List<Rate> sortedRates = [
      ...ratesState.rates.where((e) => e.rank == userRate?.rank),
      ...ratesState.rates.where((e) => e.rank != userRate?.rank && e.rank > (userRate?.rank ?? 0)),
    ];

    final toggleWidget = Padding(
      padding: windowSize.isLargeOrLarger
          ? const EdgeInsets.fromLTRB(24, 16, 24, 0)
          : const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: _SpecialOfferToggle(
        rate: _selectedRate ?? ratesState.rates.first,
        changeDiscount: (discount) {
          _selectedSpecialOffer = _selectedRate?.specialOffers.firstWhereOrNull((e) => e.discountValue == discount);
          setState(() => _discount = discount ?? 0);
        },
      ),
    );
    final Widget ratesWidget = ratesState.inProgress || ratesState.rates.isEmpty
        ? const _RatesLoadingWidget()
        : ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: FadingEdgeScrollView.fromScrollView(
              gradientFractionOnEnd: 0,
              child: ListView.separated(
                controller: _scrollController,
                padding: windowSize.isLargeOrLarger
                    ? EdgeInsets.fromLTRB(24, 16, 24, 80 + MediaQuery.paddingOf(context).bottom)
                    : EdgeInsets.fromLTRB(8, 16, 8, 80 + MediaQuery.paddingOf(context).bottom),
                itemCount: sortedRates.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final Rate rate = sortedRates[index];
                  return RateCard(
                    rate: rate,
                    isActive: _selectedRate == rate,
                    backgroundColor: rate.rank == userRate?.rank ? AppColors.bgThird : null,
                    specialOffer: rate.specialOffers.firstWhereOrNull((e) => e.discountValue == _discount),
                    expiredAt: rate.rank == userRate?.rank ? userRate?.expiredAt : null,
                    onTap: () {
                      if (_selectedRate != rate) {
                        _isSelectedUserRate = false;
                        _selectedRate = rate;
                        _selectedSpecialOffer = _selectedRate?.specialOffers.firstWhereOrNull(
                          (e) => e.discountValue == _discount,
                        );
                      }
                      if (_selectedRate?.rank == userRate?.rank) {
                        _isSelectedUserRate = true;
                      }
                      setState(() {});
                    },
                  );
                },
              ),
            ),
          );
    late Widget content;
    // width < 1200
    if (!windowSize.isLargeOrLarger) {
      content = Stack(
        fit: StackFit.expand,
        children: [
          Column(
            children: [
              SizedBox(width: double.infinity, child: toggleWidget),
              Expanded(child: ratesWidget),
            ],
          ),
          if (_selectedRate != null)
            Positioned(
              bottom: 8,
              left: 16,
              right: 16,
              child: SafeArea(
                child: PaymentButton(
                  rate: _selectedRate!,
                  isRenewal: _isSelectedUserRate,
                  specialOffer: _selectedSpecialOffer,
                  onPressed: () async {
                    final Payment? result = await showCustomModalBottomSheet<Payment?>(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => MultiBlocProvider(
                        providers: [
                          BlocProvider.value(value: context.read<PaymentBloc>()),
                          BlocProvider.value(value: context.read<PromoCodeBloc>()),
                          BlocProvider.value(value: context.read<BindingCardsBloc>()),
                        ],
                        child: PaymentFormWidget(
                          selectedRate: _selectedRate!,
                          userRate: userRate,
                          specialOffer: _selectedSpecialOffer,
                          isRenewal: _isSelectedUserRate,
                        ),
                      ),
                    );
                    if (result == null) {
                      return;
                    }
                  },
                ),
              ),
            ),
        ],
      );
    }
    // width >= 1200
    else {
      content = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              children: [
                SizedBox(width: double.infinity, child: toggleWidget),
                Expanded(child: ratesWidget),
              ],
            ),
          ),
          SizedBox(
            width: 440,
            child: _selectedRate == null
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: const BorderRadius.all(Radius.circular(24)),
                        border: Border.all(color: AppColors.textPrimary),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: PaymentFormWidget(
                          selectedRate: _selectedRate!,
                          userRate: userRate,
                          specialOffer: _selectedSpecialOffer,
                          isRenewal: _isSelectedUserRate,
                        ),
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 24),
        ],
      );
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<PaymentBloc, PaymentState>(
          listener: (context, state) async {
            final FrozenRatesBloc frozenRatesBloc = context.read<FrozenRatesBloc>();
            final RemainingBloc remainingBloc = context.read<RemainingBloc>();
            final PaymentBloc paymentBloc = context.read<PaymentBloc>();
            Future<void> succeededPayment() async {
              Future<void>.delayed(const Duration(seconds: 1), () {
                userRateBloc.add(const UserRateEvent.update());
                frozenRatesBloc.add(const FrozenRatesEvent.start());
                remainingBloc.add(const RemainingEvent.start());
              });
              context.goNamedX(Routes.paymentResult.name, pathParameters: {'result': 'success'});
            }

            switch (state) {
              case final PaymentSuccessStart s:
                if (s.payment.status case PaymentStatus.inProgress) {
                  if (s.payment.method == PaymentMethodType.sbp) {
                    userRateBloc.add(const UserRateEvent.update());
                    context.read<RemainingBloc>().add(const RemainingEvent.start());
                  }
                  if (s.payment.url == null) {
                    showErrorMessage(context, 'Ошибка получения ссылки для оплаты');
                    return;
                  }
                  if (kIsWeb) {
                    await launchUrl(Uri.parse(s.payment.url!));
                    paymentBloc.add(const PaymentEvent.updatePaymentStatus());
                    return;
                  }
                  final bool? paymentResult = await context.pushNamed<bool>(
                    Routes.paymentWebView.name,
                    queryParameters: {'url': s.payment.url},
                  );
                  if (paymentResult != null && paymentResult) {
                    paymentBloc.add(const PaymentEvent.updatePaymentStatus(fromWebView: true));
                    userRateBloc.add(const UserRateEvent.update());
                  }
                } else if (s.payment.status case PaymentStatus.succeeded) {
                  await succeededPayment();
                } else if (s.payment.status case PaymentStatus.failed) {
                  context.goNamedX(Routes.paymentResult.name, pathParameters: {'result': 'failure'});
                }
              case final PaymentSuccess s:
                if (s.payment.status case PaymentStatus.succeeded) {
                  await succeededPayment();
                } else if (s.payment.status case PaymentStatus.failed) {
                  context.goNamedX(Routes.paymentResult.name, pathParameters: {'result': 'failure'});
                }
              default:
            }
          },
        ),
        BlocListener<PromoCodeBloc, PromoCodeState>(
          listener: (context, state) {
            final FrozenRatesBloc frozenRatesBloc = context.read<FrozenRatesBloc>();
            final RemainingBloc remainingBloc = context.read<RemainingBloc>();
            if (state case final PromoCodeSuccessLicenseActivated _) {
              showSuccessMessage(context, 'Лицензия  успешно активирована');
              userRateBloc.add(const UserRateEvent.update());
              frozenRatesBloc.add(const FrozenRatesEvent.start());
              remainingBloc.add(const RemainingEvent.start());
            }
          },
        ),
      ],
      child: content,
    );
  }
}

class const _RatesLoadingWidget() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(8, 16, 8, 80 + MediaQuery.paddingOf(context).bottom),
        itemCount: 4,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) => const ShimmerLoading(
          inProgress: true,
          borderRadius: BorderRadius.all(Radius.circular(24)),
          child: SizedBox(height: 160, width: double.infinity),
        ),
      ),
    );
  }
}

class const _SpecialOfferToggle({required final Rate rate, required final ValueChanged<int?> changeDiscount})
    extends StatefulWidget {
  @override
  State<_SpecialOfferToggle> createState() => _SpecialOfferToggleState();
}

class _SpecialOfferToggleState() extends State<_SpecialOfferToggle> {
  int _toggleIndex = 0;

  @override
  Widget build(BuildContext context) {
    final rateToggleItem = <RateToggleItem>[];
    final List<SpecialOffer> specialOffers = List.of(widget.rate.specialOffers)
      ..sort((a, b) => a.days.compareTo(b.days));
    for (var i = 0; i < specialOffers.length; i++) {
      final SpecialOffer specialOffer = specialOffers[i];
      rateToggleItem.add((
        onTap: () {
          widget.changeDiscount(specialOffer.discountValue);
          _toggleIndex = i + 1;
        },
        text: specialOffer.period,
        suffixIcon: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: DiscountBadge(isActive: _toggleIndex == i + 1, discount: specialOffer.discountValue),
        ),
      ));
    }

    return RateToggleButtons(
      toggleItems: [
        (
          onTap: () {
            widget.changeDiscount(0);
            _toggleIndex = 0;
          },
          text: '1 месяц',
          suffixIcon: const SizedBox.shrink(),
        ),
        ...rateToggleItem,
      ],
    );
  }
}
