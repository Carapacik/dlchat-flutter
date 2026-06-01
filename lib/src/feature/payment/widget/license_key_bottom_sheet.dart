import 'package:dlchat/src/core/common/extensions/date_extension.dart';
import 'package:dlchat/src/core/resources/resources.dart';
import 'package:dlchat/src/feature/payment/bloc/promo_code/promo_code_bloc.dart';
import 'package:dlchat/src/feature/payment/model/promo_code.dart';
import 'package:dlchat/src/feature/payment/model/rate.dart';
import 'package:dlchat/src/feature/payment/widget/small_rate_widget.dart';
import 'package:dlchat/src/feature/shared_widgets/button/circle_icon_button.dart';
import 'package:dlchat/src/feature/shared_widgets/button/filled_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class const LicenseKeyBottomSheet({
  required final PromoCodeOrLicense promoCodeOrLicense,
  required final String license,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Rate rate = promoCodeOrLicense.rates.first;
    final PromoCodeBloc bloc = context.read<PromoCodeBloc>();
    return BlocListener<PromoCodeBloc, PromoCodeState>(
      listener: (context, state) {
        if (state case PromoCodeSuccessLicenseActivated _) {
          bloc.add(const PromoCodeEvent.clear());
          Navigator.of(context).pop();
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(child: Text('Активация лицензионного ключа', style: AppTypography.bodySemibold)),
              const SizedBox(width: 8),
              CircleIconButton(
                icon: const Icon(Icons.close, color: AppColors.black),
                padding: 8,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 16, bottom: 8),
            child: Text('ТАРИФЫ', style: AppTypography.bodySettingsRegularHeader),
          ),
          SmallRateWidget(
            name: rate.name,
            salePrice: rate.salePrice,
            initialPrice: rate.initialPrice,
            period: promoCodeOrLicense.days?.daysToPeriod,
            isLicense: promoCodeOrLicense.type == PromoCodeOrLicenseType.license.type,
          ),
          const SizedBox(height: 24),
          const Text('ЛИЦЕНЗИОННЫЙ КЛЮЧ', style: AppTypography.bodyMedium),
          const SizedBox(height: 12),
          Text(license, style: AppTypography.bodyMedium),
          const SizedBox(height: 32),
          CustomFilledButton(
            text: 'Активировать',
            onPressed: () {
              bloc.add(const PromoCodeEvent.licenseActivate());
            },
          ),
        ],
      ),
    );
  }
}
