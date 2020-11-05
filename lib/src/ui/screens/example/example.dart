import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ExamplePage extends StatefulWidget {
  @override
  _ExamplePageState createState() => _ExamplePageState();
}

enum FileState { empty, notEmpty }

class _ExamplePageState extends State<ExamplePage> {
  List<File> _files = [];
  File _file;
  String error;
  FileState _fileState;
  @override
  void initState() {
    super.initState();
    setState(() {
      _fileState = FileState.empty;
    });
  }

  Future<File> editFile(File file) async {
    File croppedFile;
    if (_fileState == FileState.notEmpty) {
      croppedFile = await ImageCropper.cropImage(
          sourcePath: file.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio5x4,
            CropAspectRatioPreset.ratio7x5,
            CropAspectRatioPreset.ratio16x9
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.blue,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              statusBarColor: Colors.black,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            title: 'Cropper',
          ));

      if (croppedFile == null) {
        setState(() {
          croppedFile = file;
        });
      }
    }
    setState(() {
      _fileState = FileState.empty;
    });
    return croppedFile;
  }

  Future<void> initFile() async {
    try {
      await ImagePicker()
          .getImage(source: ImageSource.camera)
          .then((value) => File(value.path))
          .then(
        (value) async {
          if (value != null) {
            setState(() {
              _fileState = FileState.notEmpty;
            });

            File _editedImageFile = await editFile(value);
            setState(() {
              _file = _editedImageFile;
            });
            _files.add(File(_file.path));
          } else {
            print("null Emir");
          }
        },
      );
    } catch (e) {
      print(e);
    }
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
              children: _files
                  .map((e) =>
                      Container(height: 200, width: 200, child: Image.file(e)))
                  .toList()
                  .reversed
                  .toList(),
            ),
          ),
          SizedBox(height: 10),
          TextButton(
            onPressed: initFile,
            child: Text("PickImage"),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: null),
    );
  }
}
