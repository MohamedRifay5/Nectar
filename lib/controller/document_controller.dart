import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nectar/model/document.dart';

class DocumentController extends GetxController {
  var documents = <Document>[].obs;
  final GetStorage _storage = GetStorage();
  final String _storageKey = 'documents';

  @override
  void onInit() {
    super.onInit();
    _loadDocuments();
  }

  void addDocument(Document document) {
    documents.add(document);
    _saveDocuments();
  }

  void removeDocument(Document document) {
    if (document.file != null) {
      final file = File(document.file!.path);
      if (file.existsSync()) {
        file.deleteSync();
      }
    }

    documents.remove(document);
    _saveDocuments();
  }

  Document? getDocument(int index) {
    return documents.length > index ? documents[index] : null;
  }

  void _saveDocuments() {
    final jsonList = documents.map((doc) => Document.docToJson(doc)).toList();
    _storage.write(_storageKey, jsonList);
  }

  void _loadDocuments() {
    final jsonList = _storage.read<List<dynamic>>(_storageKey) ?? [];
    documents.value = jsonList
        .map((json) => Document.docFromJson(json as Map<String, dynamic>))
        .toList();
  }
}
