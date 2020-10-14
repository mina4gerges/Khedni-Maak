import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart';
import 'package:khedni_maak/google_map/test_map/new/providers/place_provider.dart';
import 'package:khedni_maak/google_map/test_map/new/src/utils/uuid.dart';
import 'package:provider/provider.dart';

import 'autocomplete_search.dart';
import 'controllers/autocomplete_search_controller.dart';
import 'google_map_place_picker.dart';
import 'models/pick_result.dart';

enum PinState { Preparing, Idle, Dragging }
enum SearchingState { Idle, Searching }

class PlacePicker extends StatefulWidget {
  PlacePicker(
      {Key key,
      @required this.apiKey,
      this.onPlacePicked,
      @required this.initialPosition,
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
  _PlacePickerState createState() => _PlacePickerState();
}

class _PlacePickerState extends State<PlacePicker> {
  GlobalKey appBarKey = GlobalKey();
  PlaceProvider provider;
  SearchBarController searchBarController = SearchBarController();
  SearchBarController searchBarDestinationController = SearchBarController();

  @override
  void initState() {
    super.initState();

    provider =
        PlaceProvider(widget.apiKey, widget.proxyBaseUrl, widget.httpClient);
    provider.sessionToken = Uuid().generateV4();
    provider.desiredAccuracy = widget.desiredLocationAccuracy;
    provider.setMapType(widget.initialMapType);

test();
  }

  void test ()async{
    await provider
        .updateCurrentLocation(widget.forceAndroidLocationManager);
    await _moveToCurrentPosition();
  }

  @override
  void dispose() {
    searchBarController.dispose();
    searchBarDestinationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        onWillPop: () {
          searchBarController.clearOverlay();
          searchBarDestinationController.clearOverlay();
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

  Widget _buildSearchBar() {
    return Stack(
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: <Widget>[
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
                        _pickPrediction(prediction, 'startPoint');
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
                        _pickPrediction(prediction, 'endPoint');
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

  _pickPrediction(Prediction prediction, String source) async {
    provider.placeSearchingState = SearchingState.Searching;

    final PlacesDetailsResponse response =
        await provider.places.getDetailsByPlaceId(
      prediction.placeId,
      sessionToken: provider.sessionToken,
      language: widget.autocompleteLanguage,
    );

    //TODO check here if we can get the location

    if (response.errorMessage?.isNotEmpty == true ||
        response.status == "REQUEST_DENIED") {
      print("AutoCompleteSearch Error: " + response.errorMessage);
      if (widget.onAutoCompleteFailed != null) {
        widget.onAutoCompleteFailed(response.status);
      }
      return;
    }

    provider.selectedPlace = PickResult.fromPlaceDetailResult(response.result);

    // Prevents searching again by camera movement.
    provider.isAutoCompleteSearching = true;

    await _moveTo(provider.selectedPlace.geometry.location.lat,
        provider.selectedPlace.geometry.location.lng);

    if (source == 'startPoint') {
      provider.startLocation = provider.selectedPlace;
    } else if (source == 'endPoint') {
      provider.endLocation = provider.selectedPlace;
    }

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

  _moveToCurrentPosition() async {
    if (provider.currentPosition != null) {
      await _moveTo(provider.currentPosition.latitude,
          provider.currentPosition.longitude);
    }
  }

  // Method for calculating the distance between two places
  Future<bool> _createRoute() async {
    try {
      String startLocationId = provider.startLocation?.placeId;
      String endLocationId = provider.endLocation?.placeId;

      if (startLocationId.isNotEmpty && endLocationId.isNotEmpty) {
        String startLocationAddress = provider.startLocation.formattedAddress;
        String endLocationAddress = provider.endLocation.formattedAddress;

        double startLocationLat = provider.startLocation.geometry.location.lat;
        double startLocationLng = provider.startLocation.geometry.location.lng;

        double endLocationLat = provider.endLocation.geometry.location.lat;
        double endLocationLng = provider.endLocation.geometry.location.lng;

        Position startCoordinates =
            Position(latitude: startLocationLat, longitude: startLocationLng);
        Position destinationCoordinates =
            Position(latitude: endLocationLat, longitude: endLocationLng);

        // Start Location Marker
        Marker startMarker = Marker(
          markerId: MarkerId('$startCoordinates'),
          position: LatLng(
            startCoordinates.latitude,
            startCoordinates.longitude,
          ),
          infoWindow: InfoWindow(
            title: 'Start',
            snippet: startLocationAddress,
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
            snippet: endLocationAddress,
          ),
          icon: BitmapDescriptor.defaultMarker,
        );

        //get old markers
        Set<Marker> previousMarkers =
            provider.markers != null ? provider.markers : new Set<Marker>();

        // Adding the markers to the list
        previousMarkers.add(startMarker);
        previousMarkers.add(destinationMarker);

        //set new marker
        provider.markers = previousMarkers;

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
        GoogleMapController controller = provider.mapController;
        if (controller == null) return null;

        // await controller.animateCamera(
        //   CameraUpdate.newLatLngBounds(
        //     LatLngBounds(
        //       northeast: LatLng(
        //         _northeastCoordinates.latitude,
        //         _northeastCoordinates.longitude,
        //       ),
        //       southwest: LatLng(
        //         _southwestCoordinates.latitude,
        //         _southwestCoordinates.longitude,
        //       ),
        //     ),
        //     100.0,
        //   ),
        // );

        // Calculating the distance between the start and the end positions
        // with a straight path, without considering any route
        // double distanceInMeters = await Geolocator().bearingBetween(
        //   startCoordinates.latitude,
        //   startCoordinates.longitude,
        //   destinationCoordinates.latitude,
        //   destinationCoordinates.longitude,
        // );

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

        String _placeDistance = totalDistance.toStringAsFixed(2);

        print('DISTANCE: $_placeDistance km');

        //TODO: to remove later firebase exemple from here

        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  _createPolyLines(Position start, Position destination) async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      widget.apiKey, // Google Maps API Key
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
    provider.polylines = newPolylines;

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
        _createRoute();
        searchBarController.reset();
        searchBarDestinationController.reset();
      },
      onMyLocation: () async {
        // Prevent to click many times in short period.
        // if (provider.isOnUpdateLocationCooldown == false) {
        //   provider.isOnUpdateLocationCooldown = true;
        //   Timer(Duration(seconds: widget.myLocationButtonCooldown), () {
        //     provider.isOnUpdateLocationCooldown = false;
        //   });
        await provider
            .updateCurrentLocation(widget.forceAndroidLocationManager);
        await _moveToCurrentPosition();
        // }
      },
      onMoveStart: () {
        searchBarController.reset();
        searchBarDestinationController.reset();
      },
      onPlacePicked: widget.onPlacePicked,
    );
  }
}
