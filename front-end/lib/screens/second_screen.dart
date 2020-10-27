import 'dart:async';
import 'dart:math';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
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
  PickResult startLocation;
  PickResult endLocation;
  Position currentPosition;

  GoogleMapsPlaces places;

  TextEditingController _fromController = TextEditingController();
  TextEditingController _toController = TextEditingController();

  Timer debounceTimer;
  OverlayEntry overlayEntry;

  BaseClient httpClient;

  @override
  void initState() {
    super.initState();

    _fromController.addListener(_onSearchInputFromChange);
    _toController.addListener(_onSearchToInputChange);

    places = GoogleMapsPlaces(
      apiKey: Secrets.API_KEY,
      baseUrl: null,
      httpClient: httpClient,
    );
  }

  @override
  void dispose() {
    super.dispose();

    _fromController.removeListener(_onSearchInputFromChange);
    _fromController.dispose();

    _toController.removeListener(_onSearchToInputChange);
    _toController.dispose();

    _clearOverlay();
  }

  _onSearchInputFromChange() {
    if (!mounted) return;

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

  _onSearchToInputChange() {
    if (!mounted) return;

    if (_toController.text.isEmpty) {
      debounceTimer?.cancel();
      _searchPlace(_toController.text);
      return;
    }

    if (_toController.text.substring(_toController.text.length - 1) == " ") {
      debounceTimer?.cancel();
      return;
    }

    if (debounceTimer?.isActive ?? false) {
      debounceTimer.cancel();
    }

    setState(() => {
          debounceTimer = Timer(Duration(milliseconds: 500), () {
            _searchPlace(_toController.text.trim());
          })
        });
  }

  _searchPlace(String searchTerm) {
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
        top: 210.0,
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
                _pickPrediction(selectedPrediction, 'startPoint');
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

    print("hhhhh");
    print(selectedPlace);
    if (source == 'startPoint') {
      setState(() => startLocation = selectedPlace);
    } else if (source == 'endPoint') {
      setState(() => endLocation = selectedPlace);
    }

    // provider.placeSearchingState = SearchingState.Idle;
  }

  InputDecoration _getInputDecoration(
      ThemeData theme, String labelText, Icon icon) {
    return InputDecoration(
      labelText: labelText,
      prefixIcon: icon,
    );
  }

  Widget _buildSearchBar() {
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
      margin: const EdgeInsets.only(right: 20.0, left: 20.0),
      height: screenHeight * 0.2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TextFormField(
              controller: _fromController,
              decoration: _getInputDecoration(
                theme,
                'From',
                Icon(FontAwesomeIcons.dotCircle, color: Colors.green),
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              // focusNode: widget.focusNode,
              // obscureText: widget.obscureText,
              // onFieldSubmitted: widget.onFieldSubmitted,
              // onSaved: widget.onSaved,
              // validator: widget.validator,
              // enabled: widget.enabled,
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: _toController,
              decoration: _getInputDecoration(
                theme,
                'To',
                Icon(FontAwesomeIcons.dotCircle, color: Colors.blue),
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              // focusNode: widget.focusNode,
              // obscureText: widget.obscureText,
              // onFieldSubmitted: widget.onFieldSubmitted,
              // onSaved: widget.onSaved,
              // validator: widget.validator,
              // enabled: widget.enabled,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationCard() {
    final screenHeight = MediaQuery.of(context).size.height;
    final deviceSize = MediaQuery.of(context).size;
    final width = deviceSize.width;

    return Container(
      height: screenHeight - 30.0 - 210.0,
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
              children: <Widget>[
                Column(children: <Widget>[
                  Text('Departure On :'),
                  Text('Departure On :'),
                ]),
                Text('Departure On :'),
              ],
            ),
            Row(
              children: <Widget>[
                Text(
                  'Phone Number :',
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Text(
                  'Duration :',
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Text(
                  'Capacity :',
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(FontAwesomeIcons.dotCircle, color: Colors.green),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: <Widget>[
                        Icon(FontAwesomeIcons.dotCircle, color: Colors.blue),
                      ],
                    )
                  ],
                ),
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
