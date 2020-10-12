import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khedni_maak/config/palette.dart';
import 'package:khedni_maak/functions/functions.dart';
import 'package:khedni_maak/widgets/model/user.dart';
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
  Future<User> user;

  String token =
      'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJtaW5hQGdtYWlsLmNvbSIsInNjb3BlcyI6WyJST0xFX0FETUlOIl0sImlhdCI6MTYwMjUwMDIyOCwiZXhwIjoxNjAyNTE4MjI4fQ.sRIfrq7MLQ1xBhNenh3hUyKPKzM4-YzEMqKJCLRouZ4';

  String username = 'mina@gmail.com';

  @override
  void initState() {
    super.initState();
    user = Functions.getUserInfo(username, token);
  }

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
          SizedBox(height: widget.screenHeight * 0.03),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[UserProfile()],
          ),
          SizedBox(height: widget.screenHeight * 0.03),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Are you ready for a new ride ?',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: widget.screenHeight * 0.01),
              Text(
                'What do you want to do do today ?',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 15.0,
                ),
              ),
              SizedBox(height: widget.screenHeight * 0.03),
            ],
          )
        ],
      ),
    );
  }
}
