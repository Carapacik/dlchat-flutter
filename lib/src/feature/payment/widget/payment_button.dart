import 'package:dlchat/src/core/resources/resources.dart';
import 'package:dlchat/src/feature/payment/model/rate.dart';
import 'package:dlchat/src/feature/payment/model/special_offer.dart';
import 'package:dlchat/src/feature/shared_widgets/button/filled_button.dart';
import 'package:flutter/material.dart';

class const PaymentButton({
  required final Rate rate,
  final bool isRenewal = false,
  final bool isDiscountApplied = false,
  final int? salePrice,
  final SpecialOffer? specialOffer,
  final VoidCallback? onPressed,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var price = 0;
    if (salePrice != null) {
      price = salePrice! ~/ 100;
    } else if (rate.salePrice != 0) {
      price = rate.salePrice ~/ 100;
    } else if (specialOffer != null) {
      price = specialOffer!.basePrice ~/ 100;
    } else {
      price = rate.initialPrice ~/ 100;
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomFilledButton(
          text: isRenewal ? 'Продлить' : '',
          customText: isRenewal
              ? null
              : SizedBox(
                  width: constraints.maxWidth - 16 * 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isRenewal ? 'Продлить' : 'Подключить',
                            style: AppTypography.bodyMedium.copyWith(color: AppColors.white),
                          ),
                          if (isDiscountApplied)
                            Text(
                              '(с учетом промокода)',
                              style: AppTypography.bodyRegular.copyWith(color: AppColors.iconSecondary),
                            )
                          else if (salePrice != null &&
                              salePrice != rate.initialPrice &&
                              salePrice != specialOffer?.basePrice)
                            Text(
                              '(с учетом текущего тарифа)',
                              style: AppTypography.bodyRegular.copyWith(color: AppColors.iconSecondary),
                            ),
                        ],
                      ),
                      Text('$price ₽', style: AppTypography.bodyMedium.copyWith(color: AppColors.white)),
                    ],
                  ),
                ),
          onPressed: onPressed,
        );
      },
    );
  }
}
