import 'package:dlchat/src/core/common/extensions/extensions.dart';
import 'package:dlchat/src/core/constant/generated/assets.gen.dart';
import 'package:dlchat/src/core/resources/resources.dart';
import 'package:dlchat/src/core/router/path_params.dart';
import 'package:dlchat/src/core/router/routes.dart';
import 'package:dlchat/src/feature/chat/model/assistant.dart';
import 'package:dlchat/src/feature/chat/model/chat.dart';
import 'package:dlchat/src/feature/chat/model/model_type.dart';
import 'package:dlchat/src/feature/chats/bloc/chats/chats_bloc.dart';
import 'package:dlchat/src/feature/chats/widget/chats_limit_bottom_sheet.dart';
import 'package:dlchat/src/feature/shared_widgets/base/app_bar.dart';
import 'package:dlchat/src/feature/shared_widgets/button/circle_icon_button.dart';
import 'package:dlchat/src/feature/shared_widgets/button/rate_badge.dart';
import 'package:dlchat/src/feature/shared_widgets/common/gradient_icon_widget.dart';
import 'package:dlchat/src/feature/shared_widgets/loading/shimmer.dart';
import 'package:dlchat/src/feature/shared_widgets/modal/alert_dialog.dart';
import 'package:dlchat/src/feature/shared_widgets/modal/bottom_sheet.dart';
import 'package:dlchat/src/feature/shared_widgets/text_field/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class const ChatsScreen({super.key}) extends StatefulWidget {
  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState() extends State<ChatsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildPlatformAppBar(
        context,
        automaticallyImplyLeading: false,
        titleText: 'Чаты',
        actions: [
          const RateBadge(),
          const SizedBox(width: 8),
          CircleIconButton(
            icon: SvgPicture.asset(Assets.svg.addPlus.path),
            backgroundColor: AppColors.bgSecondary,
            onPressed: () => context.goNamed(Routes.home.name),
          ),
        ],
      ),
      body: const _ChatsContent(),
    );
  }
}

class const _ChatsContent() extends StatefulWidget {
  @override
  State<_ChatsContent> createState() => _ChatsContentState();
}

class _ChatsContentState() extends State<_ChatsContent> {
  late final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<ChatsBloc>().add(const ChatsEvent.fetched());
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  bool get _isBottom {
    final ChatsBloc bloc = context.read<ChatsBloc>();
    if (!_scrollController.hasClients || bloc.state.hasReachedMax) {
      return false;
    }
    final double maxScroll = _scrollController.position.maxScrollExtent;
    final double currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatsBloc, ChatsState>(
      builder: (context, state) {
        if (state.inProgress) {
          return Shimmer(
            child: ListView.builder(
              itemCount: 4,
              itemBuilder: (context, _) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                child: ShimmerLoading(
                  inProgress: true,
                  child: SizedBox(
                    height: 60,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        if (state.chats.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                Assets.svg.chat.svg(height: 32),
                const SizedBox(height: 12),
                const Text('Создайте свой первый чат', textAlign: TextAlign.center, style: AppTypography.bodyMedium),
                const Spacer(flex: 3),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async => context.read<ChatsBloc>().add(const ChatsEvent.start()),
          child: ListView.separated(
            controller: _scrollController,
            padding: EdgeInsets.zero,
            separatorBuilder: (context, index) => !(state.chats.length - 1 == index)
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Divider(height: 1, color: AppColors.iconSecondary),
                  )
                : const SizedBox(height: 120),
            shrinkWrap: true,
            itemCount: state.chats.length + 1,
            itemBuilder: (context, index) {
              if (index == state.chats.length) {
                return const SizedBox.shrink();
              }
              return _ChatTile(chat: state.chats[index], index: index);
            },
          ),
        );
      },
    );
  }
}

enum ChatAction() {
  delete,
  clean,
  rename,
}

class const _ChatTile({required final Chat chat, required final int index}) extends StatefulWidget {
  @override
  State<_ChatTile> createState() => _ChatTileState();
}

class _ChatTileState() extends State<_ChatTile> with SingleTickerProviderStateMixin {
  final _textField = TextEditingController();
  late final SlidableController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SlidableController(this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isActive = widget.chat.status == 'ACTIVE';
    return Slidable(
      controller: _controller,
      key: widget.key,
      groupTag: '0',
      endActionPane: ActionPane(
        extentRatio: 0.3,
        motion: const DrawerMotion(),
        children: [
          CustomSlidableAction(
            backgroundColor: AppColors.bgPrimary,
            onPressed: (c) async => {},
            padding: const EdgeInsets.only(right: 16),
            child: CircleIconButton(
              icon: Assets.svg.noteEdit.svg(),
              backgroundColor: AppColors.bgSecondary,
              onPressed: () async {
                await _showConfirmDialog(chatId: widget.chat.id, chatName: widget.chat.name, action: ChatAction.rename);
                await _controller.close();
              },
            ),
          ),
          CustomSlidableAction(
            backgroundColor: AppColors.bgPrimary,
            onPressed: (c) async => {},
            padding: const EdgeInsets.only(right: 16),
            child: CircleIconButton(
              icon: Assets.svg.trashFull.svg(),
              backgroundColor: AppColors.bgSecondary,
              onPressed: () async {
                await _showConfirmDialog(chatId: widget.chat.id, action: ChatAction.delete);
                await _controller.close();
              },
            ),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: ListTile(
          leading: _assistantImage(),
          title: Text(
            widget.chat.name,
            style: AppTypography.bodyMedium.copyWith(color: isActive ? AppColors.textPrimary : AppColors.textSecondary),
          ),
          trailing: isActive ? null : Assets.svg.lock.svg(),
          onTap: isActive
              ? () async =>
                    await context.pushNamedX(Routes.chat.name, pathParameters: {RouteParams.id.path: widget.chat.id})
              : () async =>
                    await showCustomModalBottomSheet(context: context, builder: (context) => const LimitsBottomSheet()),
        ),
      ),
    );
  }

  Widget _assistantImage() {
    final isActive = widget.chat.status == 'ACTIVE';

    final AssistantEnum? assistant = AssistantEnum.fromString(widget.chat.name);
    final String? assistantIcon = switch (assistant) {
      AssistantEnum.analyst => Assets.svg.assistantAnalyst.path,
      AssistantEnum.business => Assets.svg.assistantBusiness.path,
      AssistantEnum.copywriter => Assets.svg.assistantCopywriter.path,
      AssistantEnum.nutritionist => Assets.svg.assistantCopywriter.path,
      AssistantEnum.design => Assets.svg.assistantDesign.path,
      AssistantEnum.lawyer => Assets.svg.assistantLawyer.path,
      AssistantEnum.smm => Assets.svg.assistantSmm.path,
      AssistantEnum.teacher => Assets.svg.assistantTeacher.path,
      AssistantEnum.translator => Assets.svg.assistantTranslator.path,
      null => null,
    };

    if (assistantIcon != null) {
      return GradientIconWidget(
        iconPath: assistantIcon,
        iconColor: AppColors.iconMainChat1,
        gradient: AppColors.pinkGradient,
        isActive: isActive,
        padding: 8,
      );
    }

    final String iconPath = switch (widget.chat.type) {
      ChatType.text => Assets.svg.chat.path,
      ChatType.image => Assets.svg.gallery.path,
      ChatType.textToSpeech => Assets.svg.microphone.path,
      ChatType.speechToText => Assets.svg.microphone.path,
      _ => Assets.svg.chat.path,
    };
    final Color iconColor = switch (widget.chat.type) {
      ChatType.text => AppColors.iconMainChat1,
      ChatType.image => AppColors.iconMainChat2,
      ChatType.textToSpeech => AppColors.iconMainChat4,
      ChatType.speechToText => AppColors.iconMainChat4,
      _ => AppColors.iconMainChat1,
    };
    final LinearGradient gradient = switch (widget.chat.type) {
      ChatType.text => AppColors.pinkGradient,
      ChatType.image => AppColors.blueGradient,
      ChatType.textToSpeech => AppColors.orangeGradient,
      ChatType.speechToText => AppColors.orangeGradient,
      _ => AppColors.pinkGradient,
    };

    return GradientIconWidget(iconPath: iconPath, iconColor: iconColor, gradient: gradient, isActive: isActive);
  }

  Future<void> _showConfirmDialog({required ChatAction action, required String chatId, String? chatName}) {
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
            context.read<ChatsBloc>().add(ChatsEvent.renameChat(chatId, _textField.text));
        }
      },
    );
  }
}
