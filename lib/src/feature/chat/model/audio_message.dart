import 'package:dlchat/src/feature/chat/model/link.dart';
import 'package:dlchat/src/feature/chat/model/message.dart';
import 'package:meta/meta.dart';
import 'package:rest_client/chat/dto/audio_chat_message_dto.dart';

@immutable
class const AudioMessage({
  required final String id,
  required final String userMessageText,
  required final String text,
  required final MessageType type,
  final List<Link> links = const [],
  final bool isNew = false,
}) {
  factory decode(AudioChatMessageDto dto) => AudioMessage(
    id: dto.id,
    userMessageText: dto.userMessageText,
    text: dto.text,
    type: MessageType.decode(dto.type),
    links: dto.links.map(Link.decode).toList(),
  );

  factory decodeAnswer(AudioChatMessageDto dto) => AudioMessage(
    id: dto.id,
    userMessageText: dto.userMessageText,
    text: dto.text,
    type: MessageType.decode(dto.type),
    isNew: true,
    links: dto.links.map(Link.decode).toList(),
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is AudioMessage && other.id == id && other.text == text && other.type == type;
  }

  @override
  int get hashCode {
    return id.hashCode ^ text.hashCode ^ type.hashCode;
  }
}
