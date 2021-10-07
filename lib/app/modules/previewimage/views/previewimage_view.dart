import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttercamera/app/modules/home/controllers/home_controller.dart';
import 'package:fluttercamera/app/modules/home/views/home_view.dart';

import 'package:photo_view/photo_view.dart';

class PreviewimageView extends StatefulWidget {
  final String imagefile;
  final String file;
  final String logo;

  PreviewimageView(this.imagefile, this.file, this.logo);

  @override
  State<PreviewimageView> createState() => _PreviewimageViewState();
}

class _PreviewimageViewState extends State<PreviewimageView> {
  bool removelogo = false;
  final controller = HomeController;
  LogoDirection logoDirection = LogoDirection.topleft;
  late File file;
  bool islogoadded = false;

  addLogo(logoDirection) async {
    File logo = await HomeController.homecontroller.watermarkPicture(
        File(widget.imagefile), File(widget.logo), logoDirection);
    setState(() {
      islogoadded = true;
      removelogo = false;
      file = logo;
    });
  }

  Widget logo() {
    return Row(
      children: [
        InkWell(
            onTap: () {
              addLogo(LogoDirection.topleft);
            },
            child: Text(
              'Topleft',
              style: TextStyle(color: Colors.white),
            )),
        SizedBox(
          width: 20,
        ),
        InkWell(
            onTap: () {
              addLogo(
                LogoDirection.topright,
              );
              print(
                'added logo',
              );
            },
            child: Text(
              'TopRight',
              style: TextStyle(color: Colors.white),
            )),
        SizedBox(
          width: 20,
        ),
        InkWell(
            onTap: () {
              addLogo(LogoDirection.bottomleft);
            },
            child: Text(
              'BottomLeft',
              style: TextStyle(color: Colors.white),
            )),
        SizedBox(
          width: 20,
        ),
        InkWell(
            onTap: () {
              addLogo(LogoDirection.bottomright);
            },
            child: Text(
              'BottomRight',
              style: TextStyle(color: Colors.white),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('ImagePreview'),
          centerTitle: true,
          actions: [
            // Image.file(File(widget.imagefile)),
            // Image.file(File(file.path)),

            Center(
              child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      removelogo = true;
                    });
                  },
                  child: Text(
                    'Remove logo',
                    style: TextStyle(color: Colors.white),
                  )),
            )
          ],
        ),
        body: Column(children: [
          logo(),
          Expanded(
            child: PhotoView(
                imageProvider: FileImage(File(islogoadded && !removelogo
                    ? file.path
                    : !removelogo
                        ? widget.file
                        : widget.imagefile))),
          )
        ]));
  }
}
