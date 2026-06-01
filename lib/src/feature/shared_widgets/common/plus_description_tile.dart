import 'package:dlchat/src/core/constant/generated/assets.gen.dart';
import 'package:dlchat/src/core/resources/resources.dart';
import 'package:flutter/material.dart';

class const PlusDescriptionTile({required final String title, final String? description, super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Assets.svg.gradientPlus.svg(),
            const SizedBox(width: 8),
            Expanded(child: Text(title, style: AppTypography.bodyMedium)),
          ],
        ),
        if (description != null)
          Text(description!, style: AppTypography.bodySettingsMedium.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }
}
