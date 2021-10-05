import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/initial_binding.dart';
import 'app/routes/app_pages.dart';

List<CameraDescription> cameras = [];
Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print(e.code + e.description!);
  }
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      // theme: Themes.dark,
      getPages: AppPages.routes,
      initialBinding: InitialBinding(),
    ),
  );
}
