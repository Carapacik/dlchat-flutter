import 'package:json_annotation/json_annotation.dart';

part 'binding_list_dto.g.dart';

@JsonSerializable()
class const BindingListDto({required final List<BindingDto> bindings}) {
  factory fromJson(Map<String, Object?> json) => _$BindingListDtoFromJson(json);

  Map<String, Object?> toJson() => _$BindingListDtoToJson(this);
}

@JsonSerializable()
class const BindingDto({
  required final String id,
  required final BindingTypeEnum bindingType,
  final String? first6,
  final String? last4,
  final String? mps,
  final int? bankId,
}) {
  factory fromJson(Map<String, Object?> json) => _$BindingDtoFromJson(json);

  Map<String, Object?> toJson() => _$BindingDtoToJson(this);
}

/// An enumeration.
@JsonEnum()
enum BindingTypeEnum(final String? json) {
  @JsonValue('bank_card')
  bankCard('bank_card'),
  @JsonValue('sbp')
  sbp('sbp'),
  @JsonValue('binding')
  binding('binding'),
  @JsonValue('sberbank')
  sberbank('sberbank'),

  /// Default value for all unparsed values, allows backward compatibility when adding new values on the backend.
  $unknown(null);

  factory fromJson(String json) => values.firstWhere((e) => e.json == json, orElse: () => $unknown);
}
