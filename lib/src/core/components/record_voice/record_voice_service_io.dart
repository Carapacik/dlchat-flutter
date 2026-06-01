import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart' show AudioRecorder, RecordConfig;

Future<void> recordFile(AudioRecorder recorder, RecordConfig config) async {
  final Directory directory = await getTemporaryDirectory();
  final String path = p.join(
    directory.path,
    'audio_${DateTime.now().millisecondsSinceEpoch}.${Platform.isWindows || Platform.isMacOS ? 'wav' : 'm4a'}',
  );

  await recorder.start(config, path: path);
}
