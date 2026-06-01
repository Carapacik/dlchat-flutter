import 'package:json_annotation/json_annotation.dart';
import 'package:rest_client/auth/dto/token_dto.dart';
import 'package:rest_client/chat/dto/add_chat_dto.dart';
import 'package:rest_client/chat/dto/assistants_dto.dart';
import 'package:rest_client/chat/dto/audio_chat_message_dto.dart';
import 'package:rest_client/chat/dto/chat_dto.dart';
import 'package:rest_client/chat/dto/chat_message_dto.dart';
import 'package:rest_client/chat/dto/chat_messages_dto.dart';
import 'package:rest_client/chat/dto/chat_model_dto.dart';
import 'package:rest_client/chat/dto/chat_models_dto.dart';
import 'package:rest_client/chat/dto/chats_dto.dart';
import 'package:rest_client/chat_v2/dto/add_chat_v2_response.dart';
import 'package:rest_client/payment/dto/binding_list_dto.dart';
import 'package:rest_client/payment/dto/init_payments_dto.dart';
import 'package:rest_client/state/dto/app_state_dto.dart';
import 'package:rest_client/state/dto/app_state_v2_dto.dart';
import 'package:rest_client/subscription/dto/pay_rate_response.dart';
import 'package:rest_client/subscription/dto/payment_dto.dart';
import 'package:rest_client/subscription/dto/payments_dto.dart';
import 'package:rest_client/subscription/dto/rates_dto.dart';
import 'package:rest_client/subscription/dto/receipts_dto.dart';
import 'package:rest_client/subscription/dto/remaining_request_dto.dart';
import 'package:rest_client/subscription/dto/user_subscription_dto.dart';
import 'package:rest_client/subscription/dto/user_subscriptions_dto.dart';
import 'package:rest_client/subscription/dto/verify_promo_code_response.dart';
import 'package:rest_client/transcriptions/dto/message_dto.dart';
import 'package:rest_client/transcriptions/dto/transcription_dto.dart';

class const ResultResponse<T>({
  @ResultResponseConverter() required final T result,
  required final String message,
  required final int? errorCode,
}) {
  factory fromJson(Map<String, dynamic> json) => ResultResponse<T>(
    result: ResultResponseConverter<T>().fromJson(json['result']),
    message: json['message'].toString(),
    errorCode: json['errorCode'] as int?,
  );

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) => <String, dynamic>{
    'result': ResultResponseConverter<T>().toJson(result),
    'message': message,
    'errorCode': errorCode,
  };
}

class const ResultResponseConverter<T>() extends JsonConverter<T, Object?> {
  static final Map<Type, Object Function(Map<String, dynamic>)> _decoders = {
    TokenDto: TokenDto.fromJson,
    GetStateResponse: GetStateResponse.fromJson,
    GetStateV2Response: GetStateV2Response.fromJson,
    UserSubscriptionsDto: UserSubscriptionsDto.fromJson,
    UserSubscriptionDto: UserSubscriptionDto.fromJson,
    RemainingRequestDto: RemainingRequestDto.fromJson,
    RatesDto: RatesDto.fromJson,
    VerifyPromoCodeResponse: VerifyPromoCodeResponse.fromJson,
    PayRateResponse: PayRateResponse.fromJson,
    PaymentsDto: PaymentsDto.fromJson,
    PaymentDto: PaymentDto.fromJson,
    ReceiptsDto: ReceiptsDto.fromJson,
    ChatModelDto: ChatModelDto.fromJson,
    ChatModelsDto: ChatModelsDto.fromJson,
    ChatsDto: ChatsDto.fromJson,
    ChatDto: ChatDto.fromJson,
    AddChatDto: AddChatDto.fromJson,
    ChatMessagesDto: ChatMessagesDto.fromJson,
    ChatMessageDto: ChatMessageDto.fromJson,
    AudioChatMessageDto: AudioChatMessageDto.fromJson,
    AssistantsDto: AssistantsDto.fromJson,
    BindingListDto: BindingListDto.fromJson,
    InitPaymentsDto: InitPaymentsDto.fromJson,
    TranscriptionDto: TranscriptionDto.fromJson,
    TranscriptionListDto: TranscriptionListDto.fromJson,
    MessageListDto: MessageListDto.fromJson,
    AddChatV2Response: AddChatV2Response.fromJson,
  };

  @override
  T fromJson(Object? json) {
    if (json is Map<String, dynamic>) {
      final Object Function(Map<String, dynamic>)? decoder = _decoders[T];
      if (decoder == null) {
        throw UnsupportedError('Unsupported type for ResultResponseConverter: $T');
      }
      return decoder(json) as T;
    }
    return json as T;
  }

  @override
  Object? toJson(T object) => object;
}
