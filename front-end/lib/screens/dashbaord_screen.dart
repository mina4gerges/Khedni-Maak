import 'package:flutter/material.dart';
import 'package:khedni_maak/widgets/custom_app_bar.dart';
import 'package:khedni_maak/widgets/patient_profile.dart';
import 'package:khedni_maak/widgets/pic_card.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // appBar: CustomAppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          PatientProfile(screenHeight: screenHeight),
          BuildPicCard(
            title: 'Offer a ride',
            body: 'You can share your car with someone',
            pic: 'own_test.png',
            screenHeight: screenHeight,
          ),
          BuildPicCard(
            title: 'Find a ride',
            body: 'You can find someone is sharing his car',
            pic: 'own_test.png',
            screenHeight: screenHeight,
          ),
        ],
      ),
    );
  }
}
