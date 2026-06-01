import 'package:dlchat/src/core/resources/resources.dart';
import 'package:flutter/material.dart';

class const CircleIconButton({
  required final Widget icon,
  final Color? backgroundColor,
  final double? padding,
  final VoidCallback? onPressed,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor ?? AppColors.bgPrimary,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Padding(padding: EdgeInsets.all(padding ?? 10), child: icon),
      ),
    );
  }
}
