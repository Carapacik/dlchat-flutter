import 'package:dlchat/src/core/resources/resources.dart';
import 'package:flutter/material.dart';

class const CustomFilledButton({
  required final String text,
  final Widget? customText,
  final double? height,
  final Color? color,
  final Color? textColor,
  final Widget? leadingIcon,
  final Widget? trailingIcon,
  final VoidCallback? onPressed,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color ?? (onPressed != null ? AppColors.iconPrimary : AppColors.gray200),
          gradient: onPressed != null ? AppColors.buttonGradient : null,
          borderRadius: const BorderRadius.all(Radius.circular(100)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(100)),
            onTap: onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (leadingIcon != null) ...[leadingIcon!, const SizedBox(width: 8)],
                customText ??
                    Text(
                      text,
                      style: AppTypography.bodyMedium.copyWith(
                        color: textColor ?? (onPressed != null ? AppColors.white : AppColors.textTertiary),
                      ),
                    ),
                if (trailingIcon != null) ...[const SizedBox(width: 8), trailingIcon!],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
