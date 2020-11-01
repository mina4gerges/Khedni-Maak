import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:khedni_maak/config/constant.dart';
import 'package:khedni_maak/widgets/model/user.dart';
import 'package:khedni_maak/config/globals.dart' as globals;


class Functions {
  static String getGreetings() {
    int hour = DateTime.now().hour;

    if (hour <= 12) {
      return 'Good Morning';
    }
    if (hour <= 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }

  static Future<User> getUserInfo(username, token) async {

    if(token==null || token == ''){
      String fullName = globals.userFullName;

      return User(
        name: fullName.split(' ')[0],
        lastName: fullName.split(' ')[1],
        email: globals.email,
        userName: globals.loginUserName,
      );
    }

    final response = await http.get(
      '$baseUrl/usersId/$username',
      headers: <String, String>{'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {

      String fullName = json.decode(response.body)['name'];

      return User(
        name: fullName.split(' ')[0],
        lastName: fullName.split(' ')[1],
        email: json.decode(response.body)['email'],
        userName: json.decode(response.body)['username'],
      );
    } else {
      print('failed: user info');
    }
    return User(
      name: '',
      lastName: '',
      email: '',
      userName: '',
    );
  }
}
