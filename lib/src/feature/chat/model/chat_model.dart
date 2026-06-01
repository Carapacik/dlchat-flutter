import 'dart:convert';

import 'package:dlchat/src/feature/chat/model/model_type.dart';
import 'package:rest_client/chat/dto/chat_model_dto.dart';
import 'package:rest_client/chat/dto/chat_type_dto.dart';

class const ChatModel({
  required final String id,
  required final String name,
  required final String? description,
  required final ChatType chatModelType,
}) {
  factory decode(ChatModelDto dto) => ChatModel(
    id: dto.id,
    name: dto.name,
    description: dto.description,
    chatModelType: ChatType.decode(dto.chatModelType),
  );
}

final class const ChatModelConverter() extends Converter<ChatModel, ChatModelDto> {
  @override
  ChatModelDto convert(ChatModel input) => ChatModelDto(
    id: input.id,
    name: input.name,
    description: input.description,
    chatModelType: ChatTypeDto.values.firstWhere((e) => e.name == input.name, orElse: () => ChatTypeDto.$unknown),
  );
}
