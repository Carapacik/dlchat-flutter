import 'dart:async';

import 'package:cross_file/cross_file.dart';
import 'package:dlchat/src/core/common/analytics/analytics.dart';
import 'package:dlchat/src/core/common/extensions/extensions.dart';
import 'package:dlchat/src/core/common/layout/layout.dart';
import 'package:dlchat/src/core/components/record_voice/record_voice_service.dart';
import 'package:dlchat/src/core/constant/generated/assets.gen.dart';
import 'package:dlchat/src/core/exception/exception_handler.dart';
import 'package:dlchat/src/core/resources/resources.dart';
import 'package:dlchat/src/feature/chat/bloc/audio_message/audio_message_bloc.dart';
import 'package:dlchat/src/feature/chat/bloc/chat/chat_bloc.dart';
import 'package:dlchat/src/feature/chat/model/chat.dart';
import 'package:dlchat/src/feature/chat/model/message.dart';
import 'package:dlchat/src/feature/chat/model/model_type.dart';
import 'package:dlchat/src/feature/chat/model/text_field_padding.dart';
import 'package:dlchat/src/feature/chat/widget/voice_record_button.dart';
import 'package:dlchat/src/feature/chats/bloc/chats/chats_bloc.dart';
import 'package:dlchat/src/feature/chats/widget/chats_limit_bottom_sheet.dart';
import 'package:dlchat/src/feature/payment/bloc/remaining/remaining_bloc.dart';
import 'package:dlchat/src/feature/payment/model/remaining.dart';
import 'package:dlchat/src/feature/shared_widgets/base/snack_bar.dart';
import 'package:dlchat/src/feature/shared_widgets/button/circle_icon_button.dart';
import 'package:dlchat/src/feature/shared_widgets/modal/bottom_sheet.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path/path.dart' as p;
import 'package:record/record.dart';

class const TextInputWidget({
  required final bool isSearch,
  required final RecordVoiceService recordVoiceService,
  required final TextEditingController controller,
  super.key,
}) extends StatefulWidget {
  @override
  State<TextInputWidget> createState() => _TextInputWidgetState();
}

class _TextInputWidgetState() extends State<TextInputWidget> {
  late final _keyboardFocusNode = FocusNode();
  late final _focusNode = FocusNode();
  late final _textFieldScrollController = ScrollController();
  XFile? _file;

  @override
  void dispose() {
    _keyboardFocusNode.dispose();
    _focusNode.dispose();
    _textFieldScrollController.dispose();
    super.dispose();
  }

  void _removeAttachment() {
    context.read<TextFieldPadding>().setFilePicked(isPicked: false);
    setState(() {
      _file = null;
    });
  }

  void _onTranscriptionComplete(Message audioMessage) {
    context.read<ChatBloc>().add(ChatEvent.addAudioMessage(audioMessage));
  }

  void _onSend({required bool isWaitingAnswer, Chat? chat}) {
    if (isWaitingAnswer) {
      return;
    }
    unawaited(context.dependencies.reporters.logEvent(AnalyticsEvents.chatUsed));
    final String textMessage = widget.controller.text.trim();
    context.read<ChatBloc>().add(ChatEvent.sendMessage(text: textMessage, isSearch: widget.isSearch, file: _file));
    context.read<ChatsBloc>().add(ChatsEvent.moveToTop(chat!.id));

    final RemainingBloc requestLimitBloc = context.read<RemainingBloc>();
    final RemainingRequests? remaining = requestLimitBloc.state.remaining;
    if (remaining != null) {
      if (chat.type case ChatType.text) {
        requestLimitBloc.add(RemainingEvent.decreaseTextRemaining(textMessage.length));
      } else if (chat.type case ChatType.image) {
        requestLimitBloc.add(const RemainingEvent.decreaseImageRemaining());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSizeScope.of(context);
    return BlocListener<AudioMessageBloc, AudioMessageState>(
      listener: (context, state) async {
        if (state case final AudioMessageFailure s) {
          s.exception.maybeMap(
            network: (e) async {
              if (e.networkType == NetworkExceptionType.messagesLimit) {
                await showCustomModalBottomSheet<void>(
                  context: context,
                  builder: (context) => const LimitsBottomSheet(isRequestsLimit: true),
                );
              } else {
                showCustomAppException(context, s.exception, 'Превышено время ожидания сервера');
              }
            },
            orElse: () => showCustomAppException(context, s.exception),
          );
        }
      },
      child: ListenableBuilder(
        listenable: widget.recordVoiceService,
        builder: (context, child) {
          return BlocConsumer<ChatBloc, ChatState>(
            listener: (context, state) {
              if (state.isWaitingAnswer) {
                widget.controller.clear();
                context.read<TextFieldPadding>().setNewLinesNumber(1);
                _removeAttachment();

                FocusManager.instance.primaryFocus?.unfocus();
              }
            },
            builder: (context, state) {
              return KeyboardListener(
                onKeyEvent: (evt) {
                  if (!HardwareKeyboard.instance.isShiftPressed && evt.logicalKey == LogicalKeyboardKey.enter) {
                    if (evt is KeyDownEvent) {
                      _onSend(isWaitingAnswer: state.isWaitingAnswer, chat: state.chat);
                    }
                  } else if (evt.logicalKey == LogicalKeyboardKey.enter) {
                    _focusNode.requestFocus();
                  }
                },
                focusNode: _keyboardFocusNode,
                child: Column(
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 170),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final showAttachButton = state.chat?.type != ChatType.image;
                          final double textFieldWidth = _calculateTextFieldWidth(
                            size: constraints.maxWidth,
                            showAttachButton: showAttachButton,
                            hasText: widget.controller.text.trim().isNotEmpty,
                            isRecording: widget.recordVoiceService.recordState == RecordState.record,
                          );
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (_file != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: SizedBox(
                                    height: 60,
                                    width: 140,
                                    child: Material(
                                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                                      color: AppColors.bgInputPrimary,
                                      clipBehavior: Clip.antiAlias,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SvgPicture.asset(
                                                  Assets.svg.fileDocument.path,
                                                  height: 28,
                                                  width: 28,
                                                  colorFilter: const ColorFilter.mode(
                                                    AppColors.iconSecondary,
                                                    BlendMode.srcIn,
                                                  ),
                                                ),
                                                const Spacer(),
                                                GestureDetector(
                                                  onTap: _removeAttachment,
                                                  child: const SizedBox.square(
                                                    dimension: 20,
                                                    child: Material(
                                                      color: AppColors.bgPrimary,
                                                      shape: CircleBorder(),
                                                      child: Icon(Icons.close, size: 12, color: AppColors.iconPrimary),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              p.basename(_file!.name),
                                              style: AppTypography.bodyPay.copyWith(color: AppColors.textSecondary),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                spacing: 4,
                                children: [
                                  if (showAttachButton) ...[
                                    CircleIconButton(
                                      icon: _file != null
                                          ? const Icon(Icons.check, color: AppColors.textPrimary, size: 24)
                                          : const Icon(Icons.attach_file, color: AppColors.textPrimary, size: 24),
                                      padding: 10,
                                      onPressed: () async {
                                        final PlatformFile? result = await FilePicker.pickFile(
                                          type: FileType.custom,
                                          allowedExtensions: ['xlsx', 'xls', 'csv', 'pdf', 'docx', 'txt'],
                                        );
                                        if (result == null || !mounted) {
                                          return;
                                        }
                                        setState(() {
                                          _file = result.xFile;
                                          context.read<TextFieldPadding>().setFilePicked(isPicked: true);
                                        });
                                      },
                                    ),
                                  ],
                                  BlocBuilder<AudioMessageBloc, AudioMessageState>(
                                    builder: (context, audioMessageState) {
                                      return Expanded(
                                        child: TextField(
                                          controller: widget.controller,
                                          focusNode: _focusNode,
                                          maxLines: 6,
                                          minLines: 1,
                                          style: AppTypography.bodyMedium,
                                          enabled: widget.recordVoiceService.recordState != RecordState.record,
                                          decoration: InputDecoration(
                                            hintText: widget.recordVoiceService.recordState == RecordState.record
                                                ? 'Идет запись...'
                                                : audioMessageState.inProgress
                                                ? 'Обработка записи...'
                                                : 'Спроси что угодно...',
                                            hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
                                            fillColor: windowSize.isLargeOrLarger
                                                ? AppColors.white300
                                                : AppColors.bgInputPrimary,
                                            filled: true,
                                            contentPadding: windowSize.isLargeOrLarger
                                                ? const EdgeInsets.symmetric(horizontal: 20, vertical: 16)
                                                : const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                            border: const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(44)),
                                              borderSide: BorderSide(color: AppColors.white),
                                            ),
                                            enabledBorder: const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(44)),
                                              borderSide: BorderSide(color: AppColors.white),
                                            ),
                                            focusedBorder: const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(44)),
                                              borderSide: BorderSide(color: AppColors.white),
                                            ),
                                            errorBorder: const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(44)),
                                              borderSide: BorderSide(color: AppColors.white),
                                            ),
                                            focusedErrorBorder: const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(44)),
                                              borderSide: BorderSide(color: AppColors.white),
                                            ),
                                            disabledBorder: const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(44)),
                                              borderSide: BorderSide(color: AppColors.white),
                                            ),
                                          ),
                                          textCapitalization: TextCapitalization.sentences,
                                          scrollController: _textFieldScrollController,
                                          onChanged: (text) {
                                            final span = TextSpan(text: text, style: AppTypography.bodyMedium);
                                            final tp =
                                                TextPainter(text: span, textDirection: TextDirection.ltr, maxLines: 6)
                                                  ..layout(
                                                    maxWidth: textFieldWidth - (windowSize.isLargeOrLarger ? 20 : 16),
                                                  );
                                            final int numLines = tp.computeLineMetrics().length;
                                            context.read<TextFieldPadding>().setNewLinesNumber(numLines);
                                            setState(() {});
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                  if (widget.controller.text.trim().isNotEmpty) ...[
                                    CircleIconButton(
                                      key: UniqueKey(),
                                      icon: Assets.svg.trashFull.svg(height: 24, width: 24),
                                      padding: 10,
                                      onPressed: () {
                                        context.read<TextFieldPadding>().setNewLinesNumber(1);
                                        setState(() => widget.controller.clear());
                                      },
                                    ),
                                  ],
                                  if (widget.controller.text.trim().isEmpty)
                                    VoiceRecordButton(
                                      recordVoiceService: widget.recordVoiceService,
                                      isSearch: widget.isSearch,
                                      onTranscriptionComplete: _onTranscriptionComplete,
                                    )
                                  else
                                    CircleIconButton(
                                      icon: Assets.svg.arrowUpMd.svg(height: 24, width: 24),
                                      padding: 10,
                                      onPressed: () =>
                                          _onSend.call(isWaitingAnswer: state.isWaitingAnswer, chat: state.chat),
                                    ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    if ((state.chat?.type == ChatType.text || state.chat?.type == ChatType.image) &&
                        windowSize.isLargeOrLarger)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          state.chat?.type == ChatType.text
                              ? 'DLChat может допускать ошибки. Рекомендуем проверять важную информацию.'
                              : 'Сгенерированные изображения доступны следующие 24 часа. Успейте сохранить к себе в галерею.',
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyRegular.copyWith(color: AppColors.textSecondary),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  double _calculateTextFieldWidth({
    required double size,
    required bool showAttachButton,
    required bool hasText,
    required bool isRecording,
  }) {
    var width = size;
    const double buttonWidth = 44; // размер CircleIconButton
    const double spacing = 4; // размер отступа между элементами

    // Отнимаем ширину кнопки прикрепления файла
    if (showAttachButton) {
      width = width - buttonWidth - spacing;
    }

    // Отнимаем ширину кнопок справа

    width = width - buttonWidth - spacing;
    if (hasText) {
      // кнопки очистки и отправки
      width = width - buttonWidth - spacing;
    }

    // Отнимаем ширину кнопки отмены записи
    if (isRecording) {
      width = width - buttonWidth - spacing;
    }

    return width;
  }
}
