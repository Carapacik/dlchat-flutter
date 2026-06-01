import 'package:dlchat/src/core/resources/resources.dart';
import 'package:dlchat/src/feature/shared_widgets/bottom_sheet/digital_avatar.dart';
import 'package:dlchat/src/feature/shared_widgets/common/plus_description_tile.dart';
import 'package:flutter/material.dart';

Future<void> showChangeLogModal(BuildContext context) =>
    showDigitalAvatarBottomSheet(context: context, builder: (context) => const ChatInfoBottomSheet());

class const ChatInfoBottomSheet({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Column(
        spacing: 8,
        children: [
          Text('Встречайте обновление!', style: AppTypography.bodySemibold),
          SizedBox(height: 8),
          PlusDescriptionTile(
            title: 'Транскрибация видео',
            description: 'Теперь можно транскрибировать видео по ссылкам с Яндекс Диска и Google Drive!',
          ),
          PlusDescriptionTile(
            title: 'Работа с файлами',
            description: 'Прикрепляйте и анализируйте документы и таблицы прямо в чате',
          ),
          PlusDescriptionTile(
            title: 'Улучшили чат изображений',
            description: 'Повысили качество генерации, а просмотр изображений стал удобнее',
          ),
          PlusDescriptionTile(
            title: 'Обновленный нyтрициолог',
            description: 'Цифровой помощник теперь начинает работу с интерактивной анкеты',
          ),
          PlusDescriptionTile(
            title: 'Оптимизация и скорость',
            description: 'Поработали над быстродействием приложения и повысили стабильность',
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
