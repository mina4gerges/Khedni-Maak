import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
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
        fullName: fullName,
        name: fullName.split(' ')[0],
        lastName: fullName.split(' ')[1],
        email: json.decode(response.body)['email'],
        phoneNumber: json.decode(response.body)["phone"],
        userName: json.decode(response.body)['username'],
      );
    } else {
      print('failed: user info');
    }
    return User(
      name: '',
      email: '',
      lastName: '',
      fullName: '',
      userName: '',
      phoneNumber: '',
    );
  }

  static String upperCaseFirstChar(String name) {
    return name.substring(0, 1).toUpperCase() + name.substring(1);
  }

  static String timeAgoSinceDate(String dateString,
      {bool numericDates = true}) {
    DateTime notificationDate =
        DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateString);
    final date2 = DateTime.now();
    final difference = date2.difference(notificationDate);

    if (difference.inDays > 8) {
      return dateString;
    } else if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }

  //filter routes with status 1 (available)
  static List filterRoutesStatus(
      List routes, String userFullName, String source) {
    //show only driver route
    if (source == 'driver')
      return routes
          .where((route) =>
              route["status"] == 1 && route['driverUsername'] == userFullName)
          .toList();
    //show all routes different then loginUserName
    else
      return routes
          .where((route) =>
              route["passengers"].indexOf(userFullName) == -1 &&
              route["status"] == 1 &&
              route['driverUsername'] != userFullName)
          .toList();
  }

  static List getHistoryList(List routes, String userFullName) {
    return routes
        .where((route) => route["passengers"].indexOf(userFullName) > -1)
        .toList();
  }
}
