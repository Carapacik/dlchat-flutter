import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:image_saver/image_saver_platform_interface.dart';

/// An implementation of [ImageSaverPlatform] that uses method channels.
class MethodChannelImageSaver() extends ImageSaverPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('image_saver');

  @override
  Future<void> addImageToGallery(String imagePath) async {
    await methodChannel.invokeMethod('addImageToGallery', {'imagePath': imagePath});
  }
}
