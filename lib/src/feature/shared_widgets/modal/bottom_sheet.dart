import 'package:dlchat/src/core/resources/resources.dart';
import 'package:flutter/material.dart';

Future<T?> showCustomModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isScrollControlled = false,
  bool enableDrag = true,
  EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  Color? backgroundColor,
  Color? dragHandleColor,
}) => showModalBottomSheet<T>(
  context: context,
  backgroundColor: Colors.transparent,
  isScrollControlled: isScrollControlled,
  useRootNavigator: true,
  useSafeArea: true,
  enableDrag: enableDrag,
  builder: (context) => Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Material(
              color: backgroundColor ?? AppColors.white,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    SizedBox(
                      width: 32,
                      height: 4,
                      child: DecoratedBox(
                        decoration: ShapeDecoration(
                          color: dragHandleColor ?? AppColors.black800,
                          shape: const StadiumBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    builder.call(context),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  ),
);
