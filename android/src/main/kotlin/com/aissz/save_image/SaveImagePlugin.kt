package com.aissz.save_image

import android.content.Context
import android.content.Intent
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Environment
import android.provider.MediaStore
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.io.File
import java.io.FileOutputStream
import java.io.IOException


public class SaveImagePlugin: FlutterPlugin, MethodCallHandler {
  private var applicationContext: Context? = null
  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    applicationContext = flutterPluginBinding.applicationContext
    val channel = MethodChannel(flutterPluginBinding.binaryMessenger, "aissz.com/save_image")
    channel.setMethodCallHandler(SaveImagePlugin())
  }

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "aissz.com/save_image")
      channel.setMethodCallHandler(SaveImagePlugin())
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
        "saveImageToGallery" -> {
          val image = call.argument<ByteArray>("imageBytes") as ByteArray
          result.success(saveImageToGallery(BitmapFactory.decodeByteArray(image,0,image.size)))
        }
        "saveFileToGallery" -> {
          val path = call.arguments as String
          result.success(saveFileToGallery(path))
        }
        else -> result.notImplemented()
    }

  }

  private fun generateFile(extension: String = ""): File {
    val storePath =  Environment.getExternalStorageDirectory().absolutePath + File.separator + getApplicationName()
    val appDir = File(storePath)
    if (!appDir.exists()) {
      appDir.mkdir()
    }
    var fileName = System.currentTimeMillis().toString()
    if (extension.isNotEmpty()) {
      fileName += (".$extension")
    }
    return File(appDir, fileName)
  }

  private fun saveImageToGallery(bmp: Bitmap): String {
    try {
    val context = applicationContext
    val file = generateFile("png")
      val fos = FileOutputStream(file)
      bmp.compress(Bitmap.CompressFormat.PNG, 60, fos)
      fos.flush()
      fos.close()
      val uri = Uri.fromFile(file)
      MediaStore.Images.Media.insertImage(context?.contentResolver, bmp, "", "")
      context?.sendBroadcast(Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE, uri))
      return uri.toString()
    } catch (e: IOException) {
      e.printStackTrace()
    }
    return ""
  }

  private fun saveFileToGallery(filePath: String): String {
    val context = applicationContext ?: return ""
    return try {
      val originalFile = File(filePath)
      val file = generateFile(originalFile.extension)
      originalFile.copyTo(file)

      val uri = Uri.fromFile(file)
      context.sendBroadcast(Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE, uri))
      return uri.toString()
    } catch (e: IOException) {
      e.printStackTrace()
      ""
    }
  }
  private fun getApplicationName(): String {
    val context = applicationContext ?: return ""
    var ai: ApplicationInfo? = null
    try {
      ai = context.packageManager?.getApplicationInfo(context.packageName, 0)
    } catch (e: PackageManager.NameNotFoundException) {
    }
    val appName: String
    appName = if (ai != null) {
      val charSequence = context.packageManager?.getApplicationLabel(ai)
      StringBuilder(charSequence!!.length).append(charSequence).toString()
    } else {
      ""
    }
    return  appName
  }

}