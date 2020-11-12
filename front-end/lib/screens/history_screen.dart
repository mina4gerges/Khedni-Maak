import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:khedni_maak/config/constant.dart';
import 'package:khedni_maak/config/globals.dart' as globals;
import 'package:khedni_maak/functions/functions.dart';
import 'package:khedni_maak/widgets/error_widget.dart';
import 'package:khedni_maak/widgets/routes_list.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({
    Key key,
    this.navSource,
    @required this.source,
  }) : super(key: key);

  final String source;
  final String navSource;

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
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

          List filteredRoutes =
              Functions.getHistoryList(routes, globals.userFullName);

          if (filteredRoutes != null && filteredRoutes.isEmpty)
            return ErrorWidgetDisplay(
              title: 'No history',
              subTitle: 'History are empty',
              imagePath: 'truck.png',
            );
          else
            return RoutesList(
                routes: filteredRoutes,
                source: widget.source,
                navSource: widget.navSource);
        }
      },
    );
  }
}
