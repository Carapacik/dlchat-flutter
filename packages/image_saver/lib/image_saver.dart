import 'package:image_saver/image_saver_platform_interface.dart';

class ImageSaver() {
  Future<void> addImageToGallery(String imagePath) async {
    await ImageSaverPlatform.instance.addImageToGallery(imagePath);
  }
}
