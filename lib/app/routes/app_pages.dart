import 'package:get/get.dart';

import 'package:fluttercamera/app/modules/home/bindings/home_binding.dart';
import 'package:fluttercamera/app/modules/home/views/home_view.dart'; 

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => CameraHome(),
      binding: HomeBinding(),
    ),
   
  ];
}
