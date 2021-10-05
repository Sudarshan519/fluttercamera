import 'package:get/get.dart';

import '../controllers/previewimage_controller.dart';

class PreviewimageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PreviewimageController>(
      () => PreviewimageController(),
    );
  }
}
