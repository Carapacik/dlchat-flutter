import 'package:dlchat/src/core/common/persisted_entry.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// {@template request_counter_datasource}
/// [IRequestCounterDataSource] - точка входа к хранилищу данных о запросах пользователя.
///
/// Используется для отслеживания количества запросов пользователя.
/// {@endtemplate}
abstract interface class IRequestCounterDataSource() {
  /// Увеличить счетчик запросов пользователя
  Future<void> incrementRequestCount();

  /// Получить текущее количество запросов пользователя
  Future<int> getRequestCount();

  /// Сбросить счетчик запросов пользователя
  Future<void> resetRequestCount();

  /// Проверить, был ли уже показан запрос на отзыв
  Future<bool> wasReviewRequested();

  /// Отметить, что запрос на отзыв был показан
  Future<void> markReviewAsRequested();

  /// Очистить все сохраненные данные
  Future<void> removeAll();
}

final class RequestCounterDataSource({required final SharedPreferencesAsync sharedPreferences})
    implements IRequestCounterDataSource {
  late final _requestCount = IntPreferencesEntry(sharedPreferences: sharedPreferences, key: 'request_counter.count');

  late final _reviewRequested = BoolPreferencesEntry(
    sharedPreferences: sharedPreferences,
    key: 'request_counter.review_requested',
  );

  @override
  Future<int> getRequestCount() async {
    final int? count = await _requestCount.read();
    return count ?? 0;
  }

  @override
  Future<void> incrementRequestCount() async {
    final int currentCount = await getRequestCount();
    await _requestCount.set(currentCount + 1);
  }

  @override
  Future<void> resetRequestCount() => _requestCount.set(0);

  @override
  Future<bool> wasReviewRequested() async {
    final bool? requested = await _reviewRequested.read();
    return requested ?? false;
  }

  @override
  Future<void> markReviewAsRequested() => _reviewRequested.set(true);

  @override
  Future<void> removeAll() async {
    await _requestCount.remove();
    await _reviewRequested.remove();
  }
}
