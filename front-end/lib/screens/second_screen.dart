import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart';
import 'package:khedni_maak/config/Secrets.dart';
import 'package:khedni_maak/config/palette.dart';
import 'package:khedni_maak/google_map/src/components/prediction_tile.dart';
import 'package:khedni_maak/google_map/src/controllers/autocomplete_search_controller.dart';
import 'package:khedni_maak/google_map/src/models/pick_result.dart';
import 'package:khedni_maak/login/utils/widgets/animated_text_form_field.dart';
import 'package:khedni_maak/widgets/custom_app_bar.dart';
import 'package:khedni_maak/widgets/user_profile.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class SecondScreen extends StatefulWidget {
  final String sessionToken;
  final GlobalKey appBarKey;

  SecondScreen({Key key, @required this.sessionToken, @required this.appBarKey})
      : super(key: key);

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  PickResult startLocation;
  PickResult endLocation;
  Position currentPosition;

  GoogleMapsPlaces places;
  SearchBarController searchBarController = SearchBarController();
  SearchBarController searchBarDestinationController = SearchBarController();

  TextEditingController _fromController = TextEditingController();
  TextEditingController _toController = TextEditingController();

  Timer debounceTimer;
  String searchTerm;
  OverlayEntry overlayEntry;

  BaseClient httpClient;

  // FocusNode focus = FocusNode();

  @override
  void initState() {
    super.initState();

    _fromController.addListener(_onSearchInputChange);
    // focus.addListener(_onFocusChanged);

    places = GoogleMapsPlaces(
      apiKey: Secrets.API_KEY,
      baseUrl: null,
      httpClient: httpClient,
    );
  }

  @override
  void dispose() {
    searchBarController.dispose();
    searchBarDestinationController.dispose();

    _fromController.removeListener(_onSearchInputChange);
    _fromController.dispose();

    // focus.removeListener(_onFocusChanged);
    // focus.dispose();

    super.dispose();
  }

  _onSearchInputChange() {
    if (!mounted) return;

    setState(() => {searchTerm = _fromController.text});

    if (_fromController.text.isEmpty) {
      debounceTimer?.cancel();
      _searchPlace(_fromController.text);
      return;
    }

    if (_fromController.text.substring(_fromController.text.length - 1) ==
        " ") {
      debounceTimer?.cancel();
      return;
    }

    if (debounceTimer?.isActive ?? false) {
      debounceTimer.cancel();
    }

    setState(() => {
          debounceTimer = Timer(Duration(milliseconds: 500), () {
            _searchPlace(_fromController.text.trim());
          })
        });
  }

  _searchPlace(String searchTerm) {
    setState(() => {searchTerm = _fromController.text});

    if (context == null) return;

    _clearOverlay();

    if (searchTerm.length < 1) return;

    _displayOverlay(_buildSearchingOverlay());

    _performAutoCompleteSearch(searchTerm);
  }

  _clearOverlay() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
  }

  _displayOverlay(Widget overlayChild) {
    _clearOverlay();

    final RenderBox appBarRenderBox =
        widget.appBarKey.currentContext.findRenderObject();

    final screenWidth = MediaQuery.of(context).size.width;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        // top: appBarRenderBox.size.height+5.0,
        top: appBarRenderBox.size.height + 40 * 2 + 5.0,
        // top: 100,
        left: screenWidth * 0.025,
        right: screenWidth * 0.025,
        child: Material(
          elevation: 4.0,
          child: overlayChild,
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);
  }

  _performAutoCompleteSearch(String searchTerm) async {
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

      _displayOverlay(_buildPredictionOverlay(response.predictions));
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

  Widget _buildPredictionOverlay(List<Prediction> predictions) {
    return ListBody(
      children: predictions
          .map(
            (p) => PredictionTile(
              prediction: p,
              onTap: (selectedPrediction) {
                resetSearchBar();
                print("onPicked $selectedPrediction");
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

  Widget _buildSearchBar() {
    final deviceSize = MediaQuery.of(context).size;
    final width = min(deviceSize.width * 0.75, 360.0);
    final textFieldWidth = width - 16.0 * 2;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: AnimatedTextFormField(
            enabled: true,
            controller: _fromController,
            width: textFieldWidth,
            // loadingController: _loadingController,
            interval: const Interval(0, .85),
            labelText: 'From',
            prefixIcon: Icon(FontAwesomeIcons.dotCircle,color:Colors.green),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            // onFieldSubmitted: (value) {
            //   FocusScope.of(context).requestFocus(_lastNameFocusNode);
            // },
            validator: null,
            // onSaved: (value) => auth.firstName = value,
          ),
        ),
        Expanded(
          child: AnimatedTextFormField(
            enabled: true,
            controller: _toController,
            width: textFieldWidth,
            // loadingController: _loadingController,
            interval: const Interval(0, .85),
            labelText: 'To',
            prefixIcon: Icon(FontAwesomeIcons.dotCircle,color:Colors.blue),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            // onFieldSubmitted: (value) {
            //   FocusScope.of(context).requestFocus(_lastNameFocusNode);
            // },
            validator: null,
            // onSaved: (value) => auth.firstName = value,
          ),
        ),
      ],
    );
  }

    Widget _buildDatePicker() {
    final deviceSize = MediaQuery.of(context).size;
    final width = min(deviceSize.width * 0.75, 360.0);
    final textFieldWidth = width - 16.0 * 2;
final format = DateFormat("yyyy-MM-dd HH:mm");
  final initialValue = DateTime.now();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children:    <Widget>[

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

    // Prevents searching again by camera movement.
    // provider.isAutoCompleteSearching = true;

    // await _moveTo(provider.selectedPlace.geometry.location.lat,
    //     provider.selectedPlace.geometry.location.lng);

    if (source == 'startPoint') {
      setState(() => startLocation = selectedPlace);
    } else if (source == 'endPoint') {
      setState(() => endLocation = selectedPlace);
    }

    // provider.placeSearchingState = SearchingState.Idle;
  }

  @override
  Widget build(BuildContext context) {
    const Key centerKey = ValueKey('bottom-sliver-list');

    final screenHeight = MediaQuery.of(context).size.height;

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
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                        margin: const EdgeInsets.only(right: 20.0, left: 20.0),
                        height: screenHeight * 0.2,
                        child: _buildSearchBar(),
                      ),
                                            Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                        margin: const EdgeInsets.only(right: 20.0, left: 20.0,top:10.0),
                        height: screenHeight * 0.2,
                        child: _buildDatePicker(),
                      ),
                      // Container(
                      //   padding: const EdgeInsets.all(20.0),
                      //   height: screenHeight,
                      //   decoration: BoxDecoration(
                      //     color: Palette.thirdColor,
                      //     borderRadius: BorderRadius.only(
                      //       topLeft: Radius.circular(40.0),
                      //       topRight: Radius.circular(40.0),
                      //     ),
                      //   ),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: <Widget>[
                      //       SizedBox(height: screenHeight * 0.02),
                      //       Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: <Widget>[
                      //           UserProfile(screenHeight: screenHeight)
                      //         ],
                      //       ),
                      //       SizedBox(height: screenHeight * 0.02),
                      //       Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: <Widget>[
                      //           Text(
                      //             'Are you ready for a new ride ?',
                      //             style: TextStyle(
                      //               color: Colors.white,
                      //               fontSize: screenHeight * 0.04,
                      //               fontWeight: FontWeight.w600,
                      //             ),
                      //           ),
                      //           SizedBox(height: screenHeight * 0.02),
                      //           Text(
                      //             'What do you want to do today ?',
                      //             style: TextStyle(
                      //               color: Colors.white70,
                      //               fontSize: screenHeight * 0.02,
                      //             ),
                      //           ),
                      //           SizedBox(height: screenHeight * 0.01),
                      //         ],
                      //       )
                      //     ],
                      //   ),
                      // ),
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
