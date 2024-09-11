// ignore_for_file: collection_methods_unrelated_type, must_be_immutable, deprecated_member_use

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disaster_ready/models/marker_details.dart';
import 'package:disaster_ready/util/ModalBottomSheet.dart';
import 'package:disaster_ready/util/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});
  List<String> selectedHS = [];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CameraPosition? currentPosition;

  bool isHelping = false;
  String name = '';
  String email = '';
  List<String> filters = ['Helping', 'Need Help'];
  List<String> helpingOptions = [
    'Volunteer',
    'Donate',
    'Provide Shelter',
    'Food',
    'Medical'
  ];

  List<String> seekingOptions = [
    'Medical',
    'Food',
    'Shelter',
    'Clothing',
    'Other'
  ];
  bool locationLoaded = false;
  late LatLng? currentLocation = LatLng(0, 0);
  late GoogleMapController mapController;
  Completer<GoogleMapController> controllerCompleter = Completer();
  List<Marker> markersList = [];
  List<MarkerDetails> markers = [];

  void initPrefs() {
    SharedPreferences.getInstance().then((value) {
      name = value.getString('name') ?? 'Name 1';
      email = value.getString('email') ?? 'email.com';
    });
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
    getCurrentLocation();
    setupMarkerListener();
  }

// Display the marker details in a dialog box when users click on a marker
  void displayInfo(MarkerDetails markerDetails) {
    showDialog(
      useSafeArea: true,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(markerDetails.selectedFilter[0]),
          actions: [
            if (markerDetails.email == email)
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Close'),
              ),
            if (markerDetails.email != email)
              ElevatedButton(onPressed: () {}, child: Text("Remove Marker")),
            ElevatedButton.icon(
              onPressed: () {},
              label: Text('Ask for help'),
              icon: Icon(Icons.call),
            ),
          ],
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(markerDetails.phone),
              Text('Latitude: ${markerDetails.latitude}'),
              Text('Longitude: ${markerDetails.longitude}'),
            ],
          ),
        );
      },
    );
  }

// Dynamically update the markers on the map in real-time
  void updateMarkers(List<Map<String, dynamic>> data) {
    List<Marker> newMarkers = [];
    for (var i in data) {
      MarkerDetails markerDetails = MarkerDetails.fromJson(i);
      markers.add(markerDetails);
      newMarkers.add(Marker(
        markerId: MarkerId(
            '${markerDetails.phone}-${markerDetails.latitude}-${markerDetails.longitude}'),
        position:
            LatLng(double.parse(i['latitude']), double.parse(i['longitude'])),
        infoWindow: InfoWindow(title: 'Chetan'),
        onTap: () {
          displayInfo(markerDetails);
        },
      ));
    }
    setState(() {
      markersList = newMarkers;
    });
  }

  void setupMarkerListener() {
    FirebaseFirestore.instance
        .collection('main')
        .doc('locations')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        List<dynamic> rawData = snapshot.data()!['location'];
        List<Map<String, dynamic>> data = rawData.cast<Map<String, dynamic>>();
        updateMarkers(data);
      }
    });
  }

// check if the user is helping or seeking help and display the appropriate floating action button
  Widget helpOrSeek(isHelping, currentLocation, selectedFilter) {
    return Positioned(
      right: 20.0,
      bottom: 180.0,
      child: buildFloatingActionButton(
        isHelping: isHelping,
        currentLocation: currentLocation,
        selectedFilter: selectedFilter,
      ),
    );
  }

// send the user's location and details to firebase
  void sendToFire(location, isHelping, selectedFilter) async {
    var phone = await SharedPreferences.getInstance()
        .then((value) => value.getString('phoneNumber'));
    FirebaseFirestore.instance.collection('main').doc('locations').update({
      'location': FieldValue.arrayUnion([
        {
          'latitude': location.latitude.toString(),
          'longitude': location.longitude.toString(),
          'isHelping': isHelping,
          'selectedFilter': selectedFilter,
          'phone': phone,
          'email': email,
          'name': name,
        }
      ])
    });
  }

// recenter the map to the user's current location
  Widget recenterButton(Completer<GoogleMapController> controllerCompleter,
      LatLng currentLocation) {
    return FutureBuilder<GoogleMapController>(
      future: controllerCompleter.future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Positioned(
            right: 20.0,
            bottom: 110.0,
            child: FloatingActionButton(
              mini: false,
              backgroundColor: Colors.white,
              onPressed: () {
                snapshot.data!.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: currentLocation,
                      zoom: 15.0,
                    ),
                  ),
                );
              },
              child: Icon(FontAwesomeIcons.locationArrow, color: Colors.black),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

// get the user's current location
  void getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);

      currentPosition = CameraPosition(target: currentLocation!, zoom: 15.0);
      locationLoaded = true;
    });
  }

  Widget buildFloatingActionButton({
    required bool isHelping,
    required LatLng currentLocation,
    required String selectedFilter,
  }) {
    return FloatingActionButton(
      backgroundColor: isHelping
          ? Color.fromARGB(255, 61, 159, 239)
          : Color.fromARGB(255, 255, 51, 51),
      onPressed: () {
        ModelBottomSheet(
          context,
          isHelping,
          isHelping ? helpingOptions : seekingOptions,
          helpIcons,
          sendToFire,
          currentLocation,
        );
      },
      child: Icon(
        isHelping
            ? FontAwesomeIcons.handHoldingHeart
            : FontAwesomeIcons.handsHelping,
        color: Colors.white,
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    controllerCompleter.complete(controller);
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ToggleSwitch(
          initialLabelIndex: isHelping ? 0 : 1,
          minWidth: 100.0,
          cornerRadius: 20.0,
          activeBgColor: const [Colors.blue],
          borderWidth: 2.0,
          minHeight: 55,
          customWidths: const [200.0, 200.0],
          activeFgColor: Colors.white,
          inactiveBgColor: Colors.grey,
          inactiveFgColor: Colors.white,
          fontSize: 16,
          labels: filters,
          onToggle: (index) {
            setState(() {
              isHelping = index == 0;
            });
          },
        ),
      ),
      body: Stack(
        children: [
          locationLoaded
              ? GoogleMap(
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  compassEnabled: false,
                  mapToolbarEnabled: false,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: currentPosition!,
                  onCameraMove: (position) => currentPosition = position,
                  zoomControlsEnabled: false,
                  markers: markersList.toSet(),
                )
              : Center(child: CircularProgressIndicator()),
          recenterButton(controllerCompleter, currentLocation!),
          helpOrSeek(
              isHelping, currentLocation, isHelping ? filters[0] : filters[1]),
        ],
      ),
    );
  }
}
