import 'dart:async';
import 'dart:math';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:khedni_maak/config/Secrets.dart';
import 'package:khedni_maak/config/palette.dart';
import 'package:khedni_maak/google_map/src/components/prediction_tile.dart';
import 'package:khedni_maak/google_map/src/models/pick_result.dart';
import 'package:khedni_maak/widgets/custom_app_bar.dart';

class SecondScreen extends StatefulWidget {
  final String sessionToken;
  final GlobalKey appBarKey;

  SecondScreen({
    Key key,
    @required this.sessionToken,
    @required this.appBarKey,
  }) : super(key: key);

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
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

  Widget _buildDatePicker() {
    final deviceSize = MediaQuery.of(context).size;
    final width = min(deviceSize.width * 0.75, 360.0);
    // final textFieldWidth = width - 16.0 * 2;
    final format = DateFormat("yyyy-MM-dd HH:mm");
    final initialValue = DateTime.now();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        DateTimeField(
          format: format,
          initialValue: initialValue,
          onShowPicker: (context, currentValue) async {
            final date = await showDatePicker(
                context: context,
                firstDate: DateTime(2020),
                initialDate: currentValue ?? DateTime.now(),
                lastDate: DateTime(2100));
            if (date != null) {
              final time = await showTimePicker(
                context: context,
                initialTime:
                    TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
              );
              return DateTimeField.combine(date, time);
            } else {
              return currentValue;
            }
          },
        ),
      ],
    );
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
      padding: const EdgeInsets.only(right: 20.0, left: 20.0),
      height: 110.0,
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

  FutureBuilder<String> _displayDistance() {
    Future _future = _getDistance(fromSelectedPlace, toSelectedPlace);

    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(
            "${snapshot.data} km",
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          );
        }
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Text("");
      },
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
              height: 1,
              indent: 15,
              endIndent: 15,
              thickness: 1.5,
            ),
            Row(
              children: <Widget>[
                Text('Departure On: '),
              ],
            ),
            Row(
              children: <Widget>[
                Text(
                  'Estimated Duration: ',
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Text(
                  'Distance: ',
                ),
                _displayDistance(),
              ],
            ),
            Row(
              children: <Widget>[
                Text(
                  'Capacity: ',
                ),
              ],
            ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    print("Confirmed");
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Palette.primaryColor,
                  textColor: Colors.white,
                  child: const Text(
                    'CONFIRM',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
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
