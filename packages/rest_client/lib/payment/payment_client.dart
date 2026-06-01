import 'package:dio/dio.dart';
import 'package:rest_client/payment/dto/binding_list_dto.dart';
import 'package:rest_client/payment/dto/init_payments_dto.dart';
import 'package:rest_client/result_response.dart';
import 'package:retrofit/retrofit.dart';

part 'payment_client.g.dart';

@RestApi()
abstract class PaymentClient {
  factory(Dio dio, {String? baseUrl}) = _PaymentClient;

  /// Get init payments
  @POST('/v1/payments/initPayments')
  Future<ResultResponse<InitPaymentsDto>> getInitPayments();

  /// Get Bindings
  @GET('/v1/payments/bindings')
  Future<ResultResponse<BindingListDto>> getBindings();

  /// Delete Binding
  @DELETE('/v1/payments/bindings/{bindingId}')
  Future<void> deleteBinding({@Path('bindingId') required String bindingId});
}
