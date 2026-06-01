import 'package:dio/dio.dart';
import 'package:rest_client/auth/dto/init_command.dart';
import 'package:rest_client/auth/dto/token_dto.dart';
import 'package:rest_client/auth/dto/verify_request_body_dto.dart';
import 'package:rest_client/result_response.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_client.g.dart';

@RestApi()
abstract class AuthClient {
  factory(Dio dio, {String? baseUrl}) = _AuthClient;

  @POST('/v1/token/refresh')
  Future<HttpResponse<ResultResponse<TokenDto>>> refresh();

  @POST('/v1/auth/init')
  Future<void> init(@Body() InitCommand body);

  @POST('/v1/auth/verify')
  Future<ResultResponse<TokenDto>> verify(@Body() VerifyRequestBodyDto body);

  @POST('/v1/auth/logout')
  Future<void> logout();
}
