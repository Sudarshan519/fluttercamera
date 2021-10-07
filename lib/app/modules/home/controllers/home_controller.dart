import 'dart:io';
import 'package:fluttercamera/app/modules/home/views/home_view.dart';
import 'package:image/image.dart' as ui;
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class HomeController extends GetxController {
  static HomeController homecontroller = Get.find();
  final scale = 0.0.obs;

  ///camera controller
  CameraController? cameracontroller;
  String selectedlogo = '';

  ///image choose to switch camera preview with capture image
  RxBool imageClicked = false.obs;

  ///for zoom options
  double minAvailableZoom = 1.0;
  double maxAvailablezoom = 2.0;
  double currentScale = 1.0;
  double baseScale = 1.0;
  var islogoSelected = false.obs;

  ///for setting zoom scale
  int pointers = 0;

  ///max camera screen
  bool maxscreen = true;
  Rx<LogoDirection> logoDirection = LogoDirection.topleft.obs;
  var logochanged = false.obs;
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
  void onInit() {
    // TODO: implement onInit

    super.onInit();
  }

  @override
  void onClose() {}
  void increment() => scale.value++;

  ///watermark for image
  Future<File> watermarkPicture(
      File picture,
      File watermark, //String fileName,
      LogoDirection direction) async {
    print(direction);
    // print(fileName);
    ui.Image? originalImage = ui.decodeImage(picture.readAsBytesSync());
    ui.Image? watermarkImage = ui.decodeImage((watermark.readAsBytesSync()));

    ui.Image image = ui.Image(originalImage!.width, originalImage.height);
    ui.Image watermarklogo = ui.Image(200, 200);
    // ui.Image image2 =
    ui.drawImage(watermarklogo, watermarkImage!);
    ui.drawImage(image, watermarklogo);
    // ui.Image image3 =
    // ui.drawString(image, ui.arial_48, 0, 0, 'Hello World', color: 0xFF4CAF50);
    // Easy customisation for the position of the watermark in the next two lines
    final int positionX = direction == LogoDirection.topleft ||
            direction == LogoDirection.bottomleft
        ? 0
        : originalImage.width - watermarklogo.width;
    // (originalImage.width / 2 - watermarkImage.width / 2).toInt();
    final int positionY = direction == LogoDirection.topleft ||
            direction == LogoDirection.topright
        ? 0
        : originalImage.height - watermarklogo.height;
    //(originalImage.height - watermarkImage.height * 1.15).toInt();

    ui.copyInto(
      originalImage,
      image,
      dstX: positionX,
      dstY: positionY,
    );

    var date = DateTime.now().millisecondsSinceEpoch;
    File watermarkedFile =
        File('${(await getTemporaryDirectory()).path}/$date.jpg');
    await watermarkedFile.writeAsBytes(ui.encodeJpg(originalImage));
    print(watermarkedFile.path);
    return watermarkedFile;
  }
}
