import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rest_client/result_response.dart';

// <error name>$<service prefix>(<error code>)
enum NetworkExceptionType(final int? code) {
  //
  tooManyRequests(429),
  gatewayTimeOut(504),
  validation(2000),
  internalServer(5000),

  //
  chatNotFound(3001),
  chatAlreadyExists(3002),
  chatsLimit(3003),
  userSubscriptionNotFound(3004),
  invalidRateStatus(3005),
  paymentNotFound(3006),
  userNotFound(3007),
  specialOfferNotFound(3008),
  rateOfferFound(3009),
  invalidMessageType(3010),
  donNotNeedToPay(3011),
  invalidPaymentStatus(3012),
  invalidPaymentType(3013),
  invalidPayment(3014),
  invalidAutoPayment(3015),
  paymentFailed(3016),
  paymentNotAll(3017),
  autoChargeOnFirstPayment(3018),
  incompletePayment(3019),
  depositedDaysNotFound(3020),
  sumMisMatch(3021),
  impossibleSendOtpCode(3022),
  chatModelNotFound(3023),
  presetNotFound(3024),
  subscriptionAlreadyExists(3025),
  bindingNotFound(3026),
  messagesLimit(3027),
  promoCodeNotFound(3028),
  promoCodeUsageLimit(3029),
  invalidModelType(3030),
  userSubscriptionActiveNotFound(3031),
  invalidPayUserSubscription(3032),
  activeSubscriptionAlreadyExists(3033),
  invalidPromoCodeRate(3034),
  invalidPromoCodeCombination(3035),
  unsupportedPromoCodeRate(3036),
  existingSubscription(3037),
  licenseNotFound(3038),
  fileSizeLimit(3039),
  unsupportedFileType(3040),
  paymentMethodNotAllowed(3041),
  speechToTextError(3042),
  emptyMessage(3043),
  invalidMessage(3044),
  invalidUrlDomain(3045),
  serviceUnavailable(3046),
  contentPolicyViolation(3047),

  //
  otpSentAlready(6000),
  otpInvalidCode(6001),
  userNotFound$6(6002),
  invalidTokenType(6003),
  invalidToken(6004),
  expiredToken(6005),

  //
  paymentNotFound$4(4000),
  bindingNotFound$4(4001),
  $unknown(null);

  static NetworkExceptionType? byStatusCode(DioException exception) {
    if (exception.response?.statusCode == 422) {
      return NetworkExceptionType.validation;
    }
    if (exception.response?.statusCode == 429) {
      return NetworkExceptionType.tooManyRequests;
    }
    if (exception.response?.statusCode == 504) {
      return NetworkExceptionType.gatewayTimeOut;
    }
    try {
      final result = ResultResponse<void>.fromJson(exception.response?.data as Map<String, dynamic>);
      return NetworkExceptionType.values.firstWhereOrNull((e) => e.code == result.errorCode);
    } on Object {
      return null;
    }
  }

  String localizedText(BuildContext context) {
    //final l10n = context.l10n;
    return switch (this) {
      NetworkExceptionType.$unknown => 'Неизвестная ошибка',
      NetworkExceptionType.tooManyRequests => '429 Слишком много запросов',
      NetworkExceptionType.gatewayTimeOut => '504 Превышено время ожидания сервера',
      NetworkExceptionType.validation => 'Ошибка валидации запроса',
      NetworkExceptionType.internalServer => 'Внутренняя ошибка сервера',
      //
      NetworkExceptionType.otpSentAlready => 'Код уже отправлен',
      NetworkExceptionType.otpInvalidCode => 'Неправильный код подтверждения',
      NetworkExceptionType.userNotFound$6 => 'Пользователь не найден',
      NetworkExceptionType.invalidTokenType => 'Невалидный тип токена',
      NetworkExceptionType.invalidToken => 'Неправильный токен',
      NetworkExceptionType.expiredToken => 'Срок жизни токена истек',
      //
      NetworkExceptionType.chatNotFound => 'Чат не найден',
      NetworkExceptionType.chatAlreadyExists => 'Чат уже существует',
      NetworkExceptionType.chatsLimit => 'Вы достигли лимита по чатам',
      NetworkExceptionType.userSubscriptionNotFound => 'Подписка пользователя не найдена',
      NetworkExceptionType.invalidRateStatus => 'Нельзя выполнить операцию в текущем статусе тарифа',
      NetworkExceptionType.paymentNotFound => 'Платеж не найден',
      NetworkExceptionType.userNotFound => 'Пользователь не найден',
      NetworkExceptionType.specialOfferNotFound => 'Спец. предложение не найдено',
      NetworkExceptionType.rateOfferFound => 'Тариф не найден',
      NetworkExceptionType.invalidMessageType => 'Неправильный тип сообщения',
      NetworkExceptionType.donNotNeedToPay => 'Не нужно платить',
      NetworkExceptionType.invalidPaymentStatus => 'Неправильный статус платежа',
      NetworkExceptionType.invalidPaymentType => 'Неправильный тип платежа',
      NetworkExceptionType.invalidPayment => 'Неправильный платеж',
      NetworkExceptionType.invalidAutoPayment => 'Автоплатеж производится с привязкой карты',
      NetworkExceptionType.paymentFailed => 'Ошибка при проведении платежа',
      NetworkExceptionType.paymentNotAll => 'Доплата за товар производится автоматически',
      NetworkExceptionType.autoChargeOnFirstPayment => 'Автосписание можно включить только при первом платеже',
      NetworkExceptionType.incompletePayment => 'Существует незавершенный платеж',
      NetworkExceptionType.depositedDaysNotFound => 'Не найдено',
      NetworkExceptionType.sumMisMatch => 'Сумма цен на товары не соответствует общей сумме',
      NetworkExceptionType.impossibleSendOtpCode => 'Ошибка при отправке кода',
      NetworkExceptionType.chatModelNotFound => 'Модель чата не найдена',
      NetworkExceptionType.presetNotFound => 'Преднастройка не найдена',
      NetworkExceptionType.subscriptionAlreadyExists => 'У пользователя уже есть подписка',
      NetworkExceptionType.bindingNotFound => 'Платежная связка не найдена',
      NetworkExceptionType.messagesLimit => 'Вы достигли лимита по сообщениям',
      NetworkExceptionType.promoCodeNotFound => 'Промокод не найден',
      NetworkExceptionType.promoCodeUsageLimit => 'Вы уже использовали промокод максимальное количетсво раз',
      NetworkExceptionType.invalidModelType =>
        'В данном чате работает другой бот, который не поддерживает текущий тип сообщений',
      NetworkExceptionType.userSubscriptionActiveNotFound => 'Активная подписка пользователя не найдена',
      NetworkExceptionType.invalidPayUserSubscription => 'Невозможно купить подписку с данным тарифом',
      NetworkExceptionType.activeSubscriptionAlreadyExists => 'У вас уже есть активная подписка',
      NetworkExceptionType.invalidPromoCodeRate => 'Промокод недействителен на этот тариф',
      NetworkExceptionType.invalidPromoCodeCombination =>
        'Нельзя применить промокод одновременно со специальным предложением',
      NetworkExceptionType.unsupportedPromoCodeRate => 'Данный промокод не действует с выбранным тарифом',
      NetworkExceptionType.existingSubscription => 'У вас уже была подписка',
      NetworkExceptionType.licenseNotFound => 'Лицензия не найдена',
      NetworkExceptionType.fileSizeLimit => 'Слишком большой размер файла. Файл должен быть меньше 20 МБ',
      NetworkExceptionType.unsupportedFileType => 'Данный тип файла не поддерживается',
      NetworkExceptionType.paymentMethodNotAllowed => 'ыбранный метод оплаты сейчас не доступен',
      NetworkExceptionType.speechToTextError => 'Ошибка при распознавании речи',
      NetworkExceptionType.serviceUnavailable => 'Service unavailable',
      NetworkExceptionType.contentPolicyViolation => 'Нарушение политики в отношении контента',
      NetworkExceptionType.emptyMessage => 'Сообщение не может быть пустым',
      NetworkExceptionType.invalidMessage => 'Неправильный формат сообщения',
      NetworkExceptionType.invalidUrlDomain => 'Видео должно быть с Yandex Disk, Google Drive или YouTube',
      NetworkExceptionType.paymentNotFound$4 => 'Платеж не найден',
      NetworkExceptionType.bindingNotFound$4 => 'Привязанная карта не найдена',
    };
  }
}
