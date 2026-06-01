import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:dlchat/src/core/common/analytics/analytics.dart';
import 'package:dlchat/src/core/common/bloc/bloc_transformer.dart';
import 'package:dlchat/src/core/common/store_validation.dart';
import 'package:dlchat/src/core/exception/exception_handler.dart';
import 'package:dlchat/src/feature/chat/data/chat_repository.dart';
import 'package:dlchat/src/feature/chat/model/add_chat.dart';
import 'package:dlchat/src/feature/chat/model/assistant.dart';
import 'package:dlchat/src/feature/chat/model/chat.dart';
import 'package:dlchat/src/feature/chat/model/model_type.dart';
import 'package:dlchat/src/feature/user/data/user_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rest_client/chat_v2/dto/assistant_type.dart';

part 'chats_bloc.freezed.dart';
part 'chats_event.dart';
part 'chats_state.dart';

final class ChatsBloc({
  required final IChatRepository _chatRepository,
  required final IUserRepository _userRepository,
  required final AnalyticsEventReporter _reporter,
}) extends Bloc<ChatsEvent, ChatsState> {
  this : super(const ChatsState.processing([], [], hasReachedMax: false)) {
    on<_ChatsStarted>(_start);
    on<_ChatsFetched>(_fetched, transformer: ThrottleDroppableBlocTransformer<_ChatsFetched>().transform);
    on<_ChatsAdded>(_addChat);
    on<_ChatsAddedAssistant>(_addAssistant);
    on<_ChatsRemoved>(_removeChat);
    on<_ChatsCleared>(_clearChat);
    on<_ChatsRenamed>(_renameChat);
    on<_ChatsMovedToTop>(_moveToTop);
  }

  static const _limit = 30;

  Future<void> _start(_ChatsStarted event, Emitter<ChatsState> emitter) async {
    emitter(ChatsState.processing(state.chats, state.assistants, hasReachedMax: false));
    await ExceptionHandler.handle(
      () async {
        final List<Chat> chats = await _chatRepository.getChats();
        chats.sort((a, b) {
          if (a.status == 'ACTIVE' && b.status != 'ACTIVE') {
            return -1;
          } else if (a.status != 'ACTIVE' && b.status == 'ACTIVE') {
            return 1;
          } else {
            return 0;
          }
        });

        final List<Assistant> assistants = await _chatRepository.getAssistants();
        final String? phone = await _userRepository.phone;
        if (StoreValidation.isTestPhone(phone)) {
          assistants.removeWhere((a) => a.name.toLowerCase() == 'нутрициолог');
        }

        emitter(ChatsState.success(chats, assistants, hasReachedMax: chats.isEmpty || chats.length < _limit));
      },
      onError: (exception, stackTrace) => emitter(
        ChatsState.failure(state.chats, state.assistants, hasReachedMax: state.hasReachedMax, exception: exception),
      ),
      onDone: () => emitter(ChatsState.idle(state.chats, state.assistants, hasReachedMax: state.hasReachedMax)),
    );
  }

  Future<void> _fetched(_ChatsFetched event, Emitter<ChatsState> emitter) async {
    if (state.hasReachedMax) {
      return;
    }
    emitter(
      ChatsState.fetching(
        state.chats,
        state.assistants,
        newChat: state.newChat,
        existingChat: state.existingChat,
        hasReachedMax: state.hasReachedMax,
      ),
    );
    await ExceptionHandler.handle(
      () async {
        final List<Chat> chats = await _chatRepository.getChats(offset: state.chats.length);
        emitter(
          ChatsState.success(
            List.of(state.chats)..addAll(chats),
            state.assistants,
            newChat: state.newChat,
            existingChat: state.existingChat,
            hasReachedMax: chats.isEmpty,
          ),
        );
      },
      onError: (exception, stackTrace) => emitter(
        ChatsState.failure(
          state.chats,
          state.assistants,
          newChat: state.newChat,
          existingChat: state.existingChat,
          hasReachedMax: state.hasReachedMax,
          exception: exception,
        ),
      ),
      onDone: () => emitter(
        ChatsState.idle(
          state.chats,
          state.assistants,
          newChat: state.newChat,
          existingChat: state.existingChat,
          hasReachedMax: state.hasReachedMax,
        ),
      ),
    );
  }

  Future<void> _addChat(_ChatsAdded event, Emitter<ChatsState> emitter) async {
    emitter(ChatsState.addProcessing(state.chats, state.assistants, hasReachedMax: state.hasReachedMax));
    await ExceptionHandler.handle(
      () async {
        if (event.modelType == ChatType.image) {
          final Chat? existImageChat = state.chats.firstWhereOrNull((e) => e.type == ChatType.image);
          if (existImageChat != null) {
            emitter(
              ChatsState.idle(
                state.chats,
                state.assistants,
                hasReachedMax: state.hasReachedMax,
                existingChat: existImageChat,
              ),
            );
            return;
          }
        } else if (!event.useContext) {
          final Chat? existNoneContextChat = state.chats.firstWhereOrNull(
            (e) => !e.useContext && e.type == ChatType.text,
          );
          if (existNoneContextChat != null) {
            emitter(
              ChatsState.idle(
                state.chats,
                state.assistants,
                hasReachedMax: state.hasReachedMax,
                existingChat: existNoneContextChat,
              ),
            );
            return;
          }
        }

        unawaited(
          _reporter.logEvent(switch (AssistantEnum.fromString(event.name)) {
            AssistantEnum.analyst => AnalyticsEvents.usedAnalyst,
            AssistantEnum.business => AnalyticsEvents.usedBusinessAssistant,
            AssistantEnum.copywriter => AnalyticsEvents.usedCopywriter,
            AssistantEnum.nutritionist => AnalyticsEvents.usedNutritionist,
            AssistantEnum.design => AnalyticsEvents.usedDesigner,
            AssistantEnum.lawyer => AnalyticsEvents.usedLawyer,
            AssistantEnum.smm => AnalyticsEvents.usedSmm,
            AssistantEnum.teacher => AnalyticsEvents.usedTeacher,
            AssistantEnum.translator => AnalyticsEvents.usedTranslator,
            null => AnalyticsEvents.usedAnalyst,
          }),
        );

        final AddChat newChat = await _chatRepository.addChat(
          chatModelId: event.chatModelId,
          name: event.modelType == ChatType.image
              ? 'Изображения'
              : !event.useContext
              ? 'Чат на любые темы'
              : event.name,
          presetId: event.presetId,
          useContext: event.useContext,
        );

        final Chat addingChat = await _chatRepository.getChat(newChat.id);
        final updatedChats = List<Chat>.of(state.chats)..add(addingChat);
        emitter(
          ChatsState.idle(updatedChats, state.assistants, hasReachedMax: state.hasReachedMax, newChat: addingChat),
        );
      },
      onError: (exception, stackTrace) => emitter(
        ChatsState.failure(state.chats, state.assistants, hasReachedMax: state.hasReachedMax, exception: exception),
      ),
      onDone: () => emitter(ChatsState.idle(state.chats, state.assistants, hasReachedMax: state.hasReachedMax)),
    );
  }

  Future<void> _addAssistant(_ChatsAddedAssistant event, Emitter<ChatsState> emitter) async {
    emitter(ChatsState.addProcessing(state.chats, state.assistants, hasReachedMax: state.hasReachedMax));
    await ExceptionHandler.handle(
      () async {
        final Chat? existAssistant = state.chats.firstWhereOrNull((e) => e.type == ChatType.nutrition);
        if (existAssistant != null) {
          emitter(
            ChatsState.idle(
              state.chats,
              state.assistants,
              hasReachedMax: state.hasReachedMax,
              existingChat: existAssistant,
            ),
          );
          return;
        }

        unawaited(
          _reporter.logEvent(switch (AssistantEnum.fromString(event.name)) {
            AssistantEnum.analyst => AnalyticsEvents.usedAnalyst,
            AssistantEnum.business => AnalyticsEvents.usedBusinessAssistant,
            AssistantEnum.copywriter => AnalyticsEvents.usedCopywriter,
            AssistantEnum.nutritionist => AnalyticsEvents.usedNutritionist,
            AssistantEnum.design => AnalyticsEvents.usedDesigner,
            AssistantEnum.lawyer => AnalyticsEvents.usedLawyer,
            AssistantEnum.smm => AnalyticsEvents.usedSmm,
            AssistantEnum.teacher => AnalyticsEvents.usedTeacher,
            AssistantEnum.translator => AnalyticsEvents.usedTranslator,
            null => AnalyticsEvents.usedAnalyst,
          }),
        );

        final String id = await _chatRepository.addChatV2(
          assistantType: event.assistantType,
          name: event.name,
          initialMessage: event.initialMessage,
        );

        final Chat addingChat = await _chatRepository.getChat(id);
        final updatedChats = List<Chat>.of(state.chats)..add(addingChat);
        emitter(
          ChatsState.success(updatedChats, state.assistants, hasReachedMax: state.hasReachedMax, newChat: addingChat),
        );
      },
      onError: (exception, stackTrace) => emitter(
        ChatsState.failure(state.chats, state.assistants, hasReachedMax: state.hasReachedMax, exception: exception),
      ),
      onDone: () => emitter(ChatsState.idle(state.chats, state.assistants, hasReachedMax: state.hasReachedMax)),
    );
  }

  Future<void> _removeChat(_ChatsRemoved event, Emitter<ChatsState> emitter) async {
    await ExceptionHandler.handle(
      () async {
        await _chatRepository.deleteChat(event.id);
        final updatedChats = List<Chat>.of(state.chats)..removeWhere((chat) => chat.id == event.id);
        emitter(ChatsState.idle(updatedChats, state.assistants, hasReachedMax: state.hasReachedMax));
      },
      onError: (exception, stackTrace) => emitter(
        ChatsState.failure(state.chats, state.assistants, hasReachedMax: state.hasReachedMax, exception: exception),
      ),
      onDone: () => emitter(ChatsState.idle(state.chats, state.assistants, hasReachedMax: state.hasReachedMax)),
    );
  }

  Future<void> _clearChat(_ChatsCleared event, Emitter<ChatsState> emitter) async {
    await ExceptionHandler.handle(
      () async {
        await _chatRepository.cleanChat(event.id);
        emitter(ChatsState.idle(state.chats, state.assistants, hasReachedMax: state.hasReachedMax));
      },
      onError: (exception, stackTrace) => emitter(
        ChatsState.failure(state.chats, state.assistants, hasReachedMax: state.hasReachedMax, exception: exception),
      ),
      onDone: () => emitter(ChatsState.idle(state.chats, state.assistants, hasReachedMax: state.hasReachedMax)),
    );
  }

  Future<void> _renameChat(_ChatsRenamed event, Emitter<ChatsState> emitter) async {
    await ExceptionHandler.handle(
      () async {
        final int chatIndex = state.chats.indexWhere((e) => e.id == event.id);
        if (chatIndex != -1) {
          final Chat renamedChat = state.chats[chatIndex].copyWith(name: event.name);
          await _chatRepository.renameChat(chatId: state.chats[chatIndex].id, newName: event.name);
          final updatedChats = List<Chat>.of(state.chats);
          updatedChats[chatIndex] = renamedChat;
          emitter(ChatsState.idle(updatedChats, state.assistants, hasReachedMax: state.hasReachedMax));
        }
      },
      onError: (exception, stackTrace) => emitter(
        ChatsState.failure(state.chats, state.assistants, hasReachedMax: state.hasReachedMax, exception: exception),
      ),
      onDone: () => emitter(ChatsState.idle(state.chats, state.assistants, hasReachedMax: state.hasReachedMax)),
    );
  }

  void _moveToTop(_ChatsMovedToTop event, Emitter<ChatsState> emitter) {
    final int chatIndex = state.chats.indexWhere((chat) => chat.id == event.id);
    if (chatIndex != -1) {
      final updatedChats = List<Chat>.of(state.chats);
      final Chat chat = updatedChats.removeAt(chatIndex);
      updatedChats.insert(0, chat);
      emitter(ChatsState.idle(updatedChats, state.assistants, hasReachedMax: state.hasReachedMax));
    }
  }
}
