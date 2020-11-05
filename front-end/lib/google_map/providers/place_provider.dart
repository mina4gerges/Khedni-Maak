import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart';
import 'package:khedni_maak/google_map/src/models/pick_result.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../google_maps_place_picker.dart';

class PlaceProvider extends ChangeNotifier {
  PlaceProvider(String apiKey, String proxyBaseUrl, Client httpClient) {
    places = GoogleMapsPlaces(
      apiKey: apiKey,
      baseUrl: proxyBaseUrl,
      httpClient: httpClient,
    );

    geocoding = GoogleMapsGeocoding(
      apiKey: apiKey,
      baseUrl: proxyBaseUrl,
      httpClient: httpClient,
    );
  }

  static PlaceProvider of(BuildContext context, {bool listen = true}) =>
      Provider.of<PlaceProvider>(context, listen: listen);

  GoogleMapsPlaces places;
  GoogleMapsGeocoding geocoding;
  String sessionToken;
  bool isOnUpdateLocationCooldown = false;
  LocationAccuracy desiredAccuracy;
  bool isAutoCompleteSearching = false;

  Future<void> updateCurrentLocation(bool forceAndroidLocationManager) async {
    try {
      await Permission.location.request();
      if (await Permission.location.request().isGranted) {
        Position position =
            await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

        currentPosition = position;
      } else {
        currentPosition = null;
      }
    } catch (e) {
      print(e);
      currentPosition = null;
    }

    notifyListeners();
  }

  Position _currentPoisition;

  Position get currentPosition => _currentPoisition;

  set currentPosition(Position newPosition) {
    _currentPoisition = newPosition;
    notifyListeners();
  }

  Timer _debounceTimer;

  Timer get debounceTimer => _debounceTimer;

  set debounceTimer(Timer timer) {
    _debounceTimer = timer;
    notifyListeners();
  }

  CameraPosition _previousCameraPosition;

  CameraPosition get prevCameraPosition => _previousCameraPosition;

  setPrevCameraPosition(CameraPosition prePosition) {
    _previousCameraPosition = prePosition;
  }

  CameraPosition _currentCameraPosition;

  CameraPosition get cameraPosition => _currentCameraPosition;

  setCameraPosition(CameraPosition newPosition) {
    _currentCameraPosition = newPosition;
  }

  PickResult _selectedPlace;

  PickResult get selectedPlace => _selectedPlace;

  set selectedPlace(PickResult result) {
    _selectedPlace = result;
    notifyListeners();
  }

  PickResult _startLocation;

  PickResult get startLocation => _startLocation;

  set startLocation(PickResult newStartLocation) {
    _startLocation = newStartLocation;
    notifyListeners();
  }

  PickResult _endLocation;

  PickResult get endLocation => _endLocation;

  set endLocation(PickResult newStartLocation) {
    _endLocation = newStartLocation;
    notifyListeners();
  }

  Set<Marker> _markers;

  Set<Marker> get markers => _markers;

  set markers(Set<Marker> newMarkers) {
    _markers = newMarkers;
    notifyListeners();
  }

  Map<PolylineId, Polyline> _polylines;

  Map<PolylineId, Polyline> get polylines => _polylines;

  set polylines(Map<PolylineId, Polyline> newPolylines) {
    _polylines = newPolylines;
    notifyListeners();
  }

  SearchingState _placeSearchingState = SearchingState.Idle;

  SearchingState get placeSearchingState => _placeSearchingState;

  set placeSearchingState(SearchingState newState) {
    _placeSearchingState = newState;
    notifyListeners();
  }

  GoogleMapController _mapController;

  GoogleMapController get mapController => _mapController;

  set mapController(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  PinState _pinState = PinState.Preparing;

  PinState get pinState => _pinState;

  set pinState(PinState newState) {
    _pinState = newState;
    notifyListeners();
  }

  bool _isSeachBarFocused = false;

  bool get isSearchBarFocused => _isSeachBarFocused;

  set isSearchBarFocused(bool focused) {
    _isSeachBarFocused = focused;
    notifyListeners();
  }

  MapType _mapType = MapType.normal;

  MapType get mapType => _mapType;

  setMapType(MapType mapType, {bool notify = false}) {
    _mapType = mapType;
    if (notify) notifyListeners();
  }

  switchMapType() {
    _mapType = MapType.values[(_mapType.index + 1) % MapType.values.length];
    if (_mapType == MapType.none) _mapType = MapType.normal;

    notifyListeners();
  }

  double _lngFrom = 0.0;

  double get lngFrom => _lngFrom;

  set lngFrom(double lngFrom) {
    _lngFrom = lngFrom;
    notifyListeners();
  }

  double _latFrom = 0.0;

  double get latFrom => _latFrom;

  set latFrom(double latFrom) {
    _latFrom = latFrom;
    notifyListeners();
  }

  double _lngTo = 0.0;

  double get lngTo => _lngTo;

  set lngTo(double lngTo) {
    _lngTo = lngTo;
    notifyListeners();
  }

  double _latTo = 0.0;

  double get latTo => _latTo;

  set latTo(double latTo) {
    _latTo = latTo;
    notifyListeners();
  }

  // Future<void> moveToPolyLine(double lngFrom,double latFrom,double lngTo,double latTo) async {
  Future<void> moveToPolyLine() async {

    if (mapController == null) return;

    if (lngFrom == null &&
        latFrom == null &&
        lngTo == null &&
        latTo == null) return;

    Position fromLocationLatLng =
    new Position(longitude: lngFrom, latitude: latFrom);
    Position toLocationLatLng =
    new Position(longitude:lngTo, latitude: latTo);

    await mapController.animateCamera(
      CameraUpdate.newLatLngBounds(
          LatLngBounds(
              southwest: LatLng(
                  fromLocationLatLng.latitude <= toLocationLatLng.latitude
                      ? fromLocationLatLng.latitude
                      : toLocationLatLng.latitude,
                  fromLocationLatLng.longitude <= toLocationLatLng.longitude
                      ? fromLocationLatLng.longitude
                      : toLocationLatLng.longitude),
              northeast: LatLng(
                  fromLocationLatLng.latitude <= toLocationLatLng.latitude
                      ? toLocationLatLng.latitude
                      : fromLocationLatLng.latitude,
                  fromLocationLatLng.longitude <= toLocationLatLng.longitude
                      ? toLocationLatLng.longitude
                      : fromLocationLatLng.longitude)),
          100),
    );

    notifyListeners();
  }
}
