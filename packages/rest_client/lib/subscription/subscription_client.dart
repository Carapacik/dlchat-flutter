// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, unused_import

import 'package:dio/dio.dart';
import 'package:rest_client/result_response.dart';
import 'package:rest_client/subscription/dto/activate_license_command.dart';
import 'package:rest_client/subscription/dto/pay_rate_command.dart';
import 'package:rest_client/subscription/dto/pay_rate_response.dart';
import 'package:rest_client/subscription/dto/payment_dto.dart';
import 'package:rest_client/subscription/dto/payments_dto.dart';
import 'package:rest_client/subscription/dto/rates_dto.dart';
import 'package:rest_client/subscription/dto/receipts_dto.dart';
import 'package:rest_client/subscription/dto/remaining_request_dto.dart';
import 'package:rest_client/subscription/dto/user_subscription_dto.dart';
import 'package:rest_client/subscription/dto/user_subscriptions_dto.dart';
import 'package:rest_client/subscription/dto/verify_promo_code_command.dart';
import 'package:rest_client/subscription/dto/verify_promo_code_response.dart';
import 'package:retrofit/retrofit.dart';

part 'subscription_client.g.dart';

@RestApi()
abstract class SubscriptionClient {
  factory SubscriptionClient(Dio dio, {String? baseUrl}) = _SubscriptionClient;

  /// Получить тарифы пользователя.
  @GET('/v1/subscriptions/')
  Future<ResultResponse<UserSubscriptionsDto>> getUserRate({
    @Query('limit') int limit = 30,
    @Query('offset') int offset = 0,
    @Query('status') String? status,
  });

  /// Get User Current Subscriptions.
  ///
  /// Получить текущий тариф пользователя.
  @GET('/v1/subscriptions/current')
  Future<ResultResponse<UserSubscriptionDto>> getUserCurrentSubscription();

  /// Get User Remaining.
  ///
  /// Получить остаток по запросам.
  @GET('/v1/subscriptions/remaining')
  Future<ResultResponse<RemainingRequestDto>> getUserRemainingRequest();

  /// Get Rates.
  ///
  /// Получить тарифы.
  @GET('/v1/subscriptions/rates')
  Future<ResultResponse<RatesDto>> getRates();

  /// Verify Promo Code.
  ///
  /// Проверить промокод.
  @POST('/v1/subscriptions/verifyPromoCode')
  Future<ResultResponse<VerifyPromoCodeResponse>> verifyPromoCode({@Body() required VerifyPromoCodeCommand body});

  /// Pay Rate.
  ///
  /// Оплатить тариф.
  @POST('/v1/subscriptions/pay')
  Future<ResultResponse<PayRateResponse>> pay({@Body() required PayRateCommand body});

  /// Renewal Subscription.
  ///
  /// Продлить подписку.
  @POST('/v1/subscriptions/prolong')
  Future<ResultResponse<PayRateResponse>> prolong({@Body() required PayRateCommand body});

  /// Upgrade Subscription.
  ///
  /// Обновить подписку.
  @POST('/v1/subscriptions/upgrade')
  Future<ResultResponse<PayRateResponse>> upgrade({@Body() required PayRateCommand body});

  /// Activate License.
  ///
  /// Активировать лицензию.
  @POST('/v1/subscriptions/activateLicense')
  Future<void> activateLicense({@Body() required ActivateLicenseCommand body});

  /// Cancel Payment.
  ///
  /// Отменить платеж.
  @POST('/v1/subscriptions/cancelPayment')
  Future<void> cancelPayment();

  /// Get Payments
  @GET('/v1/subscriptions/payments/')
  Future<ResultResponse<PaymentsDto>> getPayments();

  /// Get Payment.
  ///
  /// [paymentId] - Идентификатор заказа.
  @GET('/v1/subscriptions/payments/{paymentId}')
  Future<ResultResponse<PaymentDto>> getPayment({@Path('paymentId') required String paymentId});

  /// Get Receipts
  @GET('/v1/subscriptions/receipts/')
  Future<ResultResponse<ReceiptsDto>> getReceipts();
}
