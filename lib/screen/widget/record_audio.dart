import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:nectar/controller/document_form_controller.dart';

class RecordingDialog extends StatelessWidget {
  final FlutterSoundRecorder audioRecorder;
  final VoidCallback onStartRecording;
  final VoidCallback onStopRecording;

  const RecordingDialog({
    super.key,
    required this.audioRecorder,
    required this.onStartRecording,
    required this.onStopRecording,
  });

  @override
  Widget build(BuildContext context) {
    final DocumentFormController controller = Get.find();
    return Obx(
      () => AlertDialog(
        title: Text(
            controller.isRecording.value ? 'Recording...' : 'Record Audio'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(controller.isRecording.value
                ? 'Tap below to stop recording.'
                : 'Tap below to start recording.'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.isRecording.value
                  ? onStopRecording
                  : onStartRecording,
              child: Text(controller.isRecording.value
                  ? 'Stop Recording'
                  : 'Start Recording'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
