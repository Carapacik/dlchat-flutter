import 'package:dlchat/src/core/resources/resources.dart';
import 'package:dlchat/src/feature/payment/model/rate.dart';
import 'package:dlchat/src/feature/payment/model/remaining.dart';
import 'package:dlchat/src/feature/payment/model/special_offer.dart';
import 'package:dlchat/src/feature/payment/widget/discount_badge.dart';
import 'package:dlchat/src/feature/shared_widgets/button/filled_button.dart';
import 'package:dlchat/src/feature/shared_widgets/custom/round_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class const RateCard({
  required final Rate rate,
  final bool isActive = false,
  final bool isSelectable = true,
  final bool autoCharge = false,
  final bool needShowRenewal = false,
  final Color? backgroundColor,
  final Widget? content,
  final SpecialOffer? specialOffer,
  final DateTime? expiredAt,
  final RemainingRequests? remaining,
  final VoidCallback? onTap,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool textRequestUnlimited =
        (remaining != null && remaining!.requests >= 9999999) || rate.numberOfRequests >= 9999999;
    final int textRequestNumber = remaining != null
        ? remaining!.requests < 9999999
              ? remaining!.requests
              : -1
        : rate.numberOfRequests < 9999999
        ? rate.numberOfRequests
        : -1;
    final textImages = remaining != null
        ? remaining!.images < 99999
              ? remaining!.images.toString()
              : 'Безлимит'
        : rate.numberOfImages < 99999
        ? rate.numberOfImages.toString()
        : 'Безлимит';
    final String textTranscription = remaining != null
        ? remaining!.transcriptionSeconds < 9999999
              ? _formatDuration(remaining!.transcriptionSeconds)
              : 'Безлимит'
        : rate.transcriptionSeconds < 9999999
        ? _formatDuration(rate.transcriptionSeconds)
        : 'Безлимит';
    final int? difference = expiredAt?.difference(DateTime.now()).inDays;
    final bool showRenewalButton = difference != null && difference < 7 && !autoCharge && needShowRenewal;
    final int rateByMountPrice = specialOffer != null && (specialOffer!.discountValue > 0)
        ? (rate.initialPrice / 100 * (1 - specialOffer!.discountValue / 100)).round()
        : (rate.initialPrice / 100).round();
    return Material(
      borderRadius: const BorderRadius.all(Radius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(24),
            border: isActive ? Border.all(color: AppColors.gray400, width: 2) : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(rate.name, style: AppTypography.bodySemibold),
                        if (expiredAt != null)
                          Text(
                            '・Подключен до ${DateFormat('dd.MM.yyyy').format(expiredAt!)}',
                            style: AppTypography.bodySettingsRegularText.copyWith(
                              color: showRenewalButton ? AppColors.inputError : AppColors.inputCorrect,
                            ),
                          ),
                      ],
                    ),
                    if (isSelectable)
                      IgnorePointer(
                        child: RoundCheckbox(value: isActive, onChanged: (_) {}),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                ?content,
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Текстовые сообщения ・',
                        style: AppTypography.bodySettingsRegularText.copyWith(color: AppColors.textSecondary),
                      ),
                      if (textRequestUnlimited)
                        TextSpan(
                          text: 'Безлимит',
                          style: AppTypography.bodySettingsRegularText.copyWith(color: AppColors.textPrimary),
                        )
                      else
                        TextSpan(
                          text: Intl.plural(
                            textRequestNumber,
                            zero: '$textRequestNumber запросов',
                            one: '$textRequestNumber запрос',
                            few: '$textRequestNumber запроса',
                            many: '$textRequestNumber запросов',
                            other: '$textRequestNumber запросов',
                            name: 'textRequestNumber',
                            desc: '',
                            args: [textRequestNumber],
                          ),
                          // text: Intl.plural(
                          //   textRequestNumber,
                          //   zero: '$textRequestNumber символов',
                          //   one: '$textRequestNumber символ',
                          //   few: '$textRequestNumber символа',
                          //   many: '$textRequestNumber символов',
                          //   other: '$textRequestNumber символов',
                          //   name: 'textRequestNumber',
                          //   desc: '',
                          //   args: [textRequestNumber],
                          // ),
                          style: AppTypography.bodySettingsRegularText.copyWith(color: AppColors.textPrimary),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Генерация изображений ・',
                        style: AppTypography.bodySettingsRegularText.copyWith(color: AppColors.textSecondary),
                      ),
                      TextSpan(
                        text: textImages,
                        style: AppTypography.bodySettingsRegularText.copyWith(color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Лимит по транскрибации ・',
                        style: AppTypography.bodySettingsRegularText.copyWith(color: AppColors.textSecondary),
                      ),
                      TextSpan(
                        text: textTranscription,
                        style: AppTypography.bodySettingsRegularText.copyWith(color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                ),
                if (rate.initialPrice != 0) ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '$rateByMountPrice ₽',
                                  style: AppTypography.bodyMedium.copyWith(color: AppColors.iconMainChat1),
                                ),
                                TextSpan(
                                  text: ' /мес',
                                  style: AppTypography.bodySettingsRegularText.copyWith(color: AppColors.iconMainChat1),
                                ),
                              ],
                            ),
                          ),
                          if (specialOffer != null && (specialOffer!.discountValue > 0))
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: DiscountBadge(isActive: true, discount: specialOffer!.discountValue),
                            ),
                        ],
                      ),
                      if (specialOffer != null)
                        Text(
                          '${specialOffer!.basePrice ~/ 100} ₽ за ${specialOffer!.period}',
                          style: AppTypography.bodyRegular.copyWith(color: AppColors.textSecondary),
                        ),
                    ],
                  ),
                  if (specialOffer != null && (specialOffer!.discountValue > 0))
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '${(rate.initialPrice / 100).round()} ₽ /мес',
                        style: AppTypography.bodyRegular.copyWith(
                          color: AppColors.textSecondary,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: AppColors.iconPrimary,
                        ),
                      ),
                    ),
                ],
                if (showRenewalButton && onTap != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: CustomFilledButton(text: 'Продлить', height: 44, onPressed: onTap),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;
    if (minutes == 0 && remainingSeconds == 0) {
      return '0';
    }

    if (minutes == 0) {
      return '$remainingSeconds сек';
    }
    if (remainingSeconds == 0) {
      return '$minutes мин';
    }

    return '$minutes мин $remainingSeconds сек';
  }
}
