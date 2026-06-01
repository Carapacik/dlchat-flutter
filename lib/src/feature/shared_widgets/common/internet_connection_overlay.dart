import 'dart:async';

import 'package:dlchat/src/core/common/connection.dart';
import 'package:dlchat/src/core/common/layout/layout.dart';
import 'package:dlchat/src/core/resources/resources.dart';
import 'package:flutter/material.dart';

class const InternetConnectionOverlay({required final Widget child, super.key}) extends StatefulWidget {
  @override
  State<InternetConnectionOverlay> createState() => _InternetConnectionOverlayState();
}

class _InternetConnectionOverlayState() extends State<InternetConnectionOverlay> {
  final _connectionUtility = ConnectionUtility();

  @override
  void dispose() {
    unawaited(_connectionUtility.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Overlay(
      initialEntries: [
        OverlayEntry(
          builder: (context) {
            _connectionUtility.init(context);
            return widget.child;
          },
        ),
      ],
    );
  }
}

class const InternetConnectionSnackBar({required final ConnectionUtility connectionUtility, super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSizeScope.of(context);
    final double horizontalPadding = windowSize.isCompact
        ? 16.0
        : (MediaQuery.sizeOf(context).width - compactMaxWidth) / 2;
    return Positioned(
      top: 8,
      left: horizontalPadding,
      right: horizontalPadding,
      child: SafeArea(
        child: Material(
          color: AppColors.error,
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    'Нет подключения к интернету',
                    style: AppTypography.bodyRegular.copyWith(color: AppColors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                GestureDetector(
                  onTap: connectionUtility.hideInternetConnectionTopSnack,
                  child: const Icon(Icons.close, size: 16, color: AppColors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
