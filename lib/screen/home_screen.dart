import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nectar/controller/document_controller.dart';
import 'package:nectar/screen/add_screen.dart';
import 'package:nectar/screen/detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DocumentController documentController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Manager'),
      ),
      body: Obx(() {
        if (documentController.documents.isEmpty) {
          return const Center(child: Text('No Documents Found'));
        }

        return ListView.builder(
          itemCount: documentController.documents.length,
          itemBuilder: (context, index) {
            final doc = documentController.documents[index];
            return Dismissible(
              key: ValueKey(doc.title),
              background: Container(
                color: Colors.red,
                child: const Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                documentController.removeDocument(doc);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${doc.title} deleted'),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        documentController.addDocument(doc);
                      },
                    ),
                  ),
                );
              },
              child: ListTile(
                title: doc.thumbnailUrl != null
                    ? Image.file(
                        width: Get.width * .5,
                        height: Get.height * .3,
                        File(doc.thumbnailUrl!.path),
                      )
                    : const Icon(Icons.insert_drive_file),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(doc.title),
                        Text(doc.documentType ?? 'Unknown Type'),
                      ],
                    ),
                    Text(doc.expiryDate != ''
                        ? doc.expiryDate.toString()
                        : 'No Expiry Date'),
                  ],
                ),
                onTap: () {
                  Get.to(() => DetailsScreen(index: index));
                },
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const AddScreen());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
