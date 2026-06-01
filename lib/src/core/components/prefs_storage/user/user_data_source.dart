import 'package:dlchat/src/core/common/persisted_entry.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class IUserDataSource() {
  Future<String?> get phone;

  Future<String?> get email;

  Future<void> savePhone(String phone);

  Future<void> saveEmail(String email);

  Future<void> remove();
}

final class UserDataSource({required final SharedPreferencesAsync sharedPreferences}) implements IUserDataSource {
  late final _userPhone = StringPreferencesEntry(sharedPreferences: sharedPreferences, key: 'user.phone');
  late final _userEmail = StringPreferencesEntry(sharedPreferences: sharedPreferences, key: 'user.email');

  @override
  Future<void> remove() async {
    await _userPhone.remove();
    await _userEmail.remove();
  }

  @override
  Future<String?> get phone => _userPhone.read();

  @override
  Future<String?> get email => _userEmail.read();

  @override
  Future<void> savePhone(String phone) => _userPhone.set(phone);

  @override
  Future<void> saveEmail(String email) => _userEmail.set(email);
}
