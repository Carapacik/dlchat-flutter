import 'package:collection/collection.dart';
import 'package:dlchat/src/feature/chat/model/link.dart';
import 'package:meta/meta.dart';
import 'package:rest_client/chat/dto/chat_message_dto.dart';
import 'package:rest_client/chat/dto/message_type_dto.dart';

@immutable
class const Message({
  required final String id,
  required final String text,
  required final MessageType type,
  final List<Link> links = const [],
  final bool isNew = false,
  final String? userMessageText,
  final String? file,
}) {
  factory decode(ChatMessageDto dto) => Message(
    id: dto.id,
    text: dto.text,
    type: MessageType.decode(dto.type),
    links: dto.links.map(Link.decode).toList(),
    userMessageText: dto.userMessageText,
    file: dto.file,
  );

  factory decodeAnswer(ChatMessageDto dto) => Message(
    id: dto.id,
    text: dto.text,
    type: MessageType.decode(dto.type),
    isNew: true,
    links: dto.links.map(Link.decode).toList(),
    userMessageText: dto.userMessageText,
    file: dto.file,
  );

  Message copyWith({
    String? id,
    String? text,
    MessageType? type,
    List<Link>? links,
    bool? isNew,
    String? userMessageText,
    String? file,
  }) => Message(
    id: id ?? this.id,
    text: text ?? this.text,
    type: type ?? this.type,
    links: links ?? this.links,
    isNew: isNew ?? this.isNew,
    userMessageText: userMessageText ?? this.userMessageText,
    file: file ?? this.file,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Message &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          text == other.text &&
          type == other.type &&
          links == other.links &&
          isNew == other.isNew &&
          userMessageText == other.userMessageText &&
          file == other.file;

  @override
  int get hashCode =>
      id.hashCode ^
      text.hashCode ^
      type.hashCode ^
      links.hashCode ^
      isNew.hashCode ^
      userMessageText.hashCode ^
      file.hashCode;

  @override
  String toString() => 'Message(id: $id, type: $type)';
}

enum MessageType(final String value) {
  user('USER'),
  assistant('ASSISTANT'),
  imageAssistant('IMAGE_ASSISTANT'),
  image('IMAGE'),
  telegramAssistant('TELEGRAM_ASSISTANT'),
  telegram('TELEGRAM'),
  transcription('TRANSCRIPTION'),
  transcriptionAssistant('TRANSCRIPTION_ASSISTANT'),
  nutrition('NUTRITION');

  factory decode(MessageTypeDto value) => MessageType.values.firstWhere((e) => value.json == e.value);

  static MessageType? fromString(String? value) =>
      MessageType.values.firstWhereOrNull((status) => status.value == value);
}
