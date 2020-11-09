import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorWidgetDisplay extends StatelessWidget {
  ErrorWidgetDisplay({
    Key key,
    this.title,
    this.subTitle,
    this.imagePath,
    this.imageWidth = 100.0,
    this.imageHeight = 100.0,
  }) : super(key: key);

  final String title;
  final String subTitle;
  final String imagePath;
  final double imageWidth;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/$imagePath',
            width: imageWidth,
            height: imageHeight,
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
          Text(
            subTitle,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
