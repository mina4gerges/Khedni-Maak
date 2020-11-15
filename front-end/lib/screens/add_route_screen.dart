import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:khedni_maak/config/Secrets.dart';
import 'package:khedni_maak/config/constant.dart';
import 'package:khedni_maak/config/globals.dart' as globals;
import 'package:khedni_maak/config/palette.dart';
import 'package:khedni_maak/google_map/src/components/prediction_tile.dart';
import 'package:khedni_maak/google_map/src/models/pick_result.dart';
import 'package:khedni_maak/widgets/custom_app_bar.dart';
import 'package:khedni_maak/widgets/display_flash_bar.dart';
import 'package:khedni_maak/widgets/from_to_three_dots.dart';

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
  String estimatedTime = '0';
  String distance = '0.0';
  String passengerCapacity;
  TimeOfDay departureOnTime;

  PickResult toSelectedPlace;
  PickResult fromSelectedPlace;

  Position currentPosition;

  GoogleMapsPlaces places;

  TextEditingController _fromController;
  TextEditingController _toController;

  Timer debounceTimer;
  OverlayEntry overlayEntry;

  FocusNode _fromFocusNode;
  FocusNode _toFocusNode;

  BaseClient httpClient;

  bool addingRoute = false;

  @override
  void initState() {
    super.initState();

    _fromController = TextEditingController();
    _toController = TextEditingController();

    _fromFocusNode = FocusNode();
    _toFocusNode = FocusNode();

    passengerCapacity = '1';
    departureOnTime =
        TimeOfDay(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute);

    places = GoogleMapsPlaces(
      apiKey: Secrets.API_KEY,
      baseUrl: null,
      httpClient: httpClient,
    );

    initCurrentPosition().then((value) => currentPosition = value);
  }

  Future<Position> initCurrentPosition() async {
    return getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
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

  _clearRouteInformation() {
    setState(() {
      distance = '0.0';
      estimatedTime = '0';
    });
  }

  _clearToSelectedPlace() {
    setState(() {
      toSelectedPlace = null;
    });
  }

  _clearFromSelectedPlace() {
    setState(() {
      fromSelectedPlace = null;
    });
  }

  _onSearchFromInputChange(text) {
    if (!mounted) return;

    if (text.isEmpty) {
      _clearOverlay();
      _clearFromSelectedPlace();
      _clearRouteInformation();
      debounceTimer?.cancel();
      return;
    }

    if (text.substring(text.length - 1) == " ") {
      _clearOverlay();
      _clearFromSelectedPlace();
      _clearRouteInformation();
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
      _clearToSelectedPlace();
      _clearRouteInformation();
      debounceTimer?.cancel();
      return;
    }

    if (text.substring(text.length - 1) == " ") {
      _clearOverlay();
      _clearToSelectedPlace();
      _clearRouteInformation();
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
        location: Location(currentPosition.latitude, currentPosition.longitude),
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

    if (response.errorMessage?.isNotEmpty == true ||
        response.status == "REQUEST_DENIED") {
      print("AutoCompleteSearch Error: " + response.errorMessage);
      return;
    }

    PickResult selectedPlace =
        PickResult.fromPlaceDetailResult(response.result);

    bool isInputChanged = true;

    if (source == 'fromInput') {
      if (fromSelectedPlace != null &&
          (selectedPlace.placeId == fromSelectedPlace.placeId)) {
        isInputChanged = false;
      }

      setState(() {
        fromSelectedPlace = selectedPlace;
      });
    } else if (source == 'toInput') {
      if (toSelectedPlace != null &&
          (selectedPlace.placeId == toSelectedPlace.placeId)) {
        isInputChanged = false;
      }

      setState(() {
        toSelectedPlace = selectedPlace;
      });
    }

    if (isInputChanged) {
      Future tempDistanceFuture;
      Future tempEstimatedTimeFuture;

      if (source == 'toInput') {
        if (fromSelectedPlace != null) {
          tempDistanceFuture = _getDistance(fromSelectedPlace, selectedPlace);
          tempEstimatedTimeFuture =
              _getEstimatedTime(fromSelectedPlace, selectedPlace);
        }
      } else if (source == 'fromInput') {
        if (toSelectedPlace != null) {
          tempDistanceFuture = _getDistance(selectedPlace, toSelectedPlace);
          tempEstimatedTimeFuture =
              _getEstimatedTime(selectedPlace, toSelectedPlace);
        }
      }

      tempDistanceFuture.then((value) => {
            setState(() => {distance = value})
          });

      tempEstimatedTimeFuture.then((value) => {
            setState(() => {estimatedTime = value})
          });
    }

    // await _moveTo(provider.selectedPlace.geometry.location.lat,
    //     provider.selectedPlace.geometry.location.lng);
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      margin: const EdgeInsets.only(right: 20.0, left: 20.0),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
      child: Row(
        children: <Widget>[
          FromToThreeDots(),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TextField(
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
                    // suffixIcon: IconButton(
                    //   icon: Icon(OMIcons.myLocation),
                    //   onPressed: _setCurrentPosition,
                    // ),
                  ),
                ),
                Divider(
                  height: 1,
                  indent: 0,
                  endIndent: 0,
                  thickness: 1.5,
                ),
                SizedBox(height: 6),
                TextField(
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
                    // suffixIcon: IconButton(
                    //   icon: Icon(OMIcons.myLocation),
                    //   onPressed: _setCurrentPosition,
                    // ),
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
      Secrets.API_KEY, // Google Maps API Key
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
      "key": Secrets.API_KEY
    };

    Uri uri = Uri.https(
        "maps.googleapis.com", "maps/api/distancematrix/json", params);

    String url = uri.toString();
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

  String _addRouteValidate() {
    String errorMsg = '';

    if (fromSelectedPlace == null)
      errorMsg += "Starting point can't be left empty.";

    if (toSelectedPlace == null)
      errorMsg +=
          "${errorMsg != '' ? '\n' : ''}Destination point can't be left empty.";

    return errorMsg;
  }

  _addRoute() async {
    String errorMsg = _addRouteValidate();

    if (errorMsg != '') {
      DisplayFlashBar.displayFlashBar('inputsEmpty', errorMsg, context);
      return;
    }

    String month = "${DateTime.now().month}".length == 1
        ? "0${DateTime.now().month}"
        : "${DateTime.now().month}";
    String day = "${DateTime.now().day}".length == 1
        ? "0${DateTime.now().day}"
        : "${DateTime.now().day}";

    String startingTime =
        "${DateTime.now().year}-$month-$day ${departureOnTime.hour}:${departureOnTime.minute}";

    setState(() {
      addingRoute = true;
    });

    final http.Response response = await http.post(
      '$baseUrlRoutes/addRoute',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, Object>{
        "source": fromSelectedPlace.formattedAddress,
        "destination": toSelectedPlace.formattedAddress,
        "distance": "${distance}Km",
        "estimationTime": estimatedTime,
        "startingTime": startingTime,
        "capacity": "$passengerCapacity",
        "driverUsername": globals.userFullName,
        "car": "-",
        "latStart": fromSelectedPlace.geometry.location.lat,
        "lngStart": fromSelectedPlace.geometry.location.lng,
        "latEnd": toSelectedPlace.geometry.location.lat,
        "lngEnd": toSelectedPlace.geometry.location.lng,
        "driverPhone": globals.userPhoneNumber,
      }),
    );

    setState(() {
      addingRoute = false;
    });

    Navigator.pop(context, {
      "routeId": json.decode(response.body)['id'],
      "status": response.statusCode == 200 ? 'success' : 'failed',
      "fromSelectedPlace": fromSelectedPlace,
      "toSelectedPlace": toSelectedPlace,
      "driverUsername": globals.userFullName,
      "latStart": fromSelectedPlace.geometry.location.lat,
      "lngStart": fromSelectedPlace.geometry.location.lng,
      "latEnd": toSelectedPlace.geometry.location.lat,
      "lngEnd": toSelectedPlace.geometry.location.lng,
    });
  }

  _pickTime() async {
    TimeOfDay t =
        await showTimePicker(context: context, initialTime: departureOnTime);
    if (t != null)
      setState(() {
        departureOnTime = t;
      });
  }

  Widget _displayDepartureOn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Departure on",
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(height: 1.0),
        SizedBox(
          width: 91,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              "${departureOnTime.hour}:${departureOnTime.minute}",
              style: TextStyle(
                fontSize: 20.0,
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

  Widget _displayEstimatedTime() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Duration',
          style: TextStyle(color: Colors.grey),
        ),
        Text(
          "$estimatedTime",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _displayDistance() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Distance",
          style: TextStyle(color: Colors.grey),
        ),
        Text(
          "${distance}km",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _displayCapacityInput() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Passenger capacity',
          style: TextStyle(color: Colors.grey),
        ),
        SizedBox(height: 7.0),
        DropdownButton<String>(
          value: passengerCapacity,
          icon: Icon(Icons.keyboard_arrow_down),
          iconSize: 20,
          elevation: 16,
          style: TextStyle(
            fontSize: 20.0,
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
          items: <String>['1', '2', '3', '4']
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
            FromToThreeDots(),
            SizedBox(width: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
        addingRoute
            ? SpinKitThreeBounce(
                color: Palette.primaryColor,
                size: 25.0,
              )
            : RaisedButton(
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

    return Container(
      // margin: const EdgeInsets.only(top: 30.0),
      height: screenHeight * 0.7,
      decoration: BoxDecoration(
        color: Palette.thirdColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.0),
          topRight: Radius.circular(40.0),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 50.0),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _displayDepartureOn(),
                    _displayEstimatedTime(),
                  ],
                ),
                Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _displayCapacityInput(),
                    _displayDistance(),
                  ],
                ),
              ],
            ),
            _displayFinalDepartureDestinationValues(),
            _buildAddRouteButton(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(title: Text("Create route")),
      backgroundColor: Palette.primaryColor,
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight - 76.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[_buildSearchBar(), _buildConfirmationCard()],
          ),
        ),
      ),
    );
  }
}
