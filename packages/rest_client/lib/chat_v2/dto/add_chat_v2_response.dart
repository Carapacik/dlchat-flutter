// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'add_chat_v2_response.g.dart';

@JsonSerializable()
class AddChatV2Response {
  const AddChatV2Response({required this.id});

  factory AddChatV2Response.fromJson(Map<String, Object?> json) => _$AddChatV2ResponseFromJson(json);

  final String id;

  Map<String, Object?> toJson() => _$AddChatV2ResponseToJson(this);
}
