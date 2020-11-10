import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fleva_icons/fleva_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:khedni_maak/config/Secrets.dart';
import 'package:khedni_maak/config/constant.dart';
import 'package:khedni_maak/config/globals.dart' as globals;
import 'package:khedni_maak/config/palette.dart';
import 'package:khedni_maak/firebase_notification/firebase_send_notification.dart';
import 'package:khedni_maak/widgets/display_flash_bar.dart';
import 'package:khedni_maak/widgets/error_widget.dart';
import 'package:khedni_maak/widgets/from_to_three_dots.dart';
import 'package:khedni_maak/widgets/stat_card.dart';
import 'package:url_launcher/url_launcher.dart';

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

  _getCardBody(Map route) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _getRouteStartingTimeInfo("Starting at", route['startingTime']),
              _getRouteSingleInfo("Duration", route['estimationTime']),
              _getRouteSingleInfo("Distance", route['distance']),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(width: 40.0),
              FromToThreeDots(),
              SizedBox(width: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _getRouteSingleInfo('From', route['source']),
                  SizedBox(height: 12.0),
                  _getRouteSingleInfo('To', route['destination']),
                ],
              ),
              //driverUsername
              //capacity
            ],
          ),
          _displayActionButton(route),
        ],
      ),
    );
  }

  _sendRequest(Map route) {
    String notificationBody = '${globals.userFullName} sent a new request.';

    Map routesInfo = new Map();

    String routeId = "${route['id']}";
    _firebaseMessaging.subscribeToTopic('request-$routeId');

    // String routeId = "55";

    routesInfo['routeId'] = routeId;
    routesInfo['requestFrom'] = "rider";
    routesInfo['from'] = route['source'];
    routesInfo['to'] = route['destination'];
    routesInfo['riderUsername'] = globals.userFullName;
    routesInfo['requestDateTime'] = DateTime.now().toString();

    sendAndRetrieveMessage(
            "New Request !", notificationBody, "route-$routeId", routesInfo)
        .then((value) => {
              if (value.statusCode == 200)
                DisplayFlashBar.displayFlashBar('success',
                    "Request sent successfully to ${route["driverUsername"]}",context)
              else
                DisplayFlashBar.displayFlashBar('failed', "Failed to send notification",context)
            });
  }

  _getRouteSingleInfo(String title, String body) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          body,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        title.isNotEmpty
            ? Text(
                title,
                style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.grey[700],
                ),
              )
            : Container(),
      ],
    );
  }

  _getRouteStartingTimeInfo(String title, String body) {
    List<String> dateTime = body.split(" ");

    DateTime dateObj = DateTime.parse(dateTime[0]);

    String time = dateTime[1];
    String date = "${dateObj.day}/${dateObj.month}/${dateObj.year}";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          children: <Widget>[
            Text(
              time,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              date,
              style: TextStyle(
                fontSize: 11.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        title.isNotEmpty
            ? Text(
                title,
                style: TextStyle(
                  fontSize: 10.0,
                  color: Colors.grey[700],
                ),
              )
            : Container(),
      ],
    );
  }

  _buildRoutesList(List routes) {
    return ListView.builder(
      padding: const EdgeInsets.all(5),
      itemCount: routes != null ? routes.length : 0,
      itemBuilder: (BuildContext context, int index) {
        final route = routes[index];
        return widget.source == 'driver'
            ? Dismissible(
                key: Key("${route['id']}"),
                onDismissed: (direction) {
                  _removeRide(route['id']);
                },
                background: Container(color: Colors.red),
                child: BuildStatCard(
                  body: _getCardBody(route),
                  color: Colors.white,
                  onCarTap: () => {_onCardTab(route)},
                ),
              )
            : BuildStatCard(
                body: _getCardBody(route),
                color: Colors.white,
              );
      },
    );
  }

  _displayActionButton(Map route) {
    return widget.source == 'rider'
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                onPressed: () => launch("tel://${route["driverPhone"]}"),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Palette.primaryColor,
                textColor: Colors.white,
                child: Row(
                  children: [
                    Icon(FlevaIcons.phone_call_outline),
                    Text(route["driverUsername"]),
                  ],
                ),
              ),
              RaisedButton(
                onPressed: () => _sendRequest(route),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Palette.fifthColor,
                textColor: Colors.white,
                child: Row(
                  children: [
                    Icon(Icons.send_sharp),
                    Text("Send Request"),
                  ],
                ),
              ),
            ],
          )
        : Container();
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
        isSuccess ? "Route deleted" : "Route not deleted",context);

    setState(() {
      _routesFuture = _getRoutes();
    });
  }

//filter routes with status 1 (available)
  List _filterRoutesStatus(List routes) {
    //show only driver route
    if (widget.source == 'driver')
      return routes
          .where((route) =>
              route["status"] == 1 &&
              route['driverUsername'] == globals.userFullName)
          .toList();
    //show all routes different then loginUserName
    else
      return routes
          .where((route) =>
              route["status"] == 1 &&
              route['driverUsername'] != globals.userFullName)
          .toList();
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

          List filteredRoutes = _filterRoutesStatus(routes);

          if (filteredRoutes != null && filteredRoutes.isEmpty)
            return ErrorWidgetDisplay(
              title: 'There is no current rides available',
              subTitle: 'Please wait for someone to add a new ride',
              imagePath: 'truck.png',
            );
          else
            return _buildRoutesList(filteredRoutes);
        }
      },
    );
  }
}
