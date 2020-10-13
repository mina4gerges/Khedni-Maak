import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:khedni_maak/google_map/main.dart';
// import 'package:khedni_maak/google_map/test_map/new/google_maps_place_picker.dart';
import 'package:khedni_maak/introduction_screen/introduction_screen.dart';
// import 'package:khedni_maak/screens/dashbaord_screen.dart';

// import 'firebase_config/firebase_main.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Start screen', home: IntroductionView());
    // return MaterialApp(title: 'Start screen', home: PlacePicker(apiKey: Secrets.API_KEY, initialPosition: LatLng(-29.8567844, 101.213108)));
    // return MaterialApp(title: 'Start screen', home: FireBaseMain(appTitle:"Hello from fire base notificationnn"));
    // return MaterialApp(title: 'Start screen', home: MapMain(initialPosition:LatLng(0, 0)));
    // return MaterialApp(
    //   title: 'Khedni Maak',
    //   home: DashboardScreen(),
    //   debugShowCheckedModeBanner: false,
    // );
  }
}
