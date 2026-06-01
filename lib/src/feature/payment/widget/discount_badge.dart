import 'package:dlchat/src/core/resources/resources.dart';
import 'package:flutter/material.dart';

class const DiscountBadge({required final bool isActive, required final int discount, super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        gradient: isActive ? AppColors.ratePromoBadgeGradient : null,
        color: isActive ? null : AppColors.white,
        shape: const StadiumBorder(),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Text(
          '- $discount%',
          style: AppTypography.bodyRegular.copyWith(color: isActive ? AppColors.white : AppColors.black),
        ),
      ),
    );
  }
}
