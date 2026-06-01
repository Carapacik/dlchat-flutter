import 'dart:async';

import 'package:dlchat/src/core/components/secure_storage/authentication/authentication_data_source.dart';
import 'package:dlchat/src/feature/authentication/model/app_device_info.dart';
import 'package:dlchat/src/feature/authentication/model/input_phone_data.dart';
import 'package:dlchat/src/feature/authentication/model/user.dart';
import 'package:dlchat/src/feature/authentication/model/user_converter.dart';
import 'package:rest_client/auth/auth_client.dart';
import 'package:rest_client/auth/dto/init_command.dart';
import 'package:rest_client/auth/dto/verify_request_body_dto.dart';
import 'package:rxdart/rxdart.dart';

abstract interface class IAuthenticationRepository() {
  Stream<User> userChanges();

  User get currentUser;

  Future<void> initPhone(String phone, SignInType type);

  Future<AuthenticatedUser> signIn(String phone, String otp, AppDeviceInfo deviceInfo);

  Future<void> signOut();

  Future<void> updateUser(User user);

  Future<User> refreshUser();
}

class AuthenticationRepository({
  required final AuthClient _authClient,
  required final IAuthenticationDataSource _authenticationDataSource,
  required User seedValue,
  required Future<void> Function() clearStorages,
}) implements IAuthenticationRepository {
  final BehaviorSubject<User> _userController = BehaviorSubject.seeded(seedValue);
  final Future<void> Function() _clearStorage = clearStorages;

  @override
  Stream<User> userChanges() => _userController.stream;

  @override
  User get currentUser => _userController.value;

  @override
  Future<void> initPhone(String phone, SignInType type) =>
      _authClient.init(InitCommand(phoneNumber: phone, type: SignInType.encode(type)));

  @override
  Future<AuthenticatedUser> signIn(String phone, String otp, AppDeviceInfo deviceInfo) async {
    final AuthenticatedUser user = await _authClient
        .verify(VerifyRequestBodyDto(phoneNumber: phone, otp: otp, device: AppDeviceInfo.encode(deviceInfo)))
        .then((dto) => const UserConverter().convert(dto.result));

    await _authenticationDataSource.setUser(user);
    _userController.add(user);
    return user;
  }

  @override
  Future<void> signOut() async {
    const user = User.unauthenticated();
    await _clearStorage.call();
    _userController.add(user);
  }

  @override
  Future<void> updateUser(User user) async {
    await _authenticationDataSource.setUser(user);
    _userController.add(user);
  }

  @override
  Future<User> refreshUser() async {
    final User user = _userController.value;
    if (user.isNotAuthenticated) {
      await signOut();
      return const User.unauthenticated();
    }

    try {
      final AuthenticatedUser newUser = await _authClient.refresh().then(
        (dto) => const UserConverter().convert(dto.data.result),
      );
      await updateUser(newUser);
      return newUser;
    } on Object {
      await signOut();
      return const User.unauthenticated();
    }
  }
}
