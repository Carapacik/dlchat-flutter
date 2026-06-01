import 'dart:convert';

import 'package:dlchat/src/feature/authentication/model/user.dart';
import 'package:rest_client/auth/dto/token_dto.dart';

final class const UserConverter() extends Converter<TokenDto, AuthenticatedUser> {
  @override
  AuthenticatedUser convert(TokenDto input) =>
      AuthenticatedUser(accessToken: input.accessToken, refreshToken: input.refreshToken);
}
