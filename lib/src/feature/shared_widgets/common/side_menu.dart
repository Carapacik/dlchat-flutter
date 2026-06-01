import 'package:collection/collection.dart';
import 'package:dlchat/src/core/common/extensions/extensions.dart';
import 'package:dlchat/src/core/constant/application_config.dart';
import 'package:dlchat/src/core/constant/generated/assets.gen.dart';
import 'package:dlchat/src/core/resources/resources.dart';
import 'package:dlchat/src/core/router/path_params.dart';
import 'package:dlchat/src/core/router/routes.dart';
import 'package:dlchat/src/feature/authentication/bloc/authentication/authentication_bloc.dart';
import 'package:dlchat/src/feature/authentication/widget/authentication_scope.dart';
import 'package:dlchat/src/feature/chat/model/assistant.dart';
import 'package:dlchat/src/feature/chat/model/chat.dart';
import 'package:dlchat/src/feature/chat/model/chat_model.dart';
import 'package:dlchat/src/feature/chat/model/model_type.dart';
import 'package:dlchat/src/feature/chats/bloc/chat_model/chat_model_bloc.dart';
import 'package:dlchat/src/feature/chats/bloc/chats/chats_bloc.dart';
import 'package:dlchat/src/feature/chats/widget/chats_limit_bottom_sheet.dart';
import 'package:dlchat/src/feature/chats/widget/chats_screen.dart' show ChatAction;
import 'package:dlchat/src/feature/shared_widgets/base/snack_bar.dart';
import 'package:dlchat/src/feature/shared_widgets/bottom_sheet/digital_avatar.dart';
import 'package:dlchat/src/feature/shared_widgets/button/filled_button.dart';
import 'package:dlchat/src/feature/shared_widgets/button/rate_badge.dart';
import 'package:dlchat/src/feature/shared_widgets/common/expansion_item.dart';
import 'package:dlchat/src/feature/shared_widgets/modal/alert_dialog.dart';
import 'package:dlchat/src/feature/shared_widgets/modal/bottom_sheet.dart';
import 'package:dlchat/src/feature/shared_widgets/text_field/text_field.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class const SideMenu({
  required final int selectedIndex,
  required final ValueChanged<int> onDestinationSelected,
  super.key,
}) extends StatefulWidget {
  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState() extends State<SideMenu> {
  final List<bool?> _expandedItems = [false, false, false];
  late final _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
    return BlocBuilder<ChatsBloc, ChatsState>(
      builder: (context, state) {
        return BlocBuilder<ChatModelBloc, ChatModelState>(
          builder: (context, chatModelState) {
            final List<({String iconPath, Future<void> Function() onTap, String title})> chats = [
              (
                onTap: () async => await addChatHandler(
                  modelType: ChatType.text,
                  useContext: true,
                  model: chatModelState.chatModels.firstWhereOrNull((e) => e.name == 'GPT-4o'),
                ),
                iconPath: Assets.svg.chat.path,
                title: 'Новый чат',
              ),
              (
                onTap: () async => await addChatHandler(
                  modelType: ChatType.image,
                  useContext: false,
                  model: chatModelState.chatModels.firstWhereOrNull((e) => e.name == 'DALL-E-3'),
                ),
                iconPath: Assets.svg.gallery.path,
                title: 'Чат изображений',
              ),
              (
                onTap: () async => await showDigitalAvatarBottomSheet(
                  context: context,
                  video: Assets.video.digitalAvatarsPreview,
                  builder: (context) => const DigitalAvatarBottomSheet(),
                ),
                iconPath: Assets.svg.people.path,
                title: 'Цифровой аватар',
              ),
              (
                onTap: () async {
                  final bool isHideVoiceOnboarding = await context.dependencies.onboardingRepository
                      .isHideVoiceOnboarding();
                  if (context.mounted) {
                    await context.pushNamedX(
                      isHideVoiceOnboarding ? Routes.transcriptions.name : Routes.transcriptionsOnboarding.name,
                    );
                  }
                },
                iconPath: Assets.svg.microphone.path,
                title: 'Голосовой чат',
              ),
            ];

            final List<Assistant> assistants = state.assistants;
            final List<Chat> chatHistory = state.chats;
            return SizedBox(
              width: 270, // menu width
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => context.goNamed(Routes.home.name),
                            child: const MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Text('DLCHAT', style: AppTypography.headerMedium),
                            ),
                          ),
                          const Spacer(),
                          const RateBadge(),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(color: Colors.black12, height: 1, width: double.infinity),
                      Expanded(
                        child: FadingEdgeScrollView.fromScrollView(
                          gradientFractionOnStart: 0,
                          gradientFractionOnEnd: 0.4,
                          child: ListView(
                            controller: _controller,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            children: [
                              CustomExpansionItem(
                                title: 'Главная',
                                isExpanded: null,
                                onTap: () => context.goNamedX(Routes.home.name),
                                body: const SizedBox.shrink(),
                              ),
                              CustomExpansionItem(
                                title: 'Чаты',
                                isExpanded: _expandedItems[0],
                                onTap: () {
                                  setState(() => _expandedItems[0] = !(_expandedItems[0] ?? false));
                                },
                                body: Column(
                                  spacing: 4,
                                  children: [
                                    for (final item in chats)
                                      _TileItem(onTap: item.onTap, iconPath: item.iconPath, title: item.title),
                                  ],
                                ),
                              ),
                              CustomExpansionItem(
                                title: 'Цифровые помощники',
                                isExpanded: _expandedItems[1],
                                onTap: () {
                                  setState(() => _expandedItems[1] = !(_expandedItems[1] ?? false));
                                },
                                body: Column(
                                  spacing: 4,
                                  children: [
                                    for (final assistant in assistants)
                                      _TileItem(
                                        id: assistant.id,
                                        onTap: () async => await _handleAssistantTap(context, assistant),
                                        iconPath: switch (AssistantEnum.fromString(assistant.name)) {
                                          AssistantEnum.analyst => Assets.svg.assistantAnalyst.path,
                                          AssistantEnum.business => Assets.svg.assistantBusiness.path,
                                          AssistantEnum.copywriter => Assets.svg.assistantCopywriter.path,
                                          AssistantEnum.nutritionist => Assets.svg.assistantCopywriter.path,
                                          AssistantEnum.design => Assets.svg.assistantDesign.path,
                                          AssistantEnum.lawyer => Assets.svg.assistantLawyer.path,
                                          AssistantEnum.smm => Assets.svg.assistantSmm.path,
                                          AssistantEnum.teacher => Assets.svg.assistantTeacher.path,
                                          AssistantEnum.translator => Assets.svg.assistantTranslator.path,
                                          _ => '',
                                        },
                                        title: assistant.name,
                                      ),
                                  ],
                                ),
                              ),
                              CustomExpansionItem(
                                title: 'История чатов',
                                isExpanded: _expandedItems[2],
                                onTap: () {
                                  setState(() => _expandedItems[2] = !(_expandedItems[2] ?? false));
                                },
                                body: Column(
                                  spacing: 4,
                                  children: [
                                    for (final item in chatHistory)
                                      _TileItem(
                                        id: item.id,
                                        onTap: item.status == 'ACTIVE'
                                            ? () async => await context.pushNamedX(
                                                Routes.chat.name,
                                                pathParameters: {RouteParams.id.path: item.id},
                                              )
                                            : () async => await showCustomModalBottomSheet(
                                                context: context,
                                                builder: (context) => const LimitsBottomSheet(),
                                              ),
                                        slidable: true,
                                        iconPath: switch (AssistantEnum.fromString(item.name)) {
                                          AssistantEnum.analyst => Assets.svg.assistantAnalyst.path,
                                          AssistantEnum.business => Assets.svg.assistantBusiness.path,
                                          AssistantEnum.copywriter => Assets.svg.assistantCopywriter.path,
                                          AssistantEnum.nutritionist => Assets.svg.assistantCopywriter.path,
                                          AssistantEnum.design => Assets.svg.assistantDesign.path,
                                          AssistantEnum.lawyer => Assets.svg.assistantLawyer.path,
                                          AssistantEnum.smm => Assets.svg.assistantSmm.path,
                                          AssistantEnum.teacher => Assets.svg.assistantTeacher.path,
                                          AssistantEnum.translator => Assets.svg.assistantTranslator.path,
                                          _ => switch (item.type) {
                                            ChatType.text => Assets.svg.chat.path,
                                            ChatType.image => Assets.svg.gallery.path,
                                            ChatType.textToSpeech => Assets.svg.microphone.path,
                                            ChatType.speechToText => Assets.svg.microphone.path,
                                            _ => Assets.svg.chat.path,
                                          },
                                        },
                                        title: item.name,
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => context.goNamedX(Routes.settings.name),
                        style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16)),
                        child: const Text('Настройки', style: AppTypography.bodyMedium),
                      ),
                      TextButton(
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
                        style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16)),
                        child: const Text('Техподдержка', style: AppTypography.bodyMedium),
                      ),
                      TextButton(
                        onPressed: () async => await showCustomAlertDialog(
                          context: context,
                          title: 'Выйти из аккаунта',
                          subTitle: 'Вы действительно хотите выйти из аккаунта?',
                          actionText: 'Выйти',
                          actionTextColor: AppColors.error,
                          action: () {
                            AuthenticationScope.of(context).add(const AuthenticationEvent.signOutPressed());
                            context.goNamedX(Routes.signIn.name);
                          },
                        ),
                        style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16)),
                        child: const Text('Выйти', style: AppTypography.bodyMedium),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
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

  Future<void> _handleAssistantTap(BuildContext context, Assistant assistant) async {
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
}

class const _TileItem({
  required final String title,
  required final VoidCallback onTap,
  required final String iconPath,
  final String id = '',
  final bool slidable = false,
}) extends StatefulWidget {
  @override
  State<_TileItem> createState() => _TileItemState();
}

class _TileItemState() extends State<_TileItem> with TickerProviderStateMixin {
  late final _textField = TextEditingController();
  late final _slidableController = SlidableController(this);

  @override
  void dispose() {
    _slidableController.dispose();
    _textField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget item = ListTile(
      onTap: widget.onTap,
      contentPadding: const EdgeInsets.all(4),
      dense: true,
      visualDensity: VisualDensity.compact,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      leading: widget.iconPath.isEmpty
          ? const SizedBox.square(dimension: 20)
          : SvgPicture.asset(
              widget.iconPath,
              height: 20,
              width: 20,
              colorFilter: const ColorFilter.mode(AppColors.black900, BlendMode.srcIn),
            ),
      title: Text(widget.title, style: AppTypography.bodyRegular.copyWith(color: AppColors.black900)),
    );
    if (widget.slidable && widget.id.isNotEmpty) {
      item = Listener(
        onPointerDown: (event) async {
          if (event.kind == PointerDeviceKind.mouse && event.buttons == kSecondaryMouseButton) {
            if (_slidableController.ratio < 1 && _slidableController.ratio > 0) {
              await _slidableController.close();
            } else {
              await _slidableController.openStartActionPane();
            }
          }
        },
        child: Slidable(
          controller: _slidableController,
          key: ValueKey(widget.id),
          startActionPane: ActionPane(
            extentRatio: 0.4,
            dragDismissible: false,
            motion: const ScrollMotion(),
            children: [
              SizedBox.square(
                dimension: 40,
                child: IconButton(
                  onPressed: () async => await _showConfirmDialog(
                    context: context,
                    chatId: widget.id,
                    chatName: widget.title,
                    action: ChatAction.rename,
                  ),
                  icon: SvgPicture.asset(
                    Assets.svg.noteEdit.path,
                    height: 20,
                    width: 20,
                    colorFilter: const ColorFilter.mode(AppColors.iconPrimary, BlendMode.srcIn),
                  ),
                  style: IconButton.styleFrom(backgroundColor: AppColors.bgIconButton),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox.square(
                dimension: 40,
                child: IconButton(
                  onPressed: () async =>
                      await _showConfirmDialog(context: context, chatId: widget.id, action: ChatAction.delete),
                  icon: SvgPicture.asset(
                    Assets.svg.trashFull.path,
                    height: 20,
                    width: 20,
                    colorFilter: const ColorFilter.mode(AppColors.inputError, BlendMode.srcIn),
                  ),
                  style: IconButton.styleFrom(backgroundColor: AppColors.bgIconButton),
                ),
              ),
            ],
          ),
          child: item,
        ),
      );
    }
    return item;
  }

  Future<void> _showConfirmDialog({
    required BuildContext context,
    required ChatAction action,
    required String chatId,
    String? chatName,
  }) {
    _textField.text = chatName ?? '';

    return showCustomAlertDialog(
      context: context,
      title: switch (action) {
        ChatAction.delete => 'Удаление чата',
        ChatAction.clean => 'Отчистка чата',
        ChatAction.rename => 'Переименовать чат',
      },
      subTitle: switch (action) {
        ChatAction.delete => 'Вы уверены, что хотите удалить чат?',
        ChatAction.clean => 'Вы уверены, что хотите отчистить чат?',
        ChatAction.rename => null,
      },
      content: switch (action) {
        ChatAction.delete => null,
        ChatAction.clean => null,
        ChatAction.rename => CustomTextField(
          controller: _textField,
          backgroundColor: AppColors.bgSecondary,
          labelText: 'Наименование чата',
          textCapitalization: TextCapitalization.sentences,
        ),
      },
      actionText: switch (action) {
        ChatAction.delete => 'Удалить',
        ChatAction.clean => 'Очистить',
        ChatAction.rename => 'Готово',
      },
      action: () {
        switch (action) {
          case ChatAction.delete:
            context.read<ChatsBloc>().add(ChatsEvent.removeChat(chatId));
          case ChatAction.clean:
            context.read<ChatsBloc>().add(ChatsEvent.clearChat(chatId));
          case ChatAction.rename:
            context.read<ChatsBloc>().add(ChatsEvent.renameChat(chatId, _textField.text.trim()));
        }
      },
    );
  }
}
