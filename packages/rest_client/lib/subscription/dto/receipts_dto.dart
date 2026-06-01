// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:json_annotation/json_annotation.dart';

import 'receipt_dto.dart';

part 'receipts_dto.g.dart';

@JsonSerializable()
class ReceiptsDto {
  const ReceiptsDto({required this.receipts});

  factory ReceiptsDto.fromJson(Map<String, Object?> json) => _$ReceiptsDtoFromJson(json);

  /// Список чеков
  final List<ReceiptDto> receipts;

  Map<String, Object?> toJson() => _$ReceiptsDtoToJson(this);
}
