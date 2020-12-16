import 'dart:io';

import 'package:path_provider/path_provider.dart';

abstract class InternalBase {
  Future<File> saveFileOnStorage({String fileName});
}

class Internal implements InternalBase {
  @override
  Future<File> saveFileOnStorage({String fileName}) async {
    File _file;
    List<String> paths = fileName.split("/").toList();
    Directory _direct = await getApplicationDocumentsDirectory();
    final List<String> _directStrings = _direct.path.split('/');
    final newPath = _directStrings
        .sublist(0, _directStrings.length - 1)
        .join(',')
        .replaceAll(',', '/');
    final Directory _directory = Directory(newPath + '/ScannerPicData');
    if (await _directory.exists() == true) {
      final _fileNewPath = _directory.path + "/" + paths.last;
      try {
        _file = await File(fileName).copy(_fileNewPath).then((value) => value);
      } catch (e) {
        print(e.toString());
      }
    } else {
      await _directory.create(recursive: true).then(
        (value) async {
          final _fileNewPath = value.path + "/" + paths.last;
          try {
            _file =
                await File(fileName).copy(_fileNewPath).then((value) => value);
          } catch (e) {
            print(e.toString());
          }
        },
      );
    }
    print(_file.path);
    return _file;
  }
}
