import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khedni_maak/config/palette.dart';
import 'package:khedni_maak/widgets/user_profile.dart';

class DashboardHeader extends StatefulWidget {
  DashboardHeader({
    Key key,
    @required this.screenHeight,
  }) : super(key: key);

  final double screenHeight;

  @override
  _DashboardHeaderState createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Palette.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40.0),
          bottomRight: Radius.circular(40.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: widget.screenHeight * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[UserProfile(screenHeight: widget.screenHeight)],
          ),
          SizedBox(height: widget.screenHeight * 0.02),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Are you ready for a new ride ?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: widget.screenHeight * 0.04,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: widget.screenHeight * 0.02),
              Text(
                'What do you want to do today ?',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: widget.screenHeight * 0.02,
                ),
              ),
              SizedBox(height: widget.screenHeight * 0.01),
            ],
          )
        ],
      ),
    );
  }
}
