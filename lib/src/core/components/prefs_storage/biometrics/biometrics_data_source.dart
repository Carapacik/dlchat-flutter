import 'package:dlchat/src/core/common/persisted_entry.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class IBiometricsDataSource() {
  Future<bool?> getFace();

  Future<bool?> getFingerprint();

  Future<bool?> getStrong();

  Future<void> setFace({required bool face});

  Future<void> setFingerprint({required bool fingerprint});

  Future<void> setStrong({required bool strong});

  Future<void> remove();
}

final class BiometricsDataSource({required final SharedPreferencesAsync sharedPreferences})
    implements IBiometricsDataSource {
  late final _face = BoolPreferencesEntry(sharedPreferences: sharedPreferences, key: 'biometrics.face');
  late final _fingerprint = BoolPreferencesEntry(sharedPreferences: sharedPreferences, key: 'biometrics.fingerprint');
  late final _strong = BoolPreferencesEntry(sharedPreferences: sharedPreferences, key: 'biometrics.strong');

  @override
  Future<bool?> getFace() => _face.read();

  @override
  Future<bool?> getFingerprint() => _fingerprint.read();

  @override
  Future<bool?> getStrong() => _strong.read();

  @override
  Future<void> setFace({required bool face}) => _face.setIfNullRemove(face);

  @override
  Future<void> setFingerprint({required bool fingerprint}) => _fingerprint.setIfNullRemove(fingerprint);

  @override
  Future<void> setStrong({required bool strong}) => _strong.setIfNullRemove(strong);

  @override
  Future<void> remove() async {
    await [_face.remove(), _fingerprint.remove(), _strong.remove()].wait;
  }
}
