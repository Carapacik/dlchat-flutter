import 'dart:async';

import 'package:dlchat/src/core/components/record_voice/record_voice_service.dart';
import 'package:dlchat/src/core/constant/generated/assets.gen.dart';
import 'package:dlchat/src/core/resources/resources.dart';
import 'package:dlchat/src/feature/shared_widgets/button/circle_icon_button.dart';
import 'package:dlchat/src/feature/shared_widgets/modal/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:record/record.dart';

Future<String?> showRecordVoice(BuildContext context, RecordVoiceService recordVoiceService) async =>
    await showCustomModalBottomSheet(
      context: context,
      builder: (context) => _Body(recordVoiceService: recordVoiceService),
    );

class const _Body({required final RecordVoiceService recordVoiceService}) extends StatefulWidget {
  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState() extends State<_Body> {
  @override
  void initState() {
    super.initState();
    unawaited(widget.recordVoiceService.start());
  }

  String _formatSecondsToTimer(BuildContext context, int seconds) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final String twoDigitHours = twoDigits(seconds.remainder(3600 * 24) ~/ (60 * 60));
    final String twoDigitMinutes = twoDigits(seconds.remainder(3600) ~/ 60);
    final String twoDigitSeconds = twoDigits(seconds.remainder(60));
    return '${twoDigitHours != '00' ? twoDigitHours : ''}$twoDigitMinutes:$twoDigitSeconds';
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.recordVoiceService,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Аудиозапись', style: AppTypography.bodySemibold),
            const SizedBox(height: 24),
            Center(
              child: Text(
                _formatSecondsToTimer(context, widget.recordVoiceService.recordDuration),
                style: AppTypography.headerMedium.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.recordVoiceService.recordState == RecordState.record)
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: CircleIconButton(
                        onPressed: () async {
                          final NavigatorState navigator = Navigator.of(context);
                          await widget.recordVoiceService.cancel();
                          navigator.pop('CANCEL');
                        },
                        icon: SvgPicture.asset(
                          Assets.svg.trashFull.path,
                          height: 24,
                          width: 24,
                          colorFilter: const ColorFilter.mode(AppColors.inputError, BlendMode.srcIn),
                        ),
                      ),
                    ),
                  _RecordVoiceButton(
                    onTap: () async {
                      switch (widget.recordVoiceService.recordState) {
                        case RecordState.pause:
                          await widget.recordVoiceService.resume();
                        case RecordState.record:
                          Navigator.of(context).pop('STOP');
                        case RecordState.stop:
                      }
                    },
                    isRecording: widget.recordVoiceService.recordState == RecordState.record,
                  ),
                  if (widget.recordVoiceService.recordState == RecordState.record)
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: CircleIconButton(
                        onPressed: () async {
                          await widget.recordVoiceService.pause();
                        },
                        icon: SvgPicture.asset(
                          Assets.svg.circlePause.path,
                          height: 24,
                          width: 24,
                          colorFilter: const ColorFilter.mode(AppColors.iconPrimary, BlendMode.srcIn),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class const _RecordVoiceButton({required final VoidCallback onTap, required final bool isRecording})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 56,
      child: Material(
        shape: const CircleBorder(side: BorderSide(color: AppColors.iconPrimary, width: 1.5)),
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: isRecording
                ? SizedBox.square(
                    dimension: 20,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: AppColors.inputError, borderRadius: BorderRadius.circular(4)),
                    ),
                  )
                : const Icon(Icons.play_arrow, color: AppColors.inputError, size: 36),
          ),
        ),
      ),
    );
  }
}
