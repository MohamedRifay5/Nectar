import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

class ExtrenalFileViewer extends StatelessWidget {
  final String filePath;
  const ExtrenalFileViewer({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => OpenFile.open(filePath),
        child: const Text('Open Excel File'),
      ),
    );
  }
}
