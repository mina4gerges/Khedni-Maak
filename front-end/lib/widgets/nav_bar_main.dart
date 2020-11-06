import 'package:badges/badges.dart';
import 'package:fleva_icons/fleva_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:khedni_maak/config/Secrets.dart';
import 'package:khedni_maak/screens/history_screen.dart';
import 'package:khedni_maak/screens/map_screen.dart';
import 'package:khedni_maak/screens/notification_screen.dart';
import 'package:khedni_maak/screens/rides_screen.dart';
import 'package:khedni_maak/widgets/custom_app_bar.dart';
import 'package:outline_material_icons/outline_material_icons.dart';

class NavBarMain extends StatefulWidget {
  NavBarMain({
    Key key,
    @required this.source,
  }) : super(key: key);

  final String source;

  @override
  _NavBarMainState createState() => _NavBarMainState();
}

class _NavBarMainState extends State<NavBarMain> {
  int currentIndex = 0;

  _onTabChange(int newIndex) {
    setState(() {
      currentIndex = newIndex;
    });
  }

  _tabView() {
    if (currentIndex == 0) {
      if (widget.source == 'driver')
        return MapScreen(
            apiKey: Secrets.API_KEY, initialPosition: LatLng(0, 0));

      return RidesScreen(source: 'rider'
          //   moveToPolyLines: (polyLines, lngFrom, latFrom, lngTo, latTo) =>
          //   {_moveToPolyLines(polyLines, lngFrom, latFrom, lngTo, latTo)},
          );
    } else if (currentIndex == 1) {
      if (widget.source == 'driver')
        return RidesScreen(
          source: 'driver',
          // moveToPolyLines: (polyLines, lngFrom, latFrom, lngTo, latTo) =>
          // {_moveToPolyLines(polyLines, lngFrom, latFrom, lngTo, latTo)},
        );
      return HistoryScreen();
    } else {
      return NotificationScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomNavigationBar(),
      appBar: CustomAppBar(title: Text('test')),
      backgroundColor: Color(0xffE6E6E6),
      body: _tabView(),
    );
  }

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (newIndex) => {_onTabChange(newIndex)},
      items: [
        BottomNavigationBarItem(
          label: widget.source == 'driver' ? 'Map' : 'Available Rides',
          icon: Icon(widget.source == 'driver'
              ? FlevaIcons.map_outline
              : OMIcons.list),
        ),
        BottomNavigationBarItem(
          label: widget.source == 'driver' ? 'My Rides' : 'History',
          icon:
              Icon(widget.source == 'driver' ? OMIcons.list : OMIcons.history),
        ),
        BottomNavigationBarItem(
          label: 'Notification',
          icon: Badge(
            shape: BadgeShape.circle,
            borderRadius: BorderRadius.circular(100),
            child: Icon(OMIcons.notifications),
            badgeContent: Container(
              height: 5,
              width: 5,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
