import 'package:bloc/bloc.dart';
import 'package:dlchat/src/core/exception/exception_handler.dart';
import 'package:dlchat/src/feature/transcription/data/transcription_repository.dart';
import 'package:dlchat/src/feature/transcription/model/transcription_message.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'detail_transcription_bloc.freezed.dart';
part 'detail_transcription_event.dart';
part 'detail_transcription_state.dart';

final class DetailTranscriptionBloc({
  required final String _transcriptionId,
  required final ITranscriptionsRepository _transcriptionsRepository,
}) extends Bloc<DetailTranscriptionEvent, DetailTranscriptionState> {
  this : super(const DetailTranscriptionState.processing([], hasReachedMax: false)) {
    on<_DetailTranscriptionStarted>(_start);
    on<_DetailTranscriptionFetched>(_fetched);

    add(const DetailTranscriptionEvent.start());
  }

  static const _limit = 30;

  Future<void> _start(_DetailTranscriptionStarted event, Emitter<DetailTranscriptionState> emitter) async {
    emitter(DetailTranscriptionState.processing(state.messages, hasReachedMax: false));
    await ExceptionHandler.handle(
      () async {
        final List<TranscriptionMessage> transcriptions = await _transcriptionsRepository.getTranscriptionMessages(
          transcriptionId: _transcriptionId,
        );
        emitter(
          DetailTranscriptionState.success(
            transcriptions,
            hasReachedMax: transcriptions.isEmpty || transcriptions.length < _limit,
          ),
        );
      },
      onError: (exception, stackTrace) => emitter(
        DetailTranscriptionState.failure(state.messages, hasReachedMax: state.hasReachedMax, exception: exception),
      ),
      onDone: () => emitter(DetailTranscriptionState.idle(state.messages, hasReachedMax: state.hasReachedMax)),
    );
  }

  Future<void> _fetched(_DetailTranscriptionFetched event, Emitter<DetailTranscriptionState> emitter) async {
    if (state.hasReachedMax) {
      return;
    }
    emitter(DetailTranscriptionState.fetching(state.messages, hasReachedMax: state.hasReachedMax));
    await ExceptionHandler.handle(
      () async {
        final List<TranscriptionMessage> messages = await _transcriptionsRepository.getTranscriptionMessages(
          transcriptionId: _transcriptionId,
          offset: state.messages.length,
        );
        emitter(
          DetailTranscriptionState.success(List.of(state.messages)..addAll(messages), hasReachedMax: messages.isEmpty),
        );
      },
      onError: (exception, stackTrace) => emitter(
        DetailTranscriptionState.failure(state.messages, hasReachedMax: state.hasReachedMax, exception: exception),
      ),
      onDone: () => emitter(DetailTranscriptionState.idle(state.messages, hasReachedMax: state.hasReachedMax)),
    );
  }
}
