# save_image

A new Flutter plugin.   OC + Kotlin  Language

# example
```dart
    var response = await Dio().get(url, options: Options(responseType: ResponseType.bytes));
    bool isSaveSuccess = await SaveImage.save(imageBytes: Uint8List.fromList(response.data));
```