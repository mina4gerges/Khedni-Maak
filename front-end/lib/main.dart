import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:khedni_maak/google_map/map_main.dart';
//import 'package:khedni_maak/test_widgets/post.dart';

import 'introduction_screen/introduction_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor:
          SystemUiOverlayStyle.dark.systemNavigationBarColor,
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Start screen', home: MapMain()
//        home: IntroductionView()
        //        home: PostsPage());

        );
  }
}
