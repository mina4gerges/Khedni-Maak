import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khedni_maak/functions/functions.dart';
import 'package:khedni_maak/config/globals.dart' as globals;

class UserProfile extends StatefulWidget {
  UserProfile({
    Key key,
    @required this.screenHeight,
  }) : super(key: key);

  final double screenHeight;

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final String username = globals.loginUserName;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        '${Functions.getGreetings()}, ${globals.userFullName.split(' ')[0]}',
        style: TextStyle(
          color: Colors.white,
          fontSize: widget.screenHeight * 0.05,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
