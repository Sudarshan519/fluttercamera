import 'package:camera/camera.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController homecontroller = Get.find();
  final scale = 0.0.obs;

   

  ///camera controller
  CameraController? cameracontroller;

  ///image choose to switch camera preview with capture image
  RxBool imageClicked = false.obs;

  ///for zoom options
  double minAvailableZoom = 1.0;
  double maxAvailablezoom = 2.0;
  double currentScale = 1.0;
  double baseScale = 1.0;

  ///for setting zoom scale
  int pointers = 0;

  ///max camera screen
  bool maxscreen = true;

//change flash icon
  void setFlashMode(FlashMode mode) async {
    if (cameracontroller == null) {
      return;
    }
    try {
      await cameracontroller!.setFlashMode(mode);
    } on CameraException catch (e) {
      print(e);
    }
  }

  @override
  void onClose() {}
  void increment() => scale.value++;
}
