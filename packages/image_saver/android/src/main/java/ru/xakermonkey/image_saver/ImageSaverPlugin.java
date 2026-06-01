package ru.xakermonkey.image_saver;

import android.content.ContentValues;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.media.MediaScannerConnection;
import android.net.Uri;
import android.os.Environment;
import android.provider.MediaStore;
import android.util.Log;

import androidx.annotation.NonNull;

import java.io.File;
import java.io.IOException;
import java.io.OutputStream;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * ImageSaverPlugin
 */
public class ImageSaverPlugin implements FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private static final String TAG = "ImageSaver";

    private MethodChannel channel;
    private Context context;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        context = flutterPluginBinding.getApplicationContext();
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "image_saver");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("addImageToGallery")) {
            String imagePath = call.argument("imagePath");
            addImageToGallery(context, imagePath);
            result.success(null);
        } else {
            result.notImplemented();
        }
    }

    private void addImageToGallery(Context context, String imagePath) {
        File internalFile = new File(imagePath);
        Bitmap bitmap = BitmapFactory.decodeFile(internalFile.getAbsolutePath());
        if (bitmap == null) {
            Log.e(TAG, "Failed to decode image file");
            return;
        }

        String imageName = internalFile.getName();
        ContentValues values = new ContentValues();
        values.put(MediaStore.Images.Media.DISPLAY_NAME, imageName);
        values.put(MediaStore.Images.Media.MIME_TYPE, "image/png");
        values.put(MediaStore.Images.Media.RELATIVE_PATH, Environment.DIRECTORY_PICTURES);


        Uri uri = context.getContentResolver().insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values);
        if (uri != null) {
            try (OutputStream fos = context.getContentResolver().openOutputStream(uri)) {
                if (fos != null) {
                    bitmap.compress(Bitmap.CompressFormat.PNG, 100, fos);
                    fos.flush();
                }

                MediaScannerConnection.scanFile(
                        context,
                        new String[]{imagePath},
                        new String[]{"image/png"},
                        (path, uriResult) -> Log.d(TAG, "Scanned " + path + ": " + uriResult)
                );

                Log.d(TAG, "Image saved to gallery successfully.");
            } catch (IOException e) {
                Log.e(TAG, "Failed to save image to gallery", e);
            }
        } else {
            Log.e(TAG, "Failed to get Uri for image");
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }
}
