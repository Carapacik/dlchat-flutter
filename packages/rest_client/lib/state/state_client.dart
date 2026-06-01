import 'package:dio/dio.dart';
import 'package:rest_client/result_response.dart';
import 'package:rest_client/state/dto/app_state_dto.dart';
import 'package:rest_client/state/dto/app_state_v2_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'state_client.g.dart';

@RestApi()
abstract class StateClient {
  factory(Dio dio, {String? baseUrl}) = _StateClient;

  /// Get State.
  ///
  /// Получение состояний сервиса.
  @GET('/v1/state')
  Future<ResultResponse<GetStateResponse>> getState();

  /// Get State.
  ///
  /// Получение состояний сервиса.
  @GET('/api/v2/state/')
  Future<ResultResponse<GetStateV2Response>> getStateV2();
}
