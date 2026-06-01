import 'package:dlchat/src/core/resources/resources.dart';
import 'package:dlchat/src/feature/shared_widgets/button/circle_icon_button.dart';
import 'package:flutter/material.dart';

class const ChatInfoBottomSheet({required final String title, required final String description, super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppTypography.bodySemibold),
            CircleIconButton(
              icon: const Icon(Icons.close, color: AppColors.black),
              padding: 8,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        const Center(child: SizedBox(height: 16)),
        Text(description),
      ],
    );
  }
}
