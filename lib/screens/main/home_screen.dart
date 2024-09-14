// ignore_for_file: collection_methods_unrelated_type, must_be_immutable, deprecated_member_use

import 'dart:async';
import 'package:text_responsive/text_responsive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disaster_ready/generated/l10n.dart';
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
  HomeScreen({super.key, required this.context});

  List<String> selectedHS = [];
  BuildContext context;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CameraPosition? currentPosition;
  var multiLanguage;
  bool isHelping = false;

  String name = '';
  String email = '';
  List<String> filters = [];

  List<String>? helpingOptions = [
    'volunteer',
    'donate',
    'provideShelter',
    'food',
    'medical'
  ];

  List<String> seekingOptions = [
    'medical',
    'food',
    'shelter',
    'clothing',
    'other'
  ];
  bool locationLoaded = false;
  late LatLng? currentLocation = LatLng(0, 0);
  late GoogleMapController mapController;
  Completer<GoogleMapController> controllerCompleter = Completer();
  List<Marker> markersList = [];
  List<MarkerDetails> markers = [];
  String? phone;
  void initPrefs() {
    SharedPreferences.getInstance().then((value) {
      phone = value.getString('phoneNumber');
      name = value.getString('name') ?? 'Name 1';
      email = value.getString('email') ?? 'email.com';
    });
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
    filters = [S.of(widget.context).helping, S.of(widget.context).seekHelp];
    getCurrentLocation();
    setupMarkerListener();
  }

// Display the marker details in a dialog box when users click on a marker
  void displayInfo(MarkerDetails markerDetails) {
    final Map<String, String> translationMap = {
      'volunteer': S.of(context).volunteer,
      'donate': S.of(context).donate,
      'provideShelter': S.of(context).provideShelter,
      'food': S.of(context).food,
      'medical': S.of(context).medical,
      // 'medical': S.of(context).medical,
      // 'food': S.of(context).food,
      'shelter': S.of(context).shelter,
      'clothing': S.of(context).clothing,
      'other': S.of(context).other,
    };
    showDialog(
      useSafeArea: true,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: ParagraphTextWidget(
            translationMap[markerDetails.selectedFilter[0]]!,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
            if (markerDetails.phone != phone)
              ElevatedButton(
                onPressed: () {},
                child: Text("Remove Marker"),
                style: ElevatedButton.styleFrom(
                  side: BorderSide(
                      color: Color.fromARGB(255, 0, 164, 205), width: 1),
                ),
              ),
            if (markerDetails.phone == phone)
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  side: BorderSide(
                      color: Color.fromARGB(255, 0, 164, 205), width: 1),
                ),
                onPressed: () {},
                label: Text(
                  S.of(context).seekHelp,
                ),
                icon: Icon(Icons.call),
              ),
          ],
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Name: ${markerDetails.name}'),
              Text('Contact: ${markerDetails.phone}'),
              Text('${markerDetails.isHelping ? 'Helping' : 'Seeking Help'}'),
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
        List<dynamic> rawData = snapshot.data()!['help'];
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
  void sendToFire(
    location, {
    bool? isHelping,
    List? selectedFilter,
    String? additionalInfo,
  }) async {
    var phone = await SharedPreferences.getInstance()
        .then((value) => value.getString('phoneNumber'));
    FirebaseFirestore.instance.collection('main').doc('locations').update({
      if (selectedFilter != null)
        'help': FieldValue.arrayUnion([
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
          isHelping ? helpingOptions! : seekingOptions,
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
          activeBgColor: const [Colors.blue, Color.fromARGB(255, 0, 47, 67)],
          multiLineText: true,
          centerText: true,
          customTextStyles: const [
            TextStyle(
              fontSize: 16,
              color: Colors.white,
              overflow: TextOverflow.clip,
            ),
            TextStyle(
              fontSize: 16,
              color: Colors.white,
              overflow: TextOverflow.clip,
            ),
          ],
          curve: Curves.easeInOut,
          borderWidth: 2.0,
          minHeight: 70,
          customWidths: const [200.0, 200.0],
          activeFgColor: Colors.white,
          inactiveBgColor: Colors.grey,
          inactiveFgColor: Colors.white,
          fontSize: 16,
          animate: true,
          animationDuration: 200,
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
                  // liteModeEnabled: true,
                  buildingsEnabled: true,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,

                  // compassEnabled: true,
                  // circles: <Circle>{
                  //   Circle(
                  //     circleId: CircleId('currentLocation'),
                  //     center: currentLocation!,
                  //     radius: 100,
                  //     fillColor: Colors.blue.withOpacity(0.1),
                  //     strokeWidth: 1,
                  //     strokeColor: const Color.fromARGB(100, 33, 149, 243),
                  //   )
                  // },
                  // mapToolbarEnabled: false,
                  onMapCreated: _onMapCreated,
                  // cloudMapId: 'c2088f572a4a96dd',
                  initialCameraPosition: currentPosition!,
                  onCameraMove: (position) => currentPosition = position,
                  zoomControlsEnabled: false,

                  // style: '3183c41a36f5be0b',
                  // polygons: <Polygon>{
                  //   Polygon(
                  //     polygonId: PolygonId('polygon'),
                  //     onTap: () {
                  //       print('This is a polygon');
                  //       snack(
                  //         'This is a polygon',
                  //         context,
                  //         color: Colors.blue,
                  //         fontSize: 16,
                  //         duration: 5,
                  //       );
                  //     },
                  //     points: <LatLng>[
                  //       LatLng(13.0041637, 77.5362149),
                  //       LatLng(13.0031637, 77.5362149),
                  //       LatLng(13.0041637, 77.5372249),
                  //       LatLng(13.0041637, 77.531258),
                  //     ],
                  //     strokeWidth: 1,
                  //     strokeColor: Colors.blue,
                  //     fillColor: Colors.blue.withOpacity(0.1),
                  //   ),
                  // },
                  heatmaps: <Heatmap>{
                    // Heatmap(
                    //   radius: HeatmapRadius.fromPixels(50),
                    //   heatmapId: HeatmapId('heatmap'),
                    //   gradient: HeatmapGradient(const [
                    //     HeatmapGradientColor(Colors.yellow, 0.1),
                    //     HeatmapGradientColor(
                    //         Color.fromARGB(104, 244, 67, 54), 0.2),
                    //   ]),
                    //   data: const <WeightedLatLng>[
                    //     WeightedLatLng(
                    //       LatLng(13.0041637, 77.5362149),
                    //       weight: 1.0,
                    //     ),
                    //     WeightedLatLng(
                    //       LatLng(13.0031637, 77.5362149),
                    //       weight: 1.0,
                    //     ),
                    //   ],
                    // ),
                    Heatmap(
                      heatmapId: HeatmapId('heatmap'),
                      opacity: 0.8,
                      // dissipating: false,
                      maximumZoomIntensity: 1,
                      minimumZoomIntensity: 1,
                      gradient: HeatmapGradient(const [
                        HeatmapGradientColor(Colors.yellow, 0.1),
                        HeatmapGradientColor(
                            Color.fromARGB(104, 244, 67, 54), 0.2),
                      ]),
                      // maxIntensity: 5, .
                      radius: HeatmapRadius.fromPixels(50),

                      data: const <WeightedLatLng>[
                        WeightedLatLng(
                          LatLng(13.0041637, 77.5362149),
                          weight: 1.0,
                        ),
                        WeightedLatLng(
                          LatLng(13.0031637, 77.5362149),
                          weight: 1.0,
                        ),
                        WeightedLatLng(
                          LatLng(13.0041637, 77.5372249),
                          weight: 1.0,
                          // intensity: 1.0,
                        ),
                        WeightedLatLng(
                          LatLng(13.0041637, 77.531258),
                          weight: 1.0,
                          // intensity: 1.0,
                        ),
                      ],
                    ),
                  },
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
