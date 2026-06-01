import 'package:collection/collection.dart';
import 'package:rest_client/chat/dto/assistant_dto.dart';

enum AssistantEnum(final String name) {
  analyst('Аналитик'),
  business('Бизнес-ассистент'),
  copywriter('Копирайтер'),
  nutritionist('Нутрициолог'),
  design('Дизайнер'),
  lawyer('Юрист'),
  smm('SMM-специалист'),
  teacher('Преподаватель'),
  translator('Переводчик');

  static AssistantEnum? fromString(String? value) => AssistantEnum.values.firstWhereOrNull((e) => e.name == value);
}

class const Assistant({
  required final String id,
  required final String name,
  required final String chatModelId,
  required final String presetId,
  final String? description,
}) {
  factory decode(AssistantDto dto) => Assistant(
    id: dto.id,
    name: dto.name,
    chatModelId: dto.chatModelId,
    presetId: dto.presetId,
    description: dto.description,
  );

  factory soon(String name) => Assistant(id: '', name: name, chatModelId: '', presetId: '', description: '');

  @override
  String toString() =>
      'Assistant{id: $id, name: $name, chatModelId: $chatModelId, presetId: $presetId, description: $description}';
}
