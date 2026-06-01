import 'package:dlchat/src/core/common/layout/layout.dart';
import 'package:dlchat/src/core/resources/resources.dart';
import 'package:dlchat/src/feature/shared_widgets/base/app_bar.dart';
import 'package:dlchat/src/feature/shared_widgets/custom/gradient_painter.dart';
import 'package:flutter/material.dart';

class const PaymentResultScreen({required final bool successResult, super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSizeScope.of(context);
    final List<StatelessWidget> children = [
      const Spacer(flex: 2),
      Icon(successResult ? Icons.check : Icons.close, size: 80),
      Text(
        successResult ? 'Оплата прошла успешно' : 'Оплата не прошла.\nПовторите попытку',
        textAlign: TextAlign.center,
        style: AppTypography.headerMedium,
      ),
      const Spacer(flex: 3),
    ];
    return Scaffold(
      appBar: buildPlatformAppBar(context, titleText: 'Оплата'),
      body: windowSize.isLargeOrLarger
          ? Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: children),
            )
          : RateGradient(
              children: [
                Center(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: children),
                ),
              ],
            ),
    );
  }
}
