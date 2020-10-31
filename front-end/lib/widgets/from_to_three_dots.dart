import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FromToThreeDots extends StatelessWidget{

  @override
  Widget build(BuildContext context){
       return Column(
      children: <Widget>[
        SizedBox(height: 12),
        Icon(FontAwesomeIcons.dotCircle, color: Colors.green),
        SizedBox(height: 5),
        Container(
          width: 5.0,
          height: 5.0,
          decoration: new BoxDecoration(
            color: Colors.grey[400],
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(height: 5),
        Container(
          width: 5.0,
          height: 5.0,
          decoration: new BoxDecoration(
            color: Colors.grey[400],
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(height: 5),
        Container(
          width: 5.0,
          height: 5.0,
          decoration: new BoxDecoration(
            color: Colors.grey[400],
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(height: 5),
        Icon(FontAwesomeIcons.dotCircle, color: Colors.blue),
      ],
    );

  }
}