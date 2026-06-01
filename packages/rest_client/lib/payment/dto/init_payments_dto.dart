import 'package:json_annotation/json_annotation.dart';

part 'init_payments_dto.g.dart';

@JsonSerializable()
class const InitPaymentsDto({
  required final bool bankCard,
  required final bool sbp,
  required final bool binding,
  required final bool sberbank,
}) {
  factory fromJson(Map<String, Object?> json) => _$InitPaymentsDtoFromJson(json);

  Map<String, Object?> toJson() => _$InitPaymentsDtoToJson(this);
}
