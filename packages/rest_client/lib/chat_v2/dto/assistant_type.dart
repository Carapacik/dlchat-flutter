import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum AssistantType(final String? json) {
  @JsonValue('NUTRITIONIST')
  nutritionist('NUTRITIONIST'),
  @JsonValue('IMAGE')
  image('IMAGE'),
  @JsonValue('NONE')
  none('NONE');

  factory fromJson(String json) => values.firstWhere((e) => e.json == json, orElse: () => none);
}
