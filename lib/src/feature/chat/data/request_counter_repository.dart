import 'dart:async';
import 'dart:io';

import 'package:dlchat/src/core/components/prefs_storage/request_counter/request_counter_datasource.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_rustore_review/flutter_rustore_review.dart';
import 'package:in_app_review/in_app_review.dart';

/// {@template request_counter_repository}
/// [IRequestCounterRepository] - repository for working with the user request counter.
///
/// Used to track the number of user requests and show a review request after a certain number of requests.
/// {@endtemplate}
abstract interface class IRequestCounterRepository() {
  /// Increment the user request counter and check if a review request is necessary
  Future<void> incrementRequestCount();

  /// Get the current number of user requests
  Future<int> getRequestCount();

  /// Reset the user request counter
  Future<void> resetRequestCount();

  /// Check if the review request has already been shown
  Future<bool> wasReviewRequested();

  /// Mark that the review request has been shown
  Future<void> markReviewAsRequested();
}

/// {@template request_counter_repository_impl}
/// Implementation of [IRequestCounterRepository].
/// {@endtemplate}
class RequestCounterRepository({required IRequestCounterDataSource requestCounterDataSource})
    implements IRequestCounterRepository {
  /// {@macro request_counter_repository_impl}
  this : _inAppReview = InAppReview.instance {
    // Initialize RuStore review client
    if (!kIsWeb && Platform.isAndroid) {
      unawaited(RustoreReviewClient.initialize());
    }
  }

  final IRequestCounterDataSource _dataSource = requestCounterDataSource;
  final InAppReview _inAppReview;

  /// The number of requests after which the review request will be shown
  static const int _requestThreshold = 3;
  static const String _appStoreId = '6636511115';

  @override
  Future<void> incrementRequestCount() async {
    await _dataSource.incrementRequestCount();

    // Check if a review request is needed
    final int currentCount = await getRequestCount();
    if (currentCount >= _requestThreshold) {
      final bool wasRequested = await wasReviewRequested();
      if (!wasRequested) {
        await _requestReview();
        await markReviewAsRequested();
      }
    }
  }

  /// Request a review based on the platform
  Future<void> _requestReview() async {
    if (kIsWeb) {
      return;
    }
    try {
      // For Android devices
      if (Platform.isAndroid) {
        // Try RuStore first for Russian users
        try {
          await RustoreReviewClient.request().then((value) {
            return RustoreReviewClient.review();
          });
          return;
        } on Exception catch (rustoreError) {
          debugPrint('RuStore review failed: $rustoreError');
          // Fall back to Google Play if RuStore fails
        }
      }

      // For all other platforms or as fallback
      final bool isAvailable = await _inAppReview.isAvailable();

      if (isAvailable) {
        await _inAppReview.requestReview();
      } else {
        // Fallback to store listing if review dialog isn't available
        await _inAppReview.openStoreListing(appStoreId: _appStoreId);
      }
    } on Exception catch (e) {
      debugPrint('Review request error: $e');
      // Silently handle errors to not disrupt user experience
    }
  }

  @override
  Future<int> getRequestCount() => _dataSource.getRequestCount();

  @override
  Future<void> resetRequestCount() => _dataSource.resetRequestCount();

  @override
  Future<bool> wasReviewRequested() => _dataSource.wasReviewRequested();

  @override
  Future<void> markReviewAsRequested() => _dataSource.markReviewAsRequested();
}
