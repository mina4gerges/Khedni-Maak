import 'dart:math';
import 'package:khedni_maak/screens/drivers_screen.dart';

import 'nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:khedni_maak/config/Secrets.dart';
import 'package:khedni_maak/widgets/custom_app_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:khedni_maak/google_map/test_map/new/src/place_picker.dart';

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
  int _selectedNavIndex = 0;
  String _appBarTitle;

  List<Widget> _viewsByIndex;

  @override
  void initState() {
    super.initState();
    //264653
    //2a9d8f
    //e9c46a
    //f4a261
    //e76f51
    if (widget.source == 'driver') {
      _appBarTitle='Dirver';
      //Declare some buttons for our tab bar
      _navBarItems = [
        NavBarItemData("Map", OMIcons.directions, 100, Color(0xff264653)),
        NavBarItemData("Rides", OMIcons.list, 100, Color(0xffe9c46a)),
        NavBarItemData("Notification", OMIcons.notifications, 135, Color(0xfff4a261)),
      ];

      //Create the views which will be mapped to the indices for our nav btns
      _viewsByIndex = <Widget>[
        PlacePicker(
            apiKey: Secrets.API_KEY,
            initialPosition: LatLng(-29.8567844, 101.213108)),
        Text('hi from driver Rides'),
        Text('hi from driver notification'),
      ];
    } else {
      _appBarTitle='Rider';

      //Declare some buttons for our tab bar
      _navBarItems = [
        NavBarItemData("Rides", OMIcons.list, 100, Color(0xff264653)),
        NavBarItemData("History", OMIcons.history, 110, Color(0xffe9c46a)),
        NavBarItemData("Notification", OMIcons.notifications, 135, Color(0xfff4a261)),
      ];

      //Create the views which will be mapped to the indices for our nav btns
      _viewsByIndex = <Widget>[
        DriverScreen(),
        Text('hi from rider History'),
        Text('hi from rider notification'),
      ];
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
      appBar: CustomAppBar(title:_appBarTitle),
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

  void _handleNavBtnTapped(int index) {
    //Save the new index and trigger a rebuild
    setState(() {
      //This will be passed into the NavBar and change it's selected state, also controls the active content page
      _selectedNavIndex = index;
    });
  }
}
