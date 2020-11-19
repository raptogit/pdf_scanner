import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_scanner/src/models/folder_model.dart';

class HiveInit {
  static String boxName = "FolderBox";

  static Future hiveInit() async {
    final documentDir = await getApplicationDocumentsDirectory();
    Hive.init(documentDir.path);
    Hive.registerAdapter(FolderAdapter());
    await Hive.openBox<Folder>(boxName);
  }
}
