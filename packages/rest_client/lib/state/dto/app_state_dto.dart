import 'package:json_annotation/json_annotation.dart';

part 'app_state_dto.g.dart';

@JsonSerializable()
class const AppStateDto({
  /// Последняя версия
  required final String lastVersion,

  /// Последняя поддерживаемая версия
  required final String lastSupportedVersion,

  /// Технические работы
  required final bool technicalWorks,

  /// На проверке
  required final bool onValidation,
}) {
  factory fromJson(Map<String, Object?> json) => _$AppStateDtoFromJson(json);

  Map<String, Object?> toJson() => _$AppStateDtoToJson(this);
}

@JsonSerializable()
class const GetStateResponse({
  /// Данные о состоянии сервиса
  required final List<AppStateDto> states,
}) {
  factory fromJson(Map<String, Object?> json) => _$GetStateResponseFromJson(json);

  Map<String, Object?> toJson() => _$GetStateResponseToJson(this);
}
