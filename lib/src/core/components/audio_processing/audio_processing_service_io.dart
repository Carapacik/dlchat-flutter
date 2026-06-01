import 'dart:developer' show log;
import 'dart:io';

import 'package:dlchat/src/core/exception/exception_handler.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class AudioProcessingService() {
  Future<String?> extractAudioFromVideo(String inputVideoPath) async {
    if (Platform.isWindows || Platform.isLinux) {
      // For windows and linux ffmpeg not working
      return null;
    }
    final Directory directory = await getTemporaryDirectory();
    final outputFileName = 'audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
    final String outputFilePath = p.join(directory.path, outputFileName);

    log('AudioProcessingService START');
    final FFmpegSession session = await FFmpegKit.execute('-i $inputVideoPath -map a $outputFilePath');

    final ReturnCode? returnCode = await session.getReturnCode();
    if (ReturnCode.isSuccess(returnCode)) {
      // SUCCESS
      log('AudioProcessingService SUCCESS');
      return outputFilePath;
    } else if (ReturnCode.isCancel(returnCode)) {
      // CANCEL
      log('AudioProcessingService CANCEL');
      return null;
    } else {
      // ERROR
      log('AudioProcessingService ERROR');
      Error.throwWithStackTrace(const AppException.unknown('Ошибка отделения аудио от видео'), StackTrace.current);
    }
  }
}
