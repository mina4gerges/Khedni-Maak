import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fleva_icons/fleva_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:khedni_maak/config/globals.dart' as globals;
import 'package:khedni_maak/config/palette.dart';
import 'package:khedni_maak/firebase_notification/firebase_send_notification.dart';
import 'package:khedni_maak/widgets/stat_card.dart';
import 'package:url_launcher/url_launcher.dart';

import 'display_flash_bar.dart';
import 'from_to_three_dots.dart';

class RoutesList extends StatefulWidget {
  RoutesList({
    Key key,
    this.navSource,
    @required this.routes,
    @required this.source,
    this.removeRide,
    this.onCardTab,
  }) : super(key: key);

  final List routes;
  final String source;
  final String navSource;
  final Function(int routeId) removeRide;
  final Function(Map route) onCardTab;

  @override
  _RoutesListState createState() => _RoutesListState();
}

class _RoutesListState extends State<RoutesList> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  String sendingRequestId = "";

  _getCardBody(Map route, BuildContext context) {
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
          _displayActionButton(route, context),
          _displayApprovalStatus(route, context),
        ],
      ),
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

  _displayActionButton(Map route, BuildContext context) {
    return widget.source == 'rider' && widget.navSource != 'history'
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
              sendingRequestId == "${route['id']}"
                  ? SpinKitThreeBounce(
                      color: Palette.fifthColor,
                      size: 25.0,
                    )
                  : RaisedButton(
                      onPressed: () => _sendRequest(route, context),
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

  _displayApprovalStatus(Map route, BuildContext context) {
    //history screen
    if (widget.source == 'rider' && widget.navSource == 'history') {
      return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
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
        Text(
          "Request Approved",
          style: TextStyle(
            color: Palette.fourthColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ]);
    }

    return Container();
  }

  _sendRequest(Map route, BuildContext context) {
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

    setState(() {
      sendingRequestId = routeId;
    });

    sendAndRetrieveMessage(
            "New Request !", notificationBody, "route-$routeId", routesInfo)
        .then((value) => {
              if (value.statusCode == 200)
                DisplayFlashBar.displayFlashBar(
                    'success',
                    "Request sent successfully to ${route["driverUsername"]}",
                    context)
              else
                DisplayFlashBar.displayFlashBar(
                    'failed', "Failed to send notification", context),
              setState(() {
                sendingRequestId = "";
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(5),
      itemCount: widget.routes != null ? widget.routes.length : 0,
      itemBuilder: (BuildContext context, int index) {
        final route = widget.routes[index];
        return widget.source == 'driver' &&
                widget.removeRide != null &&
                widget.onCardTab != null
            ? Dismissible(
                key: Key("${route['id']}"),
                onDismissed: (direction) {
                  widget.removeRide(route['id']);
                },
                background: Container(color: Colors.red),
                child: BuildStatCard(
                  body: _getCardBody(route, context),
                  color: Colors.white,
                  onCarTap: () => {widget.onCardTab(route)},
                ),
              )
            : BuildStatCard(
                body: _getCardBody(route, context),
                color: Colors.white,
              );
      },
    );
  }
}
