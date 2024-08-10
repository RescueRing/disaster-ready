import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:toggle_switch/toggle_switch.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CameraPosition? currentPosition;

  bool isHelping = false;
  List<String> filters = ['Helping', 'Need Help'];

  bool locationLoaded = false;
  late LatLng? currentLocation = LatLng(0, 0);
  late GoogleMapController mapController;
  Completer<GoogleMapController> controllerCompleter = Completer();

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

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

  void getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);

      currentPosition = CameraPosition(target: currentLocation!, zoom: 15.0);
      locationLoaded = true;
    });
    // Future.delayed(Duration(milliseconds: 1000), () {
    //   setState(() {

    //   });
    // });
  }

  Widget buildFloatingActionButton({
    required bool isHelping,
    required LatLng currentLocation,
    required String selectedFilter,
  }) {
    return FloatingActionButton(
      backgroundColor: isHelping
          ? Color.fromARGB(255, 137, 202, 255)
          : Color.fromARGB(255, 250, 121, 121),
      onPressed: () {
        print('Helping: $isHelping');
        print('Location: $currentLocation');
        print('Filter: $selectedFilter');
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
