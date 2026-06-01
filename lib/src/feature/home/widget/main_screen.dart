import 'package:dlchat/src/core/common/layout/layout.dart';
import 'package:dlchat/src/core/resources/resources.dart';
import 'package:dlchat/src/feature/authentication/bloc/authentication/authentication_bloc.dart';
import 'package:dlchat/src/feature/authentication/widget/authentication_scope.dart';
import 'package:dlchat/src/feature/chats/bloc/chats/chats_bloc.dart';
import 'package:dlchat/src/feature/payment/bloc/binding_cards/binding_cards_bloc.dart';
import 'package:dlchat/src/feature/payment/bloc/frozen_rates/frozen_rates_bloc.dart';
import 'package:dlchat/src/feature/payment/bloc/rates/rates_bloc.dart';
import 'package:dlchat/src/feature/payment/bloc/remaining/remaining_bloc.dart';
import 'package:dlchat/src/feature/payment/bloc/user_rate/user_rate_bloc.dart';
import 'package:dlchat/src/feature/shared_widgets/base/snack_bar.dart';
import 'package:dlchat/src/feature/shared_widgets/common/main_navigation_bar.dart';
import 'package:dlchat/src/feature/shared_widgets/common/side_menu.dart';
import 'package:dlchat/src/feature/shared_widgets/custom/gradient_painter.dart';
import 'package:dlchat/src/feature/transcription/bloc/send_transcription/send_transcription_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class const MainScreen({required final StatefulNavigationShell navigationShell, Key? key}) extends StatefulWidget {
  this : super(key: key ?? const ValueKey<String>('MainScreen'));

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState() extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    // TODO(all): error on desktop after relogin
    if (AuthenticationScope.userOf(context, listen: false).isAuthenticated) {
      context.read<ChatsBloc>().add(const ChatsEvent.start());

      context.read<BindingCardsBloc>().add(const BindingCardsEvent.start());
      context.read<FrozenRatesBloc>().add(const FrozenRatesEvent.start());
      context.read<RatesBloc>().add(const RatesEvent.start());
      context.read<UserRateBloc>().add(const UserRateEvent.start());

      context.read<RemainingBloc>().add(const RemainingEvent.start());
    }
  }

  @override
  Widget build(BuildContext context) {
    final WindowSize windowSize = WindowSizeScope.of(context);
    Widget body = widget.navigationShell;
    if (windowSize.isLargeOrLarger) {
      body = ChatGradient(
        isLargeOrLarger: windowSize.isLargeOrLarger,
        children: [
          Row(
            children: [
              SideMenu(
                onDestinationSelected: widget.navigationShell.goBranch,
                selectedIndex: widget.navigationShell.currentIndex,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Material(
                    color: AppColors.white,
                    elevation: 32,
                    borderRadius: BorderRadius.circular(24),
                    shadowColor: Colors.black,
                    clipBehavior: Clip.antiAlias,
                    child: body,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }
    return MultiBlocListener(
      listeners: [
        BlocListener<SendTranscriptionBloc, SendTranscriptionState>(
          listener: (context, state) {
            switch (state) {
              case final SendTranscriptionSuccess _:
                hideCurrentSnackBar();
              case final SendTranscriptionUploading s:
                if (s.progress != null) {
                  showUploadProgress(context, s.progress!);
                } else if (s.extractingVideo) {
                  showExtractionProgress(context);
                }
              default:
            }
          },
        ),
        BlocListener<AuthenticationBloc, AuthenticationState>(
          bloc: AuthenticationScope.of(context),
          listenWhen: (previous, current) => previous.user.isAuthenticated != current.user.isAuthenticated,
          listener: (context, state) {
            // TODO(all): error on desktop after relogin
            if (AuthenticationScope.userOf(context, listen: false).isAuthenticated) {
              context.read<ChatsBloc>().add(const ChatsEvent.start());

              context.read<RatesBloc>().add(const RatesEvent.start());
              context.read<UserRateBloc>().add(const UserRateEvent.start());
              context.read<FrozenRatesBloc>().add(const FrozenRatesEvent.start());

              context.read<RemainingBloc>().add(const RemainingEvent.start());
            }
          },
        ),
      ],
      child: Scaffold(
        body: body,
        extendBody: true,
        extendBodyBehindAppBar: windowSize.isLargeOrLarger,
        bottomNavigationBar: windowSize.isLargeOrLarger
            ? null
            : MainNavigationBar(
                onDestinationSelected: widget.navigationShell.goBranch,
                selectedIndex: widget.navigationShell.currentIndex,
              ),
      ),
    );
  }
}
