import 'package:dlchat/src/core/common/extensions/extensions.dart';
import 'package:dlchat/src/core/common/store_validation.dart';
import 'package:dlchat/src/core/resources/resources.dart';
import 'package:dlchat/src/core/router/routes.dart';
import 'package:dlchat/src/feature/payment/bloc/user_rate/user_rate_bloc.dart';
import 'package:dlchat/src/feature/user/data/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class const RateBadge({super.key}) extends StatefulWidget {
  @override
  State<RateBadge> createState() => _RateBadgeState();
}

class _RateBadgeState() extends State<RateBadge> {
  late final IUserRepository _userRepository = context.dependencies.userRepository;

  String? _phone;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final String? phone = await _userRepository.phone;
      setState(() => _phone = phone);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (StoreValidation.hidePayments(context, _phone)) {
      return const SizedBox.shrink();
    } else {
      return BlocBuilder<UserRateBloc, UserRateState>(
        builder: (context, state) {
          if (state.userRate != null) {
            return GestureDetector(
              onTap: () async => await context.pushNamedX(Routes.rates.name),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: SizedBox(
                  height: 36,
                  child: DecoratedBox(
                    decoration: ShapeDecoration(
                      gradient: LinearGradient(
                        colors: parseColors(state.userRate!.color),
                        stops: const [0, 1],
                        begin: const Alignment(-1, -0),
                      ),
                      shape: const StadiumBorder(),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        state.userRate!.name,
                        style: const TextStyle(color: AppColors.white, fontSize: 12, height: 1),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      );
    }
  }

  List<Color> parseColors(String colorString) {
    var colors = <Color>[];

    if (colorString.isNotEmpty) {
      final List<String> hexColors = colorString.split(';');

      for (final hex in hexColors) {
        if (hex.isNotEmpty) {
          try {
            // Удаляем символ '#' и преобразуем HEX в цвет
            final int colorInt = int.parse(hex.replaceAll('#', ''), radix: 16);
            colors.add(Color(colorInt).withAlpha(255));
          } on Exception catch (_) {
            // В случае ошибки добавляем дефолтный цвет
            colors.add(const Color(0xFF000000));
          }
        }
      }
    }

    // Если не удалось распарсить цвета, используем дефолтные
    if (colors.isEmpty) {
      colors = [const Color(0xFFFEC8FF), const Color(0xFFFF56DA)];
    }

    return colors;
  }
}
