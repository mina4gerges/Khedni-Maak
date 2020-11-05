import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khedni_maak/widgets/error_widget.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ErrorWidgetDisplay(
      title: 'NOTIFICATION',
      subTitle: 'NOTIFICATION',
      imagePath: 'truck.png',
    );
  }
}
