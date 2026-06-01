import 'package:dlchat/src/core/resources/resources.dart';
import 'package:dlchat/src/feature/shared_widgets/animation/animated_horizontal_toggle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef RateToggleItem = ({String text, VoidCallback onTap, Widget suffixIcon});

class const RateToggleButtons({required final List<RateToggleItem> toggleItems, super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedHorizontalToggle(
          taps: toggleItems.map((e) => e.text).toList(),
          suffixIcons: toggleItems.map((e) => e.suffixIcon).toList(),
          onChange: (_, targetIndex) {
            toggleItems[targetIndex].onTap();
          },
          width: constraints.maxWidth - 24 * 2,
          height: 40,
          radius: 160,
          activeButtonRadius: 100,
          duration: const Duration(milliseconds: 50),
          activeVerticalPadding: 4,
          activeHorizontalPadding: 4,
          background: AppColors.bgSecondary.withAlpha(50),
          activeColor: AppColors.white,
          activeTextStyle: AppTypography.bodySettingsMedium.copyWith(color: AppColors.textPrimary),
          inActiveTextStyle: AppTypography.bodySettingsMedium.copyWith(color: AppColors.textSecondary),
          spaceBetweenIconAndText: 4,
          horizontalPadding: 0,
        );
      },
    );
  }
}
