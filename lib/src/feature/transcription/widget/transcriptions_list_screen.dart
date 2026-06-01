import 'dart:async';
import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:dlchat/src/core/common/extensions/context_extension.dart';
import 'package:dlchat/src/core/components/audio_processing/audio_processing_service.dart';
import 'package:dlchat/src/core/components/record_voice/record_voice_service.dart';
import 'package:dlchat/src/core/constant/generated/assets.gen.dart';
import 'package:dlchat/src/core/exception/exception_handler.dart';
import 'package:dlchat/src/core/resources/resources.dart';
import 'package:dlchat/src/core/router/routes.dart';
import 'package:dlchat/src/feature/chats/widget/chats_limit_bottom_sheet.dart';
import 'package:dlchat/src/feature/payment/bloc/remaining/remaining_bloc.dart';
import 'package:dlchat/src/feature/payment/bloc/user_rate/user_rate_bloc.dart';
import 'package:dlchat/src/feature/shared_widgets/base/app_bar.dart';
import 'package:dlchat/src/feature/shared_widgets/base/snack_bar.dart';
import 'package:dlchat/src/feature/shared_widgets/bottom_sheet/record_voice.dart';
import 'package:dlchat/src/feature/shared_widgets/button/circle_icon_button.dart';
import 'package:dlchat/src/feature/shared_widgets/button/rate_badge.dart';
import 'package:dlchat/src/feature/shared_widgets/dialog/transcription_by_link.dart';
import 'package:dlchat/src/feature/shared_widgets/loading/shimmer.dart';
import 'package:dlchat/src/feature/shared_widgets/modal/bottom_sheet.dart';
import 'package:dlchat/src/feature/shared_widgets/modal/dialog.dart';
import 'package:dlchat/src/feature/shared_widgets/text_field/text_field.dart';
import 'package:dlchat/src/feature/transcription/bloc/send_transcription/send_transcription_bloc.dart';
import 'package:dlchat/src/feature/transcription/bloc/transcriptions/transcriptions_bloc.dart';
import 'package:dlchat/src/feature/transcription/model/transcription_content.dart';
import 'package:dlchat/src/feature/transcription/model/transcription_data.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

class const TranscriptionsScreen({super.key}) extends StatefulWidget {
  @override
  State<TranscriptionsScreen> createState() => _TranscriptionsScreenState();
}

class _TranscriptionsScreenState() extends State<TranscriptionsScreen> {
  late final _scrollController = ScrollController();
  late final _textField = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _textField.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<TranscriptionsBloc>().add(const TranscriptionsEvent.fetch());
    }
  }

  bool get _isBottom {
    final TranscriptionsBloc bloc = context.read<TranscriptionsBloc>();
    if (!_scrollController.hasClients || bloc.state.hasReachedMax) {
      return false;
    }
    final double maxScroll = _scrollController.position.maxScrollExtent;
    final double currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    final TranscriptionsBloc bloc = context.read<TranscriptionsBloc>();
    return BlocConsumer<SendTranscriptionBloc, SendTranscriptionState>(
      listener: (context, state) {
        switch (state) {
          case final SendTranscriptionFailure s:
            hideCurrentSnackBar();
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
          case final SendTranscriptionSuccess _:
            hideCurrentSnackBar();
            Future.delayed(const Duration(seconds: 1), () {
              bloc.add(const TranscriptionsEvent.start());
            });
          default:
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: buildPlatformAppBar(context, titleText: 'Мои транскрибации', actions: [const RateBadge()]),
          body: BlocConsumer<TranscriptionsBloc, TranscriptionsState>(
            listener: (context, state) {
              if (state case final TranscriptionsSuccess _) {
                context.read<RemainingBloc>().add(const RemainingEvent.start());
              } else if (state case final TranscriptionsFailure s) {
                showCustomAppException(context, s.exception);
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state.inProgress)
                        Expanded(
                          child: ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 12,
                            separatorBuilder: (context, index) => const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Divider(height: 1, thickness: 1, color: AppColors.iconSecondary),
                            ),
                            itemBuilder: (context, index) {
                              return const Shimmer(
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      ShimmerLoading(
                                        inProgress: true,
                                        child: SizedBox.square(
                                          dimension: 44,
                                          child: DecoratedBox(decoration: ShapeDecoration(shape: CircleBorder())),
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ShimmerLoading(inProgress: true, child: SizedBox(width: 200, height: 16)),
                                            SizedBox(height: 4),
                                            ShimmerLoading(inProgress: true, child: SizedBox(width: 150, height: 10)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      else if (state.transcriptions.isEmpty)
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: Text(
                                'Голосовое сообщение, загрузка файла или ссылки — сделайте первую транскрипцию прямо сейчас!',
                                style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                              ),
                            ),
                          ),
                        )
                      else
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: () async {
                              bloc.add(const TranscriptionsEvent.start());
                            },
                            child: FadingEdgeScrollView.fromScrollView(
                              gradientFractionOnEnd: 0,
                              child: ListView.separated(
                                controller: _scrollController,
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: EdgeInsets.fromLTRB(0, 16, 0, 130 + MediaQuery.paddingOf(context).bottom),
                                itemCount: state.transcriptions.length,
                                separatorBuilder: (context, index) => const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Divider(height: 1, thickness: 1, color: AppColors.iconSecondary),
                                ),
                                itemBuilder: (context, index) {
                                  final TranscriptionData item = state.transcriptions[index];
                                  return _ListItem(
                                    item: item,
                                    onTap: () async {
                                      await context.pushNamedX(
                                        Routes.detailTranscription.name,
                                        pathParameters: {'id': item.id},
                                        queryParameters: {'name': item.name},
                                      );
                                    },
                                    onRemove: () => bloc.add(TranscriptionsEvent.delete(item.id)),
                                    onRename: () async => await _showConfirmDialog(
                                      context: context,
                                      itemId: item.id,
                                      chatName: item.name,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      if (!state.inProgress && state.transcriptions.isEmpty) const Spacer(),
                    ],
                  ),
                  const _BottomBarWidget(),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _showConfirmDialog({required BuildContext context, required String itemId, String? chatName}) {
    _textField.text = chatName ?? '';
    return showCustomAlertDialog(
      context: context,
      title: 'Переименовать запись',
      content: CustomTextField(
        controller: _textField,
        backgroundColor: AppColors.bgSecondary,
        labelText: 'Наименование чата',
        textCapitalization: TextCapitalization.sentences,
      ),
      actionText: 'Готово',
      action: () {
        if (_textField.text.isEmpty) {
          showErrorMessage(context, 'Имя записи не может быть пустой');
          return;
        }
        context.read<TranscriptionsBloc>().add(TranscriptionsEvent.rename(itemId, _textField.text.trim()));
      },
    );
  }
}

class const _ListItem({
  required final TranscriptionData item,
  required final VoidCallback onRename,
  required final VoidCallback onRemove,
  required final VoidCallback onTap,
}) extends StatefulWidget {
  @override
  State<_ListItem> createState() => _ListItemState();
}

class _ListItemState() extends State<_ListItem> with SingleTickerProviderStateMixin {
  late final SlidableController _controller;

  Timer? _timer;
  int _counter = 0;
  final _states = <String>['В процессе', 'Еще чуть-чуть', 'Подготовка'];

  @override
  void initState() {
    super.initState();
    _controller = SlidableController(this);
    if (widget.item.status == TranscriptionStatus.inProgress) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        setState(() {
          _counter = (_counter + 1) % _states.length;
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant _ListItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.item.status != widget.item.status) {
      if (widget.item.status == TranscriptionStatus.inProgress) {
        _startTimer();
      } else {
        _timer?.cancel();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? externalTranscriptionContent = _detectTranscriptionContent(widget.item);
    return Slidable(
      key: ValueKey(widget.item.id),
      controller: _controller,
      endActionPane: ActionPane(
        extentRatio: 0.3,
        dragDismissible: false,
        motion: const ScrollMotion(),
        children: [
          CustomSlidableAction(
            backgroundColor: AppColors.bgPrimary,
            onPressed: (c) async => {},
            padding: const EdgeInsets.only(right: 16),
            child: CircleIconButton(
              icon: Assets.svg.noteEdit.svg(),
              backgroundColor: AppColors.bgSecondary,
              onPressed: () async {
                widget.onRename();
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
                widget.onRemove();
                await _controller.close();
              },
            ),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.item.status == TranscriptionStatus.failed ? null : widget.onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                SizedBox.square(
                  dimension: 44,
                  child: Center(
                    child: externalTranscriptionContent != null
                        ? Image.asset(externalTranscriptionContent, height: 28)
                        : SvgPicture.asset(Assets.svg.fileDocument.path, height: 28),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(widget.item.name, style: AppTypography.bodyMedium),
                      Text(
                        DateFormat('dd MMMM yyyy HH:mm').format(widget.item.createdAt.toLocal()),
                        style: AppTypography.bodyRegular,
                      ),
                      if (widget.item.status != TranscriptionStatus.finished) ...[
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Row(
                            children: [
                              if (widget.item.status == TranscriptionStatus.inProgress)
                                SizedBox(
                                  width: 200,
                                  height: 4,
                                  child: LinearProgressIndicator(
                                    backgroundColor: AppColors.bgSecondary,
                                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.pink1),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: Text(
                                  _statusLocalized(context, widget.item.status),
                                  style: AppTypography.bodyRegular.copyWith(color: AppColors.textSecondary),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _detectTranscriptionContent(TranscriptionData item) {
    for (final TranscriptionContent type in TranscriptionContent.values) {
      if (RegExp(type.pattern).hasMatch(item.name) || RegExp(type.pattern).hasMatch(item.content ?? '')) {
        return switch (type) {
          TranscriptionContent.youtube => Assets.image.youtube.path,
          TranscriptionContent.rutube => Assets.image.rutube.path,
          TranscriptionContent.googleDrive => Assets.image.googleDrive.path,
          TranscriptionContent.yandexDisk => Assets.image.yandexDisk.path,
          TranscriptionContent.zoom => Assets.image.zoom.path,
        };
      }
    }
    return null;
  }

  String _statusLocalized(BuildContext context, TranscriptionStatus status) => switch (status) {
    TranscriptionStatus.inProgress => _states[_counter],
    TranscriptionStatus.finished => '',
    TranscriptionStatus.failed => 'Ошибка',
  };
}

class const _BottomBarWidget() extends StatefulWidget {
  @override
  State<_BottomBarWidget> createState() => __BottomBarWidgetState();
}

class __BottomBarWidgetState() extends State<_BottomBarWidget> with SingleTickerProviderStateMixin {
  final _audioProcessingService = AudioProcessingService();
  final _recordVoiceService = RecordVoiceService();

  @override
  void dispose() {
    unawaited(_recordVoiceService.dispose());
    super.dispose();
  }

  Future<bool> _checkLimits(BuildContext context) async {
    final limitReached = context.read<UserRateBloc>().state.userRate == null;
    if (limitReached) {
      unawaited(
        showCustomModalBottomSheet<void>(
          context: context,
          builder: (context) => const LimitsBottomSheet(isRequestsLimit: true),
        ),
      );
    }
    return limitReached;
  }

  @override
  Widget build(BuildContext context) {
    final TranscriptionsBloc bloc = context.read<TranscriptionsBloc>();
    return _BottomBarWrapper(
      onMicroPressed: () async {
        final SendTranscriptionBloc sendBloc = context.read<SendTranscriptionBloc>();
        final bool limitReached = await _checkLimits(context);
        if (limitReached) {
          return;
        }
        if (!context.mounted) {
          return;
        }
        final String? result = await showRecordVoice(context, _recordVoiceService);
        if (result == null) {
          return;
        }
        if (result == 'CANCEL') {
          return;
        } else if (result == 'STOP') {
          final String? filePath = await _recordVoiceService.stop();
          if (filePath == null) {
            if (context.mounted) {
              showErrorMessage(context, 'Ошибка записи файла');
            }
            return;
          }
          final String fileName = p.basename(filePath) + (kIsWeb ? '.wav' : '');
          final file = XFile(
            filePath,
            name: fileName,
            mimeType: kIsWeb || Platform.isMacOS || Platform.isWindows ? 'audio/x-wav' : 'audio/x-m4a',
          );
          sendBloc.add(SendTranscriptionEvent.sendFile(file));
          bloc.add(const TranscriptionsEvent.start());
        }
      },
      onUploadPressed: () async {
        final SendTranscriptionBloc sendBloc = context.read<SendTranscriptionBloc>();
        final bool limitReached = await _checkLimits(context);
        if (limitReached) {
          return;
        }
        final bool isExtractAudioFromVideoSupported =
            !kIsWeb && (Platform.isAndroid || Platform.isIOS || Platform.isMacOS);
        const audioExtensions = ['mp3', 'm4a', 'wav', 'ogg'];
        const videoExtensions = ['mp4', 'avi', 'mov', 'mpeg', 'mkv'];
        final PlatformFile? result = await FilePicker.pickFile(
          type: FileType.custom,
          allowedExtensions: [...audioExtensions, ...videoExtensions],
        );
        if (result == null || !mounted) {
          return;
        }
        final XFile inputFile = result.xFile;
        final String inputFileExtension = p.extension(inputFile.name).toLowerCase().substring(1);
        XFile? audioFromVideoFile;
        if (isExtractAudioFromVideoSupported && videoExtensions.contains(inputFileExtension)) {
          // 200 Mb in bytes
          const maxVideoFileSize = 200_000_000;
          try {
            final int inputFileLength = await inputFile.length();
            if (inputFileLength > maxVideoFileSize) {
              if (context.mounted) {
                showErrorMessage(context, 'Размер файла не должен превышать 200\u{00A0}Мб');
              }
              return;
            }
            sendBloc.add(const SendTranscriptionEvent.startExtractAudio());
            final String? audioFromVideoFilePath = await _audioProcessingService.extractAudioFromVideo(inputFile.path);
            if (audioFromVideoFilePath != null) {
              audioFromVideoFile = XFile(audioFromVideoFilePath, name: p.basename(audioFromVideoFilePath));
            }
          } on AppException catch (e) {
            if (context.mounted) {
              showErrorMessage(context, e.message);
            }
            return;
          }
        }
        sendBloc.add(SendTranscriptionEvent.sendFile(audioFromVideoFile ?? inputFile));
        bloc.add(const TranscriptionsEvent.start());
      },
      onLinkPressed: () async {
        final SendTranscriptionBloc sendBloc = context.read<SendTranscriptionBloc>();
        final bool limitReached = await _checkLimits(context);
        if (limitReached) {
          return;
        }
        if (!context.mounted) {
          return;
        }
        final String? result = await showTranscriptionByLinkDialog(context: context);
        if (result == null) {
          return;
        }
        sendBloc.add(SendTranscriptionEvent.sendUrl(result));
      },
    );
  }
}

class const _BottomBarWrapper({
  required final VoidCallback onMicroPressed,
  required final VoidCallback onUploadPressed,
  required final VoidCallback onLinkPressed,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Material(
            color: AppColors.bgSecondary,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _BottomButton(iconPath: Assets.svg.upload.path, label: 'Загрузить', onTap: onUploadPressed),
                    _BottomButton(iconPath: Assets.svg.link.path, label: 'Ссылка', onTap: onLinkPressed),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 50,
          right: 0,
          left: 0,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: BlocBuilder<SendTranscriptionBloc, SendTranscriptionState>(
                builder: (context, state) {
                  final isEnabled = state is SendTranscriptionIdle;
                  return Material(
                    color: Colors.transparent,
                    shape: const CircleBorder(),
                    child: Ink(
                      decoration: ShapeDecoration(
                        gradient: LinearGradient(
                          colors: [
                            if (isEnabled) AppColors.white else AppColors.gray400,
                            if (isEnabled) AppColors.pink1 else AppColors.gray600,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: const CircleBorder(),
                      ),
                      child: SizedBox.square(
                        dimension: 80,
                        child: IconButton(
                          onPressed: isEnabled ? onMicroPressed : null,
                          icon: SvgPicture.asset(
                            Assets.svg.microphone.path,
                            height: 36,
                            width: 36,
                            colorFilter: ColorFilter.mode(
                              isEnabled ? Colors.black : AppColors.gray800,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class const _BottomButton({
  required final String iconPath,
  required final String label,
  required final VoidCallback onTap,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.bgThird,
      shape: const StadiumBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 100,
          height: 50,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(iconPath, height: 16, width: 16),
                const SizedBox(height: 4),
                Text(label, style: AppTypography.bodyRegular),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
