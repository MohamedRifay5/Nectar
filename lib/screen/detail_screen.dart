import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nectar/controller/document_controller.dart';
import 'package:nectar/screen/widget/audio_file_player.dart';
import 'package:nectar/screen/widget/extrenal_file_viewer.dart';
import 'package:nectar/screen/widget/pdf_viewer.dart';
import 'package:nectar/screen/widget/video_file_player.dart';

class DetailsScreen extends StatelessWidget {
  final int index;
  final DocumentController documentController = Get.find();

  DetailsScreen({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final document = documentController.getDocument(index);

    if (document == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Document Details'),
          leading: IconButton(
            onPressed: () => Get.offAllNamed('/home'),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: const Center(child: Text('Document not found')),
      );
    }

    File? getFileFromDocument() {
      if (document.file == null) return null;
      if (document.file is File) {
        return document.file as File;
      } else if (document.file is XFile) {
        return File((document.file as XFile).path);
      }
      return null;
    }

    final file = getFileFromDocument();

    Widget buildFileViewer() {
      if (file == null) {
        return const Text('No file available');
      }

      final fileExtension = file.path.split('.').last.toLowerCase();

      switch (fileExtension) {
        case 'pdf':
          return PdfViewerDemo(filePath: file.path);
        case 'doc':
        case 'docx':
        case 'xlsx':
        case 'ppt':
        case 'pptx':
          return ExtrenalFileViewer(filePath: file.path);
        case 'jpg':
        case 'png':
          return Image.file(file);
        case 'mp4':
          return VideoPlayerWidget(filePath: file.path);
        case 'aac':
          return AudioPlayerWidget(filePath: file.path);
        default:
          return const Text('Unsupported file type');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(document.title),
        leading: IconButton(
          onPressed: () => Get.offAllNamed('/home'),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Description: ${document.description}"),
            if (document.expiryDate != null)
              Text('Expiry Date: ${document.expiryDate}'),
            if (file != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: buildFileViewer(),
              ),
          ],
        ),
      ),
    );
  }
}
