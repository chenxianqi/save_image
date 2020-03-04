import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:save_image/save_image.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'SaveImage Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _saveImage() async {
    var response = await Dio().get(
        "https://camo.githubusercontent.com/b979458fae89f97f0e646d395935a5e8970e239e/687474703a2f2f71696e69752e636d703532302e636f6d2f6b6566757869746f6e682e6a7067",
        options: Options(responseType: ResponseType.bytes));
    bool isSaveSuccess =
        await SaveImage.save(imageBytes: Uint8List.fromList(response.data));
    print(isSaveSuccess ? "save success" : 'save fail');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: _saveImage,
              child: Text("save Photo"),
            )
          ],
        ),
      ),
    );
  }
}
