import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart';
import 'package:khedni_maak/config/palette.dart';
import 'package:khedni_maak/firebase_notification/firebase_send_notification.dart';
import 'package:khedni_maak/google_map/providers/place_provider.dart';
import 'package:khedni_maak/google_map/src/utils/uuid.dart';
import 'package:khedni_maak/login/custom_route.dart';
import 'package:khedni_maak/screens/add_route_screen.dart';
import 'package:khedni_maak/widgets/display_flash_bar.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:provider/provider.dart';

import '../google_map/src/google_map_place_picker.dart';
import '../google_map/src/models/pick_result.dart';

enum PinState { Preparing, Idle, Dragging }
enum SearchingState { Idle, Searching }

class MapScreen extends StatefulWidget {
  MapScreen({
    Key key,
    @required this.apiKey,
    this.onPlacePicked,
    @required this.initialPosition,
    this.useCurrentLocation = true,
    this.desiredLocationAccuracy = LocationAccuracy.high,
    this.onMapCreated,
    this.hintText = 'From',
    this.hintDirectionText = 'To',
    this.searchingText,
    this.polylines,
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
    this.myLocationButtonCooldown = 10,
    this.usePinPointingSearch = true,
    this.usePlaceDetailSearch = false,
    this.autocompleteOffset,
    this.autocompleteRadius,
    this.autocompleteLanguage,
    this.autocompleteComponents,
    this.autocompleteTypes,
    this.strictbounds,
    this.region,
    this.selectInitialPosition = false,
    this.resizeToAvoidBottomInset = true,
    this.initialSearchString,
    this.searchForInitialValue = false,
    this.forceAndroidLocationManager = false,
    this.forceSearchOnZoomChanged = false,
    this.automaticallyImplyAppBarLeading = true,
    this.autocompleteOnTrailingWhitespace = false,
    this.hidePlaceDetailsWhenDraggingPin = true,
    this.lngFrom,
    this.latFrom,
    this.lngTo,
    this.latTo,
  }) : super(key: key);

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
  final Map<PolylineId, Polyline> polylines;

  final double lngFrom;
  final double latFrom;
  final double lngTo;
  final double latTo;

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
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GlobalKey appBarKey = GlobalKey();
  PlaceProvider provider;
  Map<PolylineId, Polyline> polylines;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();

    provider =
        PlaceProvider(widget.apiKey, widget.proxyBaseUrl, widget.httpClient);
    provider.sessionToken = Uuid().generateV4();
    provider.desiredAccuracy = widget.desiredLocationAccuracy;
    provider.setMapType(widget.initialMapType);
    polylines = widget.polylines;

    provider.lngFrom = widget.lngFrom;
    provider.latFrom = widget.latFrom;
    provider.lngTo = widget.lngTo;
    provider.latTo = widget.latTo;

    initMap();
  }

  void initMap() async {
    await provider.updateCurrentLocation(widget.forceAndroidLocationManager);
    await _moveToCurrentPosition();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(true);
      },
      child: ChangeNotifierProvider.value(
        value: provider,
        child: Builder(
          builder: (context) {
            return Scaffold(
              resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
              extendBodyBehindAppBar: true,
              body: _buildMapWithLocation(),
              floatingActionButton: _buildFloatingActionButtons(context),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFloatingActionButtons(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(
        children: [
          SizedBox(height: 20.0),
          Container(
            height: 40.0,
            width: 40.0,
            child: FittedBox(
              child: FloatingActionButton(
                heroTag: "btn1",
                onPressed: _onToggleMapType,
                elevation: 8.0,
                child: Icon(OMIcons.layers),
                backgroundColor: Palette.secondColor,
              ),
            ),
          ),
        ],
      ),
      Column(
        children: [
          Container(
            height: 40.0,
            width: 40.0,
            child: FittedBox(
              child: FloatingActionButton(
                heroTag: "btn2",
                onPressed: _getMyLocation,
                elevation: 8.0,
                child: Icon(OMIcons.myLocation),
                backgroundColor: Palette.secondColor,
              ),
            ),
          ),
          SizedBox(height: 5.0),
          Container(
            height: 40.0,
            width: 40.0,
            child: FittedBox(
              child: FloatingActionButton(
                heroTag: "btn3",
                onPressed: _navigateToAddRouteScreen,
                elevation: 8.0,
                child: Icon(OMIcons.directions),
                backgroundColor: Palette.secondColor,
              ),
            ),
          ),
        ],
      ),
    ]);
  }

  _getMyLocation() {
    provider.updateCurrentLocation(widget.forceAndroidLocationManager);
    _moveToCurrentPosition();
  }

  _onToggleMapType() {
    provider.switchMapType();
  }

  void sentNotification(Map addRouteResponse) {
    String routeId = "${addRouteResponse['routeId']}";
    String notificationTopic = 'route-$routeId';
    _firebaseMessaging.subscribeToTopic(notificationTopic);

    String notificationBody =
        'From ${addRouteResponse['fromSelectedPlace'].formattedAddress} to ${addRouteResponse['toSelectedPlace'].formattedAddress}';

    Map routesInfo = new Map();

    if (addRouteResponse != null) {
      routesInfo['requestReason'] = "addNewRoute";
      routesInfo['requestFrom'] = "driver";
      routesInfo['routeId'] = "${addRouteResponse['routeId']}";
      routesInfo['driverUsername'] = addRouteResponse['driverUsername'];
      routesInfo['from'] =
          addRouteResponse['fromSelectedPlace'].formattedAddress;
      routesInfo['to'] = addRouteResponse['toSelectedPlace'].formattedAddress;
      routesInfo['requestDateTime'] = DateTime.now().toString();
    }

    sendAndRetrieveMessage(
            "New ride !", notificationBody, "all-users", routesInfo)
        .then((value) => {
              if (value.statusCode == 200)
                print("notification sent successfully")
              else
                print('failed to sent notification')
            });
  }

  _navigateToAddRouteScreen() {
    Navigator.push(
      context,
      FadePageRoute(
        builder: (context) => AddRouteScreen(
            sessionToken: provider.sessionToken, appBarKey: appBarKey),
      ),
    ).then(
      (addRouteResponse) => {
        if (addRouteResponse != null) _handleAddRouteResponse(addRouteResponse)
      },
    );
  }

  _handleAddRouteResponse(addRouteResponse) async {
    DisplayFlashBar.displayFlashBar(
        addRouteResponse['status'],
        addRouteResponse['status'] == 'success'
            ? "Route added"
            : 'Failed to add a new route',
        context);

    if (addRouteResponse['status'] == 'success') {
      sentNotification(addRouteResponse);
    }

    await _createPolyLines(addRouteResponse['fromSelectedPlace'],
        addRouteResponse['toSelectedPlace']);

    provider.lngFrom = addRouteResponse['lngStart'];
    provider.latFrom = addRouteResponse['latStart'];
    provider.lngTo = addRouteResponse['lngEnd'];
    provider.latTo = addRouteResponse['latEnd'];

    provider.moveToPolyLine();
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

  _moveToCurrentPosition() async {
    if (provider.currentPosition != null) {
      await _moveTo(provider.currentPosition.latitude,
          provider.currentPosition.longitude);
    }
  }

  _createPolyLines(
      PickResult fromSelectedPlace, PickResult toSelectedPlace) async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      widget.apiKey, // Google Maps API Key
      PointLatLng(fromSelectedPlace.geometry.location.lat,
          fromSelectedPlace.geometry.location.lng),
      PointLatLng(toSelectedPlace.geometry.location.lat,
          toSelectedPlace.geometry.location.lng),
      // travelMode: TravelMode.transit,
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

    setState(() {
      polylines = newPolylines;
    });
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
                return _buildMap(widget.initialPosition);
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
            return _buildMap(widget.initialPosition);
          }
        },
      );
    }
  }

  Widget _buildMap(LatLng initialTarget) {
    return GoogleMapPlacePicker(
      polyLines: polylines,
      appBarKey: appBarKey,
      initialTarget: initialTarget,
      pinBuilder: widget.pinBuilder,
      onMapCreated: widget.onMapCreated,
      onPlacePicked: widget.onPlacePicked,
      language: widget.autocompleteLanguage,
      onSearchFailed: widget.onGeocodingSearchFailed,
      enableMapTypeButton: widget.enableMapTypeButton,
      usePinPointingSearch: widget.usePinPointingSearch,
      usePlaceDetailSearch: widget.usePlaceDetailSearch,
      selectInitialPosition: widget.selectInitialPosition,
      enableMyLocationButton: widget.enableMyLocationButton,
      forceSearchOnZoomChanged: widget.forceSearchOnZoomChanged,
      selectedPlaceWidgetBuilder: widget.selectedPlaceWidgetBuilder,
      debounceMilliseconds: widget.cameraMoveDebounceInMilliseconds,
      hidePlaceDetailsWhenDraggingPin: widget.hidePlaceDetailsWhenDraggingPin,
    );
  }
}
