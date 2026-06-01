import 'package:dlchat/src/core/resources/color.dart';
import 'package:flutter/material.dart';

class const RoundCheckbox({required final bool value, required final ValueChanged<bool?>? onChanged, super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      width: 24,
      child: DecoratedBox(
        decoration: BoxDecoration(shape: BoxShape.circle, color: value ? AppColors.iconPrimary : AppColors.gray300),
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => onChanged?.call(!value),
            child: value ? const Icon(Icons.check, color: AppColors.white, size: 20) : null,
          ),
        ),
      ),
    );
  }
}
