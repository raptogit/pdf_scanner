import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf_scanner/src/models/folder_model.dart';

class FolderScreen extends StatefulWidget {
  final Box<Folder> folderBox;
  final int index;

  FolderScreen({Key key, this.folderBox, this.index}) : super(key: key);
  @override
  _FolderScreenState createState() => _FolderScreenState();
}

enum FileState { empty, notEmpty }

class _FolderScreenState extends State<FolderScreen> {
  FileState _fileState;
  File _file;
  List<File> _files;
  @override
  void initState() {
    super.initState();
    setState(() {
      _fileState = FileState.empty;
      _files = [...widget.folderBox.getAt(widget.index).files];
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
    print(widget.folderBox.getAt(widget.index).files);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folderBox.get(widget.index).folderName),
      ),
      body: _files.length != 0
          ? GridView.builder(
              itemCount: _files.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    color: Colors.grey.withOpacity(0.5),
                    height: 150,
                    width: 150,
                    child: Image.file(_files[index], fit: BoxFit.fitHeight));
              },
            )
          : Container(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            initFile().then((value) {
              var getfolder = widget.folderBox.getAt(widget.index);
              getfolder.files.add(_file);
            });
          },
          child: Icon(Icons.add)),
    );
  }
}
