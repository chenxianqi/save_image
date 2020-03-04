import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class SaveImage {
  /// channel
  static const MethodChannel _channel =
      const MethodChannel('aissz.com/save_image');

  /// save a image
  /// [imageBytes] Uint8List
  static Future<bool> save({@required Uint8List imageBytes}) async {
    if (imageBytes == null) return false;
    return await _channel.invokeMethod<bool>(
        'saveImageToGallery', <String, dynamic>{'imageBytes': imageBytes});
  }
}
