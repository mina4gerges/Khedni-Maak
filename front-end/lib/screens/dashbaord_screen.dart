import 'package:flutter/material.dart';
import 'package:khedni_maak/widgets/nav_bar_main.dart';
import 'package:khedni_maak/widgets/pic_card.dart';
import 'package:khedni_maak/login/custom_route.dart';
import 'package:khedni_maak/widgets/dashboard_header.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({Key key}) : super(key: key);
  static const routeName = '/auth/DashboardScreen';

  @override
  Widget build(BuildContext context) {
    const Key centerKey = ValueKey('bottom-sliver-list');
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: CustomScrollView(
        center: centerKey,
        slivers: <Widget>[
          SliverList(
            key: centerKey,
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      DashboardHeader(screenHeight: screenHeight),
                      SizedBox(height: screenHeight * 0.03),
                      Column(
                        children: <Widget>[
                          BuildPicCard(
                            title: 'Offer a ride',
                            body: 'You can share your car with someone',
                            pic: 'driver.png',
                            screenHeight: screenHeight,
                            onCardTap: () {
                              Navigator.of(context).push(FadePageRoute(
                                  builder: (_) =>
                                      NavBarMain(source: 'driver')));
                            },
                          ),
                          BuildPicCard(
                            title: 'Find a ride',
                            body: 'You can find someone is sharing his car',
                            pic: 'truck.png',
                            screenHeight: screenHeight,
                            onCardTap: () {
                              Navigator.of(context).push(FadePageRoute(
                                  builder: (_) => NavBarMain(source: 'rider')));
                            },
                          ),
                          SizedBox(height: screenHeight * 0.05),
                        ],
                      ),
                    ],
                  ),
                );
              },
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }
}
