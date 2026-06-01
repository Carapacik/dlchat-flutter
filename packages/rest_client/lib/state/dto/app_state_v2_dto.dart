import 'package:json_annotation/json_annotation.dart';

part 'app_state_v2_dto.g.dart';

@JsonSerializable()
class const AppStateV2Dto({
  /// Последняя версия
  required final String lastVersion,

  /// Последняя поддерживаемая версия
  required final String minSupportedVersion,

  /// Технические работы
  required final bool technicalWorks,

  /// На проверке
  required final bool onValidation,
}) {
  factory fromJson(Map<String, Object?> json) => _$AppStateV2DtoFromJson(json);

  Map<String, Object?> toJson() => _$AppStateV2DtoToJson(this);
}

@JsonSerializable()
class const GetStateV2Response({
  /// Данные о состоянии сервиса
  required final List<AppStateV2Dto> states,
}) {
  factory fromJson(Map<String, Object?> json) => _$GetStateV2ResponseFromJson(json);

  Map<String, Object?> toJson() => _$GetStateV2ResponseToJson(this);
}
