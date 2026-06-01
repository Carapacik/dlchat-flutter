import 'package:json_annotation/json_annotation.dart';

part 'token_dto.g.dart';

@JsonSerializable()
class const TokenDto({final String accessToken = '', final String refreshToken = ''}) {
  factory fromJson(Map<String, Object?> json) => _$TokenDtoFromJson(json);

  Map<String, Object?> toJson() => _$TokenDtoToJson(this);
}
