import 'dart:async';

import 'package:dlchat/src/core/components/prefs_storage/user/user_data_source.dart';
import 'package:rest_client/account/account_client.dart';

abstract interface class IUserRepository() {
  Future<String?> get phone;

  Future<String?> get email;

  Future<void> savePhone(String phone);

  Future<void> saveEmail(String email);

  Future<void> removeLocalUser();

  Future<void> deleteAccount();
}

class const UserRepository({
  required final AccountClient _accountClient,
  required final IUserDataSource _userDataSource,
  required final Future<void> Function() _clearStorages,
}) implements IUserRepository {
  @override
  Future<String?> get phone => _userDataSource.phone;

  @override
  Future<String?> get email => _userDataSource.email;

  @override
  Future<void> saveEmail(String email) => _userDataSource.saveEmail(email);

  @override
  Future<void> savePhone(String phone) => _userDataSource.savePhone(phone);

  @override
  Future<void> removeLocalUser() => _userDataSource.remove();

  @override
  Future<void> deleteAccount() async {
    await _accountClient.deleteAccount();
    await _clearStorages.call();
  }
}
