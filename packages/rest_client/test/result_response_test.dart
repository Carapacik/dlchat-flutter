import 'package:rest_client/auth/dto/token_dto.dart';
import 'package:rest_client/chat/dto/chat_messages_dto.dart';
import 'package:rest_client/chat/dto/message_type_dto.dart';
import 'package:rest_client/result_response.dart';
import 'package:test/test.dart';

void main() {
  test('decodes authentication tokens and preserves response metadata', () {
    final response = ResultResponse<TokenDto>.fromJson({
      'result': {'accessToken': 'access', 'refreshToken': 'refresh'},
      'message': 'ok',
      'errorCode': null,
    });

    expect(response.result.accessToken, 'access');
    expect(response.result.refreshToken, 'refresh');
    expect(response.result.toJson(), {'accessToken': 'access', 'refreshToken': 'refresh'});
    expect(response.message, 'ok');
    expect(response.errorCode, isNull);
  });

  test('decodes nested chat messages with their types and optional fields', () {
    final response = ResultResponse<ChatMessagesDto>.fromJson({
      'result': {
        'messages': [
          {'id': '1', 'text': 'Hello', 'type': 'USER', 'links': <Object?>[], 'file': 'note.txt'},
          {'id': '2', 'text': 'Hi!', 'type': 'ASSISTANT', 'links': <Object?>[]},
        ],
      },
      'message': 'ok',
      'errorCode': 0,
    });

    expect(response.result.messages.map((message) => message.id), ['1', '2']);
    expect(response.result.messages.first.type, MessageTypeDto.user);
    expect(response.result.messages.first.file, 'note.txt');
    expect(response.result.messages.last.type, MessageTypeDto.assistant);
    expect(response.result.messages.last.file, isNull);
    expect(ChatMessagesDto.fromJson(response.result.toJson()).messages.last.text, 'Hi!');
    expect(response.errorCode, 0);
  });

  test('preserves primitive and nullable results', () {
    expect(const ResultResponseConverter<bool>().fromJson(true), isTrue);
    expect(const ResultResponseConverter<int>().fromJson(42), 42);
    expect(const ResultResponseConverter<String?>().fromJson(null), isNull);
  });

  test('rejects unsupported object responses', () {
    expect(() => const ResultResponseConverter<DateTime>().fromJson(<String, dynamic>{}), throwsUnsupportedError);
  });
}
