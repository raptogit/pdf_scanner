import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/painting.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

abstract class GenPDFBase {
  Future<void> generatePDF({List<String> imagesPath, String pdfName});
}

class GenPDF implements GenPDFBase {
  @override
  Future<void> generatePDF({List<String> imagesPath, String pdfName}) async {
    try {
      final PdfDocument document = PdfDocument();

      for (var imagePath in imagesPath) {
        final PdfPage page = document.pages.add();
        final Size pageSize = page.getClientSize();

        final Uint8List imageData = File(imagePath).readAsBytesSync();
        final PdfBitmap image = PdfBitmap(imageData);
        page.graphics.drawImage(
          image,
          Rect.fromLTWH(0, 0, pageSize.width, pageSize.height),
        );
      }
      File('/storage/emulated/0/pictures/pdf_scanner/$pdfName.pdf')
          .writeAsBytes(
        document.save(),
      );
      document.dispose();
    } catch (e) {
      print(
        e.toString(),
      );
    }
  }
}
