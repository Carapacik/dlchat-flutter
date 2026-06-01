import 'package:rest_client/payment/dto/binding_list_dto.dart';

class const BindingCard({
  required final String id,
  required final BindingTypeEnum bindingType,
  final String? first6,
  final String? last4,
  final String? mps,
  final int? bankId,
}) {
  factory decode(BindingDto dto) => BindingCard(
    id: dto.id,
    bindingType: dto.bindingType,
    first6: dto.first6,
    last4: dto.last4,
    mps: dto.mps,
    bankId: dto.bankId,
  );
}
