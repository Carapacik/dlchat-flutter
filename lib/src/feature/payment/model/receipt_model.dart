import 'dart:convert';

import 'package:rest_client/subscription/dto/receipt_dto.dart';

class const Receipt({
  required final String id,
  required final String url,
  required final int total,
  required final DateTime createdAt,
});

class const ReceiptConverter() extends Converter<ReceiptDto, Receipt> {
  @override
  Receipt convert(ReceiptDto input) =>
      Receipt(id: input.id, url: input.url, total: input.total, createdAt: input.createdAt);
}
