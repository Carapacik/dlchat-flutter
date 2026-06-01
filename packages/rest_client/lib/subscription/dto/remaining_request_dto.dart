// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'remaining_request_dto.g.dart';

@JsonSerializable()
class RemainingRequestDto {
  const RemainingRequestDto({
    required this.remainingOfRequests,
    required this.remainingOfImages,
    required this.remainingTranscriptionSeconds,
  });

  factory RemainingRequestDto.fromJson(Map<String, Object?> json) => _$RemainingRequestDtoFromJson(json);

  /// Остаток запросов на день
  final int remainingOfRequests;

  /// Остаток генераций изображений на день
  final int remainingOfImages;

  /// Остаток генераций транскрибации на день
  final int remainingTranscriptionSeconds;

  Map<String, Object?> toJson() => _$RemainingRequestDtoToJson(this);
}
