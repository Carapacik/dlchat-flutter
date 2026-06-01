import 'package:dlchat/src/core/common/extensions/extensions.dart';
import 'package:dlchat/src/feature/chats/bloc/chat_model/chat_model_bloc.dart';
import 'package:dlchat/src/feature/chats/bloc/chats/chats_bloc.dart';
import 'package:dlchat/src/feature/payment/bloc/binding_cards/binding_cards_bloc.dart';
import 'package:dlchat/src/feature/payment/bloc/frozen_rates/frozen_rates_bloc.dart';
import 'package:dlchat/src/feature/payment/bloc/payment/payment_bloc.dart';
import 'package:dlchat/src/feature/payment/bloc/promo_code/promo_code_bloc.dart';
import 'package:dlchat/src/feature/payment/bloc/rates/rates_bloc.dart';
import 'package:dlchat/src/feature/payment/bloc/remaining/remaining_bloc.dart';
import 'package:dlchat/src/feature/payment/bloc/user_rate/user_rate_bloc.dart';
import 'package:dlchat/src/feature/profile/bloc/profile_bloc.dart';
import 'package:dlchat/src/feature/transcription/bloc/send_transcription/send_transcription_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class const BlocScope({required final Widget child, super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ChatsBloc(
            chatRepository: context.dependencies.chatRepository,
            userRepository: context.dependencies.userRepository,
            reporter: context.dependencies.reporters,
          ),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => RemainingBloc(paymentRepository: context.dependencies.paymentRepository),
        ),
        BlocProvider(create: (context) => ProfileBloc(userRepository: context.dependencies.userRepository)),
        BlocProvider(
          create: (context) => SendTranscriptionBloc(
            transcriptionsRepository: context.dependencies.transcriptionsRepository,
            authenticationRepository: context.dependencies.authenticationRepository,
          ),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => ChatModelBloc(chatRepository: context.dependencies.chatRepository),
        ),

        // Payment
        BlocProvider(
          lazy: false,
          create: (context) => FrozenRatesBloc(paymentRepository: context.dependencies.paymentRepository),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => RatesBloc(paymentRepository: context.dependencies.paymentRepository),
        ),
        BlocProvider(create: (context) => UserRateBloc(paymentRepository: context.dependencies.paymentRepository)),
        BlocProvider(
          create: (context) => PaymentBloc(
            paymentRepository: context.dependencies.paymentRepository,
            userRepository: context.dependencies.userRepository,
            analytics: context.dependencies.reporters,
          ),
        ),
        BlocProvider(create: (context) => PromoCodeBloc(paymentRepository: context.dependencies.paymentRepository)),
        BlocProvider(
          lazy: false,
          create: (context) => BindingCardsBloc(paymentRepository: context.dependencies.paymentRepository),
        ),
      ],
      child: child,
    );
  }
}
