import 'package:dlchat/src/core/components/secure_storage/authentication/authentication_data_source.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final class AppSecureStorage({required final FlutterSecureStorage _secureStorage}) {
  IAuthenticationDataSource? _authenticationDataSource;

  IAuthenticationDataSource get authenticationDataSource =>
      _authenticationDataSource ??= AuthenticationDataSource(secureStorage: _secureStorage);

  Future<void> remove() async {
    await authenticationDataSource.remove();
  }
}
