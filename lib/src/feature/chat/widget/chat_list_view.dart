import 'dart:async' show Timer;
import 'dart:io' show Platform;

import 'package:dlchat/src/core/components/file_save/file_save_service.dart';
import 'package:dlchat/src/core/resources/resources.dart';
import 'package:dlchat/src/feature/chat/bloc/chat/chat_bloc.dart';
import 'package:dlchat/src/feature/chat/model/message.dart';
import 'package:dlchat/src/feature/chat/model/text_field_padding.dart';
import 'package:dlchat/src/feature/chat/widget/chat_message.dart';
import 'package:dlchat/src/feature/shared_widgets/base/snack_bar.dart';
import 'package:dlchat/src/feature/shared_widgets/button/filled_button.dart';
import 'package:dlchat/src/feature/shared_widgets/modal/dialog.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart' show LoadingAnimationWidget;

class const ChatListView({required final bool isWaitingAnswer, super.key}) extends StatefulWidget {
  @override
  State<ChatListView> createState() => _ChatListViewState();
}

class _ChatListViewState() extends State<ChatListView> {
  late final _scrollController = ScrollController();
  Timer? _timer;
  int _counter = 0;
  final _sendMessageState = <String>['Отправляем запрос', 'Анализируем', 'Генерируем ответ'];
  final List<String> _reportMessages = [];
  final List<String> _savedMessages = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _handleTimer();
  }

  @override
  void didUpdateWidget(ChatListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isWaitingAnswer != widget.isWaitingAnswer) {
      _handleTimer();
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TextFieldPadding tfp = context.watch<TextFieldPadding>();
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return FadingEdgeScrollView.fromScrollView(
          gradientFractionOnStart:
              (tfp.paddingBottom + MediaQuery.paddingOf(context).bottom + 80) / MediaQuery.sizeOf(context).height,
          child: ListView.separated(
            controller: _scrollController,
            reverse: true,
            padding: EdgeInsets.fromLTRB(16, 24, 16, tfp.paddingBottom + MediaQuery.paddingOf(context).bottom + 64),
            itemCount: state.chatMessages.length + (state.inFetch ? 1 : 0) + (widget.isWaitingAnswer ? 1 : 0),
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              if (widget.isWaitingAnswer && index == 0) {
                return Row(
                  children: [
                    Text(
                      _sendMessageState[_counter],
                      style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(width: 8),
                    LoadingAnimationWidget.progressiveDots(color: AppColors.textSecondary, size: 32),
                  ],
                );
              }
              if (context.read<ChatBloc>().state.inFetch &&
                  index == state.chatMessages.length + (widget.isWaitingAnswer ? 1 : 0)) {
                return const Center(
                  child: Padding(padding: EdgeInsets.symmetric(vertical: 8), child: CircularProgressIndicator()),
                );
              }
              final Message message = state.chatMessages[index - (widget.isWaitingAnswer ? 1 : 0)];
              return ChatMessage(
                key: ValueKey(message.id),
                chatId: state.chat?.id ?? '',
                message: message,
                savedImages: _savedMessages,
                saveImage: (context, id, link) async => await _saveImage(context, id, link),
                reportMessages: _reportMessages,
                reportMessage: (context, id) async => await _reportMessage(context, id),
                scrollToStart: () {
                  if (_scrollController.hasClients) {
                    _scrollController.jumpTo(_scrollController.position.minScrollExtent);
                  }
                },
              );
            },
          ),
        );
      },
    );
  }

  void _onScroll() {
    if (_isTop) {
      context.read<ChatBloc>().add(const ChatEvent.fetched());
    }
  }

  bool get _isTop {
    final ChatBloc bloc = context.read<ChatBloc>();
    if (!_scrollController.hasClients || bloc.state.hasReachedMax) {
      return false;
    }
    final double maxScroll = _scrollController.position.maxScrollExtent;
    final double currentScroll = _scrollController.offset;
    return currentScroll < (maxScroll - 200);
  }

  void _handleTimer() {
    _timer?.cancel();
    if (widget.isWaitingAnswer) {
      _counter = 0;
      _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
        if (mounted) {
          setState(() {
            if (_counter < _sendMessageState.length - 1) {
              _counter++;
            } else {
              _timer?.cancel();
            }
          });
        } else {
          _timer?.cancel();
        }
      });
    }
  }

  Future<void> _saveImage(BuildContext context, String id, String link) async {
    final fileSaver = FileSaveService();
    try {
      await fileSaver.saveImageFromUrl(link);
      final resultMessage = kIsWeb
          ? 'Сохранено'
          : Platform.isAndroid || Platform.isIOS
          ? 'Сохранено в галерею'
          : 'Сохранено в загрузки';
      if (context.mounted) {
        showInfoMessage(context, resultMessage);
        setState(() {
          _savedMessages.add(id);
        });
      }
    } on Object {
      if (context.mounted) {
        showErrorMessage(context, 'Ошибка. Нет разрешения');
      }
    }
  }

  Future<void> _reportMessage(BuildContext context, String messageId) async {
    final String? result = await showCustomDialog<String?>(
      context: context,
      title: 'На что жалуетесь?',
      builder: (context) => const _ReportDialogBody(),
    );
    if (result == null) {
      return;
    }
    setState(() {
      _reportMessages.add(messageId);
    });
    if (context.mounted) {
      await showCustomAlertDialog(
        context: context,
        title: 'Жалоба принята',
        subTitle: 'Спасибо, что сообщили нам о проблеме! Ваша обратная связь важна для нас. Мы оперативно рассмотрим вашу жалобу и примем необходимые меры.',
        actionText: 'Ок',
      );
    }
  }
}

class const _ReportDialogBody() extends StatefulWidget {
  @override
  State<_ReportDialogBody> createState() => _ReportDialogBodyState();
}

class _ReportDialogBodyState() extends State<_ReportDialogBody> {
  final List<(String, String)> _list = [
    (
      'Оскорбительный контент:',
      '- Ненормативная лексика\n- Расистские и сексистские замечания\n- Обидные высказывания',
    ),
    ('Дезинформация:', '- Ложная информация или факты\n- Мошенничество\n- Проблемы с источниками'),
    (
      'Неприемлемый контент:',
      '- Непристойные изображения или тексты\n- Призывы к насилию\n- Порнографические материалы',
    ),
  ];
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final item in _list)
            DecoratedBox(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.bgThird)),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _selected = item.$1;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(child: Text(item.$1, style: AppTypography.bodyMedium)),
                            SizedBox(
                              height: 24,
                              width: 24,
                              child: Material(
                                color: _selected == item.$1 ? AppColors.textPrimary : AppColors.iconFourth,
                                shape: const CircleBorder(),
                                clipBehavior: Clip.antiAlias,
                                child: _selected == item.$1
                                    ? const Center(child: Icon(Icons.check, size: 16, color: AppColors.white))
                                    : const SizedBox.shrink(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(item.$2, style: AppTypography.bodySettingsMedium.copyWith(color: AppColors.textSecondary)),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 16),
          CustomFilledButton(
            text: 'Пожаловаться',
            onPressed: () {
              Navigator.of(context).pop(_selected);
            },
          ),
        ],
      ),
    );
  }
}
