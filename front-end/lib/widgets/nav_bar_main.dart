import 'dart:math';

import 'package:fleva_icons/fleva_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:khedni_maak/config/Secrets.dart';
import 'package:khedni_maak/config/palette.dart';
import 'package:khedni_maak/screens/rides_screen.dart';
import 'package:khedni_maak/screens/map_screen.dart';
import 'package:khedni_maak/utils/nav_bar/nav_bar.dart';
import 'package:khedni_maak/widgets/custom_app_bar.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

class NavBarMain extends StatefulWidget {
  static const routeName = '/auth/DashboardScreen/navBar';

  NavBarMain({
    Key key,
    @required this.source,
  }) : super(key: key);

  final String source;

  @override
  _NavBarMainState createState() => _NavBarMainState();
}

class _NavBarMainState extends State<NavBarMain> {
  List<NavBarItemData> _navBarItems;
  List<Widget> _viewsByIndex;
  List<String> _appBarTitles;

  int _selectedNavIndex = 0;

  @override
  void initState() {
    super.initState();

    //user is driver
    if (widget.source == 'driver') {
      //Declare some buttons for our tab bar
      _navBarItems = <NavBarItemData>[
        NavBarItemData("Map", FlevaIcons.map_outline, 100, Palette.secondColor),
        NavBarItemData("Rides", OMIcons.list, 100, Palette.thirdColor),
        NavBarItemData(
            "Notification", OMIcons.notifications, 135, Palette.fourthColor),
      ];

      //Create the views which will be mapped to the indices for our nav btns
      _viewsByIndex = <Widget>[
        MapScreen(apiKey: Secrets.API_KEY, initialPosition: LatLng(0, 0)),
        RidesScreen(
          source: 'driver',
          moveToPolyLines: (polyLines, lngFrom, latFrom, lngTo, latTo) =>
              {_moveToPolyLines(polyLines, lngFrom, latFrom, lngTo, latTo)},
        ),
        Text('hi from driver notification'),
      ];

      //Declare app bar titles
      _appBarTitles = <String>["Map", "My Rides", "Notification"];
    }
    //user is rider
    else {
      //Declare some buttons for our tab bar
      _navBarItems = <NavBarItemData>[
        NavBarItemData("Rides", OMIcons.list, 100, Palette.secondColor),
        NavBarItemData("History", OMIcons.history, 110, Palette.thirdColor),
        NavBarItemData(
            "Notification", OMIcons.notifications, 135, Palette.fourthColor),
      ];

      //Create the views which will be mapped to the indices for our nav btns
      _viewsByIndex = <Widget>[
        RidesScreen(
          source: 'rider',
          moveToPolyLines: (polyLines, lngFrom, latFrom, lngTo, latTo) =>
              {_moveToPolyLines(polyLines, lngFrom, latFrom, lngTo, latTo)},
        ),
        Text('hi from rider History'),
        Text('hi from rider notification'),
      ];

      //Declare app bar titles
      _appBarTitles = <String>["Available Rides", "History", "Notification"];
    }
  }

  @override
  Widget build(BuildContext context) {
    //Create custom navBar, pass in a list of buttons, and listen for tap event
    var navBar = NavBar(
      items: _navBarItems,
      itemTapped: _handleNavBtnTapped,
      currentIndex: _selectedNavIndex,
    );

    //Display the correct child view for the current index
    var contentView =
        _viewsByIndex[min(_selectedNavIndex, _viewsByIndex.length - 1)];

    //Wrap our custom navbar + contentView with the app Scaffold
    return Scaffold(
      appBar: CustomAppBar(title: _appBarTitles[_selectedNavIndex]),
      backgroundColor: Color(0xffE6E6E6),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          //Wrap the current page in an AnimatedSwitcher for an easy cross-fade effect
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 350),
            //Pass the current accent color down as a theme, so our overscroll indicator matches the btn color
            child: contentView,
          ),
        ),
      ),
      bottomNavigationBar: navBar, //Pass our custom navBar into the scaffold
    );
  }

  void _goToMap() {
    setState(() {
      _selectedNavIndex = 0;
    });
  }

  void _moveToPolyLines(Map<PolylineId, Polyline> polylines, double lngFrom,
      double latFrom, double lngTo, double latTo) {
    _goToMap();

    setState(() {
      _viewsByIndex = <Widget>[
        MapScreen(
          apiKey: Secrets.API_KEY,
          initialPosition: LatLng(0, 0),
          polylines: polylines,
          lngFrom: lngFrom,
          latFrom: latFrom,
          lngTo: lngTo,
          latTo: latTo,
        ),
        RidesScreen(
          source: widget.source,
          moveToPolyLines: (polyLines, lngFrom, latFrom, lngTo, latTo) =>
              {_moveToPolyLines(polyLines, lngFrom, latFrom, lngTo, latTo)},
        ),
        Text('hi from driver notification'),
      ];
    });
  }

  void _handleNavBtnTapped(int index) {
    //Save the new index and trigger a rebuild
    setState(() {
      //user is driver
      if (widget.source == 'driver') {
        //Create the views which will be mapped to the indices for our nav btns
        _viewsByIndex = <Widget>[
          MapScreen(apiKey: Secrets.API_KEY, initialPosition: LatLng(0, 0)),
          RidesScreen(
            source: 'driver',
            moveToPolyLines: (polyLines, lngFrom, latFrom, lngTo, latTo) =>
                {_moveToPolyLines(polyLines, lngFrom, latFrom, lngTo, latTo)},
          ),
          Text('hi from driver notification'),
        ];
      }
      //user is rider
      else {
        //Create the views which will be mapped to the indices for our nav btns
        _viewsByIndex = <Widget>[
          RidesScreen(
            source: 'rider',
            moveToPolyLines: (polyLines, lngFrom, latFrom, lngTo, latTo) =>
                {_moveToPolyLines(polyLines, lngFrom, latFrom, lngTo, latTo)},
          ),
          Text('hi from rider History'),
          Text('hi from rider notification'),
        ];
      }
      //This will be passed into the NavBar and change it's selected state, also controls the active content page
      _selectedNavIndex = index;
    });
  }
}
