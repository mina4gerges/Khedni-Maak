import 'package:flutter/material.dart';
import 'package:khedni_maak/widgets/pic_card.dart';
import 'package:khedni_maak/login/custom_route.dart';
import 'package:khedni_maak/widgets/nav_bar_main.dart';
import 'package:khedni_maak/widgets/dashboard_header.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key key}) : super(key: key);
  static const routeName = '/auth/DashboardScreen';

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  void initState() {
    super.initState();

    _firebaseMessaging.subscribeToTopic("all-users");
    print("firebase subscribeToTopic : all-users");

    configureFireBase();
  }

  void configureFireBase(){
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");

        // final notification = message['notification'];

        // setState(() {
        //   messages.add(Message(
        //       title: notification['title'], body: notification['body']));
        // });
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");

        // final notification = message['data'];

        // setState(() {
        //   messages.add(Message(
        //       title: notification['title'], body: notification['body']));
        // });
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");

        // final notification = message['data'];

        // setState(() {
        //   messages.add(Message(
        //       title: notification['title'], body: notification['body']));
        // });
      },
    );
  }

  _onCardTap(BuildContext context, String source) {
    Navigator.of(context).push(
      FadePageRoute(
        builder: (_) => NavBarMain(source: source),
      ),
    );
  }

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
                            onCardTap: () => {_onCardTap(context, 'driver')},
                          ),
                          BuildPicCard(
                            title: 'Find a ride',
                            body: 'You can find someone is sharing his car',
                            pic: 'truck.png',
                            screenHeight: screenHeight,
                            onCardTap: () => {_onCardTap(context, 'rider')},
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
