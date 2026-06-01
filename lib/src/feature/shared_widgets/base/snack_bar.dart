import 'package:dlchat/src/core/constant/generated/assets.gen.dart';
import 'package:dlchat/src/core/exception/exception_handler.dart';
import 'package:dlchat/src/core/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

OverlayEntry? _currentOverlay;
Widget? _currentSnackBarWidget;
double? _currentProgress;
StateSetter? _setState;

void hideCurrentSnackBar() {
  _currentOverlay?.remove();
  _currentOverlay = null;
  _currentSnackBarWidget = null;
  _currentProgress = null;
  _setState = null;
}

void showSuccessMessage(BuildContext context, String title, [String? description]) =>
    _baseTopSnack(context, title: title, description: description, iconPath: Assets.svg.tickSquare.path);

void showInfoMessage(BuildContext context, String title, [String? description]) =>
    _baseTopSnack(context, title: title, description: description, iconPath: Assets.svg.infoCircle.path);

void showErrorMessage(BuildContext context, String title, [String? description]) =>
    _baseTopSnack(context, title: title, description: description, iconPath: Assets.svg.closeSquare.path);

void showCustomAppException(BuildContext context, AppException exception, [String? customTitle]) => _baseTopSnack(
  context,
  title: exception.map(
    network: (e) => e.networkType?.localizedText(context) ?? exception.message,
    unknown: (e) => customTitle ?? exception.message,
  ),
  iconPath: Assets.svg.closeSquare.path,
);

void showExtractionProgress(BuildContext context) {
  _baseTopSnack(
    context,
    title: 'Обработка видео',
    description: 'Не закрывайте приложение',
    iconPath: Assets.svg.infoCircle.path,
    showProgress: true,
  );
}

void showUploadProgress(BuildContext context, double progress) {
  if (progress >= 1.0) {
    hideCurrentSnackBar();
    return;
  }

  if (_currentProgress == null) {
    _baseTopSnack(
      context,
      title: 'Загрузка файла',
      description: 'Не закрывайте приложение',
      iconPath: Assets.svg.infoCircle.path,
      showProgress: true,
      progress: progress,
    );
  } else {
    _currentProgress = progress;
    if (context.mounted) {
      _setState?.call(() {});
    }
  }
  _currentProgress = progress;
}

void _baseTopSnack(
  BuildContext context, {
  required String title,
  required String iconPath,
  Color? iconColor,
  String? description,
  bool showProgress = false,
  double? progress,
}) {
  hideCurrentSnackBar();
  _currentSnackBarWidget = StatefulBuilder(
    builder: (context, setState) {
      _setState = setState;
      return _SnackBarContent(
        title: title,
        iconPath: iconPath,
        iconColor: iconColor,
        description: description,
        showProgress: showProgress,
        progress: _currentProgress,
      );
    },
  );

  final overlay = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.paddingOf(context).top + 8,
      left: 16,
      right: 16,
      child: Material(color: Colors.transparent, child: _currentSnackBarWidget),
    ),
  );

  Overlay.of(context).insert(overlay);
  _currentOverlay = overlay;

  if (!showProgress) {
    Future.delayed(const Duration(seconds: 3), hideCurrentSnackBar);
  }
}

class const _SnackBarContent({
  required final String title,
  required final String iconPath,
  final Color? iconColor,
  final String? description,
  final bool showProgress = false,
  final double? progress,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: Material(
        color: AppColors.gray800,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    iconPath,
                    height: 20,
                    width: 20,
                    colorFilter: iconColor == null ? null : ColorFilter.mode(iconColor!, BlendMode.srcIn),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: AppTypography.bodyMediumBulleted.copyWith(color: AppColors.white)),
                        if (description != null)
                          Text(description!, style: AppTypography.bodyRegular.copyWith(color: AppColors.white)),
                      ],
                    ),
                  ),
                ],
              ),
              if (showProgress) ...[
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.bgSecondary,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.pink1),
                  borderRadius: BorderRadius.circular(100),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
