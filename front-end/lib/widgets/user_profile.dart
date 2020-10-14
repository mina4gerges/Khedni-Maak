import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khedni_maak/functions/functions.dart';
import 'package:khedni_maak/widgets/model/user.dart';
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
  Future<User> user;

  @override
  void initState() {
    super.initState();

    String token = globals.loginToken;

    String username = globals.loginUserName;

    user = Functions.getUserInfo(username, token);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: user,
      builder: (context, snapshot) {
        String name = snapshot.hasData ? snapshot.data.name : '';
        String capitalizedName = name.isNotEmpty
            ? ', ${name[0].toUpperCase() + name.substring(1)}'
            : '';

        return Expanded(
          child: Text(
            '${Functions.getGreetings()}$capitalizedName',
            style: TextStyle(
              color: Colors.white,
              fontSize: widget.screenHeight * 0.05,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}
