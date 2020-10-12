import 'package:flutter/material.dart';
import 'package:khedni_maak/widgets/dashboard_header.dart';
import 'package:khedni_maak/widgets/pic_card.dart';

class DashboardScreen extends StatelessWidget {
  void goToDriverScreen() {
    print('hello from goToDriverScreen');
  }

  void goToPassengerScreen() {
    print('hello from goToPassengerScreen');
  }

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
                pic: 'own_test.png',
                screenHeight: screenHeight,
                onCardTap: goToDriverScreen,
              ),
              BuildPicCard(
                title: 'Find a ride',
                body: 'You can find someone is sharing his car',
                pic: 'own_test.png',
                screenHeight: screenHeight,
                onCardTap: goToPassengerScreen,
              ),
              SizedBox(height: screenHeight * 0.05),
            ],
          ),
        ],
      ),
    );
  }
}
