import 'dart:async';

import 'package:dlchat/src/core/common/analytics/analytics.dart';
import 'package:dlchat/src/core/common/extensions/extensions.dart';
import 'package:dlchat/src/core/common/layout/layout.dart';
import 'package:dlchat/src/core/constant/generated/assets.gen.dart';
import 'package:dlchat/src/core/resources/resources.dart';
import 'package:dlchat/src/core/router/routes.dart';
import 'package:dlchat/src/feature/authentication/model/user.dart';
import 'package:dlchat/src/feature/authentication/widget/authentication_scope.dart';
import 'package:dlchat/src/feature/onboarding/data/onboarding_repository.dart';
import 'package:dlchat/src/feature/shared_widgets/base/app_bar.dart';
import 'package:dlchat/src/feature/shared_widgets/button/filled_button.dart';
import 'package:dlchat/src/feature/shared_widgets/custom/gradient_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class const Slide({required final String title, required final String description});

class const OnboardingScreen({super.key}) extends StatefulWidget {
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState() extends State<OnboardingScreen> {
  late final IOnboardingRepository _onboardingRepository = context.dependencies.onboardingRepository;
  final _pageController = PageController();
  var _currentIndex = 0;

  static const _slides = <Slide>[
    Slide(
      title: 'DLCHAT - чат \nдля умного общения',
      description: 'Забудьте про скучные справочники - DLChat ответит на все ваши вопросы за секунды',
    ),
    Slide(
      title: 'Текстовые чаты',
      description:
          'Ищите информацию, анализируйте веб-сайты, получайте советы и даже поддерживайте диалоги на любые темы',
    ),
    Slide(
      title: 'Генерация изображений',
      description: 'От иллюстраций до графики: оживите ваши идеи в визуальной форме',
    ),
  ];

  Future<void> _nextPage() async {
    if (_slides.length - 1 == _currentIndex) {
      await _goNext();
      return;
    }

    setState(() => _currentIndex = _currentIndex + 1);
    await _pageController.animateToPage(
      _currentIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    super.initState();
    unawaited(context.dependencies.reporters.logEvent(AnalyticsEvents.install));
    unawaited(context.dependencies.reporters.logEvent(AnalyticsEvents.firstOpen));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _goNext() async {
    final User user = AuthenticationScope.userOf(context, listen: false);
    final AnalyticsEventReporter reporters = context.dependencies.reporters;
    final GoRouter router = GoRouter.of(context);
    await _onboardingRepository.setHideOnboarding();

    unawaited(reporters.logEvent(AnalyticsEvents.onboardingComplete));
    router.goNamed(user.isAuthenticated ? Routes.home.name : Routes.signIn.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildPlatformAppBar(
        context,
        automaticallyImplyLeading: false,
        title: const Text('DLCHAT', style: AppTypography.headerMedium),
      ),
      extendBodyBehindAppBar: true,
      body: ChatGradient(
        children: [
          Center(
            child: Column(children: [const Spacer(), Assets.image.mainBall.image(height: 80), const Spacer(flex: 3)]),
          ),
          if (!WindowSizeScope.of(context).isLargeOrLarger) ...[
            Positioned.fill(
              child: PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _slides.length,
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                  child: Column(
                    children: [
                      const Spacer(flex: 3),
                      Text(_slides[index].title, textAlign: TextAlign.center, style: AppTypography.headerMedium),
                      const SizedBox(height: 8),
                      Text(
                        _slides[index].description,
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                      ),
                      const Spacer(flex: 2),
                    ],
                  ),
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
                      const SizedBox(height: 20),
                      CustomFilledButton(
                        text: _slides.length - 1 == _currentIndex ? 'Начать' : 'Далее',
                        onPressed: _nextPage,
                      ),
                      AnimatedOpacity(
                        opacity: _slides.length - 1 == _currentIndex ? 0 : 1,
                        duration: const Duration(milliseconds: 600),
                        child: TextButton(
                          onPressed: _goNext,
                          child: const Text('Пропустить', style: TextStyle(color: AppColors.textSecondary)),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ] else
            _DesktopContent(nextScreen: _goNext),
        ],
      ),
    );
  }
}

class const _DesktopContent({required final VoidCallback nextScreen}) extends StatefulWidget {
  @override
  State<_DesktopContent> createState() => _DesktopContentState();
}

class _DesktopContentState() extends State<_DesktopContent> {
  late final _pageController = PageController();
  var _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _nextPage() async {
    if (2 - 1 == _currentIndex) {
      widget.nextScreen.call();
      return;
    }
    setState(() => _currentIndex = _currentIndex + 1);
    await _pageController.animateToPage(
      _currentIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<({String content, LinearGradient gradient, Color iconColor, String iconPath, String title})> cards = [
      (
        iconPath: Assets.svg.chat.path,
        iconColor: AppColors.iconMainChat1,
        gradient: AppColors.pinkGradient,
        title: 'Текстовый чат',
        content: 'Ищите информацию, получайте советы и даже поддерживайте диалоги на любую тему',
      ),
      (
        iconPath: Assets.svg.gallery.path,
        iconColor: AppColors.iconMainChat2,
        gradient: AppColors.blueGradient,
        title: 'Генерация изображений',
        content: 'От иллюстраций до графики: оживите ваши идеи в визуальной форме',
      ),
      (
        iconPath: Assets.svg.people.path,
        iconColor: AppColors.iconMainChat3,
        gradient: AppColors.greenGradient,
        title: 'Цифровой аватар',
        content: 'Создайте свою цифровую копию для общения и автоматизации',
      ),
      (
        iconPath: Assets.svg.microphone.path,
        iconColor: AppColors.iconMainChat4,
        gradient: AppColors.orangeGradient,
        title: 'Голосовой чат',
        content: 'Говорите и слушайте ответы для комфортного общения',
      ),
    ];
    return Column(
      children: [
        const Spacer(flex: 5),
        SizedBox(
          height: 180,
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            clipBehavior: Clip.none,
            children: [
              Center(
                child: SizedBox(
                  width: 330,
                  child: Column(
                    children: [
                      const Spacer(),
                      const Text(
                        'DLCHAT - чат \nдля умного общения',
                        style: AppTypography.headerMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Забудьте про скучные справочники - DLChat ответит на все ваши вопросы за секунды',
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
              Center(
                child: Row(
                  spacing: 12,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final card in cards)
                      _OptionCard(
                        iconPath: card.iconPath,
                        gradient: card.gradient,
                        iconColor: card.iconColor,
                        title: card.title,
                        content: card.content,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SmoothPageIndicator(
          controller: _pageController,
          count: 2,
          effect: const ScrollingDotsEffect(
            dotHeight: 11,
            dotWidth: 11,
            dotColor: AppColors.iconSecondary,
            activeDotColor: AppColors.iconPrimary,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 210,
          child: CustomFilledButton(text: 1 == _currentIndex ? 'Начать' : 'Далее', onPressed: _nextPage),
        ),
        AnimatedOpacity(
          opacity: 1 == _currentIndex ? 0 : 1,
          duration: const Duration(milliseconds: 600),
          child: TextButton(
            onPressed: widget.nextScreen,
            child: const Text('Пропустить', style: TextStyle(color: AppColors.textSecondary)),
          ),
        ),
        const Spacer(flex: 2),
      ],
    );
  }
}

class const _OptionCard({
  required final String iconPath,
  required final String title,
  required final String content,
  required final LinearGradient gradient,
  required final Color iconColor,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          boxShadow: [
            BoxShadow(offset: const Offset(8, 4), color: AppColors.iconPrimary.withAlpha(25), blurRadius: 32),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox.square(
                dimension: 44,
                child: DecoratedBox(
                  decoration: ShapeDecoration(shape: const CircleBorder(), gradient: gradient),
                  child: Center(
                    child: SvgPicture.asset(
                      iconPath,
                      height: 18,
                      width: 18,
                      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(title, style: AppTypography.bodySettingsMedium),
              Text(content, style: AppTypography.bodySettingsMedium.copyWith(color: AppColors.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }
}
