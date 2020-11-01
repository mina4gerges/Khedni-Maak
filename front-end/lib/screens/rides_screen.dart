import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:khedni_maak/config/Secrets.dart';
import 'package:khedni_maak/config/constant.dart';
import 'package:khedni_maak/config/palette.dart';
import 'package:khedni_maak/widgets/from_to_three_dots.dart';
import 'package:khedni_maak/widgets/stat_card.dart';

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
              _getRouteSingleInfo("Starting at", route['startingTime']),
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
        ],
      ),
    );
  }

  _getRouteSingleInfo(String title, String body) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          body,
          style: TextStyle(
            fontSize: 20.0,
            // color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        title.isNotEmpty
            ? Text(
                title,
                style: TextStyle(
                  fontSize: 10.0,
                  // color: Colors.white,
                ),
              )
            : Container(),
      ],
    );
  }

  _buildRoutesList(List routes) {
    return ListView.builder(
      padding: const EdgeInsets.all(5),
      itemCount: routes.length,
      itemBuilder: (BuildContext context, int index) {
        return BuildStatCard(
          body: _getCardBody(routes[index]),
          color: Colors.white,
          onCarTap: () => {_onCardTab(routes[index])},
        );
      },
    );
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
          List routes = json.decode(snap.data.body);

          if (routes.isEmpty)
            return Center(
              child: Text(
                "Routes are empty",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          else
            return _buildRoutesList(json.decode(snap.data.body));
        }
      },
    );
  }
}
