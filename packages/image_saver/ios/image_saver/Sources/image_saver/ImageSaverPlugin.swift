import Flutter
import UIKit
import Photos

public class ImageSaverPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "image_saver", binaryMessenger: registrar.messenger())
    let instance = ImageSaverPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
        case "addImageToGallery":
          guard let args = call.arguments as? [String: String], let imagePath = args["imagePath"] else {
            result(FlutterError(code: "INVALID_ARGUMENT", message: "Image path is missing", details: nil))
            return
          }
          saveImageToPhotos(imagePath: imagePath, result: result)
        default:
          result(FlutterMethodNotImplemented)
        }
      }

      func saveImageToPhotos(imagePath: String, result: @escaping FlutterResult) {
        // Load image from the file path
        guard let image = UIImage(contentsOfFile: imagePath) else {
          result(FlutterError(code: "IMAGE_LOAD_ERROR", message: "Failed to load image from path", details: nil))
          return
        }

        // Check authorization status
        PHPhotoLibrary.requestAuthorization { status in
          switch status {
          case .authorized:
            // Save image to the photo library
            self.saveImage(image, result: result)
          case .denied, .restricted, .notDetermined, .limited:
            // Handle the case where authorization is not granted
            result(FlutterError(code: "AUTHORIZATION_ERROR", message: "Authorization status is not authorized", details: nil))
          @unknown default:
            result(FlutterError(code: "UNKNOWN_ERROR", message: "Unknown authorization status", details: nil))
          }
        }
      }

      func saveImage(_ image: UIImage, result: @escaping FlutterResult) {
        PHPhotoLibrary.shared().performChanges({
          // Create a new asset in the photo library
          PHAssetCreationRequest.creationRequestForAsset(from: image)
        }) { success, error in
          if success {
            result("Successfully saved image to Photos")
          } else if let error = error {
            result(FlutterError(code: "SAVE_ERROR", message: "Error saving image to Photos", details: error.localizedDescription))
          }
        }
      }
}
