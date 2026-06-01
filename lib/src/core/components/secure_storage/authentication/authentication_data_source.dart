import 'dart:convert';
import 'dart:developer';

import 'package:dlchat/src/feature/authentication/model/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract interface class IAuthenticationDataSource() {
  Future<User> getUser();

  Future<void> setUser(User user);

  Future<void> remove();
}

class const AuthenticationDataSource({required final FlutterSecureStorage _secureStorage})
    implements IAuthenticationDataSource {
  static const _tokensKey = 'authentication.tokens';

  @override
  Future<User> getUser() async {
    String? tokens;
    try {
      tokens = await _secureStorage.read(key: _tokensKey);
    } on Object {
      return const User.unauthenticated();
    }
    if (tokens == null) {
      return const User.unauthenticated();
    }
    return User.fromJson(json.decode(tokens) as Map<String, Object?>);
  }

  @override
  Future<void> setUser(User user) async {
    try {
      await _secureStorage.write(key: _tokensKey, value: json.encode(user.toJson()));
    } on Object catch (e, st) {
      //
      log('Error token save', error: e, stackTrace: st);
    }
  }

  @override
  Future<void> remove() async {
    try {
      await _secureStorage.delete(key: _tokensKey);
    } on Object catch (e, st) {
      //
      log('Error token remove', error: e, stackTrace: st);
    }
  }
}
