import 'dart:js_interop';
import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';
import 'package:web/web.dart' as web;

class FileSaveService() {
  Future<void> saveImageFromUrl(String imageUrl) async {
    final http.Response response = await http.get(Uri.parse(imageUrl));
    if (response.statusCode != 200) {
      throw Exception('Проблема получения изображения');
    }
    final Uint8List bytes = response.bodyBytes;
    final file = XFile.fromData(bytes);
    final String extension = p.extension(file.path);
    final String mimeType = switch (extension) {
      '.png' => 'image/png',
      '.webp' => 'image/webp',
      _ => 'image/jpeg',
    };
    final blobWeb = web.Blob(<JSUint8Array>[Uint8List.fromList(bytes).toJS].toJS, web.BlobPropertyBag(type: mimeType));
    final String url = web.URL.createObjectURL(blobWeb);
    final String fileName = const Uuid().v4() + extension;
    final anchor = web.document.createElement('a') as web.HTMLAnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = fileName;
    web.document.body!.add(anchor);
    anchor
      ..click()
      ..remove();
  }
}
