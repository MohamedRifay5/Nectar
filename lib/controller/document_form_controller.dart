import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nectar/controller/document_controller.dart';
import 'package:nectar/model/document.dart';
import 'package:nectar/screen/widget/record_audio.dart';
import 'package:permission_handler/permission_handler.dart';

class DocumentFormController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final expiryDateController = TextEditingController();
  RxString documentType = RxString('');
  Rx<XFile?> file = Rx<XFile?>(null);
  Rx<XFile?> thumbnailUrl = Rx<XFile?>(null);
  final FilePicker _filepicker = FilePicker.platform;
  final ImagePicker _picker = ImagePicker();

  final FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();
  RxBool isRecording = false.obs;

  final DocumentController documentController = Get.find();

  @override
  void onInit() {
    super.onInit();
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    final status = await Permission.microphone.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      openAppSettings();
      return;
    }
    await _audioRecorder.openRecorder();
  }

  Future<void> pickFile() async {
    final pickedFile = await _filepicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'xlsx'],
    );
    if (pickedFile != null) {
      file.value = pickedFile.xFiles.first;
    }
  }

  Future<void> pickThumbnail() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      thumbnailUrl.value = pickedFile;
    }
  }

  Future<void> captureImage() async {
    final capturedFile = await _picker.pickImage(source: ImageSource.camera);
    if (capturedFile != null) {
      file.value = capturedFile;
    }
  }

  Future<void> captureVideo() async {
    final capturedFile = await _picker.pickVideo(source: ImageSource.camera);
    if (capturedFile != null) {
      file.value = capturedFile;
    }
  }

  Future<void> showRecordingDialog() async {
    await Get.dialog(
      RecordingDialog(
        audioRecorder: _audioRecorder,
        onStartRecording: _startRecording,
        onStopRecording: _stopRecording,
      ),
    );
  }

  Future<void> _startRecording() async {
    try {
      final tempDir = Directory.systemTemp;
      final filePath =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.aac';
      await _audioRecorder.startRecorder(toFile: filePath);
      file.value = XFile(filePath);
      isRecording.value = true;
    } catch (e) {
      print('Error starting recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      await _audioRecorder.stopRecorder();
      isRecording.value = false;
    } catch (e) {
      print('Error stopping recording: $e');
    }
  }

  void saveDocument() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      final document = Document(
        title: titleController.text,
        description: descriptionController.text,
        file: file.value,
        expiryDate: expiryDateController.text,
        documentType: documentType.value,
        thumbnailUrl: thumbnailUrl.value,
      );
      documentController.addDocument(document);
      Get.back();
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    expiryDateController.dispose();
    _audioRecorder.closeRecorder();
    super.onClose();
  }
}
