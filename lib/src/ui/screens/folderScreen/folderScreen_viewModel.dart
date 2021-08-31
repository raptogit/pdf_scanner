import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pdf_scanner/src/models/folder_model.dart';
import 'package:pdf_scanner/src/services/hive_pref.dart';
import 'package:pdf_scanner/src/services/internal.dart';
import 'package:pdf_scanner/src/utils/enums.dart';

class FolderScreenViewModel extends ChangeNotifier {
  late Box<Folder> _folderBox;
  FileState _fileState = FileState.empty;
  File? _file;
  File? _fileToAdd;
  List<String>? _files;
  Folder? _folder;

  void initState(int? index) {
    _folderBox = Hive.box<Folder>(HiveInit.boxName);
    _folder = _folderBox.get(index);
    _fileState = FileState.empty;
    _files = [..._folder!.files!];
  }

  Future<File?> editFile(File file) async {
    File? croppedFile;
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
        croppedFile = file;
        notifyListeners();
      }
    }
    _fileState = FileState.empty;
    notifyListeners();
    return croppedFile;
  }

  Future<void> initFile() async {
    try {
      // image picker services
      await ImagePicker().getImage(source: ImageSource.camera).then((value) {
        if (value != null) {
          return File(value.path);
        } else {
          return null;
        }
      }).then(
        (value) async {
          if (value != null) {
            _fileState = FileState.notEmpty;

            File? _editedImageFile = await editFile(value);

            _file = _editedImageFile;
            notifyListeners();
            _fileToAdd =
                await Internal().saveFileOnStorage(fileName: _file!.path);
            print("${_fileToAdd!.path} and the rest");

            _files!.add(_fileToAdd!.path);
          } else {
            _fileState = FileState.empty;
            print("null Emir");
          }
        },
      );
    } catch (e) {
      print(e);
    }
  }

  void onPressed() {
    initFile().then((value) async {
      try {
        var getfolder = _folder!;

        getfolder.files!.add(_fileToAdd!.path);
        getfolder.save();
        notifyListeners();
      } catch (e) {
        print(e);
      }
    });
  }

  Folder? get folder => _folder;
  List<String>? get files => _files;
  File? get fileToAdd => _fileToAdd;
  File? get file => _file;
  FileState get fileState => _fileState;
}
