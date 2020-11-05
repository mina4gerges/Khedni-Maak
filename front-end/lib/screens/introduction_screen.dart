import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:introduction_screen/introduction_screen.dart';
import 'package:khedni_maak/config/constant.dart';
import 'package:khedni_maak/config/palette.dart';
import 'package:khedni_maak/login/login_screen.dart';

class IntroductionView extends StatefulWidget {
  static const routeName = '/';

  @override
  _IntroductionViewState createState() => _IntroductionViewState();
}

class _IntroductionViewState extends State<IntroductionView> {
  final introKey = GlobalKey<IntroductionScreenState>();
  bool displayIntroductionScreen = false;

  @override
  void initState() {
    super.initState();
    _startTime();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future _getIntroductionScreens() async {
    return await http.get('$baseUrlIntroductionScreen/screens');
  }

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }

  Widget _buildImage(String assetName) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Image.asset('assets/images/$assetName.jpg', width: 350.0),
    );
  }

  _displayPage(Map screen) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = const PageDecoration(
      pageColor: Colors.white,
      bodyTextStyle: bodyStyle,
      imagePadding: EdgeInsets.zero,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
    );

    return PageViewModel(
      body: screen["body"],
      title: screen["title"],
      decoration: pageDecoration,
      image: _buildImage(screen["image"]),
    );
  }

  _displayPages(List screens) {
    List<PageViewModel> finalScreens = [];

    for (int i = 0; i < screens.length; i++) {
      finalScreens.add(_displayPage(screens[i]));
    }

    return finalScreens;
  }

  _startTime() async {
    var _duration = new Duration(seconds: 2);
    return new Timer(
        _duration,
        () => setState(() {
              displayIntroductionScreen = true;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getIntroductionScreens(),
      builder: (context, snap) {
        if (!displayIntroductionScreen ||
            snap.connectionState == ConnectionState.waiting)
          // return const Center(child: CircularProgressIndicator());
          return new Scaffold(
            backgroundColor: Palette.primaryColor,
            body: new Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/truck.png',
                      width: 200, height: 200),
                  const Center(
                    child: SpinKitThreeBounce(
                      color: Colors.white,
                      size: 25.0,
                    ),
                  ),
                ],
              ),
            ),
          );
        else if (snap.data == null || snap.data.statusCode == 500) {
          return Center(
            child: Text(
              "Error occurred",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        } else {
          List screens = json.decode(snap.data.body);

          return IntroductionScreen(
            key: introKey,
            pages: _displayPages(screens),
            skipFlex: 0,
            nextFlex: 0,
            showSkipButton: true,
            curve: Curves.bounceIn,
            skip: const Text('Skip'),
            onDone: () => _onIntroEnd(context),
            onSkip: () => _onIntroEnd(context),
            next: const Icon(Icons.arrow_forward),
            done: const Text('Done',
                style: TextStyle(fontWeight: FontWeight.w600)),
            dotsDecorator: const DotsDecorator(
              size: Size(10.0, 10.0),
              color: Color(0xFFBDBDBD),
              activeSize: Size(22.0, 10.0),
              activeColor: Palette.primaryColor,
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
            ),
          );
        }
      },
    );
  }
}
