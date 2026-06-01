import 'dart:async';

import 'package:record/record.dart';

Future<void> recordFile(AudioRecorder recorder, RecordConfig config) async {
  await recorder.start(config, path: '');
}
