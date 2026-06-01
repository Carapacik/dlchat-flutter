import 'dart:async' show StreamSubscription, Timer;
import 'dart:io';

import 'package:dlchat/src/core/components/record_voice/record_voice_service_io.dart'
    if (dart.library.js_interop) 'package:dlchat/src/core/components/record_voice/record_voice_service_web.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier, kIsWeb;
import 'package:record/record.dart';

class RecordVoiceService() with ChangeNotifier {
  this : _audioRecorder = AudioRecorder() {
    _recordSub = _audioRecorder.onStateChanged().listen(_updateRecordState);
  }

  final AudioRecorder _audioRecorder;
  StreamSubscription<RecordState>? _recordSub;
  Timer? _timer;

  int recordDuration = 0;
  RecordState recordState = RecordState.stop;

  @override
  Future<void> dispose() async {
    _timer?.cancel();
    await _recordSub?.cancel();
    await _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> start() async {
    try {
      final bool hasPermission = await _audioRecorder.hasPermission();
      if (!hasPermission) {
        // нет разрешений
        return;
      }
      final AudioEncoder encoder = kIsWeb || Platform.isWindows || Platform.isMacOS
          ? AudioEncoder.wav
          : AudioEncoder.aacLc;
      final config = RecordConfig(encoder: encoder, numChannels: 1);

      await recordFile(_audioRecorder, config);

      recordDuration = 0;
      _startTimer();
    } on Object {
      //
    }
  }

  Future<void> pause() => _audioRecorder.pause();

  Future<void> resume() => _audioRecorder.resume();

  Future<void> cancel() async {
    _timer?.cancel();
    await _audioRecorder.cancel();
  }

  Future<String?> stop() async {
    final String? path = await _audioRecorder.stop();
    return path;
  }

  void _updateRecordState(RecordState newRecordState) {
    recordState = newRecordState;
    switch (recordState) {
      case RecordState.pause:
        _timer?.cancel();
      case RecordState.record:
        _startTimer();
      case RecordState.stop:
        _timer?.cancel();
        recordDuration = 0;
    }
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      recordDuration++;
      notifyListeners();
    });
  }
}
