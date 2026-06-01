// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

part 'receipt_dto.g.dart';

@JsonSerializable()
class ReceiptDto {
  const ReceiptDto({required this.id, required this.url, required this.total, required this.createdAt});

  factory ReceiptDto.fromJson(Map<String, Object?> json) => _$ReceiptDtoFromJson(json);

  /// Идентификатор чека
  final String id;

  /// Ссылка на чек
  final String url;

  /// Количество
  final int total;

  /// Дата создания
  final DateTime createdAt;

  Map<String, Object?> toJson() => _$ReceiptDtoToJson(this);
}
