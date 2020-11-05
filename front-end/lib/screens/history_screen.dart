import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khedni_maak/widgets/error_widget.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ErrorWidgetDisplay(
      title: 'HISTORY',
      subTitle: 'HISTORY',
      imagePath: 'truck.png',
    );
  }
}
