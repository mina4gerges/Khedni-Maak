import 'package:flutter/material.dart';
import 'package:khedni_maak/config/palette.dart';

class BuildPicCard extends StatelessWidget {
  BuildPicCard({
    Key key,
    @required this.pic,
    @required this.body,
    @required this.title,
    @required this.screenHeight,
    @required this.onCardTap,
  }) : super(key: key);

  final String pic;
  final String body;
  final String title;
  final double screenHeight;
  final VoidCallback onCardTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 20.0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: InkWell(
        splashColor: Palette.primaryColor,
        onTap: onCardTap,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Palette.gradientPrimaryColor, Palette.primaryColor],
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
          height: screenHeight * 0.27,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.asset('assets/images/$pic',width: 100,),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      body,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
