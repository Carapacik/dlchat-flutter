import 'package:dlchat/src/feature/authentication/bloc/authentication/authentication_bloc.dart';
import 'package:dlchat/src/feature/authentication/model/user.dart';
import 'package:dlchat/src/feature/initialization/widget/dependencies_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// {@template auth_scope}
/// AuthenticationScope widget.
/// {@endtemplate}
class const AuthenticationScope({
  /// The child widget.
  required final Widget child,
  super.key,
}) extends StatefulWidget {
  /// {@macro auth_scope}
  this;

  /// Get the [AuthenticationBloc] instance.
  static AuthenticationBloc of(BuildContext context, {bool listen = true}) {
    final _InheritedAuthenticationUser? scope = listen
        ? context.dependOnInheritedWidgetOfExactType<_InheritedAuthenticationUser>()
        : context.getInheritedWidgetOfExactType<_InheritedAuthenticationUser>();
    return scope!.state._authenticationBloc;
  }

  /// Get the [User] instance.
  static User userOf(BuildContext context, {bool listen = true}) {
    final _InheritedAuthenticationUser? scope = listen
        ? context.dependOnInheritedWidgetOfExactType<_InheritedAuthenticationUser>()
        : context.getInheritedWidgetOfExactType<_InheritedAuthenticationUser>();
    return scope!.user;
  }

  @override
  State<AuthenticationScope> createState() => _AuthenticationScopeState();
}

/// State for widget AuthenticationScope.
class _AuthenticationScopeState() extends State<AuthenticationScope> {
  late final AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    super.initState();
    _authenticationBloc = DependenciesScope.of(context).authenticationBloc;
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<AuthenticationBloc, AuthenticationState>(
    bloc: _authenticationBloc,
    builder: (context, state) => _InheritedAuthenticationUser(user: state.user, state: this, child: widget.child),
  );
}

/// {@template inherited_authentication_user}
/// _InheritedAuthenticationUser widget.
/// {@endtemplate}
class const _InheritedAuthenticationUser({
  required super.child,

  /// _AuthenticationScopeState instance
  required final _AuthenticationScopeState state,
  required final User user,
}) extends InheritedWidget {
  /// {@macro inherited_authentication_user}
  this;

  @override
  bool updateShouldNotify(covariant _InheritedAuthenticationUser oldWidget) => user != oldWidget.user;
}
