import 'package:flutter/material.dart';
import 'package:khedni_maak/login/custom_route.dart';
import 'package:khedni_maak/nav_bar/nav_bar_main.dart';
import 'package:khedni_maak/widgets/dashboard_header.dart';
import 'package:khedni_maak/widgets/pic_card.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = '/auth/DashboardScreen';

  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // appBar: CustomAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          DashboardHeader(screenHeight: screenHeight),
          Column(
            children: <Widget>[
              BuildPicCard(
                title: 'Offer a ride',
                body: 'You can share your car with someone',
                pic: 'driver.png',
                screenHeight: screenHeight,
                onCardTap: () {
                  Navigator.of(context).push(
                      FadePageRoute(builder: (_) => NavBarMain(source: 'driver')));
                },
              ),
              BuildPicCard(
                title: 'Find a ride',
                body: 'You can find someone is sharing his car',
                pic: 'truck.png',
                screenHeight: screenHeight,
                onCardTap: () {
                  Navigator.of(context).push(
                      FadePageRoute(builder: (_) => NavBarMain(source: 'rider')));
                },
              ),
              SizedBox(height: screenHeight * 0.05),
            ],
          ),
        ],
      ),
    );
  }
}
