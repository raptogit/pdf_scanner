import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf_scanner/src/models/folder_model.dart';
import 'package:pdf_scanner/src/services/hive_pref.dart';
import 'package:pdf_scanner/src/services/internal.dart';

class FolderScreen extends StatefulWidget {
  final int index;

  FolderScreen({Key key, this.index}) : super(key: key);
  @override
  _FolderScreenState createState() => _FolderScreenState();
}

enum FileState { empty, notEmpty }

class _FolderScreenState extends State<FolderScreen> {
  Box<Folder> folderBox;
  FileState _fileState;
  File _file;
  File _fileToAdd;
  List<String> _files;
  Folder _folder;
  @override
  void initState() {
    print(widget.index);
    super.initState();
    setState(() {
      folderBox = Hive.box<Folder>(HiveInit.boxName);
      _folder = folderBox.get(widget.index);
      _fileState = FileState.empty;
      _files = [..._folder.files];
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
      await ImagePicker().getImage(source: ImageSource.camera).then((value) {
        if (value != null) {
          return File(value.path);
        } else {
          return null;
        }
      }).then(
        (value) async {
          if (value != null) {
            setState(() {
              _fileState = FileState.notEmpty;
            });

            File _editedImageFile = await editFile(value);

            setState(() {
              _file = _editedImageFile;
            });
            _fileToAdd =
                await Internal().saveFileOnStorage(fileName: _file.path);
            print("${_fileToAdd.path} and the rest");

            _files.add(_fileToAdd.path);
          } else {
            setState(() {
              _fileState = FileState.empty;
            });
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
    print(_folder.files ?? "Non ");
    print(_folder.files.length ?? "Non ");
    return Scaffold(
      appBar: AppBar(
        title: Text(_folder.folderName ?? "non"),
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
                    child:
                        Image.file(File(_files[index]), fit: BoxFit.fitHeight));
              },
            )
          : Container(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            initFile().then((value) async {
              try {
                var getfolder = _folder;

                getfolder.files.add(_fileToAdd.path);
                getfolder.save();
              } catch (e) {
                print(e);
              }
            });
          },
          child: Icon(Icons.add)),
    );
  }
}
