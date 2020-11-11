import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:khedni_maak/config/Secrets.dart';
import 'package:khedni_maak/config/constant.dart';
import 'package:khedni_maak/config/globals.dart' as globals;
import 'package:khedni_maak/config/palette.dart';
import 'package:khedni_maak/functions/functions.dart';
import 'package:khedni_maak/widgets/display_flash_bar.dart';
import 'package:khedni_maak/widgets/error_widget.dart';
import 'package:khedni_maak/widgets/routes_list.dart';

class RidesScreen extends StatefulWidget {
  RidesScreen({
    Key key,
    this.moveToPolyLines,
    @required this.source,
  }) : super(key: key);

  final String source;
  final Function(Map<PolylineId, Polyline>, double lngFrom, double latFrom,
      double lngTo, double latTo) moveToPolyLines;

  @override
  _RidesScreenState createState() => _RidesScreenState();
}

class _RidesScreenState extends State<RidesScreen> {
  Future _routesFuture;
  bool isLoadingData = true;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _routesFuture = _getRoutes();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future _getRoutes() async {
    return await http.get('$baseUrlRoutes/routes');
  }

  _removeRide(int routeId) async {
    // Unsubscribe to topic to stop receiving request on this route
    _firebaseMessaging.unsubscribeFromTopic('route-$routeId');

    final http.Response response = await http.put(
      '$baseUrlRoutes/updateStatus',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, Object>{
        "id": routeId,
      }),
    );

    bool isSuccess = response.statusCode == 200;

    DisplayFlashBar.displayFlashBar(isSuccess ? "success" : "failed",
        isSuccess ? "Route deleted" : "Route not deleted", context);

    setState(() {
      _routesFuture = _getRoutes();
    });
  }

  Future<void> _onCardTab(Map route) async {
    Map<PolylineId, Polyline> polylines = await _createPolyLines(route);

    widget.moveToPolyLines(polylines, route["lngStart"], route["latStart"],
        route["lngEnd"], route["latEnd"]);
  }

  _createPolyLines(Map route) async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Secrets.API_KEY, // Google Maps API Key
      PointLatLng(route['latStart'], route['lngStart']),
      PointLatLng(
        route['latEnd'], route['lngEnd'],
        // travelMode: TravelMode.transit,
      ),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    PolylineId id = PolylineId('poly');

    Polyline polyline = Polyline(
      width: 3,
      polylineId: id,
      color: Palette.primaryColor,
      points: polylineCoordinates,
    );

    Map<PolylineId, Polyline> newPolylines = new Map<PolylineId, Polyline>();

    newPolylines[id] = polyline;

    return newPolylines;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _routesFuture,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting)
          return const Center(child: CircularProgressIndicator());
        else if (snap.data == null) {
          return ErrorWidgetDisplay(
            title: 'Error',
            subTitle: 'Error',
            imagePath: 'error.png',
          );
        } else {
          List routes = json.decode(snap.data.body);

          List filteredRoutes = Functions.filterRoutesStatus(
              routes, globals.userFullName, widget.source);

          if (filteredRoutes != null && filteredRoutes.isEmpty)
            return ErrorWidgetDisplay(
              title: 'There is no current rides available',
              subTitle: 'Please wait for someone to add a new ride',
              imagePath: 'truck.png',
            );
          else
            return RoutesList(
              routes: filteredRoutes,
              removeRide: (int routeId) {
                _removeRide(routeId);
              },
              source: widget.source,
              onCardTab: (Map<dynamic, dynamic> route) {
                _onCardTab(route);
              },
            );
        }
      },
    );
  }
}
