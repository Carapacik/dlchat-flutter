import 'dart:io';

import 'package:dlchat/src/core/common/extensions/extensions.dart';
import 'package:dlchat/src/core/common/layout/layout.dart';
import 'package:dlchat/src/core/constant/constants.dart';
import 'package:dlchat/src/core/constant/generated/assets.gen.dart';
import 'package:dlchat/src/core/resources/resources.dart';
import 'package:dlchat/src/feature/shared_widgets/base/app_bar.dart';
import 'package:dlchat/src/feature/shared_widgets/button/filled_button.dart';
import 'package:dlchat/src/feature/shared_widgets/custom/gradient_painter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class const UpdateAppScreen({required final String latestVersion, super.key}) extends StatelessWidget {
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
                  const SizedBox(height: 24),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _VersionBadge(version: context.dependencies.packageInfo.version),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward, size: 16, color: AppColors.iconSecondary),
                      const SizedBox(width: 4),
                      _VersionBadge(version: latestVersion),
                    ],
                  ),
                  const Spacer(flex: 2),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(Assets.svg.warning.path, height: imageDimension, width: imageDimension),
                        const SizedBox(height: 16),
                        const Text(
                          'Ваша версия приложения устарела',
                          style: AppTypography.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Чтобы продолжить пользоваться DLChat, пожалуйста, обновитесь',
                          style: AppTypography.bodyRegular,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 350),
                          child: CustomFilledButton(
                            onPressed: () async {
                              if (kIsWeb) {
                                return;
                              }
                              final Uri uri = Platform.isAndroid
                                  ? Uri.parse(androidMarketUrl)
                                  : Uri.parse(appleMarketUrl);
                              await launchUrl(uri);
                            },
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

class const _VersionBadge({required final String version}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(color: AppColors.white, shape: StadiumBorder()),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Text(version, style: AppTypography.bodyRegular.copyWith(color: AppColors.textSecondary)),
      ),
    );
  }
}
