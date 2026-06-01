import 'dart:convert';

import 'package:dlchat/src/feature/chat/model/model_type.dart';
import 'package:meta/meta.dart';
import 'package:rest_client/chat/dto/chat_dto.dart';

@immutable
class const Chat({
  required final String id,
  required final String name,
  required final ChatType type,
  required final String status,
  required final bool useContext,
  final String? presetId,
}) {
  factory decode(ChatDto dto) => Chat(
    id: dto.id,
    name: dto.name,
    presetId: dto.presetId,
    type: ChatType.decode(dto.type),
    status: dto.status,
    useContext: dto.useContext,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is Chat && other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  Chat copyWith({
    String? id,
    String? name,
    String? presetId,
    ChatType? type,
    String? status,
    String? preset,
    bool? useContext,
  }) => Chat(
    id: id ?? this.id,
    name: name ?? this.name,
    presetId: presetId ?? this.presetId,
    type: type ?? this.type,
    status: status ?? this.status,
    useContext: useContext ?? this.useContext,
  );

  @override
  String toString() => 'Chat{id: $id, name: $name, presetId: $presetId, type: $type}';
}

final class const ChatConverter() extends Converter<Chat, ChatDto> {
  @override
  ChatDto convert(Chat input) => ChatDto(
    id: input.id,
    name: input.name,
    presetId: input.presetId,
    type: ChatType.encode(input.type),
    status: input.status,
    useContext: input.useContext,
  );
}
