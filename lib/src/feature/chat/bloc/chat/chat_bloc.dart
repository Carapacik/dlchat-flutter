import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cross_file/cross_file.dart';
import 'package:dlchat/src/core/common/bloc/bloc_transformer.dart';
import 'package:dlchat/src/core/exception/exception_handler.dart';
import 'package:dlchat/src/feature/chat/data/chat_repository.dart';
import 'package:dlchat/src/feature/chat/data/request_counter_repository.dart';
import 'package:dlchat/src/feature/chat/model/chat.dart';
import 'package:dlchat/src/feature/chat/model/message.dart';
import 'package:dlchat/src/feature/chat/model/model_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

part 'chat_bloc.freezed.dart';
part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc({
  required final IChatRepository _chatRepository,
  required final IRequestCounterRepository _requestCounterRepository,
}) extends Bloc<ChatEvent, ChatState> {
  this : super(const ChatState.processing(chatMessages: [], isWaitingAnswer: false, chat: null, hasReachedMax: false)) {
    on<_ChatStarted>(_start);
    on<_ChatFetched>(_fetched, transformer: ThrottleDroppableBlocTransformer<_ChatFetched>().transform);
    on<_ChatDeleted>(_deleteChat);
    on<_ChatCleared>(_clearChat);
    on<_ChatRenamed>(_renameChat);
    on<_ChatAudioMessageAdded>(_addAudioMessage);
    on<_ChatMessageSent>(_sendMessage);
  }

  static const _limit = 20;

  Future<void> _start(_ChatStarted event, Emitter<ChatState> emitter) async {
    emitter(const ChatState.processing(chatMessages: [], isWaitingAnswer: false, chat: null, hasReachedMax: false));
    await ExceptionHandler.handle(
      () async {
        final Chat chat = await _chatRepository.getChat(event.id);
        final List<Message> messages = await _chatRepository.getChatMessages(event.id);
        emitter(
          ChatState.idle(
            chat: chat,
            chatMessages: List.of(messages.reversed.map((m) => m.copyWith(isNew: false))),
            isWaitingAnswer: state.isWaitingAnswer,
            hasReachedMax: messages.isEmpty || messages.length < _limit,
          ),
        );
      },
      onError: (exception, stackTrace) => emitter(
        ChatState.failure(
          chat: state.chat,
          chatMessages: state.chatMessages,
          isWaitingAnswer: state.isWaitingAnswer,
          hasReachedMax: state.hasReachedMax,
          exception: exception,
        ),
      ),
      onDone: () => ChatState.idle(
        chat: state.chat,
        chatMessages: state.chatMessages,
        isWaitingAnswer: state.isWaitingAnswer,
        hasReachedMax: state.hasReachedMax,
      ),
    );
  }

  Future<void> _fetched(_ChatFetched event, Emitter<ChatState> emitter) async {
    if (state.hasReachedMax) {
      return;
    }
    emitter(
      ChatState.fetching(
        chat: state.chat,
        chatMessages: state.chatMessages,
        isWaitingAnswer: state.isWaitingAnswer,
        hasReachedMax: state.hasReachedMax,
      ),
    );
    await Future<void>.delayed(const Duration(seconds: 1));
    await ExceptionHandler.handle(
      () async {
        final List<Message> messages = await _chatRepository.getChatMessages(
          state.chat!.id,
          offset: state.chatMessages.length,
        );
        emitter(
          ChatState.idle(
            chat: state.chat,
            chatMessages: List.of(state.chatMessages)..addAll(messages.reversed),
            isWaitingAnswer: state.isWaitingAnswer,
            hasReachedMax: messages.isEmpty,
          ),
        );
      },
      onError: (exception, stackTrace) => emitter(
        ChatState.failure(
          chat: state.chat,
          chatMessages: state.chatMessages,
          isWaitingAnswer: state.isWaitingAnswer,
          hasReachedMax: state.hasReachedMax,
          exception: exception,
        ),
      ),
      onDone: () => ChatState.idle(
        chat: state.chat,
        chatMessages: state.chatMessages,
        isWaitingAnswer: state.isWaitingAnswer,
        hasReachedMax: state.hasReachedMax,
      ),
    );
  }

  Future<void> _sendMessage(_ChatMessageSent event, Emitter<ChatState> emitter) async {
    final MessageType messageType = switch (state.chat!.type) {
      ChatType.text => MessageType.user,
      ChatType.image => MessageType.image,
      _ => MessageType.user,
    };

    await ExceptionHandler.handle(
      () async {
        final String? fileName = event.file != null ? path.basename(event.file!.path) : null;
        final newMessage = Message(id: const Uuid().v4(), text: event.text, type: messageType, file: fileName);
        emitter(
          ChatState.idle(
            chat: state.chat,
            chatMessages: List.from(state.chatMessages.map((m) => m.copyWith(isNew: false)))..insert(0, newMessage),
            isWaitingAnswer: true,
            hasReachedMax: state.hasReachedMax,
          ),
        );

        await _requestCounterRepository.incrementRequestCount();
        final Message answer = await _chatRepository.sendMessage(
          chatId: state.chat!.id,
          isSearch: event.isSearch,
          text: event.text,
          file: event.file,
        );
        emitter(
          ChatState.idle(
            chat: state.chat,
            chatMessages: List.from(state.chatMessages)..insert(0, answer),
            isWaitingAnswer: false,
            hasReachedMax: state.hasReachedMax,
          ),
        );
      },
      onError: (exception, stackTrace) => emitter(
        ChatState.failure(
          chat: state.chat,
          chatMessages: List.from(state.chatMessages)..removeAt(0),
          exception: exception,
          isWaitingAnswer: false,
          hasReachedMax: state.hasReachedMax,
        ),
      ),
      onDone: () => emitter(
        ChatState.idle(
          chat: state.chat,
          chatMessages: state.chatMessages,
          isWaitingAnswer: false,
          hasReachedMax: state.hasReachedMax,
        ),
      ),
    );
  }

  Future<void> _deleteChat(_ChatDeleted event, Emitter<ChatState> emitter) async {
    await ExceptionHandler.handle(
      () async {
        await _chatRepository.deleteChat(event.id);
        emitter(
          ChatState.idle(
            chatMessages: [],
            isWaitingAnswer: false,
            chat: state.chat,
            hasReachedMax: state.hasReachedMax,
          ),
        );
      },
      onError: (exception, stackTrace) => emitter(
        ChatState.failure(
          chat: state.chat,
          chatMessages: state.chatMessages,
          exception: exception,
          isWaitingAnswer: state.isWaitingAnswer,
          hasReachedMax: state.hasReachedMax,
        ),
      ),
    );
  }

  Future<void> _clearChat(_ChatCleared event, Emitter<ChatState> emitter) async {
    await ExceptionHandler.handle(
      () async {
        await _chatRepository.cleanChat(event.id);
        final List<Message> chatMessages = await _chatRepository.getChatMessages(event.id);
        emitter(
          ChatState.idle(
            chat: state.chat,
            chatMessages: chatMessages,
            isWaitingAnswer: state.isWaitingAnswer,
            hasReachedMax: state.hasReachedMax,
          ),
        );
      },
      onError: (exception, stackTrace) => emitter(
        ChatState.failure(
          chat: state.chat,
          chatMessages: state.chatMessages,
          exception: exception,
          isWaitingAnswer: state.isWaitingAnswer,
          hasReachedMax: state.hasReachedMax,
        ),
      ),
      onDone: () => emitter(
        ChatState.idle(
          chat: state.chat,
          chatMessages: state.chatMessages,
          isWaitingAnswer: state.isWaitingAnswer,
          hasReachedMax: state.hasReachedMax,
        ),
      ),
    );
  }

  Future<void> _renameChat(_ChatRenamed event, Emitter<ChatState> emitter) async {
    await ExceptionHandler.handle(
      () async {
        final Chat chat = state.chat!.copyWith(name: event.name);
        await _chatRepository.renameChat(chatId: chat.id, newName: event.name);
        emitter(
          ChatState.idle(
            chat: chat,
            chatMessages: state.chatMessages,
            isWaitingAnswer: state.isWaitingAnswer,
            hasReachedMax: state.hasReachedMax,
          ),
        );
      },
      onError: (exception, stackTrace) => emitter(
        ChatState.failure(
          chat: state.chat,
          chatMessages: state.chatMessages,
          isWaitingAnswer: false,
          hasReachedMax: state.hasReachedMax,
          exception: exception,
        ),
      ),
    );
  }

  Future<void> _addAudioMessage(_ChatAudioMessageAdded event, Emitter<ChatState> emitter) async {
    final message = Message(
      id: const Uuid().v4(),
      text: event.audioMessage.userMessageText ?? '',
      type: MessageType.user,
    );
    final Message answerMessage = event.audioMessage.copyWith(isNew: true);

    emitter(
      ChatState.idle(
        chat: state.chat,
        chatMessages: [answerMessage, message, ...state.chatMessages.map((m) => m.copyWith(isNew: false))],
        isWaitingAnswer: state.isWaitingAnswer,
        hasReachedMax: state.hasReachedMax,
      ),
    );
  }
}
