import 'package:cross_file/cross_file.dart';
import 'package:dlchat/src/feature/transcription/model/transcription_data.dart';
import 'package:dlchat/src/feature/transcription/model/transcription_message.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:rest_client/file/file_client.dart';
import 'package:rest_client/transcriptions/transcriptions_client.dart';

abstract interface class ITranscriptionsRepository() {
  Future<List<TranscriptionData>> getTranscriptions({int offset = 0, int limit = 30});

  Future<List<TranscriptionMessage>> getTranscriptionMessages({
    required String transcriptionId,
    int limit = 20,
    int offset = 0,
  });

  Future<void> createTranscription({XFile? file, String? url, void Function(double)? onProgress});
}

class const TranscriptionsRepository({
  required final TranscriptionsClient _transcriptionsClient,
  required final SendFileClient _sendFileClient,
}) implements ITranscriptionsRepository {
  @override
  Future<List<TranscriptionData>> getTranscriptions({int offset = 0, int limit = 30}) => _transcriptionsClient
      .getTranscriptions(offset: offset, limit: limit)
      .then((dto) => dto.result.transcriptions.map(TranscriptionData.decode).toList());

  @override
  Future<void> createTranscription({XFile? file, String? url, void Function(double)? onProgress}) {
    if (url != null) {
      return _transcriptionsClient.createTranscription(
        url: url,
        onSendProgress: onProgress != null ? (sent, total) => onProgress(total > 0 ? sent / total : 0) : null,
      );
    } else if (file != null) {
      return _sendFileClient.createTranscription(
        file: file,
        useBytes: kIsWeb,
        onSendProgress: onProgress != null ? (sent, total) => onProgress(total > 0 ? sent / total : 0) : null,
      );
    }
    throw ArgumentError('Either url or file must be provided');
  }

  @override
  Future<List<TranscriptionMessage>> getTranscriptionMessages({
    required String transcriptionId,
    int limit = 20,
    int offset = 0,
  }) => _transcriptionsClient
      .getTranscriptionMessages(transcriptionId: transcriptionId, limit: limit, offset: offset)
      .then((dto) => dto.result.messages.map(TranscriptionMessage.decode).toList());
}
