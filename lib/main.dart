import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nectar/controller/document_controller.dart';
import 'package:nectar/screen/add_screen.dart';
import 'package:nectar/screen/detail_screen.dart';
import 'package:nectar/screen/home_screen.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  await GetStorage.init();
  await requestPermissions();
  Get.put(DocumentController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/home',
      getPages: [
        GetPage(name: '/home', page: () => const HomeScreen()),
        GetPage(name: '/add', page: () => const AddScreen()),
        GetPage(
            name: '/details',
            page: () => DetailsScreen(
                  index: Get.arguments,
                )),
      ],
      defaultTransition: Transition.fadeIn,
      home: const HomeScreen(),
    );
  }
}

Future<void> requestPermissions() async {
  var cameraStatus = await Permission.camera.request();
  if (cameraStatus.isGranted) {
    print('Camera permission granted');
  } else if (cameraStatus.isDenied) {
    print('Camera permission denied');
  } else if (cameraStatus.isPermanentlyDenied) {
    print('Camera permission permanently denied');
    openAppSettings();
  }

  // Request file access permissions
  var storageStatus = await Permission.storage.request();
  if (storageStatus.isGranted) {
    print('Storage permission granted');
  } else if (storageStatus.isDenied) {
    print('Storage permission denied');
  } else if (storageStatus.isPermanentlyDenied) {
    print('Storage permission permanently denied');
    openAppSettings();
  }
}
