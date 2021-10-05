import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

import '../controllers/previewimage_controller.dart';

class PreviewimageView extends GetView<PreviewimageController>
    with WidgetsBindingObserver {
  final String imagefile;

  PreviewimageView(this.imagefile);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        // appBar: AppBar(
        //   title: Text('PreviewimageView'),
        //   centerTitle: true,
        // ),
        body: PhotoView(imageProvider: FileImage(File(imagefile))));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('lifecycle changed');
    if (state == AppLifecycleState.resumed) {
      print('resumed');
    }
  }
}
