import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../main.dart';

class ExamplePage extends StatefulWidget {
  @override
  _ExamplePageState createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  List<File> files = [];
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(),
  //     body: Center(
  //       child: ListView(
  //         children: files
  //             .map((e) =>
  //                 Container(height: 200, width: 200, child: Image.file(e)))
  //             .toList()
  //             .reversed
  //             .toList(),
  //       ),
  //     ),
  //     floatingActionButton: FloatingActionButton(onPressed: () async {
  //       try {
  //         await ImagePicker()
  //             .getImage(source: ImageSource.camera)
  //             .then((value) {
  //           setState(() {
  //             files.add(File(value.path));
  //           });
  //         });
  //       } catch (e) {
  //         print(e.toString());
  //       }
  //     }),
  //   );
  // }
  CameraController _cameraController;
  String error;
  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(cameras[0], ResolutionPreset.veryHigh);
    _cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _cameraController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 300,
            width: 300,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: files
                  .map((e) =>
                      Container(height: 200, width: 200, child: Image.file(e)))
                  .toList()
                  .reversed
                  .toList(),
            ),
          ),
          Container(
            height: 200,
            width: 200,
            child: CameraPreview(_cameraController),
          ),
          SizedBox(height: 10),
          Text(error ?? "Error"),
          TextButton(
              onPressed: () async {
                try {
                  final path = join((await getTemporaryDirectory()).path,
                      '${DateTime.now()}.png');
                  await _cameraController.takePicture(path);
                  setState(() {
                    files.add(File(path));
                    error = path;
                  });
                } catch (e) {
                  setState(() {
                    error = e.toString();
                  });
                }
              },
              child: Text("Capture"))
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: null),
    );
  }
}
