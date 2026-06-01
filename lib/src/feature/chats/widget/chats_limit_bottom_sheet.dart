import 'package:dlchat/src/core/common/extensions/extensions.dart';
import 'package:dlchat/src/core/constant/generated/assets.gen.dart';
import 'package:dlchat/src/core/resources/resources.dart';
import 'package:dlchat/src/core/router/routes.dart';
import 'package:dlchat/src/feature/shared_widgets/button/filled_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class const LimitsBottomSheet({super.key, final bool isRequestsLimit = false}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: Assets.svg.unlock.svg()),
        const SizedBox(height: 16),
        const Text('Раскройте больше возможностей', style: AppTypography.bodySemibold),
        const SizedBox(height: 16),
        Text(
          isRequestsLimit
              ? 'Получите больше сообщений с более высоким тарифом'
              : 'Перейдите на более высокий тариф, либо удалите один ваших чатов',
          style: AppTypography.bodyRegular2,
        ),
        const SizedBox(height: 16),
        CustomFilledButton(
          text: 'Выбрать тариф',
          onPressed: () async {
            context.pop();
            await context.pushNamedX(Routes.rates.name);
          },
        ),
        const SizedBox(height: 4),
        if (!isRequestsLimit)
          CustomFilledButton(
            text: 'К чатам',
            color: AppColors.textSecondary,
            onPressed: () {
              context
                ..pop()
                ..goNamed(Routes.chats.name);
            },
          ),
      ],
    );
  }
}
