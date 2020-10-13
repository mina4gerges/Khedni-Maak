import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:khedni_maak/config/palette.dart';
import 'package:khedni_maak/login/login_screen.dart';

class IntroductionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OnBoardingPage();
  }
}

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

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

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = const PageDecoration(
      pageColor: Colors.white,
      bodyTextStyle: bodyStyle,
      imagePadding: EdgeInsets.zero,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          body: "Intro 1",
          title: "Khedni Maak 1",
          decoration: pageDecoration,
          image: _buildImage('introduction1'),
        ),
        PageViewModel(
          body: "Intro 2",
          title: "Khedni Maak 2",
          decoration: pageDecoration,
          image: _buildImage('introduction2'),
        ),
        PageViewModel(
          body: "Intro 3",
          title: "Khedni Maak 3",
          decoration: pageDecoration,
          image: _buildImage('introduction3'),
        ),
        PageViewModel(
          body: "Intro 4",
          title: "Khedni Maak 4",
          decoration: pageDecoration,
          image: _buildImage('introduction4'),
        ),
      ],
      skipFlex: 0,
      nextFlex: 0,
      showSkipButton: true,
      curve: Curves.bounceIn,
      skip: const Text('Skip'),
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
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
}
