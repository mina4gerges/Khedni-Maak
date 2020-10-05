import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';

void main() => runApp(MapMain());

class MapMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Google Maps Demo',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  PickResult selectedPlace;

//  _getCurrentLocation() {
//    geolocator
//        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
//        .then((Position position) {
//      setState(() {
//        _currentPosition = position;
//      });
//
//      _getAddressFromLatLng();
//    }).catchError((e) {
//      print(e);
//    });
//  }

  static final kInitialPosition = LatLng(-29.8567844, 101.213108);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PlacePicker(
          apiKey: '',
          initialPosition: kInitialPosition,
          useCurrentLocation: true,
          selectInitialPosition: true,

          //usePlaceDetailSearch: true,
          onPlacePicked: (result) {
            selectedPlace = result;
            Navigator.of(context).pop();
            setState(() {});
          },
          //forceSearchOnZoomChanged: true,
          //automaticallyImplyAppBarLeading: false,
          //autocompleteLanguage: "ko",
//          region: 'lb',
//          selectInitialPosition: true,
          selectedPlaceWidgetBuilder:
              (_, selectedPlace, state, isSearchBarFocused) {
            print("state: $state, isSearchBarFocused: $isSearchBarFocused");
            return isSearchBarFocused
                ? Container()
                : FloatingCard(
                    bottomPosition: 0.0,
                    // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
                    leftPosition: 0.0,
                    rightPosition: 0.0,
                    width: 500,
                    borderRadius: BorderRadius.circular(12.0),
                    child: state == SearchingState.Searching
                        ? Center(child: CircularProgressIndicator())
                        : RaisedButton(
                            child: Text("Pick Here"),
                            onPressed: () {
                              // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
                              //            this will override default 'Select here' Button.
                              print("do something with [selectedPlace] data");
                              Navigator.of(context).pop();
                            },
                          ),
                  );
          },
        )
      ],
    );
  }
}
