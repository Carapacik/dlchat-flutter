import 'dart:async';

import 'package:dlchat/src/core/resources/resources.dart';
import 'package:flutter/material.dart';

class const CountdownButton({required final VoidCallback onPressed, final int seconds = 120, super.key})
    extends StatefulWidget {
  @override
  State<CountdownButton> createState() => _CountdownButtonState();
}

class _CountdownButtonState() extends State<CountdownButton> {
  Timer? _timer;
  late final ValueNotifier<int> _secondsLeftNotifier = ValueNotifier(widget.seconds);

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final int value = _secondsLeftNotifier.value;
      if (value == 0) {
        timer.cancel();
      } else {
        _secondsLeftNotifier.value = value - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _secondsLeftNotifier,
      builder: (context, value, child) {
        return SizedBox(
          height: 56,
          width: double.infinity,
          child: TextButton(
            onPressed: value == 0
                ? () {
                    widget.onPressed.call();
                    _secondsLeftNotifier.value = widget.seconds;
                    _start();
                  }
                : null,
            child: value == 0
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Отправить повторно в СМС',
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.update),
                      // SvgPicture.asset(
                      //   Assets.svg.update.path,
                      //   width: 20,
                      //   height: 20,
                      //   colorFilter: ColorFilter.mode(context.colors.iconPrimaryInverse, BlendMode.srcIn),
                      // ),
                    ],
                  )
                : Text(
                    '${'Запросить через'} · ${formatSecondsToTimer(context, value)}',
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
          ),
        );
      },
    );
  }

  String formatSecondsToTimer(BuildContext context, int seconds) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final String twoDigitMinutes = twoDigits(seconds.remainder(3600) ~/ 60);
    final String twoDigitSeconds = twoDigits(seconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds сек';
  }
}
