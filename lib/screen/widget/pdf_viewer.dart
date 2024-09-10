import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';

class PdfViewerDemo extends StatelessWidget {
  final String filePath;
  const PdfViewerDemo({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: Get.height * 0.6,
        width: Get.width * 0.8,
        child: PDFView(
          filePath: filePath,
          fitPolicy: FitPolicy.BOTH,
          onError: (error) {
            print('Error loading PDF: $error');
          },
          onRender: (pages) {
            print('PDF Rendered with $pages pages');
          },
          onViewCreated: (PDFViewController pdfViewController) {
            print('PDFView created');
          },
          onPageChanged: (int? page, int? total) {
            print('Page changed to $page of $total');
          },
          onPageError: (page, error) {
            print('Error on page $page: $error');
          },
        ),
      ),
    );
  }
}
