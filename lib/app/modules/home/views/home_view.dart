import 'dart:io';
import 'dart:math';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttercamera/main.dart';
import '../controllers/home_controller.dart';
import 'package:fluttercamera/app/constant/app_colors.dart';
import 'package:fluttercamera/app/constant/constant.dart';
import 'package:fluttercamera/app/modules/previewimage/views/previewimage_view.dart';

class CameraHome extends StatefulWidget {
  const CameraHome({Key? key}) : super(key: key);

  @override
  _CameraHomeState createState() => _CameraHomeState();
}

class _CameraHomeState extends State<CameraHome> with WidgetsBindingObserver {
  FlashState currentFlashState = FlashState.Flash_OFF;

  String flashIcon = 'flash-off';
  bool isFullScreen = false;
  XFile? imageFile;
  final homeController = HomeController.homecontroller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    ///lock orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    ambiguate(WidgetsBinding.instance)?.addObserver(this);
    _initCamera(cameras.first);
    super.initState();
  }

  ///init camera
  Future<void> _initCamera(CameraDescription description) async {
    homeController.cameracontroller =
        CameraController(description, ResolutionPreset.max, enableAudio: true);

    try {
      await homeController.cameracontroller!.initialize();
      await Future.wait([
        homeController.cameracontroller!
            .getMaxZoomLevel()
            .then((value) => homeController.maxAvailablezoom = value),
        homeController.cameracontroller!
            .getMinZoomLevel()
            .then((value) => homeController.minAvailableZoom = value),
      ]);
      // to notify the widgets that camera has been initialized and now camera preview can be done
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  ///toggle aspect ratio
  void toggleaspectratio() {
    // get current lens direction (front / rear)
    final lensDirection =
        homeController.cameracontroller!.description.lensDirection;
    if (lensDirection == CameraLensDirection.front) {
    } else {}
  }

  ///toggle camera
  void _toggleCameraLens() {
    // get current lens direction (front / rear)
    final lensDirection =
        homeController.cameracontroller!.description.lensDirection;
    CameraDescription newDescription;
    if (lensDirection == CameraLensDirection.front) {
      newDescription = cameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.back);
    } else {
      newDescription = cameras.firstWhere((description) =>
          description.lensDirection == CameraLensDirection.front);
    }

    // ignore: unnecessary_null_comparison
    if (newDescription != null) {
      _initCamera(newDescription);
      homeController.cameracontroller!.setFlashMode(FlashMode.off);
    } else {
      print('Asked camera not available');
    }
  }

  ///take picture
  Future<XFile?> takePicture() async {
    final CameraController? cameraController = homeController.cameracontroller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      XFile file = await cameraController.takePicture();
      print(file.path);

      return file;
    } on CameraException {
      return null;
    }
  }

  ///clicked
  void onTakePictureButtonPressed() {
    takePicture().then((XFile? file) {
      if (mounted) {
        setState(() {
          imageFile = file;
        });
        // homeController.dispose();

        if (file != null) showInSnackBar('Picture saved to ${file.path}');
      }
    });
  }

  ///snackbar
  void showInSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: 400.milliseconds,
    ));
    // _scaffoldKey.currentState?.showSnackBar(SnackBar(
    //   content: Text(message),
    //   duration: 400.milliseconds,
    // ));
  }

  @override
  void dispose() {
    homeController.dispose();
    super.dispose();
  }

  Widget flashButton() {
    return GestureDetector(
      onTap: () {
        currentFlashState =
            currentFlashState.index < FlashState.values.length - 1
                ? FlashState.values[currentFlashState.index + 1]
                : FlashState.values[0];
        if (currentFlashState == FlashState.Flash_On) {
          homeController.cameracontroller!.setFlashMode(FlashMode.always);
          setState(() {
            flashIcon = 'flash-on';
          });
          //Lamp.turnOn(); Turning on the flash through lamp package flutter but the flash not opening
        } else if (currentFlashState == FlashState.Flash_Auto) {
          homeController.cameracontroller!.setFlashMode(FlashMode.auto);
          setState(() {
            flashIcon = 'flash-auto';
          });
        } else if (currentFlashState == FlashState.Flash_Light) {
          homeController.cameracontroller!.setFlashMode(FlashMode.torch);
          setState(() {
            flashIcon = 'flash-torch';
          });
        } else {
          homeController.cameracontroller!.setFlashMode(FlashMode.off);
          setState(() {
            flashIcon = 'flash-off';
          });
          //Lamp.turnOff();
        }
      },
      child: Icon(
        flashIcon == 'flash-auto'
            ? Icons.flash_auto
            : flashIcon == 'flash-on'
                ? Icons.flash_on
                : flashIcon == 'flash-torch'
                    ? Icons.highlight
                    : Icons.flash_off,
        color: AppColors.white,
      ),
    );
  }

  ///get default camera view
  Widget fullScreenToggleButton() {
    return InkWell(
      onTap: () {
        setState(() {
          isFullScreen = !isFullScreen;
        });
      },
      child: Transform.rotate(
        angle: 90 * pi / 180,
        child: Text(
          '[   ]',
          style: TextStyle(
              fontSize: Constant.defaultFontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.white),
        ),
      ),
    );
  }

  ///menu button for settings cont...
  Widget menuButton() {
    return Icon(
      Icons.menu,
      color: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            ///full screen camera
            Center(
              child: isFullScreen ? cameraPreview() : Container(),
            ),

            ///top settings row
            Column(
              children: [
                ///tob bar
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  height: size.height * .08,
                  color: AppColors.black.withOpacity(.5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      flashButton(),
                      fullScreenToggleButton(),
                      menuButton()
                    ],
                  ),
                ),

                ///camera preview part
                Expanded(
                    child: isFullScreen
                        ? Column()
                        : Container(
                            width: double.infinity, child: cameraPreview())),

                ///bottom widget
                Container(
                  color: AppColors.black.withOpacity(.5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...modes.map((e) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                                child: Text(
                                  e,
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      fontSize: Constant.defaultFontSize,
                                      fontWeight: FontWeight.bold),
                                ),
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ///test zoom level
                          // Obx(() => Text(
                          //       homeController.scale.value.toStringAsFixed(1),
                          //       style: TextStyle(color: Colors.white),
                          //     )),
                          imageFile == null
                              ? CircleAvatar(
                                  backgroundColor: AppColors.black,
                                  radius: 25,
                                )
                              : InkWell(
                                  onTap: () {
                                    Get.to(() =>
                                        PreviewimageView(imageFile!.path));
                                  },
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: AppColors.black,
                                    backgroundImage: imageFile != null
                                        ? FileImage(File(imageFile!.path))
                                        : null,
                                  ),
                                ),
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: AppColors.whiteblur,
                            child: InkWell(
                              onTap: () {
                                onTakePictureButtonPressed();
                              },
                              child: CircleAvatar(
                                radius: 30,
                              ),
                            ),
                          ),
                          CircleAvatar(
                            radius: 25,
                            child: IconButton(
                                onPressed: _toggleCameraLens,
                                icon: Icon(Icons.cameraswitch)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  ///camera preview widget
  Widget cameraPreview() {
    return Container(
      width: double.infinity,
      child: Listener(
        onPointerDown: (_) => homeController.pointers++,
        onPointerUp: (_) => homeController.pointers--,
        child: CameraPreview(
          homeController.cameracontroller!,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return GestureDetector(
              onDoubleTap: scalezoom,
              behavior: HitTestBehavior.opaque,
              onScaleStart: handleScaleStart,
              onScaleUpdate: handleScaleUpdate,
              onTapDown: (details) => onViewFinderTap(details, constraints),
            );
          }),
        ),
      ),
    );
  }

  ///zoom on double tap
  void scalezoom() async {
    if (homeController.maxAvailablezoom > homeController.currentScale) {
      homeController.currentScale = homeController.currentScale + 1;
    } else {
      homeController.currentScale = 1;
    }
    await homeController.cameracontroller!
        .setZoomLevel(homeController.currentScale);
  }

  //it haldle the zoom scale of camera
  void handleScaleStart(ScaleStartDetails details) {
    homeController.baseScale = homeController.currentScale;
  }

  //zoom function
  Future<void> handleScaleUpdate(ScaleUpdateDetails details) async {
    // When there are not exactly two fingers on screen don't scale
    if (homeController.cameracontroller == null ||
        homeController.pointers != 2) {
      return;
    }

    homeController.currentScale = (homeController.baseScale * details.scale)
        .clamp(
            homeController.minAvailableZoom, homeController.maxAvailablezoom);
    // homeController.scale.value = homeController.currentScale;
    await homeController.cameracontroller!
        .setZoomLevel(homeController.currentScale);
  }

  ///..
  onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (homeController.cameracontroller == null) return;

    final CameraController cameraController = homeController.cameracontroller!;
    final offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    cameraController.setExposurePoint(offset);
    cameraController.setFocusPoint(offset);
  }

  //app lifecycle state notifier
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      homeController.cameracontroller!.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera(homeController.cameracontroller!.description);
    }

    super.didChangeAppLifecycleState(state);
  }
}

T? ambiguate<T>(T? value) => value;
