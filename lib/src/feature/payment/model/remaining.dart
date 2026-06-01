import 'package:meta/meta.dart';
import 'package:rest_client/subscription/dto/remaining_request_dto.dart';

@immutable
class const RemainingRequests({
  required final int requests,
  required final int images,
  required final int transcriptionSeconds,
}) {
  factory decode(RemainingRequestDto dto) => RemainingRequests(
    requests: dto.remainingOfRequests,
    images: dto.remainingOfImages,
    transcriptionSeconds: dto.remainingTranscriptionSeconds,
  );

  RemainingRequests copyWith({int? requests, int? images, int? transcriptionSeconds}) {
    return RemainingRequests(
      requests: requests ?? this.requests,
      images: images ?? this.images,
      transcriptionSeconds: transcriptionSeconds ?? this.transcriptionSeconds,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RemainingRequests &&
          runtimeType == other.runtimeType &&
          requests == other.requests &&
          images == other.images &&
          transcriptionSeconds == other.transcriptionSeconds;

  @override
  int get hashCode => requests.hashCode ^ images.hashCode ^ transcriptionSeconds.hashCode;

  @override
  String toString() =>
      'RemainingRequests(requests: $requests, images: $images, transcriptionSeconds: $transcriptionSeconds)';
}
