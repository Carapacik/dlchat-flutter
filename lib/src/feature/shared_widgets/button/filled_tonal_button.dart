import 'package:dlchat/src/core/resources/resources.dart';
import 'package:flutter/material.dart';

class const CustomFilledTonalButton({
  required final String text,
  final Color? textColor,
  final Widget? leadingIcon,
  final Widget? trailingIcon,
  final VoidCallback? onPressed,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Material(
        color: AppColors.white,
        borderRadius: const BorderRadius.all(Radius.circular(100)),
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          onTap: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leadingIcon != null) ...[leadingIcon!, const SizedBox(width: 8)],
              Text(
                text,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: textColor ?? (onPressed != null ? AppColors.black : AppColors.textTertiary),
                ),
              ),
              if (trailingIcon != null) ...[const SizedBox(width: 8), trailingIcon!],
            ],
          ),
        ),
      ),
    );
  }
}
