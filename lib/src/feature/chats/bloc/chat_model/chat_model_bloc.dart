import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dlchat/src/core/exception/exception_handler.dart';
import 'package:dlchat/src/feature/chat/data/chat_repository.dart';
import 'package:dlchat/src/feature/chat/model/chat_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_model_bloc.freezed.dart';
part 'chat_model_event.dart';
part 'chat_model_state.dart';

final class ChatModelBloc({required final IChatRepository _chatRepository})
    extends Bloc<ChatModelEvent, ChatModelState> {
  this : super(const ChatModelState.processing([])) {
    on<_ChatModelStarted>(_start);

    add(const ChatModelEvent.start());
  }

  Future<void> _start(_ChatModelStarted event, Emitter<ChatModelState> emitter) async {
    emitter(const ChatModelState.processing([]));
    await ExceptionHandler.handle(
      () async {
        final List<ChatModel> models = await _chatRepository.getChatModels();
        emitter(ChatModelState.success(models));
      },
      onError: (exception, stackTrace) => emitter(ChatModelState.failure(state.chatModels)),
      onDone: () => emitter(ChatModelState.idle(state.chatModels)),
    );
  }
}
