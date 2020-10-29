import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart';
import 'package:khedni_maak/config/Secrets.dart';
import 'package:khedni_maak/config/palette.dart';
import 'package:khedni_maak/google_map/src/components/prediction_tile.dart';
import 'package:khedni_maak/google_map/src/models/pick_result.dart';
import 'package:khedni_maak/widgets/custom_app_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddRouteScreen extends StatefulWidget {
  final String sessionToken;
  final GlobalKey appBarKey;

  AddRouteScreen({
    Key key,
    @required this.sessionToken,
    @required this.appBarKey,
  }) : super(key: key);

  @override
  _AddRouteScreenState createState() => _AddRouteScreenState();
}

class _AddRouteScreenState extends State<AddRouteScreen> {
  String passengerCapacity;
  TimeOfDay time;

  PickResult fromSelectedPlace = new PickResult();
  PickResult toSelectedPlace;

  Position currentPosition;

  GoogleMapsPlaces places;

  TextEditingController _fromController = TextEditingController();
  TextEditingController _toController = TextEditingController();

  Timer debounceTimer;
  OverlayEntry overlayEntry;

  FocusNode _fromFocusNode = FocusNode();
  FocusNode _toFocusNode = FocusNode();

  BaseClient httpClient;

  @override
  void initState() {
    super.initState();

    passengerCapacity = 'One';
    // time = TimeOfDay.now();
    time =
        TimeOfDay(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute);

    places = GoogleMapsPlaces(
      apiKey: Secrets.API_KEY,
      baseUrl: null,
      httpClient: httpClient,
    );
  }

  @override
  void dispose() {
    super.dispose();

    _fromController.dispose();
    _toController.dispose();

    _fromFocusNode.dispose();
    _toFocusNode.dispose();

    _clearOverlay();
  }

  _onSearchFromInputChange(text) {
    if (!mounted) return;

    if (text.isEmpty) {
      _clearOverlay();
      debounceTimer?.cancel();
      return;
    }

    if (text.substring(text.length - 1) == " ") {
      _clearOverlay();
      debounceTimer?.cancel();
      return;
    }

    if (debounceTimer?.isActive ?? false) {
      debounceTimer.cancel();
    }

    setState(() => {
          debounceTimer = Timer(Duration(milliseconds: 500), () {
            _searchPlace(text.trim(), 'fromInput');
          })
        });
  }

  _onSearchToInputChange(text) {
    if (!mounted) return;

    if (text.isEmpty) {
      _clearOverlay();
      debounceTimer?.cancel();
      return;
    }

    if (text.substring(text.length - 1) == " ") {
      _clearOverlay();
      debounceTimer?.cancel();
      return;
    }

    if (debounceTimer?.isActive ?? false) {
      debounceTimer.cancel();
    }

    setState(() => {
          debounceTimer = Timer(Duration(milliseconds: 500), () {
            _searchPlace(text.trim(), 'toInput');
          })
        });
  }

  _searchPlace(String searchTerm, String source) {
    if (context == null) return;

    _clearOverlay();

    if (searchTerm.length < 1) return;

    _displayOverlay(_buildSearchingOverlay());

    _performAutoCompleteSearch(searchTerm, source);
  }

  _clearOverlay() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }

    // _fromController.clear();
    // _toController.clear();
  }

  _displayOverlay(Widget overlayChild) {
    _clearOverlay();

    // final RenderBox appBarRenderBox =
    //       widget.appBarKey.currentContext.findRenderObject();

    final screenWidth = MediaQuery.of(context).size.width;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        // top: appBarRenderBox.size.height+5.0,s
        top: 190.0,
        left: screenWidth * 0.048,
        right: screenWidth * 0.048,
        child: Material(
          elevation: 4.0,
          child: overlayChild,
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);
  }

  _performAutoCompleteSearch(String searchTerm, String source) async {
    if (searchTerm.isNotEmpty) {
      //get searched place
      final PlacesAutocompleteResponse response = await places.autocomplete(
        searchTerm,
        sessionToken: widget.sessionToken,
        location: currentPosition == null
            ? null
            : Location(currentPosition.latitude, currentPosition.longitude),
        offset: null,
        radius: null,
        language: null,
        types: null,
        components: null,
        strictbounds: null,
        region: null,
      );

      if (response.errorMessage?.isNotEmpty == true ||
          response.status == "REQUEST_DENIED") {
        print("AutoCompleteSearch Error: " + response.errorMessage);
        return;
      }

      _displayOverlay(_buildPredictionOverlay(response.predictions, source));
    }
  }

  Widget _buildSearchingOverlay() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Row(
        children: <Widget>[
          SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(strokeWidth: 3),
          ),
          SizedBox(width: 24),
          Expanded(
            child: Text(
              "Searching...",
              style: TextStyle(fontSize: 16),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPredictionOverlay(List<Prediction> predictions, String source) {
    return ListBody(
      children: predictions
          .map(
            (p) => PredictionTile(
              prediction: p,
              onTap: (selectedPrediction) {
                resetSearchBar();
                _pickPrediction(selectedPrediction, source);
              },
            ),
          )
          .toList(),
    );
  }

  resetSearchBar() {
//    clearText();
    _clearOverlay();
  }

  _pickPrediction(Prediction prediction, String source) async {
    // provider.placeSearchingState = SearchingState.Searching;
    _clearOverlay();

    if (source == 'fromInput') {
      _fromController.text = prediction.description;
      _fromFocusNode.unfocus();
      if (_toController.text.isEmpty) {
        FocusScope.of(context).requestFocus(_toFocusNode);
      }
    } else if (source == 'toInput') {
      _toController.text = prediction.description;
      _toFocusNode.unfocus();
    }

    final PlacesDetailsResponse response = await places.getDetailsByPlaceId(
      prediction.placeId,
      sessionToken: widget.sessionToken,
      // language: widget.autocompleteLanguage,
    );

    //TODO check here if we can get the location

    if (response.errorMessage?.isNotEmpty == true ||
        response.status == "REQUEST_DENIED") {
      print("AutoCompleteSearch Error: " + response.errorMessage);
      // if (widget.onAutoCompleteFailed != null) {
      //   widget.onAutoCompleteFailed(response.status);
      // }
      return;
    }

    PickResult selectedPlace =
        PickResult.fromPlaceDetailResult(response.result);

    if (source == 'fromInput') {
      setState(() {
        fromSelectedPlace = selectedPlace;
      });
    } else if (source == 'toInput') {
      setState(() {
        toSelectedPlace = selectedPlace;
      });
    }
    // Prevents searching again by camera movement.
    // provider.isAutoCompleteSearching = true;

    // await _moveTo(provider.selectedPlace.geometry.location.lat,
    //     provider.selectedPlace.geometry.location.lng);

    // provider.placeSearchingState = SearchingState.Idle;
  }

  Widget _threeDots() {
    return Column(
      children: <Widget>[
        SizedBox(height: 12),
        Icon(FontAwesomeIcons.dotCircle, color: Colors.green),
        SizedBox(height: 5),
        Container(
          width: 5.0,
          height: 5.0,
          decoration: new BoxDecoration(
            color: Colors.grey[400],
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(height: 5),
        Container(
          width: 5.0,
          height: 5.0,
          decoration: new BoxDecoration(
            color: Colors.grey[400],
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(height: 5),
        Container(
          width: 5.0,
          height: 5.0,
          decoration: new BoxDecoration(
            color: Colors.grey[400],
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(height: 5),
        Icon(FontAwesomeIcons.dotCircle, color: Colors.blue),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      margin: const EdgeInsets.only(right: 20.0, left: 20.0),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
      // height: 115.0,
      child: Row(
        children: <Widget>[
          _threeDots(),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _fromController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  focusNode: _fromFocusNode,
                  onChanged: (text) {
                    _onSearchFromInputChange(text);
                  },
                  // onFieldSubmitted: (term) {
                  //   _fieldFocusChange(context, _fromFocusNode, _toFocusNode);
                  // },
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: 'From',
                    border: InputBorder.none,
                  ),
                ),
                Divider(
                  height: 1,
                  indent: 0,
                  endIndent: 0,
                  thickness: 1.5,
                ),
                SizedBox(height: 6),
                TextFormField(
                  controller: _toController,
                  focusNode: _toFocusNode,
                  onChanged: (text) {
                    _onSearchToInputChange(text);
                  },
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: 'To',
                    border: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _createPolyLines(Position start, Position destination) async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      // Secrets.API_KEY, // Google Maps API Key
      "123", // Google Maps API Key
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      // travelMode: TravelMode.transit,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    PolylineId id = PolylineId('poly');

    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );

    //get old polylines
    Map<PolylineId, Polyline> newPolylines = new Map<PolylineId, Polyline>();
    // Map<PolylineId, Polyline> a = new Map<PolylineId, Polyline>();

    // Adding the new polyline
    // a[id] = polyline;
    newPolylines[id] = polyline;

    //set new marker
    // provider.polylines = newPolylines;

    return polylineCoordinates;
  }

  // Formula for calculating distance between two coordinates
  // https://stackoverflow.com/a/54138876/11910277
  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future<String> _getDistance(
      PickResult fromSelectedPlace, PickResult toSelectedPlace) async {
    double startLocationLat = fromSelectedPlace.geometry.location.lat;
    double startLocationLng = fromSelectedPlace.geometry.location.lng;
    double endLocationLat = toSelectedPlace.geometry.location.lat;
    double endLocationLng = toSelectedPlace.geometry.location.lng;

    Position startCoordinates =
        Position(latitude: startLocationLat, longitude: startLocationLng);

    Position destinationCoordinates =
        Position(latitude: endLocationLat, longitude: endLocationLng);

    List<LatLng> polylineCoordinates =
        await _createPolyLines(startCoordinates, destinationCoordinates);

    double totalDistance = 0.0;

    // Calculating the total distance by adding the distance
    // between small segments
    for (int i = 0; i < polylineCoordinates.length - 1; i++) {
      totalDistance += _coordinateDistance(
        polylineCoordinates[i].latitude,
        polylineCoordinates[i].longitude,
        polylineCoordinates[i + 1].latitude,
        polylineCoordinates[i + 1].longitude,
      );
    }

    return totalDistance.toStringAsFixed(2);
  }

  Future<String> _getEstimatedTime(
      PickResult fromSelectedPlace, PickResult toSelectedPlace) async {
    double startLocationLat = fromSelectedPlace.geometry.location.lat;
    double startLocationLng = fromSelectedPlace.geometry.location.lng;
    double endLocationLat = toSelectedPlace.geometry.location.lat;
    double endLocationLng = toSelectedPlace.geometry.location.lng;

    String result = "";

    var params = {
      "origins": "$startLocationLat,$startLocationLng",
      "destinations": "$endLocationLat,$endLocationLng",
      // "key": Secrets.API_KEY
    };

    //TODO:fix URL
    Uri uri = Uri.https(
        "maps.googleapis.com", "maps/api/distancematrix/json", params);

    String url = uri.toString();
    // print('GOOGLE MAPS URL: ' + url);
    var response = await http.get(url);
    if (response?.statusCode == 200) {
      var parsedJson = json.decode(response.body);
      if (parsedJson["status"]?.toLowerCase() == "ok" &&
          parsedJson["rows"] != null &&
          parsedJson["rows"].isNotEmpty) {
        result = parsedJson["rows"][0]["elements"][0]["duration"]["text"];
      } else {
        // result = parsedJson["error_message"];
      }
    }
    return result;
  }

  Widget _displaySummaryHeader() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Route Summary',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w500,
                fontSize: 18.0,
              ),
            ),
          ],
        ),
        Divider(
          height: 5,
          indent: 15,
          endIndent: 15,
          thickness: 1.5,
        ),
      ],
    );
  }

  _addRoute() {
    print("route added");
  }

  _pickTime() async {
    TimeOfDay t = await showTimePicker(context: context, initialTime: time);
    if (t != null)
      setState(() {
        time = t;
      });
  }

  Widget _displayDepartureOn() {
    return Row(
      children: <Widget>[
        Text("Departure on:"),
        SizedBox(
          width: 90,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              "${time.hour}:${time.minute}",
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Icon(Icons.keyboard_arrow_down),
            onTap: _pickTime,
          ),
        ),
      ],
    );
  }

  FutureBuilder<String> _displayEstimatedTime() {
    Future _future = _getEstimatedTime(fromSelectedPlace, toSelectedPlace);

    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Row(
            children: <Widget>[
              Text(
                'Estimated Duration: ',
              ),
              Text(
                "${snapshot.data}",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        }
        // if (snapshot.hasError) {
        //   return Text(snapshot.error.toString());
        // }
        return Row(
          children: <Widget>[
            Text(
              'Estimated Duration: ',
            ),
            Text(
              "${0} min",
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      },
    );
  }

  FutureBuilder<String> _displayDistance() {
    Future _future = _getDistance(fromSelectedPlace, toSelectedPlace);

    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Row(
            children: <Widget>[
              Text("Distance: "),
              Text(
                "${snapshot.data} km",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        }
        // if (snapshot.hasError) {
        //   return Text(snapshot.error.toString());
        // }
        return (Row(
          children: <Widget>[
            Text("Distance: "),
            Text(
              "${0.00} km",
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ));
      },
    );
  }

  Widget _displayCapacityInput() {
    return Row(
      children: <Widget>[
        Text(
          'Passenger capacity: ',
        ),
        DropdownButton<String>(
          value: passengerCapacity,
          icon: Icon(Icons.keyboard_arrow_down),
          iconSize: 20,
          elevation: 16,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          // underline: Container(
          //   height: 2,
          //   color: Colors.deepPurpleAccent,
          // ),
          onChanged: (String newValue) {
            setState(() {
              passengerCapacity = newValue;
            });
          },
          items: <String>['One', 'Two', 'Three', 'Four']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _displayFinalDepartureDestinationValues() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _threeDots(),
            SizedBox(width: 10.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(height: 13.0),
                Text(
                  _fromController?.text,
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 45.0),
                Text(
                  _toController?.text,
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }

  Widget _buildAddRouteButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          onPressed: _addRoute,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: Palette.primaryColor,
          textColor: Colors.white,
          child: const Text(
            'ADD ROUTE',
            style: TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmationCard() {
    final screenHeight = MediaQuery.of(context).size.height;
    final deviceSize = MediaQuery.of(context).size;
    final width = deviceSize.width;

    return Container(
      height: screenHeight - 30.0 - 190.0,
      width: width,
      margin: const EdgeInsets.only(top: 30.0),
      decoration: BoxDecoration(
        color: Palette.thirdColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.0),
          topRight: Radius.circular(40.0),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 50.0),
        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _displaySummaryHeader(),
            _displayDepartureOn(),
            _displayEstimatedTime(),
            SizedBox(height: 5.0),
            _displayDistance(),
            _displayCapacityInput(),
            _displayFinalDepartureDestinationValues(),
            _buildAddRouteButton(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Key centerKey = ValueKey('bottom-sliver-list');

    return Scaffold(
      appBar: CustomAppBar(title: "Create a new route"),
      backgroundColor: Palette.primaryColor,
      body: CustomScrollView(
        center: centerKey,
        slivers: <Widget>[
          SliverList(
            key: centerKey,
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: <Widget>[
                      _buildSearchBar(),
                      _buildConfirmationCard()
                    ],
                  ),
                );
              },
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }
}
