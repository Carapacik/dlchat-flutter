import 'package:meta/meta.dart';
import 'package:rest_client/transcriptions/dto/message_dto.dart';

@immutable
class const TranscriptionMessage({required final String id, required final String text, required final String type}) {
  factory decode(MessageDto dto) => TranscriptionMessage(id: dto.id, text: dto.text, type: dto.type);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TranscriptionMessage &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          text == other.text &&
          type == other.type;

  @override
  int get hashCode => id.hashCode ^ text.hashCode ^ type.hashCode;
}
