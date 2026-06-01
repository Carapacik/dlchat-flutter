import 'dart:async';
import 'dart:io' show Platform;

import 'package:collection/collection.dart';
import 'package:dlchat/src/core/common/extensions/extensions.dart';
import 'package:dlchat/src/core/common/layout/layout.dart';
import 'package:dlchat/src/core/components/prefs_storage/tutorial/tutorial_datasource.dart';
import 'package:dlchat/src/core/components/record_voice/record_voice_service.dart';
import 'package:dlchat/src/core/constant/generated/assets.gen.dart';
import 'package:dlchat/src/core/constant/generated/fonts.gen.dart';
import 'package:dlchat/src/core/exception/exception_handler.dart';
import 'package:dlchat/src/core/resources/resources.dart';
import 'package:dlchat/src/feature/chat/bloc/chat/chat_bloc.dart';
import 'package:dlchat/src/feature/chat/model/assistant.dart';
import 'package:dlchat/src/feature/chat/model/model_type.dart';
import 'package:dlchat/src/feature/chat/widget/chat_list_view.dart';
import 'package:dlchat/src/feature/chat/widget/chat_shimmer.dart';
import 'package:dlchat/src/feature/chat/widget/chat_text_input.dart';
import 'package:dlchat/src/feature/chat/widget/modal/chat_faq_bottom_sheet.dart';
import 'package:dlchat/src/feature/chats/bloc/chats/chats_bloc.dart';
import 'package:dlchat/src/feature/chats/widget/chats_limit_bottom_sheet.dart';
import 'package:dlchat/src/feature/home/data/tutorial_repository.dart';
import 'package:dlchat/src/feature/shared_widgets/base/app_bar.dart';
import 'package:dlchat/src/feature/shared_widgets/base/snack_bar.dart';
import 'package:dlchat/src/feature/shared_widgets/button/circle_icon_button.dart';
import 'package:dlchat/src/feature/shared_widgets/custom/gradient_painter.dart';
import 'package:dlchat/src/feature/shared_widgets/modal/bottom_sheet.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class const ChatScreen({super.key, final GlobalKey? mainScreenKey}) extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState() extends State<ChatScreen> {
  late final ITutorialRepository _tutorialRepository = context.dependencies.tutorialRepository;
  bool _isSearch = false;
  final GlobalKey _dlSearchButtonKey = GlobalKey();
  Timer? _debounce;
  TutorialCoachMark? _tutorialCoachMark;
  final RecordVoiceService _recordVoiceService = RecordVoiceService();
  late final _textController = TextEditingController();

  @override
  void dispose() {
    _debounce?.cancel();
    _textController.dispose();
    unawaited(_recordVoiceService.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSizeScope.of(context);
    final List<Widget> children = [
      const _ChatContent(),
      Positioned(
        bottom: 8,
        right: 8,
        left: 8,
        child: SafeArea(
          top: false,
          child: TextInputWidget(
            recordVoiceService: _recordVoiceService,
            isSearch: _isSearch,
            controller: _textController,
          ),
        ),
      ),
      if (windowSize.isLargeOrLarger)
        BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            final bool showDLSearch = state.chat?.type == ChatType.text && state.chat?.presetId == null;
            if (showDLSearch) {
              _onOpenTutorial(context);
            }
            return showDLSearch
                ? Positioned(
                    top: 8,
                    right: 8,
                    child: SafeArea(
                      child: CircleIconButton(
                        key: _dlSearchButtonKey,
                        icon: Icon(
                          Icons.language,
                          color: _isSearch ? const Color(0xFF148eff) : AppColors.textPrimary,
                          size: 24,
                        ),
                        backgroundColor: _isSearch ? const Color(0x1a148eff) : AppColors.bgSecondary,
                        onPressed: () => setState(() => _isSearch = !_isSearch),
                      ),
                    ),
                  )
                : const SizedBox.shrink();
          },
        ),
    ];
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: windowSize.isLargeOrLarger
            ? null
            : _ChatAppBar(
                isSearch: _isSearch,
                onSearchChanged: ({required value}) {
                  setState(() => _isSearch = value);
                },
                dlSearchButtonKey: _dlSearchButtonKey,
                onDLSearchAvailable: () => _onOpenTutorial(context),
              ),
        backgroundColor: windowSize.isLargeOrLarger ? AppColors.white : null,
        body: windowSize.isLargeOrLarger
            ? Stack(fit: StackFit.expand, children: children)
            : ChatGradient(children: children),
      ),
    );
  }

  void _onOpenTutorial(BuildContext context) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
      _tutorialCoachMark?.skip();
    }
    _debounce = Timer(const Duration(milliseconds: 600), () {
      _tutorialCoachMark?.skip();
      _tutorialCoachMark = null;
      _tutorialCoachMark = _createTutorial();
      unawaited(_showTutorialIfNeeded(context));
    });
  }

  TutorialCoachMark _createTutorial() => TutorialCoachMark(
    targets: [
      TargetFocus(
        identify: 'DLSearchButton',
        keyTarget: _dlSearchButtonKey,
        alignSkip: Alignment.bottomRight,
        contents: [
          TargetContent(
            align: ContentAlign.left,
            builder: (context, controller) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (kIsWeb || Platform.isMacOS) const SizedBox(height: 60),
                const Text(
                  'DLSearch',
                  style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Включите, чтобы получать обработанную и структурированную информацию прямо из актуальных ресурсов интернета',
                  style: TextStyle(color: AppColors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    ],
    textSkip: 'Отлично!',
    textStyleSkip: const TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 14),
    onFinish: () async => await _saveTutorialShown(),
    onSkip: () {
      unawaited(_saveTutorialShown());
      return true;
    },
  );

  Future<void> _saveTutorialShown() async => await _tutorialRepository.markTutorialAsShown(TutorialType.dlSearch);

  Future<void> _showTutorialIfNeeded(BuildContext context) async {
    final bool? wasShown = await _tutorialRepository.wasTutorialShown(TutorialType.dlSearch);
    if (!(wasShown ?? false)) {
      if (context.mounted) {
        _tutorialCoachMark?.show(context: context, rootOverlay: true);
      }
    }
  }
}

class const _ChatAppBar({
  required final bool isSearch,
  required final void Function({required bool value}) onSearchChanged,
  required final GlobalKey dlSearchButtonKey,
  required final VoidCallback onDLSearchAvailable,
}) extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        final bool showDLSearch = state.chat?.type == ChatType.text && state.chat?.presetId == null;
        if (showDLSearch) {
          onDLSearchAvailable.call();
        }
        return buildPlatformAppBar(
          context,
          title: const Text('DLCHAT', style: AppTypography.headerMedium),
          actions: [
            if (showDLSearch) ...[
              CircleIconButton(
                key: dlSearchButtonKey,
                icon: Icon(Icons.language, color: isSearch ? const Color(0xFF148eff) : AppColors.textPrimary),
                backgroundColor: isSearch ? const Color(0x1a148eff) : AppColors.bgSecondary,
                onPressed: () async => onSearchChanged(value: !isSearch),
              ),
              const SizedBox(width: 8),
            ],
            if (state.chat?.type == ChatType.text && (state.chat?.useContext ?? false))
              CircleIconButton(
                icon: Assets.svg.circleHelp.svg(),
                backgroundColor: AppColors.bgSecondary,
                onPressed: () async => await showCustomModalBottomSheet(
                  context: context,
                  builder: (context) => const ChatInfoBottomSheet(
                    title: 'Контекст диалога',
                    description: 'DLChat поддерживает контекст диалога в пределах одного чата. Если вы хотите обсудить новую тему, начните новый чат, чтобы получить наиболее точные и связные ответы',
                  ),
                ),
              ),
            const SizedBox(width: 8),
          ],
        );
      },
    );
  }
}

class const _ChatContent() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSizeScope.of(context);
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) async {
        if (state case final ChatFailure s) {
          s.exception.maybeMap(
            network: (e) async {
              if (e.networkType == NetworkExceptionType.messagesLimit ||
                  e.networkType == NetworkExceptionType.userSubscriptionNotFound) {
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
      builder: (context, state) {
        final List<Assistant> assistants = context.read<ChatsBloc>().state.assistants;
        final Assistant? existsAssistant = assistants.firstWhereOrNull((a) => a.presetId == state.chat?.presetId);
        final String? assistantDescription = existsAssistant?.description;
        if (state.inProgress) {
          return const ChatShimmer();
        }
        if (state.chatMessages.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (assistantDescription != null)
                    _ChatPreview(message: assistantDescription)
                  else
                    _ChatPreview(
                      message: state.chat?.type == ChatType.image
                          ? 'Создавайте и редактируйте изображения'
                          : 'Привет! Чем я могу помочь?',
                    ),
                  if ((state.chat?.type == ChatType.text || state.chat?.type == ChatType.image) &&
                      !windowSize.isLargeOrLarger) ...[
                    const SizedBox(height: 16),
                    Text(
                      state.chat?.type == ChatType.text
                          ? 'DLChat может допускать ошибки.\nРекомендуем проверять важную информацию.'
                          : 'Сгенерированные изображения доступны следующие 24 часа.\nУспейте сохранить к себе в галерею.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyRegular.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ],
              ),
            ),
          );
        }
        return ChatListView(isWaitingAnswer: state.isWaitingAnswer);
      },
    );
  }
}

class const _ChatPreview({required final String message}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Assets.image.mainBall.image(height: 80),
        const SizedBox(height: 32),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: Text(
            message,
            style: const TextStyle(fontSize: 24, fontFamily: FontFamily.sFNSExpanded, color: AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
