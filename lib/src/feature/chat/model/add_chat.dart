import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:rest_client/chat/dto/add_chat_dto.dart';

@immutable
class const AddChat({
  required final String id,
  required final String name,
  required final String type,
  final String? preset,
}) {
  factory decode(AddChatDto dto) => AddChat(id: dto.id, name: dto.name, type: dto.type, preset: dto.preset);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is AddChat && other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  AddChat copyWith({String? id, String? name, String? type, String? preset}) =>
      AddChat(id: id ?? this.id, name: name ?? this.name, type: type ?? this.type, preset: preset ?? this.preset);

  @override
  String toString() {
    return 'AddChat{id: $id, name: $name}';
  }
}

final class const AddChatConverter() extends Converter<AddChat, AddChatDto> {
  @override
  AddChatDto convert(AddChat input) =>
      AddChatDto(id: input.id, name: input.name, type: input.type, preset: input.preset);
}
