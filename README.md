# save_image

A new Flutter plugin.   OC + Kotlin  Language

# example
```
var response = await Dio().get(url, options: Options(responseType: ResponseType.bytes));
bool isSaveSuccess = await SaveImage.save(imageBytes: Uint8List.fromList(response.data));
```