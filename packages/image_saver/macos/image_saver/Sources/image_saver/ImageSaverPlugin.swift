import Cocoa
import FlutterMacOS

public class ImageSaverPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "image_saver", binaryMessenger: registrar.messenger)
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
              saveImageToDownloads(imagePath: imagePath, result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func saveImageToDownloads(imagePath: String, result: @escaping FlutterResult) {
      let fileManager = FileManager.default
      let downloadsDirectory = fileManager.urls(for: .downloadsDirectory, in: .userDomainMask).first!

      let fileName = URL(fileURLWithPath: imagePath).lastPathComponent
      let destinationURL = downloadsDirectory.appendingPathComponent(fileName)

      do {
        if fileManager.fileExists(atPath: destinationURL.path) {
          try fileManager.removeItem(at: destinationURL)
        }
        try fileManager.copyItem(at: URL(fileURLWithPath: imagePath), to: destinationURL)
            result("Successfully saved image to Download")
      } catch {
        result(FlutterError(code: "FILE_SAVE_ERROR", message: "Failed to save image to Downloads", details: error.localizedDescription))
      }
    }
}
