import 'package:meta/meta.dart';
import 'package:rest_client/transcriptions/dto/transcription_dto.dart';

@immutable
class const TranscriptionData({
  required final String id,
  required final String name,
  required final TranscriptionStatus status,
  required final DateTime createdAt,
  final String? content,
}) {
  factory decode(TranscriptionDto dto) => TranscriptionData(
    id: dto.id,
    name: dto.name,
    status: TranscriptionStatus.decode(dto.status),
    createdAt: dto.createdAt,
    content: dto.content,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TranscriptionData &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          status == other.status &&
          createdAt == other.createdAt &&
          content == other.content;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ status.hashCode ^ createdAt.hashCode ^ content.hashCode;

  TranscriptionData copyWith({String? name, TranscriptionStatus? status, DateTime? createdAt, String? content}) =>
      TranscriptionData(
        id: id,
        name: name ?? this.name,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        content: content ?? this.content,
      );
}

enum TranscriptionStatus(final String json) {
  inProgress('IN_PROGRESS'),
  finished('FINISHED'),
  failed('FAILED');

  factory decode(String data) =>
      TranscriptionStatus.values.firstWhere((e) => e.json == data, orElse: () => TranscriptionStatus.failed);
}
