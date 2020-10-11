import 'package:flutter/material.dart';
import 'package:khedni_maak/config/palette.dart';

class BuildPicCard extends StatelessWidget {
  BuildPicCard({
    Key key,
    @required this.pic,
    @required this.body,
    @required this.title,
    @required this.screenHeight,
  }) : super(key: key);

  final String pic;
  final String body;
  final String title;
  final double screenHeight;

  @override
  Widget build(BuildContext context) {
      return Container(
        margin: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 20.0,
        ),
        padding: const EdgeInsets.all(10.0),
        height: screenHeight * 0.17,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Palette.gradientPrimaryColor, Palette.primaryColor],
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Image.asset('assets/images/$pic'),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  body,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12.0,
                  ),
                  maxLines: 2,
                ),
              ],
            )
          ],
        ),
    );
  }
}
