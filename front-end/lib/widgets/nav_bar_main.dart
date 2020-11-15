import 'package:badges/badges.dart';
import 'package:fleva_icons/fleva_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:khedni_maak/config/Secrets.dart';
import 'package:khedni_maak/context/nav_bar_provider.dart';
import 'package:khedni_maak/context/notification_provider.dart';
import 'package:khedni_maak/screens/history_screen.dart';
import 'package:khedni_maak/screens/map_screen.dart';
import 'package:khedni_maak/screens/notification_driver_screen.dart';
import 'package:khedni_maak/screens/notification_rider_screen.dart';
import 'package:khedni_maak/screens/rides_screen.dart';
import 'package:khedni_maak/widgets/custom_app_bar.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';

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
  _onTabChange(int newIndex, NavbarProvider navBarProvider) {
    navBarProvider.setTabIndex(newIndex);
  }

  _tabView(NavbarProvider navBarProvider) {
    if (navBarProvider.getTabIndex == 0) {
      if (widget.source == 'driver')
        return MapScreen(
            apiKey: Secrets.API_KEY, initialPosition: LatLng(0, 0));

      return RidesScreen(source: 'rider'
          //   moveToPolyLines: (polyLines, lngFrom, latFrom, lngTo, latTo) =>
          //   {_moveToPolyLines(polyLines, lngFrom, latFrom, lngTo, latTo)},
          );
    } else if (navBarProvider.getTabIndex == 1) {
      if (widget.source == 'driver')
        return RidesScreen(
          source: 'driver',
          // moveToPolyLines: (polyLines, lngFrom, latFrom, lngTo, latTo) =>
          // {_moveToPolyLines(polyLines, lngFrom, latFrom, lngTo, latTo)},
        );
      return HistoryScreen(source: 'rider', navSource: 'history');
    } else {
      if (widget.source == 'driver')
        return NotificationDriverScreen(source: widget.source);
      else
        return NotificationRiderScreen(source: widget.source);
    }
  }

  _getAppBarTitle(NavbarProvider navBarProvider) {
    List driverAppBarTitle = ["Map", "My Rides", "Notification"];
    List riderAppBarTitle = ["Available Rides", "History", "Notification"];

    return widget.source == 'driver'
        ? driverAppBarTitle[navBarProvider.getTabIndex]
        : riderAppBarTitle[navBarProvider.getTabIndex];
  }

  @override
  Widget build(BuildContext context) {
    NavbarProvider navBarProvider = Provider.of<NavbarProvider>(context);

    NotificationProvider notificationProvider =
        Provider.of<NotificationProvider>(context);

    List notificationsAddRoute = notificationProvider.getNotificationsAddRoute;

    List notificationsRiderRequest =
        notificationProvider.getNotificationsRiderRequest;

    return Scaffold(
      bottomNavigationBar: _bottomNavigationBar(
          notificationsAddRoute, notificationsRiderRequest, navBarProvider),
      appBar: CustomAppBar(
          title: Text(
            _getAppBarTitle(navBarProvider),
          ),
          onBackClick:()=> _onTabChange(0, navBarProvider),
      ),
      backgroundColor: Color(0xffE6E6E6),
      body: _tabView(navBarProvider),
    );
  }

  Widget _bottomNavigationBar(List notificationsAddRoute,
      List notificationsRiderRequest, NavbarProvider navBarProvider) {
    return BottomNavigationBar(
      currentIndex: navBarProvider.getTabIndex,
      onTap: (newIndex) => {_onTabChange(newIndex, navBarProvider)},
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
        widget.source == 'driver'
            ? BottomNavigationBarItem(
                label: 'Notification',
                icon: notificationsRiderRequest.length == 0
                    ? Icon(OMIcons.notifications)
                    : Badge(
                        padding: EdgeInsets.all(4),
                        child: Icon(OMIcons.notifications),
                        badgeContent: Container(
                          child: Text(
                            "${notificationsRiderRequest.length}",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
              )
            : BottomNavigationBarItem(
                label: 'Notification',
                icon: notificationsAddRoute.length == 0
                    ? Icon(OMIcons.notifications)
                    : Badge(
                        padding: EdgeInsets.all(4),
                        child: Icon(OMIcons.notifications),
                        badgeContent: Container(
                          child: Text(
                            "${notificationsAddRoute.length}",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
              ),
      ],
    );
  }
}
