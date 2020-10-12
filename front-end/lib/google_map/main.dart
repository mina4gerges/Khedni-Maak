import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'dart:math' show cos, sqrt, asin;

import '../config/Secrets.dart';
import 'test_map/new/providers/place_provider.dart';
import 'test_map/new/src/autocomplete_search.dart';
import 'test_map/new/src/controllers/autocomplete_search_controller.dart';
import 'test_map/new/src/google_map_place_picker.dart';
import 'test_map/new/src/models/pick_result.dart';
import 'test_map/new/src/place_picker.dart';
//import 'dart:io' show Platform;

import 'test_map/new/src/utils/uuid.dart';

class MapMain extends StatefulWidget {
  MapMain(
      {Key key,
      this.apiKey = Secrets.API_KEY,
      this.onPlacePicked,
      @required this.initialPosition,
//  LatLng(-29.8567844, 101.213108)
      this.useCurrentLocation = true,
      this.desiredLocationAccuracy = LocationAccuracy.high,
      this.onMapCreated,
      this.hintText = 'Choose starting point',
      this.hintDirectionText = 'Choose ending point',
      this.searchingText,
      // this.searchBarHeight,
      // this.contentPadding,
      this.onAutoCompleteFailed,
      this.onGeocodingSearchFailed,
      this.proxyBaseUrl,
      this.httpClient,
      this.selectedPlaceWidgetBuilder,
      this.pinBuilder,
      this.autoCompleteDebounceInMilliseconds = 500,
      this.cameraMoveDebounceInMilliseconds = 750,
      this.initialMapType = MapType.normal,
      this.enableMapTypeButton = true,
      this.enableMyLocationButton = true,
      this.myLocationButtonCooldown = 1,
      this.usePinPointingSearch = true,
      this.usePlaceDetailSearch = false,
      this.autocompleteOffset,
      this.autocompleteRadius,
      this.autocompleteLanguage,
      this.autocompleteComponents,
      this.autocompleteTypes,
      this.strictbounds,
      this.region,
      this.selectInitialPosition = true,
      this.resizeToAvoidBottomInset = true,
      this.initialSearchString,
      this.searchForInitialValue = false,
      this.forceAndroidLocationManager = false,
      this.forceSearchOnZoomChanged = false,
      this.automaticallyImplyAppBarLeading = true,
      this.autocompleteOnTrailingWhitespace = false,
      this.hidePlaceDetailsWhenDraggingPin = true})
      : super(key: key);

  final String apiKey;

  final LatLng initialPosition;
  final bool useCurrentLocation;
  final LocationAccuracy desiredLocationAccuracy;

  final MapCreatedCallback onMapCreated;

  final String hintText;
  final String hintDirectionText;
  final String searchingText;

  // final double searchBarHeight;
  // final EdgeInsetsGeometry contentPadding;

  final ValueChanged<String> onAutoCompleteFailed;
  final ValueChanged<String> onGeocodingSearchFailed;
  final int autoCompleteDebounceInMilliseconds;
  final int cameraMoveDebounceInMilliseconds;

  final MapType initialMapType;
  final bool enableMapTypeButton;
  final bool enableMyLocationButton;
  final int myLocationButtonCooldown;

  final bool usePinPointingSearch;
  final bool usePlaceDetailSearch;

  final num autocompleteOffset;
  final num autocompleteRadius;
  final String autocompleteLanguage;
  final List<String> autocompleteTypes;
  final List<Component> autocompleteComponents;
  final bool strictbounds;
  final String region;

  /// If true the [body] and the scaffold's floating widgets should size
  /// themselves to avoid the onscreen keyboard whose height is defined by the
  /// ambient [MediaQuery]'s [MediaQueryData.viewInsets] `bottom` property.
  ///
  /// For example, if there is an onscreen keyboard displayed above the
  /// scaffold, the body can be resized to avoid overlapping the keyboard, which
  /// prevents widgets inside the body from being obscured by the keyboard.
  ///
  /// Defaults to true.
  final bool resizeToAvoidBottomInset;

  final bool selectInitialPosition;

  /// By using default setting of Place Picker, it will result result when user hits the select here button.
  ///
  /// If you managed to use your own [selectedPlaceWidgetBuilder], then this WILL NOT be invoked, and you need use data which is
  /// being sent with [selectedPlaceWidgetBuilder].
  final ValueChanged<PickResult> onPlacePicked;

  /// optional - builds selected place's UI
  ///
  /// It is provided by default if you leave it as a null.
  /// INPORTANT: If this is non-null, [onPlacePicked] will not be invoked, as there will be no default 'Select here' button.
  final SelectedPlaceWidgetBuilder selectedPlaceWidgetBuilder;

  /// optional - builds customized pin widget which indicates current pointing position.
  ///
  /// It is provided by default if you leave it as a null.
  final PinBuilder pinBuilder;

  /// optional - sets 'proxy' value in google_maps_webservice
  ///
  /// In case of using a proxy the baseUrl can be set.
  /// The apiKey is not required in case the proxy sets it.
  /// (Not storing the apiKey in the app is good practice)
  final String proxyBaseUrl;

  /// optional - set 'client' value in google_maps_webservice
  ///
  /// In case of using a proxy url that requires authentication
  /// or custom configuration
  final BaseClient httpClient;

  /// Initial value of autocomplete search
  final String initialSearchString;

  /// Whether to search for the initial value or not
  final bool searchForInitialValue;

  /// On Android devices you can set [forceAndroidLocationManager]
  /// to true to force the plugin to use the [LocationManager] to determine the
  /// position instead of the [FusedLocationProviderClient]. On iOS this is ignored.
  final bool forceAndroidLocationManager;

  /// Allow searching place when zoom has changed. By default searching is disabled when zoom has changed in order to prevent unwilling API usage.
  final bool forceSearchOnZoomChanged;

  /// Whether to display appbar backbutton. Defaults to true.
  final bool automaticallyImplyAppBarLeading;

  /// Will perform an autocomplete search, if set to true. Note that setting
  /// this to true, while providing a smoother UX experience, may cause
  /// additional unnecessary queries to the Places API.
  ///
  /// Defaults to false.
  final bool autocompleteOnTrailingWhitespace;

  final bool hidePlaceDetailsWhenDraggingPin;

  @override
  _MapMainState createState() => _MapMainState();
}

class _MapMainState extends State<MapMain> {
  GlobalKey appBarKey = GlobalKey();
  PlaceProvider provider;
  SearchBarController searchBarController = SearchBarController();
  SearchBarController searchBarDestinationController = SearchBarController();

  // CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  GoogleMapController mapController;

  final Geolocator _geolocator = Geolocator();

  Position _currentPosition;
  String _currentAddress;

  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();

  String _startAddress = '';
  String _destinationAddress = '';
  String _placeDistance;

  Set<Marker> markers = {};

  PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _textField({
    TextEditingController controller,
    String label,
    String hint,
    double width,
    Icon prefixIcon,
    Widget suffixIcon,
    Function(String) locationCallback,
  }) {
    return Container(
      width: width * 0.8,
      child: TextField(
        onChanged: (value) {
          locationCallback(value);
        },
        controller: controller,
        decoration: new InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.grey[400],
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.blue[300],
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.all(15),
          hintText: hint,
        ),
      ),
    );
  }

  // Method for retrieving the current location
  _getCurrentLocation() async {
    await _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
        print('CURRENT POS: $_currentPosition');
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );
      });
      await _getAddress();
    }).catchError((e) {
      print(e);
    });
  }

  // Method for retrieving the address
  _getAddress() async {
    try {
      List<Placemark> p = await _geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
        startAddressController.text = _currentAddress;
        _startAddress = _currentAddress;
      });
    } catch (e) {
      print(e);
    }
  }

  // Method for calculating the distance between two places
  Future<bool> _calculateDistance() async {
    try {
      // Retrieving placemarks from addresses
      List<Placemark> startPlacemark =
          await _geolocator.placemarkFromAddress(_startAddress);
      List<Placemark> destinationPlacemark =
          await _geolocator.placemarkFromAddress(_destinationAddress);

      if (startPlacemark != null && destinationPlacemark != null) {
        // Use the retrieved coordinates of the current position,
        // instead of the address if the start position is user's
        // current position, as it results in better accuracy.
        Position startCoordinates = _startAddress == _currentAddress
            ? Position(
                latitude: _currentPosition.latitude,
                longitude: _currentPosition.longitude)
            : startPlacemark[0].position;
        Position destinationCoordinates = destinationPlacemark[0].position;

        // Start Location Marker
        Marker startMarker = Marker(
          markerId: MarkerId('$startCoordinates'),
          position: LatLng(
            startCoordinates.latitude,
            startCoordinates.longitude,
          ),
          infoWindow: InfoWindow(
            title: 'Start',
            snippet: _startAddress,
          ),
          icon: BitmapDescriptor.defaultMarker,
        );

        // Destination Location Marker
        Marker destinationMarker = Marker(
          markerId: MarkerId('$destinationCoordinates'),
          position: LatLng(
            destinationCoordinates.latitude,
            destinationCoordinates.longitude,
          ),
          infoWindow: InfoWindow(
            title: 'Destination',
            snippet: _destinationAddress,
          ),
          icon: BitmapDescriptor.defaultMarker,
        );

        // Adding the markers to the list
        markers.add(startMarker);
        markers.add(destinationMarker);

        print('START COORDINATES: $startCoordinates');
        print('DESTINATION COORDINATES: $destinationCoordinates');

        Position _northeastCoordinates;
        Position _southwestCoordinates;

        // Calculating to check that
        // southwest coordinate <= northeast coordinate
        if (startCoordinates.latitude <= destinationCoordinates.latitude) {
          _southwestCoordinates = startCoordinates;
          _northeastCoordinates = destinationCoordinates;
        } else {
          _southwestCoordinates = destinationCoordinates;
          _northeastCoordinates = startCoordinates;
        }

        // Accommodate the two locations within the
        // camera view of the map
        mapController.animateCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
              northeast: LatLng(
                _northeastCoordinates.latitude,
                _northeastCoordinates.longitude,
              ),
              southwest: LatLng(
                _southwestCoordinates.latitude,
                _southwestCoordinates.longitude,
              ),
            ),
            100.0,
          ),
        );

        // Calculating the distance between the start and the end positions
        // with a straight path, without considering any route
        // double distanceInMeters = await Geolocator().bearingBetween(
        //   startCoordinates.latitude,
        //   startCoordinates.longitude,
        //   destinationCoordinates.latitude,
        //   destinationCoordinates.longitude,
        // );

        await _createPolylines(startCoordinates, destinationCoordinates);

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

        setState(() {
          _placeDistance = totalDistance.toStringAsFixed(2);
          print('DISTANCE: $_placeDistance km');
        });

        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
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

  // Create the polylines for showing the route between two places
  _createPolylines(Position start, Position destination) async {
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Secrets.API_KEY, // Google Maps API Key
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(destination.latitude, destination.longitude),
//      travelMode: TravelMode.transit,
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
    polylines[id] = polyline;
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();

    provider =
        PlaceProvider(widget.apiKey, widget.proxyBaseUrl, widget.httpClient);
    provider.sessionToken = Uuid().generateV4();
    provider.desiredAccuracy = widget.desiredLocationAccuracy;
    provider.setMapType(widget.initialMapType);
  }

  @override
  void dispose() {
    searchBarController.dispose();

    super.dispose();
  }

  _pickPrediction(Prediction prediction) async {
    provider.placeSearchingState = SearchingState.Searching;

    final PlacesDetailsResponse response =
        await provider.places.getDetailsByPlaceId(
      prediction.placeId,
      sessionToken: provider.sessionToken,
      language: widget.autocompleteLanguage,
    );

    if (response.errorMessage?.isNotEmpty == true ||
        response.status == "REQUEST_DENIED") {
      print("AutoCompleteSearch Error: " + response.errorMessage);
      if (widget.onAutoCompleteFailed != null) {
        widget.onAutoCompleteFailed(response.status);
      }
      return;
    }

    provider.selectedPlace = PickResult.fromPlaceDetailResult(response.result);

    var a = provider.selectedPlace.formattedAddress;
    print('selected place result $a');

    // Prevents searching again by camera movement.
    provider.isAutoCompleteSearching = true;

    await _moveTo(provider.selectedPlace.geometry.location.lat,
        provider.selectedPlace.geometry.location.lng);

    provider.placeSearchingState = SearchingState.Idle;
  }

  _moveTo(double latitude, double longitude) async {
    GoogleMapController controller = provider.mapController;
    if (controller == null) return;

    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 16,
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Stack(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: <Widget>[
                //TODO: check if we need back button
//                widget.automaticallyImplyAppBarLeading
//                    ? IconButton(
//                        onPressed: () => Navigator.maybePop(context),
//                        icon: Icon(
//                          Platform.isIOS
//                              ? Icons.arrow_back_ios
//                              : Icons.arrow_back,
//                        ),
//                        padding: EdgeInsets.zero)
//                    : SizedBox(width: 15),
                SizedBox(width: 15),
                Expanded(
                  child: AutoCompleteSearch(
                      appBarKey: appBarKey,
                      searchBarController: searchBarController,
                      sessionToken: provider.sessionToken,
                      hintText: widget.hintText,
                      searchingText: widget.searchingText,
                      debounceMilliseconds:
                          widget.autoCompleteDebounceInMilliseconds,
                      onPicked: (prediction) {
                        _pickPrediction(prediction);
                      },
                      onSearchFailed: (status) {
                        if (widget.onAutoCompleteFailed != null) {
                          widget.onAutoCompleteFailed(status);
                        }
                      },
                      autocompleteOffset: widget.autocompleteOffset,
                      autocompleteRadius: widget.autocompleteRadius,
                      autocompleteLanguage: widget.autocompleteLanguage,
                      autocompleteComponents: widget.autocompleteComponents,
                      autocompleteTypes: widget.autocompleteTypes,
                      strictbounds: widget.strictbounds,
                      region: widget.region,
                      initialSearchString: widget.initialSearchString,
                      searchForInitialValue: widget.searchForInitialValue,
                      autocompleteOnTrailingWhitespace:
                          widget.autocompleteOnTrailingWhitespace),
                ),
                // SizedBox(width: 5),
              ],
            ),
            Row(
              children: <Widget>[
                SizedBox(width: 15),
                Expanded(
                  child: AutoCompleteSearch(
                      appBarKey: appBarKey,
                      searchBarController: searchBarDestinationController,
                      sessionToken: provider.sessionToken,
                      hintText: widget.hintDirectionText,
                      searchingText: widget.searchingText,
                      debounceMilliseconds:
                          widget.autoCompleteDebounceInMilliseconds,
                      onPicked: (prediction) {
                        _pickPrediction(prediction);
                      },
                      onSearchFailed: (status) {
                        if (widget.onAutoCompleteFailed != null) {
                          widget.onAutoCompleteFailed(status);
                        }
                      },
                      autocompleteOffset: widget.autocompleteOffset,
                      autocompleteRadius: widget.autocompleteRadius,
                      autocompleteLanguage: widget.autocompleteLanguage,
                      autocompleteComponents: widget.autocompleteComponents,
                      autocompleteTypes: widget.autocompleteTypes,
                      strictbounds: widget.strictbounds,
                      region: widget.region,
                      initialSearchString: widget.initialSearchString,
                      searchForInitialValue: widget.searchForInitialValue,
                      autocompleteOnTrailingWhitespace:
                          widget.autocompleteOnTrailingWhitespace),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }

  Widget _buildMapWithLocation() {
    if (widget.useCurrentLocation) {
      return FutureBuilder(
          future: provider
              .updateCurrentLocation(widget.forceAndroidLocationManager),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (provider.currentPosition == null) {
                // return _buildMap(widget.initialPosition);
                return _buildMap(LatLng(
                    _currentPosition.latitude, _currentPosition.longitude));
              } else {
                return _buildMap(LatLng(provider.currentPosition.latitude,
                    provider.currentPosition.longitude));
              }
            }
          });
    } else {
      return FutureBuilder(
        future: Future.delayed(Duration(milliseconds: 1)),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return _buildMap(
                LatLng(_currentPosition.latitude, _currentPosition.longitude));
          }
        },
      );
    }
  }

  Widget _buildMap(LatLng initialTarget) {
    return GoogleMapPlacePicker(
      // polylines: polylines,
      initialTarget: initialTarget,
      appBarKey: appBarKey,
      selectedPlaceWidgetBuilder: widget.selectedPlaceWidgetBuilder,
      pinBuilder: widget.pinBuilder,
      onSearchFailed: widget.onGeocodingSearchFailed,
      debounceMilliseconds: widget.cameraMoveDebounceInMilliseconds,
      enableMapTypeButton: widget.enableMapTypeButton,
      enableMyLocationButton: widget.enableMyLocationButton,
      usePinPointingSearch: widget.usePinPointingSearch,
      usePlaceDetailSearch: widget.usePlaceDetailSearch,
      onMapCreated: widget.onMapCreated,
      selectInitialPosition: widget.selectInitialPosition,
      language: widget.autocompleteLanguage,
      forceSearchOnZoomChanged: widget.forceSearchOnZoomChanged,
      hidePlaceDetailsWhenDraggingPin: widget.hidePlaceDetailsWhenDraggingPin,
      onToggleMapType: () {
        provider.switchMapType();
      },
      createRoute: () {
        // addLocation(searchBarController.getSearchBarInfo(),searchBarDestinationController.getSearchBarInfo());

        print(searchBarController.getSearchBarInfo());
        print(searchBarDestinationController.getSearchBarInfo());
      },
      onMyLocation: () async {
        // Prevent to click many times in short period.
        if (provider.isOnUpdateLocationCooldown == false) {
          provider.isOnUpdateLocationCooldown = true;
          Timer(Duration(seconds: widget.myLocationButtonCooldown), () {
            provider.isOnUpdateLocationCooldown = false;
          });
          // await provider
          //     .updateCurrentLocation(widget.forceAndroidLocationManager);
          // await _moveToCurrentPosition();
          await _moveTo(_currentPosition.latitude, _currentPosition.longitude);
        }
      },
      onMoveStart: () {
        searchBarController.reset();
      },
      onPlacePicked: widget.onPlacePicked,
    );
  }

  // Future<void> addLocation(String startLocation,String endLocation) async {
  //   await Firebase.initializeApp();
  //   await FirebaseFirestore.instance
  //       .collection("users")
  //       .add({
  //         'full_name': startLocation,
  //         'company': endLocation,
  //         'age': 12
  //       })
  //       .then((value) => print("User Added"))
  //       .catchError((error) => print("Failed to add user: $error"));
  // }

  // _moveToCurrentPosition() async {
  // if (provider.currentPosition != null) {
  //   await _moveTo(provider.currentPosition.latitude,
  //       provider.currentPosition.longitude);
  // }
  // }

//  @override
//  Widget build(BuildContext context) {
//    var height = MediaQuery.of(context).size.height;
//    var width = MediaQuery.of(context).size.width;
//    return Container(
//      height: height,
//      width: width,
//      child: Scaffold(
//        key: _scaffoldKey,
//        body: Stack(
//          children: <Widget>[
//            // Map View
//            GoogleMap(
//              markers: markers != null ? Set<Marker>.from(markers) : null,
//              initialCameraPosition: _initialLocation,
//              myLocationEnabled: true,
//              myLocationButtonEnabled: false,
//              mapType: MapType.normal,
//              zoomGesturesEnabled: true,
//              zoomControlsEnabled: false,
//              polylines: Set<Polyline>.of(polylines.values),
//              onMapCreated: (GoogleMapController controller) {
//                mapController = controller;
//              },
//            ),
//            // Show zoom buttons
//            SafeArea(
//              child: Padding(
//                padding: const EdgeInsets.only(left: 10.0),
//                child: Column(
//                  mainAxisAlignment: MainAxisAlignment.center,
//                  children: <Widget>[
//                    ClipOval(
//                      child: Material(
//                        color: Colors.blue[100], // button color
//                        child: InkWell(
//                          splashColor: Colors.blue, // inkwell color
//                          child: SizedBox(
//                            width: 50,
//                            height: 50,
//                            child: Icon(Icons.add),
//                          ),
//                          onTap: () {
//                            mapController.animateCamera(
//                              CameraUpdate.zoomIn(),
//                            );
//                          },
//                        ),
//                      ),
//                    ),
//                    SizedBox(height: 20),
//                    ClipOval(
//                      child: Material(
//                        color: Colors.blue[100], // button color
//                        child: InkWell(
//                          splashColor: Colors.blue, // inkwell color
//                          child: SizedBox(
//                            width: 50,
//                            height: 50,
//                            child: Icon(Icons.remove),
//                          ),
//                          onTap: () {
//                            mapController.animateCamera(
//                              CameraUpdate.zoomOut(),
//                            );
//                          },
//                        ),
//                      ),
//                    )
//                  ],
//                ),
//              ),
//            ),
//            // Show the place input fields & button for
//            // showing the route
//            SafeArea(
//              child: Align(
//                alignment: Alignment.topCenter,
//                child: Padding(
//                  padding: const EdgeInsets.only(top: 10.0),
//                  child: Container(
//                    decoration: BoxDecoration(
//                      color: Colors.white70,
//                      borderRadius: BorderRadius.all(
//                        Radius.circular(20.0),
//                      ),
//                    ),
//                    width: width * 0.9,
//                    child: Padding(
//                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
//                      child: Column(
//                        mainAxisSize: MainAxisSize.min,
//                        children: <Widget>[
//                          Text(
//                            'Places',
//                            style: TextStyle(fontSize: 20.0),
//                          ),
//                          SizedBox(height: 10),
//                          _textField(
//                              label: 'Start',
//                              hint: 'Choose starting point',
//                              prefixIcon: Icon(Icons.looks_one),
//                              suffixIcon: IconButton(
//                                icon: Icon(Icons.my_location),
//                                onPressed: () {
//                                  startAddressController.text = _currentAddress;
//                                  _startAddress = _currentAddress;
//                                },
//                              ),
//                              controller: startAddressController,
//                              width: width,
//                              locationCallback: (String value) {
//                                setState(() {
//                                  _startAddress = value;
//                                });
//                              }),
//                          SizedBox(height: 10),
//                          _textField(
//                              label: 'Destination',
//                              hint: 'Choose destination',
//                              prefixIcon: Icon(Icons.looks_two),
//                              controller: destinationAddressController,
//                              width: width,
//                              locationCallback: (String value) {
//                                setState(() {
//                                  _destinationAddress = value;
//                                });
//                              }),
//                          SizedBox(height: 10),
//                          Visibility(
//                            visible: _placeDistance == null ? false : true,
//                            child: Text(
//                              'DISTANCE: $_placeDistance km',
//                              style: TextStyle(
//                                fontSize: 16,
//                                fontWeight: FontWeight.bold,
//                              ),
//                            ),
//                          ),
//                          SizedBox(height: 5),
//                          RaisedButton(
//                            onPressed: (_startAddress != '' &&
//                                    _destinationAddress != '')
//                                ? () async {
//                                    setState(() {
//                                      if (markers.isNotEmpty) markers.clear();
//                                      if (polylines.isNotEmpty)
//                                        polylines.clear();
//                                      if (polylineCoordinates.isNotEmpty)
//                                        polylineCoordinates.clear();
//                                      _placeDistance = null;
//                                    });
//
//                                    _calculateDistance().then((isCalculated) {
//                                      if (isCalculated) {
//                                        _scaffoldKey.currentState.showSnackBar(
//                                          SnackBar(
//                                            content: Text(
//                                                'Distance Calculated Sucessfully'),
//                                          ),
//                                        );
//                                      } else {
//                                        _scaffoldKey.currentState.showSnackBar(
//                                          SnackBar(
//                                            content: Text(
//                                                'Error Calculating Distance'),
//                                          ),
//                                        );
//                                      }
//                                    });
//                                  }
//                                : null,
//                            color: Colors.red,
//                            shape: RoundedRectangleBorder(
//                              borderRadius: BorderRadius.circular(20.0),
//                            ),
//                            child: Padding(
//                              padding: const EdgeInsets.all(8.0),
//                              child: Text(
//                                'Show Route'.toUpperCase(),
//                                style: TextStyle(
//                                  color: Colors.white,
//                                  fontSize: 20.0,
//                                ),
//                              ),
//                            ),
//                          ),
//                        ],
//                      ),
//                    ),
//                  ),
//                ),
//              ),
//            ),
//            // Show current location button
//            SafeArea(
//              child: Align(
//                alignment: Alignment.bottomRight,
//                child: Padding(
//                  padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
//                  child: ClipOval(
//                    child: Material(
//                      color: Colors.orange[100], // button color
//                      child: InkWell(
//                        splashColor: Colors.orange, // inkwell color
//                        child: SizedBox(
//                          width: 56,
//                          height: 56,
//                          child: Icon(Icons.my_location),
//                        ),
//                        onTap: () {
//                          mapController.animateCamera(
//                            CameraUpdate.newCameraPosition(
//                              CameraPosition(
//                                target: LatLng(
//                                  _currentPosition.latitude,
//                                  _currentPosition.longitude,
//                                ),
//                                zoom: 18.0,
//                              ),
//                            ),
//                          );
//                        },
//                      ),
//                    ),
//                  ),
//                ),
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          searchBarController.clearOverlay();
          return Future.value(true);
        },
        child: ChangeNotifierProvider.value(
          value: provider,
          child: Builder(
            builder: (context) {
              return Scaffold(
                resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
                extendBodyBehindAppBar: true,
                appBar: AppBar(
                  toolbarHeight: 90.0,
                  key: appBarKey,
                  automaticallyImplyLeading: false,
                  iconTheme: Theme.of(context).iconTheme,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  titleSpacing: 0.0,
                  title: _buildSearchBar(),
                ),
                body: _buildMapWithLocation(),
              );
            },
          ),
        ));
  }
}
