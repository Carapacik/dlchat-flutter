import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dlchat/src/core/common/extensions/extensions.dart';
import 'package:dlchat/src/core/common/layout/layout.dart';
import 'package:dlchat/src/core/constant/generated/assets.gen.dart';
import 'package:dlchat/src/core/resources/resources.dart';
import 'package:dlchat/src/feature/payment/bloc/binding_cards/binding_cards_bloc.dart';
import 'package:dlchat/src/feature/payment/bloc/payment/payment_bloc.dart';
import 'package:dlchat/src/feature/payment/bloc/promo_code/promo_code_bloc.dart';
import 'package:dlchat/src/feature/payment/model/payment_method_data.dart';
import 'package:dlchat/src/feature/payment/model/payment_method_type.dart';
import 'package:dlchat/src/feature/payment/model/promo_code.dart';
import 'package:dlchat/src/feature/payment/model/rate.dart';
import 'package:dlchat/src/feature/payment/model/special_offer.dart';
import 'package:dlchat/src/feature/payment/model/user_rate.dart';
import 'package:dlchat/src/feature/payment/widget/license_key_bottom_sheet.dart';
import 'package:dlchat/src/feature/payment/widget/payment_button.dart';
import 'package:dlchat/src/feature/payment/widget/promocode_bottom_sheet.dart';
import 'package:dlchat/src/feature/payment/widget/small_rate_widget.dart';
import 'package:dlchat/src/feature/shared_widgets/base/snack_bar.dart';
import 'package:dlchat/src/feature/shared_widgets/button/circle_icon_button.dart';
import 'package:dlchat/src/feature/shared_widgets/loading/full_screen_loading.dart';
import 'package:dlchat/src/feature/shared_widgets/modal/bottom_sheet.dart';
import 'package:dlchat/src/feature/shared_widgets/text_field/text_field.dart';
import 'package:dlchat/src/feature/user/data/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class const PaymentFormWidget({
  required final Rate selectedRate,
  required final UserRate? userRate,
  required final bool isRenewal,
  final SpecialOffer? specialOffer,
  final int? salePrice,
  super.key,
}) extends StatefulWidget {
  @override
  State<PaymentFormWidget> createState() => _PaymentFormWidgetState();
}

class _PaymentFormWidgetState() extends State<PaymentFormWidget> {
  late Rate _selectedRate;
  final _emailController = TextEditingController();
  final _promoCodeController = TextEditingController();
  late final IUserRepository _userRepository = context.dependencies.userRepository;
  PaymentMethodType _paymentMethodType = PaymentMethodType.sbp;
  String? _bindingId;
  bool _needReceipt = false;
  final _bindCard = true;
  final _autoCharge = true;

  @override
  void initState() {
    super.initState();
    _selectedRate = widget.selectedRate;
    unawaited(_fillEmail());
  }

  Future<void> _fillEmail() async {
    final String? email = await _userRepository.email;
    if (email != null) {
      _emailController.text = email;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _promoCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSizeScope.of(context);
    final PromoCodeBloc promoCodeBloc = context.watch<PromoCodeBloc>();
    final PaymentBloc paymentBloc = context.read<PaymentBloc>();
    return MultiBlocListener(
      listeners: [
        BlocListener<PromoCodeBloc, PromoCodeState>(
          listener: (context, state) async {
            switch (state) {
              case final PromoCodeFailure s:
                showCustomAppException(context, s.exception);
              case final PromoCodeSuccess s:
                if (s.promoCodeOrLicense?.type == PromoCodeOrLicenseType.promoCode.type) {
                  final Rate? result = await showCustomModalBottomSheet<Rate?>(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => BlocProvider.value(
                      value: promoCodeBloc,
                      child: PromoCodeBottomSheet(promoCode: s.code ?? '', promoCodeOrLicense: s.promoCodeOrLicense!),
                    ),
                  );
                  if (result == null) {
                    return;
                  }
                  setState(() {
                    _selectedRate = result;
                  });
                } else if (s.promoCodeOrLicense?.type == PromoCodeOrLicenseType.license.type) {
                  if (!windowSize.isLargeOrLarger) {
                    Navigator.of(context).pop();
                  }
                  await showCustomModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => BlocProvider.value(
                      value: promoCodeBloc,
                      child: LicenseKeyBottomSheet(license: s.code ?? '', promoCodeOrLicense: s.promoCodeOrLicense!),
                    ),
                  );
                }

              default:
            }
          },
        ),
        BlocListener<PaymentBloc, PaymentState>(
          listener: (context, state) {
            switch (state) {
              case final PaymentFailure s:
                showCustomAppException(context, s.exception);
              case final PaymentSuccessStart s:
                if (!windowSize.isLargeOrLarger) {
                  Navigator.of(context).pop(s.payment);
                }
                promoCodeBloc.add(const PromoCodeEvent.clear());
              default:
            }
          },
        ),
      ],
      child: BlocBuilder<PaymentBloc, PaymentState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: FullScreenLoading(
              inProgress: state.inProgress && !windowSize.isLargeOrLarger,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight:
                      MediaQuery.sizeOf(context).height -
                      MediaQuery.viewInsetsOf(context).bottom -
                      View.of(context).padding.top,
                ),
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Оплата', style: AppTypography.bodySemibold),
                        if (!windowSize.isLargeOrLarger)
                          CircleIconButton(
                            icon: const Icon(Icons.close, color: AppColors.black),
                            padding: 8,
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text('Тариф'.toUpperCase(), style: AppTypography.bodySettingsRegularHeader),
                    const SizedBox(height: 12),
                    SmallRateWidget(
                      name: _selectedRate.name,
                      salePrice: widget.salePrice ?? widget.specialOffer?.basePrice ?? _selectedRate.initialPrice,
                      initialPrice: _selectedRate.initialPrice * (widget.specialOffer?.month ?? 1),
                      period: widget.specialOffer?.period,
                    ),
                    const SizedBox(height: 24),
                    Text('Промокод'.toUpperCase(), style: AppTypography.bodySettingsRegularHeader),
                    const SizedBox(height: 12),
                    ListenableBuilder(
                      listenable: _promoCodeController,
                      builder: (context, child) {
                        return CustomTextField(
                          controller: _promoCodeController,
                          labelText: 'Введите промокод',
                          textCapitalization: TextCapitalization.characters,
                          suffixIcon: _promoCodeController.text.trim().isNotEmpty
                              ? GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    context.read<PromoCodeBloc>().add(
                                      PromoCodeEvent.verifyPromo(_promoCodeController.text.trim()),
                                    );
                                    FocusManager.instance.primaryFocus?.unfocus();
                                  },
                                  child: Text(
                                    'Применить',
                                    style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
                                  ),
                                )
                              : null,
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    Text('Способы оплаты'.toUpperCase(), style: AppTypography.bodySettingsRegularHeader),
                    const SizedBox(height: 12),
                    _PaymentMethodWidget(
                      changePaymentMethodType: (type) {
                        setState(() {
                          _paymentMethodType = type;
                        });
                      },
                      changeBindingId: (bindingId) {
                        setState(() {
                          _bindingId = bindingId;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    CheckboxListTile(
                      value: _needReceipt,
                      title: const Text('Нужен чек', style: AppTypography.bodyMedium),
                      onChanged: (_) => setState(() => _needReceipt = !_needReceipt),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                      dense: true,
                      checkboxShape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
                    ),
                    if (_needReceipt) ...[
                      const SizedBox(height: 16),
                      Text('Email (вышлем чек)'.toUpperCase(), style: AppTypography.bodySettingsRegularHeader),
                      const SizedBox(height: 12),
                      CustomTextField(controller: _emailController, labelText: 'Введите email'),
                    ],
                    const SizedBox(height: 24),
                    const Row(
                      children: [
                        Icon(Icons.info_outline, color: AppColors.textSecondary),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Карта привяжется к вашему аккаунту автоматически. Вы всегда можете удалить ее в разделе Привязанные карты',
                            style: TextStyle(fontSize: 8, color: AppColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    PaymentButton(
                      rate: _selectedRate,
                      specialOffer: widget.specialOffer,
                      salePrice: widget.salePrice,
                      isRenewal: widget.isRenewal,
                      isDiscountApplied: promoCodeBloc.state.code != null,
                      onPressed: () => paymentBloc.add(
                        PaymentEvent.pay(
                          _selectedRate,
                          widget.userRate,
                          PaymentMethodData(
                            type: _paymentMethodType,
                            bindCard: _bindCard,
                            autoCharge: _autoCharge,
                            bindingId: _bindingId,
                          ),
                          specialOfferId: widget.specialOffer?.id,
                          email: _emailController.text.isEmpty ? null : _emailController.text.trim(),
                          promoCode: promoCodeBloc.state.code,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class const _PaymentMethodWidget({
  required final void Function(PaymentMethodType type) changePaymentMethodType,
  required final void Function(String? bindingId) changeBindingId,
}) extends StatefulWidget {
  @override
  State<_PaymentMethodWidget> createState() => _PaymentMethodWidgetState();
}

class _PaymentMethodWidgetState() extends State<_PaymentMethodWidget> {
  var _currentIndex = -1;

  @override
  void initState() {
    super.initState();
    _currentIndex = context.read<BindingCardsBloc>().state.cards.length;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: BlocBuilder<BindingCardsBloc, BindingCardsState>(
        builder: (context, state) {
          return ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ...state.cards.mapIndexed(
                (index, card) => PaymentTypeCard(
                  key: ValueKey(card.id),
                  icon: card.bankId != null ? Assets.svg.sbp.svg() : Assets.svg.bankCard.svg(),
                  title: card.bankId != null ? 'Привяз. СБП' : card.mps,
                  description: card.last4,
                  isSelected: _currentIndex == index,
                  onPressed: () {
                    setState(() => _currentIndex = index);
                    widget.changePaymentMethodType.call(PaymentMethodType.binding);
                    widget.changeBindingId.call(card.id);
                  },
                ),
              ),
              PaymentTypeCard(
                key: const ValueKey('sbp'),
                icon: Assets.svg.sbp.svg(),
                title: 'Выбрать банк',
                description: 'СБП',
                isSelected: _currentIndex == state.cards.length,
                onPressed: () {
                  setState(() => _currentIndex = state.cards.length);
                  widget.changePaymentMethodType.call(PaymentMethodType.sbp);
                  widget.changeBindingId.call(null);
                },
              ),
              PaymentTypeCard(
                key: const ValueKey('bankcard'),
                icon: Assets.svg.bankCard.svg(),
                title: 'Новая карта',
                isSelected: _currentIndex == state.cards.length + 1,
                onPressed: () {
                  setState(() => _currentIndex = state.cards.length + 1);
                  widget.changePaymentMethodType.call(PaymentMethodType.bankCard);
                  widget.changeBindingId.call(null);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class const PaymentTypeCard({
  required final Widget icon,
  final String? title,
  final String? description,
  final VoidCallback? onPressed,
  final bool isSelected = false,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: isSelected ? Border.all(color: AppColors.iconSecondary, width: 2) : null,
          color: AppColors.bgPrimary,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(24)),
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  icon,
                  const SizedBox(height: 4),
                  if (title != null) Text(title!, style: AppTypography.bodyRegular),
                  if (description != null)
                    Text(description!, style: AppTypography.bodyRegular.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
