import 'package:image_picker/image_picker.dart';

class Document {
  final String title;
  final String description;
  final XFile? file;
  final String? expiryDate;
  final String? documentType;
  final XFile? thumbnailUrl;

  Document({
    required this.title,
    required this.description,
    this.file,
    this.expiryDate,
    this.documentType,
    this.thumbnailUrl,
  });

  static Map<String, dynamic> docToJson(Document doc) {
    return {
      'title': doc.title,
      'description': doc.description,
      'file': doc.file?.path,
      'expiryDate': doc.expiryDate,
      'documentType': doc.documentType,
      'thumbnailUrl': doc.thumbnailUrl?.path
    };
  }

  static Document docFromJson(Map<String, dynamic> json) {
    return Document(
      title: json['title'],
      description: json['description'],
      file: json['file'] != null ? XFile(json['file']) : null,
      expiryDate: json['expiryDate'] == '' ? json['expiryDate'] : '',
      documentType: json['documentType'],
      thumbnailUrl:
          json['thumbnailUrl'] != null ? XFile(json['thumbnailUrl']) : null,
    );
  }
}
