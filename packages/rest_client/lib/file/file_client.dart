import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:dio/dio.dart';
import 'package:rest_client/chat/dto/chat_message_dto.dart';
import 'package:rest_client/result_response.dart';

abstract class SendFileClient {
  factory(Dio dio, {String? baseUrl}) = _SendFileClient;

  Future<ResultResponse<ChatMessageDto>> sendMessage({
    required bool useBytes,
    required String chatId,
    bool isSearch = false,
    String? text,
    XFile? file,
    XFile? audio,
  });

  Future<void> createTranscription({required XFile file, required bool useBytes, ProgressCallback? onSendProgress});
}

class _SendFileClient(final Dio _dio, {var String? baseUrl}) implements SendFileClient {
  @override
  Future<ResultResponse<ChatMessageDto>> sendMessage({
    required bool useBytes,
    required String chatId,
    bool isSearch = false,
    String? text,
    XFile? file,
    XFile? audio,
  }) async {
    final data = FormData();
    if (text != null) {
      data.fields.add(MapEntry('text', text));
    }
    data.fields.add(MapEntry('isSearch', isSearch.toString()));
    MultipartFile? multipartFileF;
    MultipartFile? multipartFileA;
    if (useBytes && file != null) {
      final Uint8List bytes = await file.readAsBytes();
      multipartFileF = MultipartFile.fromBytes(bytes, filename: file.name);
    } else if (file != null) {
      multipartFileF = await MultipartFile.fromFile(file.path);
    }
    if (useBytes && audio != null) {
      final Uint8List bytes = await audio.readAsBytes();
      multipartFileA = MultipartFile.fromBytes(bytes, filename: audio.name);
    } else if (audio != null) {
      multipartFileA = await MultipartFile.fromFile(audio.path);
    }
    if (multipartFileF != null) {
      data.files.add(MapEntry('file', multipartFileF));
    }
    if (multipartFileA != null) {
      data.files.add(MapEntry('audio', multipartFileA));
    }
    final RequestOptions options = _setStreamType<ResultResponse<ChatMessageDto>>(
      Options(method: 'POST', contentType: 'multipart/form-data')
          .compose(_dio.options, '/v2/chats/$chatId/message', data: data)
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final Response<Map<String, dynamic>> result = await _dio.fetch<Map<String, dynamic>>(options);
    return ResultResponse<ChatMessageDto>.fromJson(result.data!);
  }

  @override
  Future<void> createTranscription({
    required bool useBytes,
    required XFile file,
    void Function(int, int)? onSendProgress,
  }) async {
    final data = FormData();
    MultipartFile multipartFile;
    if (useBytes) {
      final Uint8List bytes = await file.readAsBytes();
      multipartFile = MultipartFile.fromBytes(bytes, filename: file.name);
    } else {
      multipartFile = await MultipartFile.fromFile(file.path);
    }
    data.files.add(MapEntry('audio', multipartFile));
    final RequestOptions options = _setStreamType<void>(
      Options(method: 'POST', contentType: 'multipart/form-data')
          .compose(_dio.options, '/v1/transcriptions/', data: data, onSendProgress: onSendProgress)
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    await _dio.fetch<void>(options);
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes || requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(String dioBaseUrl, String? baseUrl) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final Uri url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
