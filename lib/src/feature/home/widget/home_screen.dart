import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dlchat/src/core/common/extensions/extensions.dart';
import 'package:dlchat/src/core/common/layout/layout.dart';
import 'package:dlchat/src/core/common/version.dart';
import 'package:dlchat/src/core/constant/generated/assets.gen.dart';
import 'package:dlchat/src/core/exception/exception_handler.dart';
import 'package:dlchat/src/core/resources/resources.dart';
import 'package:dlchat/src/core/router/path_params.dart';
import 'package:dlchat/src/core/router/routes.dart';
import 'package:dlchat/src/feature/chat/model/assistant.dart';
import 'package:dlchat/src/feature/chat/model/chat.dart';
import 'package:dlchat/src/feature/chat/model/chat_model.dart';
import 'package:dlchat/src/feature/chat/model/model_type.dart';
import 'package:dlchat/src/feature/chats/bloc/chat_model/chat_model_bloc.dart';
import 'package:dlchat/src/feature/chats/bloc/chats/chats_bloc.dart';
import 'package:dlchat/src/feature/chats/widget/chats_limit_bottom_sheet.dart';
import 'package:dlchat/src/feature/home/data/tutorial_repository.dart';
import 'package:dlchat/src/feature/home/widget/modal/change_log_bottom_sheet.dart';
import 'package:dlchat/src/feature/payment/bloc/remaining/remaining_bloc.dart';
import 'package:dlchat/src/feature/shared_widgets/base/app_bar.dart';
import 'package:dlchat/src/feature/shared_widgets/base/snack_bar.dart';
import 'package:dlchat/src/feature/shared_widgets/bottom_sheet/digital_avatar.dart';
import 'package:dlchat/src/feature/shared_widgets/button/rate_badge.dart';
import 'package:dlchat/src/feature/shared_widgets/common/gradient_icon_widget.dart';
import 'package:dlchat/src/feature/shared_widgets/loading/full_screen_loading.dart';
import 'package:dlchat/src/feature/shared_widgets/loading/shimmer.dart';
import 'package:dlchat/src/feature/shared_widgets/modal/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class const HomeScreen({super.key}) extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState() extends State<HomeScreen> {
  late final String _appVersion = context.dependencies.packageInfo.version;
  late final ITutorialRepository _tutorialRepository = context.dependencies.tutorialRepository;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async => await _showChangeLog());
  }

  Future<void> _showChangeLog() async {
    final String? lastVersion = await _tutorialRepository.getLastShownVersion();

    if (lastVersion == null || compareVersions(_appVersion, lastVersion) == 1) {
      if (mounted) {
        await showChangeLogModal(context);
        await _tutorialRepository.setLastShownVersion(_appVersion);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ChatsBloc chatsBloc = context.watch<ChatsBloc>();
    final WindowSize windowSize = WindowSizeScope.of(context);
    return FullScreenLoading(
      inProgress: chatsBloc.state.inAddProgress,
      child: Scaffold(
        appBar: windowSize.isLargeOrLarger
            ? null
            : const MobileAppBar(
                automaticallyImplyLeading: false,
                title: Text('DLCHAT', style: AppTypography.headerMedium),
                actions: [RateBadge()],
              ),
        body: BlocListener<ChatsBloc, ChatsState>(
          listener: (context, state) async {
            if (state.newChat != null) {
              await context.pushNamedX(Routes.chat.name, pathParameters: {RouteParams.id.path: state.newChat!.id});
            } else if (state.existingChat != null) {
              await context.pushNamedX(Routes.chat.name, pathParameters: {RouteParams.id.path: state.existingChat!.id});
            }
            if (state case final ChatsFailure s) {
              s.exception.maybeMap(
                network: (e) async {
                  if (e.networkType == NetworkExceptionType.chatsLimit) {
                    await showCustomModalBottomSheet<void>(
                      context: context,
                      builder: (context) => const LimitsBottomSheet(isRequestsLimit: true),
                    );
                  } else {
                    showCustomAppException(context, s.exception);
                  }
                },
                orElse: () => showCustomAppException(context, s.exception),
              );
            }
          },
          child: windowSize.isLargeOrLarger
              ? ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    Text('Возможности сервиса', style: AppTypography.bodySemibold.copyWith(fontSize: 32)),
                    const SizedBox(height: 20),
                    const Text('Чаты', style: AppTypography.bodySemibold),
                    const _SelectService(),
                    const SizedBox(height: 20),
                    const Text('Цифровые помощники', style: AppTypography.bodySemibold),
                    const SizedBox(height: 16),
                    const _SelectAssistant(),
                  ],
                )
              : ListView(
                  children: const [
                    _SelectService(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Цифровые помощники', style: AppTypography.bodySemibold),
                    ),
                    _SelectAssistant(),
                  ],
                ),
        ),
      ),
    );
  }
}

class const _SelectService() extends StatefulWidget {
  @override
  State<_SelectService> createState() => _SelectServiceState();
}

class _SelectServiceState() extends State<_SelectService> {
  Future<void> addChatHandler({required ChatType modelType, required bool useContext, ChatModel? model}) async {
    if (model != null) {
      context.read<ChatsBloc>().add(
        ChatsEvent.addChat(chatModelId: model.id, modelType: modelType, useContext: useContext),
      );
    } else {
      showErrorMessage(context, 'Не удалось создать чат');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final WindowSize windowSize = WindowSizeScope.of(context);
    return BlocBuilder<RemainingBloc, RemainingState>(
      builder: (context, state) {
        if (state.inProgress) {
          Shimmer(
            child: GridView.builder(
              padding: windowSize.isLargeOrLarger ? EdgeInsets.zero : const EdgeInsets.all(16),
              itemCount: 4,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                mainAxisExtent: 130,
                maxCrossAxisExtent: size.width / 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 12,
              ),
              itemBuilder: (context, index) =>
                  const ShimmerLoading(inProgress: true, child: DecoratedBox(decoration: BoxDecoration())),
            ),
          );
        }
        final List<Widget> card = [
          // TODO(akozlov): Временный builder
          BlocBuilder<ChatModelBloc, ChatModelState>(
            builder: (context, chatModelState) {
              final ChatModel? model = chatModelState.chatModels.firstWhereOrNull((e) => e.name == 'GPT-4o');
              return _ServiceCard(
                icon: GradientIconWidget(
                  iconPath: Assets.svg.chat.path,
                  iconColor: AppColors.iconMainChat1,
                  gradient: AppColors.pinkGradient,
                ),
                title: 'Обсудить тему',
                description: 'Чат с контекстом',
                limit: (state.remaining?.requests ?? 0) < 9999 ? (state.remaining?.requests ?? 0).toString() : '∞',
                gradient: AppColors.pinkGradient,
                onPressed: () async => await addChatHandler(modelType: ChatType.text, useContext: true, model: model),
              );
            },
          ),
          BlocBuilder<ChatModelBloc, ChatModelState>(
            builder: (context, chatModelState) {
              final ChatModel? model = chatModelState.chatModels.firstWhereOrNull((e) => e.name == 'DALL-E-3');
              return _ServiceCard(
                icon: GradientIconWidget(
                  iconPath: Assets.svg.gallery.path,
                  iconColor: AppColors.iconMainChat2,
                  gradient: AppColors.blueGradient,
                ),
                title: 'Чат изображений',
                description: 'Создавай и рисуй',
                limit: (state.remaining?.images ?? 0) < 9999 ? (state.remaining?.images ?? 0).toString() : '∞',
                gradient: AppColors.blueGradient,
                onPressed: () async => await addChatHandler(modelType: ChatType.image, useContext: false, model: model),
              );
            },
          ),
          _ServiceCard(
            icon: GradientIconWidget(
              iconPath: Assets.svg.people.path,
              iconColor: AppColors.iconMainChat3,
              gradient: AppColors.greenGradient,
            ),
            title: 'Цифровой аватар',
            description: 'Клонируй себя',
            limit: 'Скоро',
            gradient: AppColors.greenGradient,
            showBadge: true,
            onPressed: () async => await showDigitalAvatarBottomSheet(
              context: context,
              video: Assets.video.digitalAvatarsPreview,
              builder: (context) => const DigitalAvatarBottomSheet(),
            ),
          ),
          _ServiceCard(
            icon: GradientIconWidget(
              iconPath: Assets.svg.microphone.path,
              iconColor: AppColors.iconMainChat4,
              gradient: AppColors.orangeGradient,
            ),
            title: 'Голосовой чат',
            description: 'Транскрибируй',
            limit: 'Скоро',
            gradient: AppColors.orangeGradient,
            onPressed: () async {
              final bool isHideVoiceOnboarding = await context.dependencies.onboardingRepository
                  .isHideVoiceOnboarding();
              if (context.mounted) {
                await context.pushNamedX(
                  isHideVoiceOnboarding ? Routes.transcriptions.name : Routes.transcriptionsOnboarding.name,
                );
              }
            },
          ),
        ];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: windowSize.isLargeOrLarger
                  ? const EdgeInsets.symmetric(vertical: 16)
                  : const EdgeInsets.symmetric(horizontal: 16),
              child: BlocBuilder<ChatModelBloc, ChatModelState>(
                builder: (context, chatModelState) {
                  final ChatModel? model = chatModelState.chatModels.firstWhereOrNull((e) => e.name == 'GPT-4o');
                  return SizedBox(
                    width: windowSize.isLargeOrLarger ? 760 : double.infinity,
                    child: _ServiceCard(
                      icon: GradientIconWidget(
                        iconPath: Assets.svg.chat.path,
                        iconColor: AppColors.iconMainChat1,
                        gradient: AppColors.pinkGradient,
                      ),
                      title: 'Чат на любые темы',
                      description: 'Быстрый вопрос - быстрый ответ',
                      limit: (state.remaining?.requests ?? 0) < 9999
                          ? (state.remaining?.requests ?? 0).toString()
                          : '∞',
                      gradient: AppColors.pinkGradient,
                      onPressed: () async =>
                          await addChatHandler(modelType: ChatType.text, useContext: false, model: model),
                    ),
                  );
                },
              ),
            ),
            GridView.builder(
              padding: windowSize.isLargeOrLarger ? EdgeInsets.zero : const EdgeInsets.all(16),
              itemCount: card.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                mainAxisExtent: 130,
                maxCrossAxisExtent: windowSize.isLargeOrLarger ? 760 / 4 : size.width / 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 12,
              ),
              itemBuilder: (context, index) => card[index],
            ),
          ],
        );
      },
    );
  }
}

class const _SelectAssistant() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final WindowSize windowSize = WindowSizeScope.of(context);
    final double maxCrossAxisExtent = windowSize.isLargeOrLarger
        ? (size.width - 270 - 24 * 2 - 16 * 2) / 4
        : size.width / 2;
    return BlocBuilder<ChatsBloc, ChatsState>(
      builder: (context, state) {
        if (state.inProgress) {
          return Shimmer(
            child: GridView.builder(
              padding: windowSize.isLargeOrLarger ? EdgeInsets.zero : const EdgeInsets.all(16),
              itemCount: 8,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                mainAxisExtent: 100,
                maxCrossAxisExtent: maxCrossAxisExtent,
                mainAxisSpacing: 16,
                crossAxisSpacing: 12,
              ),
              itemBuilder: (context, index) => const Padding(
                padding: EdgeInsets.only(right: 8),
                child: ShimmerLoading(inProgress: true, child: SizedBox.shrink()),
              ),
            ),
          );
        }
        return GridView.builder(
          padding: windowSize.isLargeOrLarger ? EdgeInsets.zero : const EdgeInsets.all(16),
          itemCount: state.assistants.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            mainAxisExtent: 100,
            maxCrossAxisExtent: maxCrossAxisExtent,
            mainAxisSpacing: 16,
            crossAxisSpacing: 12,
          ),
          itemBuilder: (context, index) => _AssistantCard(assistant: state.assistants[index]),
        );
      },
    );
  }
}

class const _ServiceCard({
  required final Widget icon,
  required final String title,
  required final String description,
  required final String limit,
  required final Gradient gradient,
  required final VoidCallback onPressed,
  final bool showBadge = false,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, right: 8),
          child: Material(
            borderRadius: BorderRadius.circular(16),
            clipBehavior: Clip.antiAlias,
            color: AppColors.bgSecondary,
            child: InkWell(
              onTap: onPressed,
              child: SizedBox(
                width: double.infinity,
                height: 130,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      icon,
                      const Spacer(),
                      Text(title, style: AppTypography.bodySettingsMedium),
                      const SizedBox(height: 2),
                      Text(description, style: AppTypography.bodyRegular.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (showBadge)
          Positioned(
            right: 0,
            child: _DescriptionIcon(limit: limit, gradient: gradient),
          ),
      ],
    );
  }
}

class const _DescriptionIcon({required final String limit, required final Gradient gradient}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 20,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          gradient: gradient,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        ),
        child: Center(child: Text(limit, style: const TextStyle(fontSize: 12))),
      ),
    );
  }
}

class const _AssistantCard({required final Assistant assistant}) extends StatelessWidget {
  Future<void> _handleAssistantTap(BuildContext context) async {
    final AssistantEnum? assistantEnum = AssistantEnum.fromString(assistant.name);
    final List<Chat> chats = context.read<ChatsBloc>().state.chats;

    if (assistantEnum == AssistantEnum.nutritionist) {
      await _handleNutritionistTap(context, chats);
      return;
    }

    final Chat? existingChat = chats.firstWhereOrNull((e) => e.presetId == assistant.presetId);
    if (existingChat != null) {
      await _navigateToExistingChat(context, existingChat.id);
      return;
    }

    context.read<ChatsBloc>().add(
      ChatsEvent.addChat(
        chatModelId: assistant.chatModelId,
        useContext: true,
        name: assistant.name,
        presetId: assistant.presetId,
      ),
    );
  }

  Future<void> _handleNutritionistTap(BuildContext context, List<Chat> chats) async {
    final Chat? existingNutritionist = chats.firstWhereOrNull((e) => e.type == ChatType.nutrition);
    if (existingNutritionist != null) {
      await _navigateToExistingChat(context, existingNutritionist.id);
      return;
    }

    final bool isHideOnboarding = await context.dependencies.onboardingRepository.isHideAssistantNutritionOnboarding();
    if (!context.mounted) {
      return;
    }

    await context.pushNamedX(
      isHideOnboarding ? Routes.nutritionistFillingData.name : Routes.nutritionistOnboarding.name,
    );
  }

  Future<void> _navigateToExistingChat(BuildContext context, String chatId) async {
    context.goNamedX(Routes.chats.name);
    await context.pushNamedX(Routes.chat.name, pathParameters: {RouteParams.id.path: chatId});
  }

  @override
  Widget build(BuildContext context) {
    final AssistantEnum? assistantEnum = AssistantEnum.fromString(assistant.name);
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        color: AppColors.bgSecondary,
        child: InkWell(
          onTap: () async => await _handleAssistantTap(context),
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  switch (assistantEnum) {
                    AssistantEnum.analyst => Assets.svg.assistantAnalyst.svg(),
                    AssistantEnum.business => Assets.svg.assistantBusiness.svg(),
                    AssistantEnum.copywriter => Assets.svg.assistantCopywriter.svg(),
                    AssistantEnum.nutritionist => Assets.svg.assistantCopywriter.svg(),
                    AssistantEnum.design => Assets.svg.assistantDesign.svg(),
                    AssistantEnum.lawyer => Assets.svg.assistantLawyer.svg(),
                    AssistantEnum.smm => Assets.svg.assistantSmm.svg(),
                    AssistantEnum.teacher => Assets.svg.assistantTeacher.svg(),
                    AssistantEnum.translator => Assets.svg.assistantTranslator.svg(),
                    null => const SizedBox.shrink(),
                  },
                  const Spacer(),
                  Text(assistant.name, style: AppTypography.bodySettingsMedium),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
