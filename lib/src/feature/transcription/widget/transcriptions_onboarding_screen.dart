import 'dart:async';
import 'dart:math';

import 'package:dlchat/src/core/common/extensions/extensions.dart';
import 'package:dlchat/src/core/constant/generated/assets.gen.dart';
import 'package:dlchat/src/core/resources/resources.dart';
import 'package:dlchat/src/core/router/routes.dart';
import 'package:dlchat/src/feature/onboarding/data/onboarding_repository.dart';
import 'package:dlchat/src/feature/shared_widgets/button/filled_button.dart';
import 'package:dlchat/src/feature/shared_widgets/custom/gradient_painter.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class const Slide({required final String imagePath, required final String title, required final String description});

class const TranscriptionsOnboardingScreen({super.key}) extends StatefulWidget {
  @override
  State<TranscriptionsOnboardingScreen> createState() => _TranscriptionsOnboardingScreenState();
}

class _TranscriptionsOnboardingScreenState() extends State<TranscriptionsOnboardingScreen> {
  late final IOnboardingRepository _onboardingRepository = context.dependencies.onboardingRepository;
  late final _pageController = PageController();
  late final _pageController2 = PageController();
  var _currentIndex = 0;

  final _slides = <Slide>[
    Slide(
      imagePath: Assets.image.transcriptionOnboarding1.path,
      title: 'Траскрибируйте из ссылок',
      description: 'Отправьте ссылку на видео, чтобы мы преобразовали его в текст и проанализировали содержимое',
    ),
    Slide(
      imagePath: Assets.image.transcriptionOnboarding2.path,
      title: 'Траскрибируйте из файлов',
      description: 'Преобразовывайте любые аудио файлы в текстовый формат',
    ),
    Slide(
      imagePath: Assets.image.transcriptionOnboarding3.path,
      title: 'Записывайте аудио в онлайн-режиме',
      description: 'Записывайте и транскрибируйте онлайн-встречи, записывайте любые аудио и переводите их в текст',
    ),
  ];

  Future<void> _nextPage() async {
    if (_slides.length - 1 == _currentIndex) {
      await _navigate();
      return;
    }

    setState(() => _currentIndex = _currentIndex + 1);
    _pageController.animateToPage(_currentIndex, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    _pageController2.animateToPage(_currentIndex, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pageController2.dispose();
    super.dispose();
  }

  Future<void> _navigate() async {
    await _onboardingRepository.setHideVoiceOnboarding();
    if (mounted) {
      Navigator.of(context).pop();
      await context.pushNamedX(Routes.transcriptions.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    child: SizedBox(
                      height: min(
                        MediaQuery.sizeOf(context).height * 0.4 - MediaQuery.paddingOf(context).vertical,
                        400,
                      ),
                      child: PageView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _slides.length,
                        controller: _pageController2,
                        itemBuilder: (context, index) =>
                            Center(child: Image.asset(_slides[index].imagePath, width: 400)),
                      ),
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
