package com.example.opencamera

import android.app.Activity
import android.content.ContentResolver
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.net.Uri
import android.os.Environment
import android.provider.MediaStore
import android.util.Log
import android.widget.Toast
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import java.io.File
import java.io.FileOutputStream
import java.io.IOException


class OpencameraPlugin: FlutterPlugin, MethodCallHandler, ActivityAware,
  PluginRegistry.ActivityResultListener {

  private lateinit var channel : MethodChannel
  private lateinit var resultOfCamera: Result

  private lateinit var context : Context
  private lateinit var activity: Activity

  private val openCameraCode = 123

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "opencamera")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext

  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when(call.method){
      "getPlatformVersion" -> getPlatformVersion(result)
      "capturePhoto" -> capturePhoto(result)
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun getPlatformVersion(result: Result) {
    result.success("Android ${android.os.Build.VERSION.RELEASE}")
  }

  private fun capturePhoto(result: Result) {
    this.resultOfCamera = result
    Toast.makeText(context, "capture photo called", Toast.LENGTH_SHORT).show()
    val cameraIntent = Intent(MediaStore.ACTION_IMAGE_CAPTURE)
    activity.startActivityForResult(cameraIntent, openCameraCode)
  }


  override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
    /*if (requestCode == openCameraCode) {
      if (resultCode == Activity.RESULT_OK) {
        if (data != null) {
          val photo: Bitmap = data.extras?.get("data") as Bitmap
          Log.d("CAPTURED_IMAGE PATH", "image bitmap = $photo")
          resultOfCamera.success("name.jpg")
         return true
        }
      }
    }*/

    if (requestCode == openCameraCode) {
      if (resultCode == Activity.RESULT_OK) {
        if (data != null) {
          val bitmap: Bitmap = data.extras?.get("data") as Bitmap
          val imagePath = saveBitmapToStorage(bitmap)
          if (imagePath != null) {
            resultOfCamera.success(imagePath)
          } else {
            resultOfCamera.error("FILE_SAVE_ERROR", "Failed to save the photo", null)
          }
        } else {
          resultOfCamera.error("URI_ERROR", "Failed to get the photo URI", null)
        }
      } else {
        resultOfCamera.error("CAPTURE_ERROR", "Photo capture failed", null)
      }
    }
    return false
  }





  // Method to save the Bitmap to external storage and return the file path
  private fun saveBitmapToStorage(bitmap: Bitmap): String? {
    val storageDir = activity.getExternalFilesDir(Environment.DIRECTORY_PICTURES)
    val imagesDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES)
    if (!imagesDir.exists()) imagesDir.mkdirs()

    Log.d("STORAGE_DIRECTORY","storageDir = $storageDir")
    Log.d("STORAGE_DIRECTORY","imagesDir = $imagesDir")



    return try {
      val imageFileName = "IMG_${System.currentTimeMillis()}.jpg"
      val imageFile = File(imagesDir, imageFileName)
      FileOutputStream(imageFile).use { out ->
        bitmap.compress(Bitmap.CompressFormat.JPEG, 100, out)
      }
      imageFile.absolutePath
    } catch (ex: IOException) {
      null
    }
  }



  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
    binding.addActivityResultListener(this)
  }
  override fun onDetachedFromActivityForConfigChanges() {}
  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {}
  override fun onDetachedFromActivity() {}


}
