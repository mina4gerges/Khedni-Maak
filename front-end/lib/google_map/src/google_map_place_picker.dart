import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:khedni_maak/google_map/providers/place_provider.dart';
import 'package:provider/provider.dart';

import '../../screens/map_screen.dart';
import 'models/pick_result.dart';

typedef SelectedPlaceWidgetBuilder = Widget Function(
  BuildContext context,
  PickResult selectedPlace,
  SearchingState state,
  bool isSearchBarFocused,
);

typedef PinBuilder = Widget Function(
  BuildContext context,
  PinState state,
);

class GoogleMapPlacePicker extends StatelessWidget {
  const GoogleMapPlacePicker({
    Key key,
    @required this.initialTarget,
    @required this.appBarKey,
    this.polyLines,
    this.selectedPlaceWidgetBuilder,
    this.pinBuilder,
    this.onSearchFailed,
    this.onMoveStart,
    this.onMapCreated,
    this.debounceMilliseconds,
    this.enableMapTypeButton,
    this.enableMyLocationButton,
    this.onToggleMapType,
    this.onMyLocation,
    this.onPlacePicked,
    this.usePinPointingSearch,
    this.usePlaceDetailSearch,
    this.selectInitialPosition,
    this.language,
    this.forceSearchOnZoomChanged,
    this.hidePlaceDetailsWhenDraggingPin,
  }) : super(key: key);

  final LatLng initialTarget;
  final GlobalKey appBarKey;

  final Map<PolylineId, Polyline> polyLines;

  final SelectedPlaceWidgetBuilder selectedPlaceWidgetBuilder;
  final PinBuilder pinBuilder;

  final ValueChanged<String> onSearchFailed;
  final VoidCallback onMoveStart;
  final MapCreatedCallback onMapCreated;
  final VoidCallback onToggleMapType;
  final VoidCallback onMyLocation;
  final ValueChanged<PickResult> onPlacePicked;

  final int debounceMilliseconds;
  final bool enableMapTypeButton;
  final bool enableMyLocationButton;

  final bool usePinPointingSearch;
  final bool usePlaceDetailSearch;

  final bool selectInitialPosition;

  final String language;

  final bool forceSearchOnZoomChanged;
  final bool hidePlaceDetailsWhenDraggingPin;

  _searchByCameraLocation(PlaceProvider provider) async {
    // We don't want to search location again if camera location is changed by zooming in/out.
    bool hasZoomChanged = provider.cameraPosition != null &&
        provider.prevCameraPosition != null &&
        provider.cameraPosition.zoom != provider.prevCameraPosition.zoom;

    if (forceSearchOnZoomChanged == false && hasZoomChanged) {
      provider.placeSearchingState = SearchingState.Idle;
      return;
    }

    provider.placeSearchingState = SearchingState.Searching;

    final GeocodingResponse response =
        await provider.geocoding.searchByLocation(
      Location(provider.cameraPosition.target.latitude,
          provider.cameraPosition.target.longitude),
      language: language,
    );

    if (response.errorMessage?.isNotEmpty == true ||
        response.status == "REQUEST_DENIED") {
      print("Camera Location Search Error: " + response.errorMessage);
      if (onSearchFailed != null) {
        onSearchFailed(response.status);
      }
      provider.placeSearchingState = SearchingState.Idle;
      return;
    }

    if (usePlaceDetailSearch) {
      final PlacesDetailsResponse detailResponse =
          await provider.places.getDetailsByPlaceId(
        response.results[0].placeId,
        language: language,
      );

      if (detailResponse.errorMessage?.isNotEmpty == true ||
          detailResponse.status == "REQUEST_DENIED") {
        print("Fetching details by placeId Error: " +
            detailResponse.errorMessage);
        if (onSearchFailed != null) {
          onSearchFailed(detailResponse.status);
        }
        provider.placeSearchingState = SearchingState.Idle;
        return;
      }

      provider.selectedPlace =
          PickResult.fromPlaceDetailResult(detailResponse.result);
    } else {
      provider.selectedPlace =
          PickResult.fromGeocodingResult(response.results[0]);
    }

    provider.placeSearchingState = SearchingState.Idle;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildGoogleMap(context),
        _buildPin(),
      ],
    );
  }

  Widget _buildGoogleMap(BuildContext context) {
    return Selector<PlaceProvider, MapType>(
        selector: (_, provider) => provider.mapType,
        builder: (_, data, __) {
          PlaceProvider provider = PlaceProvider.of(context, listen: false);
          CameraPosition initialCameraPosition =
              CameraPosition(target: initialTarget, zoom: 15);

          return GoogleMap(
            myLocationButtonEnabled: false,
            compassEnabled: false,
            mapToolbarEnabled: false,
            initialCameraPosition: initialCameraPosition,
            mapType: data,
            myLocationEnabled: true,

            markers: provider.markers != null
                ? Set<Marker>.from(provider.markers)
                : null,
            polylines:
                polyLines != null ? Set<Polyline>.from(polyLines.values) : null,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              provider.mapController = controller;
              provider.setCameraPosition(null);
              provider.pinState = PinState.Idle;

              // When select initialPosition set to true.
              if (selectInitialPosition) {
                provider.setCameraPosition(initialCameraPosition);
                _searchByCameraLocation(provider);
              }
              provider.moveToPolyLine();
            },
            onCameraIdle: () {
              if (provider.isAutoCompleteSearching) {
                provider.isAutoCompleteSearching = false;
                provider.pinState = PinState.Idle;
                return;
              }

              // Perform search only if the setting is to true.
              if (usePinPointingSearch) {
                // Search current camera location only if camera has moved (dragged) before.
                if (provider.pinState == PinState.Dragging) {
                  // Cancel previous timer.
                  if (provider.debounceTimer?.isActive ?? false) {
                    provider.debounceTimer.cancel();
                  }
                  provider.debounceTimer =
                      Timer(Duration(milliseconds: debounceMilliseconds), () {
                    _searchByCameraLocation(provider);
                  });
                }
              }

              provider.pinState = PinState.Idle;
            },
            onCameraMoveStarted: () {
              provider.setPrevCameraPosition(provider.cameraPosition);

              // Cancel any other timer.
              provider.debounceTimer?.cancel();

              // Update state, dismiss keyboard and clear text.
              provider.pinState = PinState.Dragging;

              // Begins the search state if the hide details is enabled
              if (this.hidePlaceDetailsWhenDraggingPin) {
                provider.placeSearchingState = SearchingState.Searching;
              }

              onMoveStart();
            },
            onCameraMove: (CameraPosition position) {
              provider.setCameraPosition(position);
            },
            // gestureRecognizers make it possible to navigate the map when it's a
            // child in a scroll view e.g ListView, SingleChildScrollView...
            gestureRecognizers: Set()
              ..add(Factory<EagerGestureRecognizer>(
                  () => EagerGestureRecognizer())),
          );
        });
  }

  Widget _buildPin() {
    return Center(
      child: Selector<PlaceProvider, PinState>(
        selector: (_, provider) => provider.pinState,
        builder: (context, state, __) {
          if (pinBuilder == null) {
            return _defaultPinBuilder(context, state);
          } else {
            return Builder(
                builder: (builderContext) => pinBuilder(builderContext, state));
          }
        },
      ),
    );
  }

  Widget _defaultPinBuilder(BuildContext context, PinState state) {
    if (state == PinState.Preparing) {
      return Container();
    } else {
      return Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.place, size: 36, color: Colors.red),
                SizedBox(height: 42),
              ],
            ),
          ),
          Center(
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      );
    }
  }
}
