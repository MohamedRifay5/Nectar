import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nectar/controller/document_form_controller.dart';

class AddScreen extends StatelessWidget {
  const AddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DocumentFormController formController =
        Get.put(DocumentFormController());

    String _docType = 'Select Document Type';

    return Scaffold(
      appBar: AppBar(title: const Text('Add Document')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formController.formKey,
          child: Column(
            children: [
              TextFormField(
                controller: formController.titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextFormField(
                controller: formController.descriptionController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              DropdownButtonFormField<String>(
                value: _docType,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value == 'Select Document Type') {
                    return 'Please select a document type';
                  }
                  return null;
                },
                onChanged: (String? newValue) {
                  _docType = newValue ?? '';
                  formController.documentType.value = _docType;
                  switch (_docType) {
                    case 'File':
                      formController.pickFile();
                      break;
                    case 'Capture Image':
                      formController.captureImage();
                      break;
                    case 'Capture Video':
                      formController.captureVideo();
                      break;
                    case 'Record Audio':
                      formController.showRecordingDialog();
                      break;
                    default:
                      break;
                  }
                },
                items: <String>[
                  'File',
                  'Capture Image',
                  'Capture Video',
                  'Record Audio',
                  'Select Document Type',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              TextFormField(
                controller: formController.expiryDateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Expiry Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (selectedDate != null) {
                    formController.selectExpiryDate(selectedDate);
                  }
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )),
                onPressed: formController.saveDocument,
                child: const Text(
                  'Save Document',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
