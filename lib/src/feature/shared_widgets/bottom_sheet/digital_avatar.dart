import 'dart:io';

import 'package:dlchat/src/core/resources/resources.dart';
import 'package:dlchat/src/feature/shared_widgets/common/plus_description_tile.dart';
import 'package:dlchat/src/feature/shared_widgets/modal/drag_handle.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

Future<void> showDigitalAvatarBottomSheet({
  required BuildContext context,
  required WidgetBuilder builder,
  String? video,
}) async {
  late VideoPlayerController controller;
  if (video != null) {
    controller = VideoPlayerController.asset(video);
    await controller.setLooping(true);
    await controller.initialize();
    await controller.play();
  }

  if (!context.mounted) {
    return;
  }

  await showModalBottomSheet<void>(
    context: context,
    elevation: 0,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    useRootNavigator: true,
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: SafeArea(
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                      child: video != null
                          ? AspectRatio(aspectRatio: controller.value.aspectRatio, child: VideoPlayer(controller))
                          : const SizedBox(height: 24, width: double.infinity),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: 24,
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                        ),
                      ),
                    ),
                    const Positioned(left: 0, top: 8, right: 0, child: DragHandle()),
                  ],
                ),
                Material(
                  color: AppColors.white,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(24))),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 8),
                    child: SafeArea(child: builder.call(context)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  if (!kIsWeb && Platform.isAndroid && video != null) {
    await controller.dispose();
  }
}

class const DigitalAvatarBottomSheet({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('Цифровые аватары — надежные помощники в онлайн-среде', style: AppTypography.bodySemibold),
        SizedBox(height: 16),
        PlusDescriptionTile(
          title: 'Визуальная точность',
          description: 'Цифровые аватары полностью копируют ваш внешний вид, эмоции, мимику и жесты',
        ),
        SizedBox(height: 8),
        PlusDescriptionTile(
          title: 'Говорите на любом языке',
          description: 'Ваш цифровой аватар свободно владеет множеством языков',
        ),
        SizedBox(height: 8),
        PlusDescriptionTile(
          title: 'Делайте качественные переводы',
          description: 'Переводите любые видео на любые языки',
        ),
        SizedBox(height: 8),
        PlusDescriptionTile(
          title: 'Экономьте время',
          description:
              'Перестаньте тратить время на создание контента. Теперь видео можно создавать за считанные минуты',
        ),
      ],
    );
  }
}
