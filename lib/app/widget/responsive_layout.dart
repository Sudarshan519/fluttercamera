import 'package:flutter/cupertino.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({Key? key, required this.mobile, this.tablet})
      : super(key: key);
  final Widget mobile;
  final Widget? tablet;
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      if (orientation == Orientation.landscape) {
        return tablet!;
      } else {
        return mobile;
      }
    });
  }
}
