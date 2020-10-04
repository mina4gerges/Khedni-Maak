import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'google_map/main.dart';
import 'google_map/test_map/Secrets.dart';
import 'login/login_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor:
          SystemUiOverlayStyle.dark.systemNavigationBarColor,
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(title: 'Start screen', home: LoginScreen()
    return MaterialApp(title: 'Start screen', home: MapMain(
        apiKey: Secrets.API_KEY,
        initialPosition: LatLng(-29.8567844, 101.213108))
//        home: MapMain()
//        home: IntroductionView()
        //        home: PostsPage());

        );
  }
}
