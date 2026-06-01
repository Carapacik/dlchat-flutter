import 'package:json_annotation/json_annotation.dart';

part 'message_dto.g.dart';

@JsonSerializable()
class const MessageDto({
  /// Идентификатор сообщения
  required final String id,

  /// Текст сообщения
  required final String text,

  /// Тип сообщения
  required final String type,
}) {
  factory fromJson(Map<String, Object?> json) => _$MessageDtoFromJson(json);

  Map<String, Object?> toJson() => _$MessageDtoToJson(this);
}

@JsonSerializable()
class const MessageListDto({required final List<MessageDto> messages}) {
  factory fromJson(Map<String, Object?> json) => _$MessageListDtoFromJson(json);

  Map<String, Object?> toJson() => _$MessageListDtoToJson(this);
}
