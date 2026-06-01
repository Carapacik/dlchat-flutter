import 'package:image_saver/image_saver_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

abstract class ImageSaverPlatform() extends PlatformInterface {
  /// Constructs a ImageSaverPlatform.
  this : super(token: _token);

  static final _token = Object();

  static ImageSaverPlatform _instance = MethodChannelImageSaver();

  /// The default instance of [ImageSaverPlatform] to use.
  ///
  /// Defaults to [MethodChannelImageSaver].
  static ImageSaverPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ImageSaverPlatform] when
  /// they register themselves.
  static set instance(ImageSaverPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> addImageToGallery(String imagePath) {
    throw UnimplementedError('addImageToGallery() has not been implemented.');
  }
}
