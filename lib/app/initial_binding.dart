import 'package:fluttercamera/app/modules/home/controllers/home_controller.dart';
import 'package:get/get.dart';

import 'core/app_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      AppService(),
    );
    Get.put(HomeController());
  }
}
