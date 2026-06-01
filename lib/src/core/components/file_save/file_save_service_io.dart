import 'dart:io';
import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_saver/image_saver.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class FileSaveService() {
  Future<void> saveImageFromUrl(String imageUrl) async {
    final File cachedFile = await DefaultCacheManager().getSingleFile(imageUrl);
    final file = XFile(cachedFile.path);
    // save to downloads
    if (Platform.isMacOS || Platform.isWindows) {
      final Directory? directory = await getDownloadsDirectory();
      if (directory == null) {
        throw Exception('Нет доступа к загрузкам');
      }
      final String extension = p.extension(file.path);
      final String filePath = p.join(directory.path, const Uuid().v4(), extension);
      final File createdFile = await File(filePath).create(recursive: true);
      final Uint8List bytes = await file.readAsBytes();
      await createdFile.writeAsBytes(bytes);
      return;
    }
    // save to gallery
    if (Platform.isAndroid || Platform.isIOS) {
      final imageSaver = ImageSaver();
      await imageSaver.addImageToGallery(file.path);
      return;
    }
  }
}
