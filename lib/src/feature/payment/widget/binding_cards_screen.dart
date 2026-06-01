import 'package:dlchat/src/core/common/layout/layout.dart';
import 'package:dlchat/src/core/constant/generated/assets.gen.dart';
import 'package:dlchat/src/core/resources/resources.dart';
import 'package:dlchat/src/feature/payment/bloc/binding_cards/binding_cards_bloc.dart';
import 'package:dlchat/src/feature/payment/model/binding_card.dart';
import 'package:dlchat/src/feature/payment/model/payment_method_type.dart';
import 'package:dlchat/src/feature/shared_widgets/base/app_bar.dart';
import 'package:dlchat/src/feature/shared_widgets/base/snack_bar.dart';
import 'package:dlchat/src/feature/shared_widgets/custom/gradient_painter.dart';
import 'package:dlchat/src/feature/shared_widgets/loading/shimmer.dart';
import 'package:dlchat/src/feature/shared_widgets/modal/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class const BindingCardsScreen({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final BindingCardsBloc bloc = context.read<BindingCardsBloc>();
    final WindowSize windowSize = WindowSizeScope.of(context);
    final children = [
      BlocBuilder<BindingCardsBloc, BindingCardsState>(
        builder: (context, state) {
          if (state.inProgress) {
            return ListView.separated(
              primary: false,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              padding: windowSize.isLargeOrLarger
                  ? EdgeInsets.fromLTRB(24, 16, 24, 16 + MediaQuery.paddingOf(context).bottom)
                  : EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.paddingOf(context).bottom),
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemBuilder: (context, index) => const Shimmer(
                child: ShimmerLoading(inProgress: true, child: SizedBox(height: 82, width: double.infinity)),
              ),
            );
          }
          if (state.cards.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Spacer(flex: 2),
                  Assets.svg.settingsCards.svg(width: 160, height: 160),
                  const SizedBox(height: 20),
                  const Text(
                    'У вас нет сохраненных карт',
                    style: AppTypography.bodySemibold,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Добавьте карту, чтобы использовать её для оплаты заказов',
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(flex: 3),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: windowSize.isLargeOrLarger
                ? EdgeInsets.fromLTRB(24, 16, 24, 16 + MediaQuery.paddingOf(context).bottom)
                : EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.paddingOf(context).bottom),
            itemCount: state.cards.length,
            separatorBuilder: (context, index) => const SizedBox(height: 20),
            itemBuilder: (context, index) {
              final BindingCard card = state.cards[index];
              return _CardItem(
                key: ValueKey(card.id),
                card: card,
                onRemoveTap: () async => await showCustomAlertDialog(
                  context: context,
                  title: 'Удалить карту?',
                  content: const Text('Функция автоплатежа по данной карте будет отключена у активных заказов'),
                  actionText: 'Удалить',
                  actionTextColor: AppColors.error,
                  action: () {
                    bloc.add(BindingCardsEvent.removeCard(card.id));
                  },
                ),
              );
            },
          );
        },
      ),
    ];
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BlocListener<BindingCardsBloc, BindingCardsState>(
        listener: (context, state) {
          switch (state) {
            case final BindingCardsFailure s:
              showCustomAppException(context, s.exception);
            case final BindingCardsSuccess s when s.isCardRemoved:
              showSuccessMessage(context, 'Карта успешно удалена');
            default:
          }
        },
        child: Scaffold(
          appBar: buildPlatformAppBar(context, titleText: 'Способы оплаты'),
          body: windowSize.isLargeOrLarger
              ? Stack(fit: StackFit.expand, children: children)
              : RateGradient(children: children),
        ),
      ),
    );
  }
}

class const _CardItem({required final BindingCard card, required final VoidCallback onRemoveTap, super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PaymentMethodType type = PaymentMethodType.fromString(card.bindingType.json);
    return Material(
      color: AppColors.bgIconButton,
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Assets.svg.bankCard.svg(width: 28, height: 28),
            const SizedBox(width: 12),
            Expanded(child: Text(type.localizedText(context), style: AppTypography.bodyMedium)),
            if (card.last4 != null)
              Text('・${card.last4}', style: AppTypography.bodyRegular.copyWith(color: AppColors.textSecondary)),
            const SizedBox(width: 12),
            IconButton(
              onPressed: onRemoveTap,
              icon: SvgPicture.asset(
                Assets.svg.trashFull.path,
                height: 24,
                width: 24,
                colorFilter: const ColorFilter.mode(AppColors.iconPrimary, BlendMode.srcIn),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
