import 'package:dlchat/src/core/common/extensions/theme_extension.dart';
import 'package:dlchat/src/core/common/layout/layout.dart';
import 'package:dlchat/src/core/constant/localization/generated/l10n.dart';
import 'package:dlchat/src/core/constant/localization/localization.dart';
import 'package:dlchat/src/core/router/routes.dart';
import 'package:dlchat/src/feature/initialization/model/dependencies_container.dart';
import 'package:dlchat/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Extension methods on [BuildContext] for working with inherited widgets.
extension InheritedExtension on BuildContext {
  /// Obtain the nearest widget of the given type T,
  /// which must be the type of a concrete [InheritedWidget] subclass,
  /// and register this build context with that widget such that
  /// when that widget changes (or a new widget of that type is introduced,
  /// or the widget goes away), this build context is rebuilt so that it can
  /// obtain new values from that widget.
  T? inhMaybeOf<T extends InheritedWidget>({bool listen = true}) =>
      listen ? dependOnInheritedWidgetOfExactType<T>() : getInheritedWidgetOfExactType<T>();

  /// Obtain the nearest widget of the given type T,
  /// which must be the type of a concrete [InheritedWidget] subclass,
  /// and register this build context with that widget such that
  /// when that widget changes (or a new widget of that type is introduced,
  /// or the widget goes away), this build context is rebuilt so that it can
  /// obtain new values from that widget.
  T inhOf<T extends InheritedWidget>({bool listen = true}) =>
      inhMaybeOf<T>(listen: listen) ??
      (throw ArgumentError(
        'Out of scope, not found inherited widget '
            'a $T of the exact type',
        'out_of_scope',
      ));

  /// Maybe inherit specific aspect from [InheritedModel].
  T? maybeInheritFrom<A extends Object, T extends InheritedModel<A>>({A? aspect}) =>
      InheritedModel.inheritFrom<T>(this, aspect: aspect);

  /// Inherit specific aspect from [InheritedModel].
  T inheritFrom<A extends Object, T extends InheritedModel<A>>({A? aspect}) =>
      maybeInheritFrom(aspect: aspect) ??
      (throw ArgumentError(
        'Out of scope, not found inherited model '
            'a $T of the exact type',
        'out_of_scope',
      ));
}

extension ContextX on BuildContext {
  /// Get localization
  AppLocalizations get l10n => Localization.of(this);

  /// Get dependencies container
  DependenciesContainer get dependencies => DependenciesScope.of(this);

  /// Get AppColorsX theme extension
  AppColorsX get colors => Theme.of(this).extension<AppColorsX>()!;
}

extension GoRouterX on BuildContext {
  String _nameBySize(String name) {
    final Map<String, String> nestedMap = {
      Routes.chat.name: Routes.chatNested.name,
      Routes.rates.name: Routes.ratesNested.name,
      Routes.faq.name: Routes.faqNested.name,
      Routes.bingingCards.name: Routes.bingingCardsNested.name,
      Routes.paymentWebView.name: Routes.paymentWebViewNested.name,
      Routes.paymentResult.name: Routes.paymentResultNested.name,
      Routes.transcriptionsOnboarding.name: Routes.transcriptionsOnboardingNested.name,
      Routes.transcriptions.name: Routes.transcriptionsNested.name,
      Routes.detailTranscription.name: Routes.detailTranscriptionNested.name,
      Routes.nutritionistFillingData.name: Routes.nutritionistFillingDataNested.name,
    };
    final WindowSize windowSize = WindowSizeScope.of(this);
    return windowSize.isLargeOrLarger && nestedMap.containsKey(name) ? nestedMap[name]! : name;
  }

  void goNamedX(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
    String? fragment,
  }) => GoRouter.of(this).goNamed(
    _nameBySize(name),
    pathParameters: pathParameters,
    queryParameters: queryParameters,
    extra: extra,
    fragment: fragment,
  );

  Future<T?> pushNamedX<T extends Object?>(
    String name, {
    Map<String, String> pathParameters = const <String, String>{},
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    Object? extra,
  }) => GoRouter.of(this)
      .pushNamed<T>(_nameBySize(name), pathParameters: pathParameters, queryParameters: queryParameters, extra: extra);
}
