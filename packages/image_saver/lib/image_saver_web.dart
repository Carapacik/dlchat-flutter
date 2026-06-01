import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:image_saver/image_saver_platform_interface.dart';

/// A web implementation of the ImageSaverPlatform of the ImageSaver plugin.
class ImageSaverWeb() extends ImageSaverPlatform {
  /// Constructs a ImageSaverWeb
  this;

  static void registerWith(Registrar registrar) {
    ImageSaverPlatform.instance = ImageSaverWeb();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<void> addImageToGallery(String imagePath) async {}
}
