import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:khedni_maak/globals/constant.dart';
import 'package:dio/dio.dart';

void main() => runApp(MapSample());

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  String _heading = '';

  @override
  void initState() {
    super.initState();
    _heading = "Suggestions";
  }

  void getLocationResults(String input) async {
    if (input.isEmpty) {
      setState(() {
        _heading = "Suggestions";
      });

      return;
    }

    String baseUrl = "";
    String type = "(region)";

    String request ="$baseUrl?input=$input&key=$googleMapAPI&type=$type";

    // try{

    // Response response = await Dio().get(request);
    //
    // print(response);
    // }
    // catch(e){
    //   print(e);
    // }

    setState(() {
      _heading: 'Results';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: []);
  }
}
