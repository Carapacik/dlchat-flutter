import 'package:dlchat/src/core/common/layout/layout.dart';
import 'package:dlchat/src/core/resources/resources.dart';
import 'package:dlchat/src/feature/shared_widgets/button/circle_icon_button.dart';
import 'package:flutter/material.dart';

export 'alert_dialog.dart';

Future<T?> showCustomDialog<T>({
  required BuildContext context,
  required String title,
  required WidgetBuilder builder,
}) => showDialog<T>(
  context: context,
  builder: (context) {
    final WindowSize windowSize = WindowSizeScope.of(context);
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: windowSize.isCompact ? 16 : ((MediaQuery.sizeOf(context).width - compactMaxWidth + 200) / 2 - 16),
      ),
      backgroundColor: AppColors.bgPopup,
      surfaceTintColor: AppColors.bgPopup,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(child: Text(title, style: AppTypography.bodySemibold)),
                CircleIconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  padding: 8,
                  icon: const Icon(Icons.close, color: AppColors.black),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          builder.call(context),
        ],
      ),
    );
  },
);

class const DialogActionButton({required final String actionText, required final VoidCallback onActionTap, super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: SizedBox(
        width: double.infinity,
        child: Material(
          color: Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            onTap: onActionTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Text(
                actionText,
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
