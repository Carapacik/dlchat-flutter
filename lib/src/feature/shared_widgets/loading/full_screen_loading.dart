import 'dart:ui';

import 'package:dlchat/src/core/resources/resources.dart';
import 'package:flutter/material.dart';

class const FullScreenLoading({
  required final bool inProgress,
  required final Widget child,
  final String? text,
  final String? actionText,
  final VoidCallback? action,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(child: child),
        Positioned.fill(
          child: AbsorbPointer(
            absorbing: inProgress,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: inProgress
                  ? ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const RepaintBoundary(child: CircularProgressIndicator()),
                              if (text != null)
                                Material(
                                  color: Colors.transparent,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Text(text!, style: AppTypography.bodySettingsRegularHeader),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ),
        if (inProgress && (action != null && actionText != null))
          Positioned(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 100),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: inProgress
                      ? TextButton(
                          onPressed: action,
                          child: Text(actionText!, style: AppTypography.bodySettingsRegularHeader),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
