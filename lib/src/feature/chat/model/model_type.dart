import 'package:rest_client/chat/dto/chat_type_dto.dart';

enum ChatType {
  text,
  image,
  textToSpeech,
  speechToText,
  nutrition,
  $unknown;

  factory decode(ChatTypeDto dto) => values.firstWhere((e) => e.name == dto.name, orElse: () => $unknown);

  static ChatTypeDto encode(ChatType type) =>
      ChatTypeDto.values.firstWhere((e) => e.name == type.name, orElse: () => ChatTypeDto.$unknown);
}
