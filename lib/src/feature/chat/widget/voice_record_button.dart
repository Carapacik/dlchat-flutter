import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:dlchat/src/core/components/record_voice/record_voice_service.dart';
import 'package:dlchat/src/core/constant/generated/assets.gen.dart';
import 'package:dlchat/src/core/resources/resources.dart';
import 'package:dlchat/src/feature/chat/bloc/audio_message/audio_message_bloc.dart';
import 'package:dlchat/src/feature/chat/model/message.dart';
import 'package:dlchat/src/feature/shared_widgets/base/snack_bar.dart';
import 'package:dlchat/src/feature/shared_widgets/button/circle_icon_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path/path.dart' as p;
import 'package:record/record.dart';

class const VoiceRecordButton({
  required final RecordVoiceService recordVoiceService,
  required final bool isSearch,
  required final void Function(Message) onTranscriptionComplete,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AudioMessageBloc bloc = context.read<AudioMessageBloc>();
    return BlocBuilder<AudioMessageBloc, AudioMessageState>(
      builder: (context, state) {
        return ListenableBuilder(
          listenable: recordVoiceService,
          builder: (context, child) {
            return Row(
              spacing: 4,
              children: [
                if (recordVoiceService.recordState == RecordState.record) ...[
                  CircleIconButton(
                    icon: const Icon(Icons.close, color: AppColors.textPrimary),
                    padding: 12,
                    onPressed: () async {
                      await recordVoiceService.cancel();
                    },
                  ),
                ],
                CircleIconButton(
                  icon: recordVoiceService.recordState == RecordState.record
                      ? const Icon(Icons.stop, color: Colors.red)
                      : state.inProgress
                      ? LoadingAnimationWidget.progressiveDots(color: AppColors.textPrimary, size: 24)
                      : Assets.svg.microphone.svg(height: 24, width: 24),
                  padding: 10,
                  onPressed: state.inProgress
                      ? null
                      : () async {
                          if (recordVoiceService.recordState == RecordState.record) {
                            final String? filePath = await recordVoiceService.stop();
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
                              mimeType: kIsWeb || Platform.isMacOS || Platform.isWindows
                                  ? 'audio/x-wav'
                                  : 'audio/x-m4a',
                            );
                            bloc.add(
                              AudioMessageEvent.sendFile(
                                file: file,
                                isSearch: isSearch,
                                onTranscriptionComplete: onTranscriptionComplete,
                              ),
                            );
                          } else {
                            await recordVoiceService.start();
                          }
                        },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
