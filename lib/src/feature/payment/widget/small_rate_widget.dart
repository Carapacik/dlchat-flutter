import 'package:dlchat/src/core/resources/resources.dart';
import 'package:flutter/material.dart';

class const SmallRateWidget({
  required final String name,
  required final int initialPrice,
  final int? salePrice,
  final String? period,
  final bool isLicense = false,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: AppColors.bgPrimary),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(name, style: AppTypography.bodyMedium),
                if (period != null) Text(period!, style: AppTypography.bodyMedium),
              ],
            ),
            if (isLicense)
              Text('Оплачено', style: AppTypography.bodyMedium.copyWith(color: AppColors.iconMainChat1))
            else
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${(salePrice ?? initialPrice) ~/ 100} ₽',
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.iconMainChat1),
                  ),
                  if (salePrice != null && salePrice != initialPrice)
                    Text(
                      '${initialPrice ~/ 100} ₽',
                      style: AppTypography.bodyRegular.copyWith(
                        color: AppColors.textSecondary,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
