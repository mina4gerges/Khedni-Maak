import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:khedni_maak/screens/map_screen.dart';
import 'package:khedni_maak/screens/rides_screen.dart';
import 'package:provider/provider.dart';
import 'config/Secrets.dart';
import 'context/nav_bar_provider.dart';
import 'context/notification_provider.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: NotificationProvider(),
        ),
        ChangeNotifierProvider.value(
          value: NavbarProvider(),
        ),
      ],
      child: MaterialApp(
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
          '/auth/DashboardScreen/navBar/mapScreen': (BuildContext context) {
            return MapScreen(
                apiKey: Secrets.API_KEY, initialPosition: LatLng(0, 0));
          },
          '/auth/DashboardScreen/navBar/driverRidesScreen':
              (BuildContext context) {
            return RidesScreen(source: 'driver');
          },
          '/auth/DashboardScreen/navBar/riderRidesScreen':
              (BuildContext context) {
            return RidesScreen(source: 'rider');
          },
        },
      ),
    );
  }
}
