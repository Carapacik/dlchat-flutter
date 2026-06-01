import 'package:dlchat/src/core/constant/generated/assets.gen.dart';
import 'package:dlchat/src/core/resources/resources.dart';
import 'package:dlchat/src/feature/shared_widgets/modal/dialog.dart';
import 'package:dlchat/src/feature/transcription/model/transcription_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Future<String?> showTranscriptionByLinkDialog({required BuildContext context}) =>
    showCustomDialog(context: context, title: 'Укажите ссылку', builder: (context) => const _TranscriptionByLink());

class const _TranscriptionByLink() extends StatefulWidget {
  @override
  State<_TranscriptionByLink> createState() => _TranscriptionByLinkState();
}

class _TranscriptionByLinkState() extends State<_TranscriptionByLink> {
  late final TextEditingController _linkController = TextEditingController();
  late final _linkError = ValueNotifier<String?>(null);

  late final List<String? Function(String data)> _validators = [(data) => _linkError.value = data.isValidLink(context)];

  @override
  void dispose() {
    _linkError.dispose();
    _linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(44)),
      borderSide: BorderSide(color: AppColors.bgInputPrimary),
    );
    const errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(44)),
      borderSide: BorderSide(color: AppColors.inputError),
    );
    final List<TranscriptionContent> allowedServices = [
      TranscriptionContent.yandexDisk,
      TranscriptionContent.googleDrive,
      TranscriptionContent.youtube,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('Поддерживаемые сервисы: ', style: AppTypography.bodyRegular),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 26,
          child: ListView.separated(
            primary: false,
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemBuilder: (context, index) => Image.asset(
              switch (allowedServices[index]) {
                TranscriptionContent.youtube => Assets.image.youtube.path,
                TranscriptionContent.rutube => Assets.image.rutube.path,
                TranscriptionContent.googleDrive => Assets.image.googleDrive.path,
                TranscriptionContent.yandexDisk => Assets.image.yandexDisk.path,
                TranscriptionContent.zoom => Assets.image.zoom.path,
              },
              height: 26,
              width: 26,
            ),
            separatorBuilder: (context, index) => const SizedBox(width: 24),
            itemCount: allowedServices.length,
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ValueListenableBuilder(
            valueListenable: _linkError,
            builder: (context, value, child) {
              return TextField(
                controller: _linkController,
                decoration: InputDecoration(
                  fillColor: AppColors.bgInputPrimary,
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  border: outlineInputBorder,
                  enabledBorder: outlineInputBorder,
                  focusedBorder: outlineInputBorder,
                  errorBorder: errorBorder,
                  focusedErrorBorder: outlineInputBorder,
                  disabledBorder: outlineInputBorder,
                  errorText: value,
                  errorStyle: AppTypography.bodyRegular.copyWith(color: AppColors.inputError),
                  suffixIcon: value == null ? null : SvgPicture.asset(Assets.svg.errorIcon.path, height: 20, width: 20),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        const Divider(thickness: 1, height: 1, color: AppColors.iconSecondary),
        DialogActionButton(actionText: 'Готово', onActionTap: () => _onSubmitted(context)),
      ],
    );
  }

  bool _validate(BuildContext context, String data) {
    var result = true;
    for (final String? Function(String data) validator in _validators) {
      final String? validMessage = validator(data);
      if (validMessage != null) {
        result = false;
      }
    }
    return result;
  }

  void _onSubmitted(BuildContext context) {
    final String link = _linkController.text.trim();
    if (!_validate(context, link)) {
      return;
    }
    Navigator.of(context).pop(link);
  }
}

extension on String {
  String? isValidLink(BuildContext context) {
    if (trim().isEmpty) {
      return 'Ссылка не может быть пустой';
    }
    return null;
  }
}
