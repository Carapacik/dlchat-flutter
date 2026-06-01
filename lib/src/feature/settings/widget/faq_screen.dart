import 'dart:io';

import 'package:dlchat/src/core/common/layout/layout.dart';
import 'package:dlchat/src/core/constant/application_config.dart';
import 'package:dlchat/src/core/constant/generated/assets.gen.dart';
import 'package:dlchat/src/core/resources/resources.dart';
import 'package:dlchat/src/feature/shared_widgets/base/app_bar.dart';
import 'package:dlchat/src/feature/shared_widgets/button/circle_icon_button.dart';
import 'package:dlchat/src/feature/shared_widgets/button/filled_button.dart';
import 'package:dlchat/src/feature/shared_widgets/custom/gradient_painter.dart';
import 'package:dlchat/src/feature/shared_widgets/modal/bottom_sheet.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class const FaqScreen({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSizeScope.of(context);
    final List<({String answer, String question})> faq = [
      (
        question: 'Как сгенерировать изображение?',
        answer: 'Запрос на генерацию изображения необходимо делать в чате изображений. Простые текстовые чаты не предназначены для этой задачи.',
      ),
      (
        question: 'Как удалить или переименовать чат?',
        answer: 'Нужный чат необходимо потянуть влево и выбрать нужное действие.',
      ),
      (
        question: 'Можно ли анализировать веб-сайты?',
        answer: 'Да! Просто отправьте в запросе ссылку на необходимый ресурс для анализа.',
      ),
      if (kIsWeb || (!Platform.isMacOS && !Platform.isIOS))
        (
          question: 'Как продлить тариф?',
          answer: 'Перейдите в тарифы и выберите текущий. Далее нажмите кнопку продлить.',
        ),
      (
        question: 'Как сохранить сгенерированное изображение?',
        answer: 'Зажмите сгенерированное изображение пока не появится меню. Нажмите сохранить в фото.',
      ),
      if (kIsWeb || (!Platform.isMacOS && !Platform.isIOS))
        (
          question: 'Что делать при достижении лимита?',
          answer: 'В этом случае вам необходимо перейти на более высокий тариф.',
        ),
      (
        question: 'Что обозначают числа на главном экране?',
        answer: 'Числа обозначают оставшееся количество запросов на текущие сутки.',
      ),
      (
        question: 'Не нашли свой вопрос, есть предложение или пожелание',
        answer: 'Вы всегда можете связаться с нами по почте в верхней части экрана.',
      ),
    ];
    final children = [
      ListView.separated(
        padding: const EdgeInsets.all(16),
        shrinkWrap: true,
        itemCount: faq.length,
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemBuilder: (context, index) => _FaqButton(question: faq[index].question, answer: faq[index].answer),
      ),
    ];
    return Scaffold(
      appBar: buildPlatformAppBar(
        context,
        titleText: 'FAQ',
        actions: [
          CircleIconButton(
            icon: Assets.svg.circleHelp.svg(),
            backgroundColor: AppColors.bgSecondary,
            onPressed: () async => await showCustomModalBottomSheet(
              context: context,
              builder: (context) => Column(
                children: [
                  const Text('Не нашли ответ? Напишите нам:', style: AppTypography.bodySemibold),
                  const SizedBox(height: 16),
                  CustomFilledButton(
                    text: 'Telegram',
                    leadingIcon: Assets.svg.telegram.svg(),
                    onPressed: () async {
                      final Uri? url = Uri.tryParse(const ApplicationConfig().telegramBotUrl);
                      if (url != null) {
                        await launchUrl(url);
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomFilledButton(
                    text: 'E-mail',
                    leadingIcon: Assets.svg.mail.svg(),
                    onPressed: () async {
                      final emailLaunchUri = Uri(scheme: 'mailto', path: 'support@diglab.ru');
                      await launchUrl(emailLaunchUri);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: windowSize.isLargeOrLarger
          ? Stack(fit: StackFit.expand, children: children)
          : RateGradient(children: children),
    );
  }
}

class const _FaqButton({required final String question, required final String answer}) extends StatefulWidget {
  @override
  State<_FaqButton> createState() => _FaqButtonState();
}

class _FaqButtonState() extends State<_FaqButton> {
  var _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final Widget expandIconPadded = ExpandIcon(
      color: AppColors.black800,
      disabledColor: AppColors.black800,
      isExpanded: _isExpanded,
      size: 20,
      padding: EdgeInsets.zero,
      onPressed: null,
    );
    final Widget header = Row(
      children: [
        Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Text(widget.question, style: AppTypography.bodyMedium),
            ),
          ),
        ),
        expandIconPadded,
      ],
    );
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: () => setState(() => _isExpanded ^= true),
              borderRadius: BorderRadius.circular(8),
              child: header,
            ),
          ),
          AnimatedCrossFade(
            firstChild: const LimitedBox(maxWidth: 0, child: SizedBox(width: double.infinity, height: 0)),
            secondChild: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(widget.answer, style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
            ),
            firstCurve: const Interval(0, 0.6, curve: Curves.fastOutSlowIn),
            secondCurve: const Interval(0.4, 1, curve: Curves.fastOutSlowIn),
            sizeCurve: Curves.fastOutSlowIn,
            alignment: Alignment.bottomLeft,
            crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 400),
          ),
        ],
      ),
    );
  }
}
