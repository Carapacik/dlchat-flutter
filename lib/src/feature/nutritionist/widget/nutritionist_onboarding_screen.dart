import 'dart:async';
import 'dart:math';

import 'package:dlchat/src/core/common/extensions/extensions.dart';
import 'package:dlchat/src/core/common/layout/layout.dart';
import 'package:dlchat/src/core/constant/generated/assets.gen.dart';
import 'package:dlchat/src/core/resources/resources.dart';
import 'package:dlchat/src/core/router/routes.dart';
import 'package:dlchat/src/feature/onboarding/data/onboarding_repository.dart';
import 'package:dlchat/src/feature/shared_widgets/base/app_bar.dart';
import 'package:dlchat/src/feature/shared_widgets/button/filled_button.dart';
import 'package:dlchat/src/feature/shared_widgets/custom/gradient_painter.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class TextBlock({
  required final String text,
  required final double top,
  final double? left,
  final double? right,
  final double? rotation,
});

class const Slide({
  required final String imagePath,
  required final String title,
  required final String description,
  required final List<TextBlock> texts,
});

class const NutritionistOnboardingScreen({super.key}) extends StatefulWidget {
  @override
  State<NutritionistOnboardingScreen> createState() => _NutritionistOnboardingScreenState();
}

class _NutritionistOnboardingScreenState() extends State<NutritionistOnboardingScreen> {
  late final IOnboardingRepository _onboardingRepository = context.dependencies.onboardingRepository;
  late final _pageController = PageController();

  // late final _pageController2 = PageController();
  var _currentIndex = 0;

  final _slides = <Slide>[
    Slide(
      imagePath: Assets.image.nutritionist1.path,
      title: 'Голосовые сообщения',
      description: 'Общайтесь со своим цифровым нутрициологом голосом. Просто расскажите о своем дневном рационе и получите полезные советы',
      texts: [
        TextBlock(text: 'На завтрак съел яблоко...', top: 30, right: 10, rotation: 10),
        TextBlock(text: 'На что заменить конфеты?', top: 140, left: 20, rotation: -10),
        TextBlock(text: 'Что съесть на обед?', top: 240, right: 20, rotation: -10),
      ],
    ),
    Slide(
      imagePath: Assets.image.nutritionist2.path,
      title: 'Текстовый чат',
      description: 'Иногда удобнее написать, чем сказать. В любом случае, ваш персональный цифровой нутрициолог всегда на связи!',
      texts: [
        TextBlock(text: 'Сколько воды нужно пить в день?', top: 30, left: 10, rotation: -10),
        TextBlock(text: 'Напиши варианты перекуса', top: 140, right: 20, rotation: 5),
        TextBlock(text: 'Полезен ли мёд?', top: 240, left: 20, rotation: 10),
      ],
    ),
    Slide(
      imagePath: Assets.image.nutritionist3.path,
      title: 'План питания',
      description:
          'Получай персонализированный план питания, основанный на твоих физических данных, предпочтениях и целях',
      texts: [
        TextBlock(text: 'Заменим в меню все мясные блюда', top: 30, left: 10, rotation: 10),
        TextBlock(text: 'ПП меню для вегана', top: 140, left: 20, rotation: -10),
        TextBlock(text: 'Составь меню на неделю', top: 240, right: 20, rotation: 10),
      ],
    ),
    Slide(
      imagePath: Assets.image.nutritionist4.path,
      title: 'Рецепты и калории',
      description: 'Получай здоровые рецепты под любой запрос с информацией о калориях, белках, жирах и углеводах на каждый день',
      texts: [
        TextBlock(text: 'Сколько белков в стейке?', top: 30, left: 10, rotation: -5),
        TextBlock(text: 'КБЖУ пиццы "4 сыра"', top: 120, right: 20, rotation: -10),
        TextBlock(text: 'Напиши рецепт ПП салата', top: 240, left: 20, rotation: 10),
      ],
    ),
  ];

  Future<void> _nextPage() async {
    if (_slides.length - 1 == _currentIndex) {
      await _navigate();
      return;
    }

    setState(() => _currentIndex = _currentIndex + 1);
    _pageController.animateToPage(_currentIndex, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    // _pageController2.animateToPage(_currentIndex, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _pageController.dispose();
    // _pageController2.dispose();
    super.dispose();
  }

  Future<void> _navigate() async {
    await _onboardingRepository.setHideAssistantNutritionOnboarding();
    if (mounted) {
      Navigator.of(context).pop();
      await context.pushNamedX(Routes.nutritionistFillingData.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final WindowSize windowSize = WindowSizeScope.of(context);
    return Scaffold(
      appBar: buildPlatformAppBar(context, title: const Text('DLCHAT', style: AppTypography.headerMedium)),
      extendBodyBehindAppBar: true,
      body: ChatGradient(
        children: [
          Positioned.fill(
            child: SafeArea(
              bottom: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Spacer(),
                  Center(
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 300,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (widget, animation) => FadeTransition(opacity: animation, child: widget),
                            child: Image.asset(
                              _slides[_currentIndex].imagePath,
                              key: ValueKey<int>(_currentIndex),
                              width: size.width,
                            ),
                          ),
                        ),
                        Center(
                          child: SizedBox(
                            height: 300,
                            width: windowSize.isLargeOrLarger ? 480 : size.width,
                            child: Stack(
                              children: _slides[_currentIndex].texts.map<Widget>((textData) {
                                return AnimatedPositioned(
                                  duration: const Duration(milliseconds: 300),
                                  top: textData.top,
                                  left: textData.right != null
                                      ? ((windowSize.isLargeOrLarger ? 480 : size.width) -
                                            textData.right! -
                                            textData.text.length * 8)
                                      : textData.left,
                                  child: Transform.rotate(
                                    angle: textData.rotation != null ? textData.rotation! * pi / 180 : 0,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        child: Text(textData.text, style: AppTypography.bodySettingsMedium),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  DecoratedBox(
                    decoration: const BoxDecoration(
                      color: AppColors.bgSecondary,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                        child: SizedBox(
                          height: 300,
                          child: PageView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _slides.length,
                            controller: _pageController,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Text(
                                    _slides[index].title,
                                    textAlign: TextAlign.center,
                                    style: AppTypography.headerMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    _slides[index].description,
                                    textAlign: TextAlign.center,
                                    style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                                  ),
                                  const Spacer(flex: 2),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            left: 0,
            bottom: 0,
            child: Center(
              child: SizedBox(
                width: 200,
                child: Column(
                  children: [
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: _slides.length,
                      effect: const ScrollingDotsEffect(
                        dotHeight: 11,
                        dotWidth: 11,
                        dotColor: AppColors.iconSecondary,
                        activeDotColor: AppColors.iconPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    CustomFilledButton(
                      text: _slides.length - 1 == _currentIndex ? 'Начать' : 'Далее',
                      onPressed: _nextPage,
                    ),
                    AnimatedOpacity(
                      opacity: _slides.length - 1 == _currentIndex ? 0 : 1,
                      duration: const Duration(milliseconds: 600),
                      child: TextButton(
                        onPressed: _navigate,
                        child: const Text('Пропустить', style: TextStyle(color: AppColors.textSecondary)),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
