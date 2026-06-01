import 'package:dlchat/src/core/common/extensions/date_extension.dart';
import 'package:dlchat/src/core/resources/resources.dart';
import 'package:dlchat/src/feature/payment/model/promo_code.dart';
import 'package:dlchat/src/feature/payment/model/rate.dart';
import 'package:dlchat/src/feature/payment/widget/small_rate_widget.dart';
import 'package:dlchat/src/feature/shared_widgets/button/circle_icon_button.dart';
import 'package:flutter/material.dart';

class const PromoCodeBottomSheet({
  required final String promoCode,
  required final PromoCodeOrLicense promoCodeOrLicense,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(child: Text('Промокод', style: AppTypography.bodySemibold)),
            CircleIconButton(
              icon: const Icon(Icons.close, color: AppColors.black),
              padding: 8,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Material(
          color: AppColors.bgPrimary,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(100)),
            side: BorderSide(color: AppColors.success),
          ),
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(promoCode, style: AppTypography.bodyMedium),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 16, bottom: 8),
          child: Text('ДОСТУПНЫЕ ТАРИФЫ', style: AppTypography.bodySettingsRegularHeader),
        ),
        ListView.separated(
          shrinkWrap: true,
          itemCount: promoCodeOrLicense.rates.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final Rate rate = promoCodeOrLicense.rates[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).pop(rate);
              },
              child: SmallRateWidget(
                name: rate.name,
                salePrice: rate.salePrice,
                initialPrice: rate.initialPrice,
                period: promoCodeOrLicense.days?.daysToPeriod,
              ),
            );
          },
        ),
      ],
    );
  }
}
