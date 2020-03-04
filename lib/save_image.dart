import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class SaveImage {
  static const MethodChannel _channel = const MethodChannel('aissz.com/save_image');
  static Future<void> save({@required Uint8List imageBytes}) async {
    if(imageBytes == null) return null;
    print("imageBytes======$imageBytes");
    var filePath = await _channel.invokeMethod('saveImageToGallery', <String, dynamic>{'imageBytes': imageBytes});
    print("filePath======$filePath");
    return "filePath";
  }
}
