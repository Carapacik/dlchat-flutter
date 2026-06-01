import 'package:shared_preferences/shared_preferences.dart';

/// {@template persisted_entry}
/// [PersistedEntry] describes a single persisted entry.
/// {@endtemplate}
abstract class const PersistedEntry<T extends Object>() {
  /// {@macro persisted_entry}
  this;

  /// Read the value from the cache.
  Future<T?> read();

  /// Set the value in the cache.
  Future<void> set(T value);

  /// Remove the value from the cache.
  Future<void> remove();

  /// Set the value in the cache if the value is not null, otherwise remove the value from the cache.
  Future<void> setIfNullRemove(T? value) => value == null ? remove() : set(value);
}

/// {@template shared_preferences_entry}
/// [SharedPreferencesEntry] describes a single persisted entry in [SharedPreferences].
/// {@endtemplate}
abstract class const SharedPreferencesEntry<T extends Object>({
  /// The instance of [SharedPreferences] used to read and write values.
  required final SharedPreferencesAsync sharedPreferences,

  /// The key used to store the value in the cache.
  required final String key,
}) extends PersistedEntry<T> {
  /// {@macro shared_preferences_entry}
  this;
}

/// A [int] implementation of [SharedPreferencesEntry].
class const IntPreferencesEntry({required super.sharedPreferences, required super.key})
    extends SharedPreferencesEntry<int> {
  /// {@macro int_preferences_entry}
  this;

  @override
  Future<int?> read() => sharedPreferences.getInt(key);

  @override
  Future<void> set(int value) async {
    await sharedPreferences.setInt(key, value);
  }

  @override
  Future<void> remove() async {
    await sharedPreferences.remove(key);
  }
}

/// A [String] implementation of [SharedPreferencesEntry].
class const StringPreferencesEntry({required super.sharedPreferences, required super.key})
    extends SharedPreferencesEntry<String> {
  /// {@macro string_preferences_entry}
  this;

  @override
  Future<String?> read() => sharedPreferences.getString(key);

  @override
  Future<void> set(String value) async {
    await sharedPreferences.setString(key, value);
  }

  @override
  Future<void> remove() async {
    await sharedPreferences.remove(key);
  }
}

/// A [bool] implementation of [SharedPreferencesEntry].
class const BoolPreferencesEntry({required super.sharedPreferences, required super.key})
    extends SharedPreferencesEntry<bool> {
  /// {@macro bool_preferences_entry}
  this;

  @override
  Future<bool?> read() => sharedPreferences.getBool(key);

  @override
  Future<void> set(bool value) async {
    await sharedPreferences.setBool(key, value);
  }

  @override
  Future<void> remove() async {
    await sharedPreferences.remove(key);
  }
}

/// A [double] implementation of [SharedPreferencesEntry].
class const DoublePreferencesEntry({required super.sharedPreferences, required super.key})
    extends SharedPreferencesEntry<double> {
  /// {@macro double_preferences_entry}
  this;

  @override
  Future<double?> read() => sharedPreferences.getDouble(key);

  @override
  Future<void> set(double value) async {
    await sharedPreferences.setDouble(key, value);
  }

  @override
  Future<void> remove() async {
    await sharedPreferences.remove(key);
  }
}

/// A `List<String>` implementation of [SharedPreferencesEntry].
class const StringListPreferencesEntry({required super.sharedPreferences, required super.key})
    extends SharedPreferencesEntry<List<String>> {
  /// {@macro string_list_preferences_entry}
  this;

  @override
  Future<List<String>?> read() => sharedPreferences.getStringList(key);

  @override
  Future<void> set(List<String> value) async {
    await sharedPreferences.setStringList(key, value);
  }

  @override
  Future<void> remove() async {
    await sharedPreferences.remove(key);
  }
}
