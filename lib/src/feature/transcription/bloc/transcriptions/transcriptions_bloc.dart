import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dlchat/src/core/exception/exception_handler.dart';
import 'package:dlchat/src/feature/chat/data/chat_repository.dart';
import 'package:dlchat/src/feature/transcription/data/transcription_repository.dart';
import 'package:dlchat/src/feature/transcription/model/transcription_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transcriptions_bloc.freezed.dart';
part 'transcriptions_event.dart';
part 'transcriptions_state.dart';

final class TranscriptionsBloc({
  required final ITranscriptionsRepository _transcriptionsRepository,
  required final IChatRepository _chatRepository,
}) extends Bloc<TranscriptionsEvent, TranscriptionsState> {
  this : super(const TranscriptionsState.processing([], hasReachedMax: false)) {
    on<_TranscriptionsStarted>(_start);
    on<_TranscriptionsFetched>(_fetch);
    on<_TranscriptionsPoll>(_poll);
    on<_TranscriptionsRenamed>(_rename);
    on<_TranscriptionsDeleted>(_delete);

    add(const TranscriptionsEvent.start());
  }

  Timer? _pollTimer;
  static const _limit = 30;
  static const _pollInterval = Duration(seconds: 30);

  @override
  Future<void> close() {
    _pollTimer?.cancel();
    return super.close();
  }

  Future<void> _start(_TranscriptionsStarted event, Emitter<TranscriptionsState> emitter) async {
    emitter(TranscriptionsState.processing(state.transcriptions, hasReachedMax: false));
    await ExceptionHandler.handle(
      () async {
        final List<TranscriptionData> transcriptions = await _transcriptionsRepository.getTranscriptions();
        emitter(
          TranscriptionsState.success(
            transcriptions,
            hasReachedMax: transcriptions.isEmpty || transcriptions.length < _limit,
          ),
        );

        // Запускаем таймер для периодического опроса
        _pollTimer?.cancel();
        _pollTimer = Timer.periodic(_pollInterval, (_) {
          add(const TranscriptionsEvent.poll());
        });
      },
      onError: (exception, stackTrace) =>
          TranscriptionsState.failure(state.transcriptions, hasReachedMax: state.hasReachedMax, exception: exception),
      onDone: () => emitter(TranscriptionsState.idle(state.transcriptions, hasReachedMax: state.hasReachedMax)),
    );
  }

  Future<void> _fetch(_TranscriptionsFetched event, Emitter<TranscriptionsState> emitter) async {
    if (state.hasReachedMax) {
      return;
    }
    emitter(TranscriptionsState.fetching(state.transcriptions, hasReachedMax: state.hasReachedMax));
    await ExceptionHandler.handle(
      () async {
        final List<TranscriptionData> transcriptions = await _transcriptionsRepository.getTranscriptions(
          offset: state.transcriptions.length,
        );
        emitter(
          TranscriptionsState.success(
            List.of(state.transcriptions)..addAll(transcriptions),
            hasReachedMax: transcriptions.isEmpty,
          ),
        );
      },
      onError: (exception, stackTrace) => emitter(
        TranscriptionsState.failure(state.transcriptions, hasReachedMax: state.hasReachedMax, exception: exception),
      ),
      onDone: () => emitter(TranscriptionsState.idle(state.transcriptions, hasReachedMax: state.hasReachedMax)),
    );
  }

  Future<void> _poll(_TranscriptionsPoll event, Emitter<TranscriptionsState> emitter) async {
    await ExceptionHandler.handle(
      () async {
        final List<TranscriptionData> newTranscriptions = await _transcriptionsRepository.getTranscriptions();
        final currentTranscriptions = List<TranscriptionData>.from(state.transcriptions);

        // Обновляем существующие и добавляем новые транскрипции
        for (final newTranscription in newTranscriptions) {
          final int existingIndex = currentTranscriptions.indexWhere((t) => t.id == newTranscription.id);

          if (existingIndex != -1) {
            // Обновляем существующую транскрипцию если она изменилась
            if (currentTranscriptions[existingIndex] != newTranscription) {
              currentTranscriptions[existingIndex] = newTranscription;
            }
          } else {
            // Добавляем новую транскрипцию в правильной позиции
            final int insertIndex = currentTranscriptions.indexWhere(
              (t) => t.createdAt.isBefore(newTranscription.createdAt),
            );

            if (insertIndex == -1) {
              currentTranscriptions.add(newTranscription);
            } else {
              currentTranscriptions.insert(insertIndex, newTranscription);
            }
          }
        }

        emitter(TranscriptionsState.success(currentTranscriptions, hasReachedMax: state.hasReachedMax));
      },
      onError: (exception, stackTrace) {
        // Игнорируем ошибки при опросе, чтобы не прерывать работу приложения
      },
      onDone: () => TranscriptionsState.idle(state.transcriptions, hasReachedMax: state.hasReachedMax),
    );
  }

  Future<void> _rename(_TranscriptionsRenamed event, Emitter<TranscriptionsState> emitter) async {
    await ExceptionHandler.handle(
      () async {
        await _chatRepository.renameChat(chatId: event.id, newName: event.name);

        final List<TranscriptionData> transcriptions = List.of(state.transcriptions);
        final int index = transcriptions.indexWhere((t) => t.id == event.id);
        if (index != -1) {
          transcriptions[index] = transcriptions[index].copyWith(name: event.name);
        }
        emitter(TranscriptionsState.success(transcriptions, hasReachedMax: state.hasReachedMax));
      },
      onError: (exception, stackTrace) => emitter(
        TranscriptionsState.failure(state.transcriptions, hasReachedMax: state.hasReachedMax, exception: exception),
      ),
      onDone: () => emitter(TranscriptionsState.idle(state.transcriptions, hasReachedMax: state.hasReachedMax)),
    );
  }

  Future<void> _delete(_TranscriptionsDeleted event, Emitter<TranscriptionsState> emitter) async {
    await ExceptionHandler.handle(
      () async {
        await _chatRepository.deleteChat(event.id);

        final List<TranscriptionData> transcriptions = List.of(state.transcriptions)
          ..removeWhere((t) => t.id == event.id);

        emitter(TranscriptionsState.success(transcriptions, hasReachedMax: state.hasReachedMax));
      },
      onError: (exception, stackTrace) => emitter(
        TranscriptionsState.failure(state.transcriptions, hasReachedMax: state.hasReachedMax, exception: exception),
      ),
      onDone: () => emitter(TranscriptionsState.idle(state.transcriptions, hasReachedMax: state.hasReachedMax)),
    );
  }
}
