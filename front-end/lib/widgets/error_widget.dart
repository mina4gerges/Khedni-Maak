import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorWidgetDisplay extends StatelessWidget{

  ErrorWidgetDisplay({
    Key key,
    this.title,
    this.subTitle,
    this.imagePath,
  }) : super(key: key);

  final String title;
  final String subTitle;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/$imagePath',
            width: 100,
            height: 100,
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