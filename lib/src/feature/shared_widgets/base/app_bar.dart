import 'package:dlchat/src/core/common/layout/layout.dart';
import 'package:dlchat/src/core/resources/resources.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget buildPlatformAppBar(
  BuildContext context, {
  bool automaticallyImplyLeading = true,
  Widget? leading,
  Widget? title,
  String? titleText,
  List<Widget>? actions,
}) {
  if (WindowSizeScope.of(context).isLargeOrLarger) {
    return DesktopAppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      title: titleText != null ? Text(titleText, style: AppTypography.headerSemibold) : title,
      actions: actions,
    );
  } else {
    return MobileAppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      title: titleText != null ? Text(titleText, style: AppTypography.bodyMedium) : title,
      actions: actions,
    );
  }
}

class const MobileAppBar({
  final bool automaticallyImplyLeading = true,
  final List<Widget>? actions,
  final Widget? title,
  final Widget? leading,
  super.key,
}) extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      leading: leading == null && !automaticallyImplyLeading
          ? null
          : Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
              child: leading ?? (automaticallyImplyLeading ? const CustomBackButton() : const SizedBox.square()),
            ),
      leadingWidth: 52,
      toolbarHeight: 60,
      centerTitle: true,
      actions: [...?actions, const SizedBox(width: 16)],
      title: title,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class const DesktopAppBar({
  final bool automaticallyImplyLeading = true,
  final List<Widget>? actions,
  final Widget? title,
  final Widget? leading,
  super.key,
}) extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        leading: leading ?? (automaticallyImplyLeading ? const CustomBackButton() : null),
        leadingWidth: 44,
        toolbarHeight: 44,
        centerTitle: false,
        actions: actions,
        title: title,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(68);
}

class const CustomBackButton({final VoidCallback? onPressed, super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 44,
      child: BackButton(
        onPressed: onPressed,
        style: IconButton.styleFrom(
          backgroundColor: AppColors.mobileButtonBg,
          foregroundColor: AppColors.iconPrimary,
          iconSize: 20,
        ),
      ),
    );
  }
}

class const CustomCloseButton({final VoidCallback? onPressed, super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 44,
      child: CloseButton(
        onPressed: onPressed,
        style: IconButton.styleFrom(
          backgroundColor: AppColors.mobileButtonBg,
          foregroundColor: AppColors.iconPrimary,
          iconSize: 20,
        ),
      ),
    );
  }
}
