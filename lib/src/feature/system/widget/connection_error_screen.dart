import 'package:dlchat/src/core/common/layout/layout.dart';
import 'package:dlchat/src/core/constant/generated/assets.gen.dart';
import 'package:dlchat/src/core/resources/resources.dart';
import 'package:dlchat/src/core/router/routes.dart';
import 'package:dlchat/src/feature/shared_widgets/base/app_bar.dart';
import 'package:dlchat/src/feature/shared_widgets/button/filled_button.dart';
import 'package:dlchat/src/feature/shared_widgets/custom/gradient_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class const ConnectionErrorScreen({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSizeScope.of(context);
    final double imageDimension = windowSize.maybeMap(compact: () => 80.0, orElse: () => 120.0);
    return Scaffold(
      appBar: buildPlatformAppBar(
        context,
        automaticallyImplyLeading: false,
        title: const Text('DLCHAT', style: AppTypography.headerMedium),
      ),
      extendBodyBehindAppBar: true,
      body: ChatGradient(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(Assets.svg.warning.path, height: imageDimension, width: imageDimension),
                        const SizedBox(height: 16),
                        const Text('Нет подключения', style: AppTypography.bodyMedium, textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        const Text(
                          'Проверьте интернет соединение',
                          style: AppTypography.bodyRegular,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 350),
                          child: CustomFilledButton(
                            onPressed: () async => context.goNamed(Routes.splash.name),
                            text: 'Обновить',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
