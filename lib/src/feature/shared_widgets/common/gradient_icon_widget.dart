import 'package:dlchat/src/core/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class const GradientIconWidget({
  required final String iconPath,
  required final Color iconColor,
  required final Gradient gradient,
  final bool isActive = true,
  final double padding = 12,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      width: 44,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: isActive ? null : AppColors.iconSecondary,
          gradient: isActive ? gradient : null,
        ),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: SvgPicture.asset(
            iconPath,
            colorFilter: ColorFilter.mode(isActive ? iconColor : AppColors.iconSecondary, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}
