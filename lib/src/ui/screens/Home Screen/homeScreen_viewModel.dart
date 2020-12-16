import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:pdf_scanner/src/models/folder_model.dart';
import 'package:pdf_scanner/src/services/hive_pref.dart';
import 'package:pdf_scanner/src/services/pdf.dart';

class HomeScreenViewModel extends ChangeNotifier {
  GenPDFBase _pdfBase = GenPDF();
  Box<Folder> _folderBox;

  void initState() {
    _folderBox = Hive.box<Folder>(HiveInit.boxName);
  }

  Future<void> generatePDF({List<String> imagesPath, String pdfName}) async {
    return _pdfBase.generatePDF(
      imagesPath: imagesPath,
      pdfName: pdfName,
    );
  }

  Box<Folder> get folderBox => _folderBox;
}
