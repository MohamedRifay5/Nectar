import 'package:image_picker/image_picker.dart';

class Document {
  final String title;
  final String description;
  final XFile? file;
  final DateTime? expiryDate;
  final String? documentType;

  Document({
    required this.title,
    required this.description,
    this.file,
    this.expiryDate,
    this.documentType,
  });

  static Map<String, dynamic> docToJson(Document doc) {
    return {
      'title': doc.title,
      'description': doc.description,
      'file': doc.file?.path,
      'expiryDate': doc.expiryDate?.toIso8601String(),
      'documentType': doc.documentType,
    };
  }

  static Document docFromJson(Map<String, dynamic> json) {
    return Document(
      title: json['title'],
      description: json['description'],
      file: json['file'] != null ? XFile(json['file']) : null,
      expiryDate: json['expiryDate'] != null
          ? DateTime.parse(json['expiryDate'])
          : null,
      documentType: json['documentType'],
    );
  }
}
