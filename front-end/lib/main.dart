import 'package:flutter/material.dart';
import 'login/login_screen.dart';
import 'widgets/nav_bar_main.dart';
import 'login/transition_route_observer.dart';
import 'package:khedni_maak/screens/dashbaord_screen.dart';
import 'package:khedni_maak/screens/introduction_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Khedni Maak',
      home: IntroductionView(),
      debugShowCheckedModeBanner: false,
      navigatorObservers: [TransitionRouteObserver()],
      routes: <String, WidgetBuilder>{
        '/auth': (BuildContext context) {
          return LoginScreen();
        },
        '/auth/DashboardScreen': (BuildContext context) {
          return DashboardScreen();
        },
        '/auth/DashboardScreen/navBar': (BuildContext context) {
          return NavBarMain(source: 'driver');
        },
      },
    );
  }
}
