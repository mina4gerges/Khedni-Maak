import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:khedni_maak/functions/functions.dart';
import 'package:khedni_maak/widgets/model/user.dart';

class UserProfile extends StatefulWidget {
  UserProfile({
    Key key,
  }) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
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
    return FutureBuilder<User>(
      future: user,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text('${Functions.getGreetings()}, ${snapshot.data.name}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ));
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        // By default, show a loading spinner.
        return CircularProgressIndicator();
      },
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Hello, Mina',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
