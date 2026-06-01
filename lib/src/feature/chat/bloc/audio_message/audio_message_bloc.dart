import 'package:bloc/bloc.dart';
import 'package:cross_file/cross_file.dart';
import 'package:dlchat/src/core/exception/exception_handler.dart';
import 'package:dlchat/src/feature/authentication/data/authentication_repository.dart';
import 'package:dlchat/src/feature/chat/data/chat_repository.dart';
import 'package:dlchat/src/feature/chat/model/message.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_message_bloc.freezed.dart';
part 'audio_message_event.dart';
part 'audio_message_state.dart';

final class AudioMessageBloc({
  required final IAuthenticationRepository _authenticationRepository,
  required final IChatRepository _chatRepository,
  required final String _chatId,
}) extends Bloc<AudioMessageEvent, AudioMessageState> {
  this : super(const AudioMessageState.idle()) {
    on<_AudioMessageSendFile>(_sendFile);
  }

  Future<void> _sendFile(_AudioMessageSendFile event, Emitter<AudioMessageState> emitter) async {
    emitter(const AudioMessageState.processing());
    await ExceptionHandler.handle(
      () async {
        await _authenticationRepository.refreshUser();
        final Message message = await _chatRepository.sendMessage(
          chatId: _chatId,
          isSearch: event.isSearch,
          audio: event.file,
        );
        event.onTranscriptionComplete.call(message);
      },
      onError: (exception, stackTrace) => emitter(AudioMessageState.failure(exception: exception)),
      onDone: () => emitter(const AudioMessageState.idle()),
    );
  }
}
