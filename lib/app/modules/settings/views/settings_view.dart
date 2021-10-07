import 'package:flutter/material.dart';
import 'package:fluttercamera/app/constant/app_colors.dart';

import 'package:get/get.dart';

import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.grey,
              size: 30,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Camera Settings',
                style: Theme.of(context).textTheme.headline4,
              ),
              SizedBox(
                height: 20,
              ),
              Text('Watermark',
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: Colors.grey[700])),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Text('Position',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: Colors.grey[600])),
                  Spacer(),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text('Logo',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(color: Colors.grey[600])),
                  Spacer(),
                  OutlinedButton(onPressed: () {}, child: Text('Choose Logo')),
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ));
  }
}
