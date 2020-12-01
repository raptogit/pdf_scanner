import 'dart:io';

class Internal {
  Future<File> saveFileOnStorage({String fileName}) async {
    File _file;
    List<String> paths = fileName.split("/").toList();
    final Directory _directory =
        Directory('/storage/emulated/0/pictures/pdf_scanner');
    if (await _directory.exists() == true) {
      final _fileNewPath = _directory.path + "/" + paths.last;
      try {
        _file = await File(fileName).copy(_fileNewPath).then((value) => value);
      } catch (e) {
        print(e.toString());
        // return;
      }
    } else {
      await _directory.create(recursive: true).then((value) async {
        final _fileNewPath = value.path + "/" + paths.last;
        try {
          _file =
              await File(fileName).copy(_fileNewPath).then((value) => value);
        } catch (e) {
          print(e.toString());
          // return;
        }
      });
    }
    print(_file.path);
    return _file;
  }
}
