import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';

import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:khedni_maak/testFiles/firebase/add_user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:location/location.dart';
import 'package:rxdart/rxdart.dart';

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
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = HashSet<Marker>();

  GoogleMapController _mapController;
  Location location = new Location();

  Geoflutterfire geo = Geoflutterfire();

//  BehaviorSubject<double> radius = BehaviorSubject(seedValue:100.0);
  BehaviorSubject<double> radius = BehaviorSubject();
  Stream<dynamic> query;

  //Subscription
//  StreamSubscription subscription;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.77483, -122.41942),
    zoom: 12,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

//  Map Created Lifecycle Hook
  void _onMapCreated(GoogleMapController controller) {
//    _starQuerry();

    setState(() {
      _mapController = controller;
      _markers.add(Marker(
        markerId: MarkerId("0"),
        position: LatLng(37.77483, -122.41942),
        infoWindow:
            InfoWindow(title: "San Fransisco", snippet: "An Interesting city"),
      ));
    });
  }

  //function to animate to user location
  void _animateToUserLocation() async {
    var pos = await location.getLocation();

    _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(pos.latitude, pos.longitude),
      zoom: 17.0,
    )));
  }

  //add a document to fire store
//  Future<DocumentReference> _addGeoPoint() async {
//    //access to user current position
//    var pos = await location.getLocation();
//    GeoFirePoint point =
//        geo.point(latitude: pos.latitude, longitude: pos.longitude);
//    return fireStore
//        .collection('locations')
//        .add({'position': point.data, 'name': 'yay I can be queried!'});
//  }

//  void _updateMarkers(List<DocumentSnapshot> documentList) {
//    print(documentList);
//    _mapController.clearMarkers();
//    documentList.forEach((DocumentSnapshot document) {
//      GeoPoint pos = document.data.position.geopoint;
//      double distance = document.data.distance;
//      var marker = Marker(
//        markerId: MarkerId("1"),
//        position: LatLng(pos.latitude, pos.longitude),
//        icon: BitmapDescriptor.defaultMarker,
//        infoWindow: InfoWindow(
//            title: "Magic Marker",
//            snippet: "$distance kilometer from querry center"),
//      );
//    });
//  }

//  void _starQuerry() async {
//    var pos = await location.getLocation();
//    double lat = pos.latitude;
//    double lng = pos.longitude;
//
//    //Make a reference to fireStore
//    var ref = fireStore.collection('locations');
//    GeoFirePoint center = geo.point(latitude: lat, longitude: lng);
//
//    //subscribe to query
//    subscription = radius.switchMap((rad) {
//      return geo.collection(collectionRef: ref).within(
//          center: center, radius: rad, field: 'position', strictMode: true);
//    }).listen(_updateMarkers);
//  }

//  void _updateQuery(value) {
//    final zoomMap = {
//      100.0: 12.0,
//      200.0: 10.0,
//      300.0: 7.0,
//      400.0: 6.0,
//      500.0: 5.0,
//    };
//
//    final zoom = zoomMap[value];
//    _mapController.moveCamera(CameraUpdate.zoomTo(zoom));
//
//    setState(() {
//      radius.add(value);
//    });
//  }

  Future<void> _addUser() async {
    await Firebase.initializeApp();
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    String fullName = 'samer';
    String company = 'test';
    int age = 25;

    // Call the user's CollectionReference to add a new user
    return users
        .add({
      'full_name': fullName, // John Doe
      'company': company, // Stokes and Sons
      'age': age // 42
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  void dispose() {
//    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
//        mapType: MapType.satellite,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: _onMapCreated,
          markers: _markers,
          myLocationEnabled: true,
          compassEnabled: true,
//          trackCameraPosition:true,
        ),
        Positioned(
          bottom: 50,
          right: 10,
          child: FlatButton(
            child: Icon(Icons.pin_drop, color: Colors.white),
            color: Colors.green,
//            onPressed: _addGeoPoint,
//            onPressed: _animateToUserLocation,
            onPressed: _addUser,
          ),
        ),
//        Positioned(
//          bottom: 50,
//          left: 10,
//          child: Slider(
//            min: 100.0,
//            max: 500.0,
//            divisions: 4,
//            value: radius.value,
//            label: 'Radius ${radius.value}km',
//            onChanged: _updateQuery,
//          ),
//        ),
      ],
    );
//    return new Scaffold(
//      body: GoogleMap(
////        mapType: MapType.satellite,
//        initialCameraPosition: _kGooglePlex,
//        onMapCreated: _onMapCreated,
//        markers: _markers,
//      ),
//      floatingActionButton: FloatingActionButton.extended(
//        onPressed: _goToTheLake,
//        label: Text('To the lake!'),
//        icon: Icon(Icons.directions_boat),
//      ),
//    );
  }

//  Future<void> _goToTheLake() async {
//    final GoogleMapController controller = await _controller.future;
//    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
//  }
}
