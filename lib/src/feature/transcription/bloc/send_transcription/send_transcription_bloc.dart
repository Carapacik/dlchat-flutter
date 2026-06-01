import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cross_file/cross_file.dart';
import 'package:dlchat/src/core/exception/exception_handler.dart';
import 'package:dlchat/src/feature/authentication/data/authentication_repository.dart';
import 'package:dlchat/src/feature/transcription/data/transcription_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'send_transcription_bloc.freezed.dart';
part 'send_transcription_event.dart';
part 'send_transcription_state.dart';

final class SendTranscriptionBloc({
  required final ITranscriptionsRepository _transcriptionsRepository,
  required final IAuthenticationRepository _authenticationRepository,
}) extends Bloc<SendTranscriptionEvent, SendTranscriptionState> {
  this : super(const SendTranscriptionState.idle()) {
    on<_SendTranscriptionSendFile>(_sendFile);
    on<_SendTranscriptionSendUrl>(_sendUrl);
    on<_SendTranscriptionStartExtractAudio>(_startExtractAudio);
  }

  static const _maxFileSize = 200_000_000; // 200 MB in bytes

  Future<void> _sendFile(_SendTranscriptionSendFile event, Emitter<SendTranscriptionState> emitter) async {
    emitter(const SendTranscriptionState.uploading(progress: 0));
    await ExceptionHandler.handle(
      () async {
        final XFile file = event.file;
        final int fileSize = await file.length();
        if (fileSize > _maxFileSize) {
          emitter(
            const SendTranscriptionState.failure(
              exception: AppException.unknown('Размер файла не должен превышать 200\u{00A0}МБ'),
            ),
          );
          return;
        }

        await _authenticationRepository.refreshUser();
        await _transcriptionsRepository.createTranscription(
          file: file,
          onProgress: (progress) {
            emitter(SendTranscriptionState.uploading(progress: progress));
          },
        );
        emitter(const SendTranscriptionState.success());
      },
      onError: (exception, stackTrace) => emitter(SendTranscriptionState.failure(exception: exception)),
      onDone: () => emitter(const SendTranscriptionState.idle()),
    );
  }

  Future<void> _sendUrl(_SendTranscriptionSendUrl event, Emitter<SendTranscriptionState> emitter) async {
    emitter(const SendTranscriptionState.uploading());
    await ExceptionHandler.handle(
      () async {
        await _transcriptionsRepository.createTranscription(url: event.url);
        emitter(const SendTranscriptionState.success());
      },
      onError: (exception, stackTrace) => emitter(SendTranscriptionState.failure(exception: exception)),
      onDone: () => emitter(const SendTranscriptionState.idle()),
    );
  }

  void _startExtractAudio(_SendTranscriptionStartExtractAudio event, Emitter<SendTranscriptionState> emitter) {
    emitter(const SendTranscriptionState.uploading(extractingVideo: true));
  }
}
