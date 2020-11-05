import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:khedni_maak/config/constant.dart';
import 'package:khedni_maak/widgets/model/user.dart';


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

    final response = await http.get(
      '$baseUrl/usersId/$username',
      headers: <String, String>{'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {

      String fullName = json.decode(response.body)['name'];

      return User(
        fullName:fullName,
        name: fullName.split(' ')[0],
        lastName: fullName.split(' ')[1],
        email: json.decode(response.body)['email'],
        phoneNumber:json.decode(response.body)["phone"],
        userName: json.decode(response.body)['username'],
      );
    } else {
      print('failed: user info');
    }
    return User(
      name: '',
      email: '',
      lastName: '',
      fullName:'',
      userName: '',
      phoneNumber:'',
    );
  }

  static String upperCaseFirstChar(String name){
    return name.substring(0, 1).toUpperCase() + name.substring(1);
  }
}
