import 'package:dlchat/src/core/common/layout/layout.dart';
import 'package:dlchat/src/core/resources/resources.dart';
import 'package:dlchat/src/feature/shared_widgets/button/circle_icon_button.dart';
import 'package:flutter/material.dart';

Future<bool?> showCustomAlertDialog({
  required BuildContext context,
  required String title,
  String? subTitle,
  Widget? content,
  String? actionText,
  VoidCallback? action,
  Color? actionTextColor,
}) => showDialog<bool?>(
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: AppTypography.bodySemibold),
                  CircleIconButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    padding: 8,
                    icon: const Icon(Icons.close, color: AppColors.black),
                  ),
                ],
              ),
            ),
            if (subTitle != null) ...[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: Text(subTitle, style: AppTypography.bodyRegular2, textAlign: TextAlign.center),
                ),
              ),
            ],
            if (content != null) ...[
              const SizedBox(height: 8),
              Padding(padding: const EdgeInsets.all(16), child: content),
            ],
            if (actionText != null) ...[
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Divider(thickness: 1, height: 1, color: AppColors.iconSecondary),
              ),
              Padding(
                padding: const EdgeInsets.all(4),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    onTap: () {
                      action?.call();
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                      child: SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            actionText,
                            style: AppTypography.bodyMedium.copyWith(color: actionTextColor ?? AppColors.textPrimary),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  },
);
