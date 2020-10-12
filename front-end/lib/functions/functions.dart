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
      print('success: patient info');
      return User(
        name: 'mina',
        lastName: 'gerges',
        email: 'mina@gmail.com',
        userName: 'mina@gmail.com',
      );
    } else {
      print('failed: patient info');
    }
    return User(
      name: '',
      lastName: '',
      email: '',
      userName: '',
    );
  }
}
