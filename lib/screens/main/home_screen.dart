// ignore_for_file: collection_methods_unrelated_type, must_be_immutable

import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disaster_ready/models/marker_details.dart';
import 'package:disaster_ready/util/ModalBottomSheet.dart';
import 'package:disaster_ready/util/snack.dart';
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
    // FireToMarker();
    // print('Init state');
  }

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
        return Center(
          child: SizedBox(
            height: 300,
            child: AlertDialog(
              title: Text(markerDetails.selectedFilter[0]),
              content: Column(
                children: [
                  Text(markerDetails.phone),
                  Text('Latitude: ${markerDetails.latitude}'),
                  Text('Longitude: ${markerDetails.longitude}'),

                  // Text('Selected Filters: ${selectedFilters[0]}'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void updateMarkers(List<Map<String, dynamic>> data) {
    List<Marker> newMarkers = [];
    print('In updateMarkers');
    for (var i in data) {
      MarkerDetails markerDetails = MarkerDetails.fromJson(i);
      // print(markerDetails);
      markers.add(markerDetails);
      // print(markerDetails.latitude);
      // print(markerDetails.longitude);
      // print(markerDetails.phone);
      // print(markerDetails.email);
      // print(markerDetails.isHelping);
      // print(markerDetails.address);
      newMarkers.add(Marker(
        markerId: MarkerId(
            '${markerDetails.phone}-${markerDetails.latitude}-${markerDetails.longitude}'),
        position:
            LatLng(double.parse(i['latitude']), double.parse(i['longitude'])),
        infoWindow: InfoWindow(title: 'Chetan'),
        onTap: () {
          displayInfo(markerDetails);
          // showModalBottomSheet(
          //     context: context,
          //     builder: (context) {
          //       return Container(
          //         height: 200,
          //         child: Column(
          //           children: [
          //             Text(i['name']),
          //             Text(i['phone']),
          //             Text(i['address']),
          //           ],
          //         ),
          //       );
          //     });
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
        log(0);
        print('Snapshot exists');
        List<dynamic> rawData = snapshot.data()!['location'];
        List<Map<String, dynamic>> data = rawData.cast<Map<String, dynamic>>();
        // print(data);
        updateMarkers(data);
      }
    });
  }

  // void FireToMarker() async {
  //   // print('Fire to marker');
  //   List<Marker> markers = [];
  //   List<String> contacts = [];
  //   List<Map<String, dynamic>> data = await FirebaseFirestore.instance
  //       .collection('main')
  //       .doc('locations')
  //       .get()
  //       .then((value) {
  //     List<dynamic> rawData = value.data()!['location'];
  //     return rawData.cast<Map<String, dynamic>>();
  //   });

  //   for (var i in data) {
  //     markers.add(Marker(
  //       markerId: MarkerId(i['phone']),
  //       position:
  //           LatLng(double.parse(i['latitude']), double.parse(i['longitude'])),
  //       icon: BitmapDescriptor.defaultMarker,
  //     ));
  //     contacts.add(i['phone']);
  //   }

  //   print(data);
  //   // print('Fire to marker');
  //   // List<Marker> markers = [];
  //   // List<String> contacts = [];
  //   // List<Map<String, dynamic>> data = await FirebaseFirestore.instance
  //   //     .collection('main')
  //   //     .doc('locations')
  //   //     .get()
  //   //     .then((value) => value.data()!['location']);
  //   // for (var i in data) {
  //   //   markers.add(Marker(
  //   //     markerId: MarkerId(i['phone']),
  //   //     position:
  //   //         LatLng(double.parse(i['latitude']), double.parse(i['longitude'])),
  //   //     icon: BitmapDescriptor.defaultMarker,
  //   //   ));
  //   //   contacts.add(i['phone']);
  //   // }

  //   // print(data);
  // }

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
    // });
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

  Widget helpingBuilder() {
    return ListView.builder(
      itemCount: helpingOptions.length + 1,
      itemBuilder: (context, index) {
        if (index == helpingOptions.length) {
          return SizedBox(
            height: 100,
          );
        }
        return Card(
          child: ListTile(
            tileColor: widget.selectedHS.contains(helpingOptions[index])
                ? Colors.blue.shade300
                : null,
            onTap: () {
              if (widget.selectedHS.contains(helpingOptions[index])) {
                setState(() {
                  widget.selectedHS.remove(helpingOptions[index]);
                });
              } else {
                setState(() {
                  widget.selectedHS.add(helpingOptions[index]);
                });
              }
              setState(() {
                print(widget.selectedHS);
              });
            },
            leading: Icon(
              helpIcons[helpingOptions[index]],
              color: !widget.selectedHS.contains(helpingOptions[index])
                  ? Colors.blue
                  : Colors.white,
            ),
            title: Text(
              helpingOptions[index],
              style: const TextStyle(fontSize: 18),
            ),
          ),
        );
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
    // FireToMarker();
  }

  Map<String, IconData> helpIcons = {
    'Volunteer': Icons.volunteer_activism,
    'Donate': Icons.monetization_on,
    'Provide Shelter': Icons.house,
    'Offer Food': Icons.food_bank,
    'Medical': Icons.medical_services,
    'Shelter': Icons.house,
    'Food': Icons.fastfood,
    'Clothing': Icons.checkroom,
    'Other': Icons.help_outline,
  };

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
        // print('Helping: $isHelping');
        // print('Location: $currentLocation');
        // print('Filter: $selectedFilter');
      },
      child: GestureDetector(
        onTap: () {
          ModelBottomSheet(
            context,
            isHelping,
            isHelping ? helpingOptions : seekingOptions,
            helpIcons,
            sendToFire,
            currentLocation,
          );

          return;
          // print('Helping: $isHelping');
          // print('Location: $currentLocation');
          // print('Filter: $selectedFilter');
          showModalBottomSheet(
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            ),
            enableDrag: true,
            showDragHandle: true,
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) =>
                    Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    height: 470,

                    // color: Colors.blue,
                    child: Center(
                      child: Column(
                        children: [
                          TextField(
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                            controller: TextEditingController(
                                text: isHelping ? 'Helping' : 'Seeking Help'),
                            decoration: InputDecoration(
                              prefixIconColor: Colors.red,
                              prefixIcon: Icon(
                                isHelping
                                    ? FontAwesomeIcons.handHoldingHeart
                                    : FontAwesomeIcons.handsHelping,
                                color: Colors.red.shade300,
                              ),
                            ),
                            enabled: false,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if (isHelping)
                            Expanded(
                              child: ListView.builder(
                                itemCount: helpingOptions.length,
                                itemBuilder: (context, index) {
                                  // if (index == helpingOptions.length) {
                                  //   return SizedBox(
                                  //     height: 30,
                                  //   );
                                  // }
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: BorderSide(
                                            color: Colors.blue.shade300,
                                            width: 2)),
                                    child: ListTile(
                                      // style: ListTileStyle.drawer,
                                      // dense: true,
                                      tileColor: widget.selectedHS
                                              .contains(helpingOptions[index])
                                          ? Colors.blue.shade300
                                          : null,
                                      onTap: () {
                                        if (widget.selectedHS
                                            .contains(helpingOptions[index])) {
                                          setState(() {
                                            widget.selectedHS
                                                .remove(helpingOptions[index]);
                                          });
                                        } else {
                                          setState(() {
                                            widget.selectedHS
                                                .add(helpingOptions[index]);
                                          });
                                        }
                                        setState(() {
                                          print(widget.selectedHS);
                                        });
                                      },
                                      leading: Icon(
                                        helpIcons[helpingOptions[index]],
                                        color: !widget.selectedHS
                                                .contains(helpingOptions[index])
                                            ? Colors.blue
                                            : Colors.white,
                                      ),
                                      title: Text(
                                        helpingOptions[index],
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          if (!isHelping)
                            Expanded(
                              child: ListView.builder(
                                itemCount: seekingOptions.length,
                                itemBuilder: (context, index) {
                                  // if (index == helpingOptions.length) {
                                  //   return SizedBox(
                                  //     height: 30,
                                  //   );
                                  // }
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: BorderSide(
                                            color: Colors.blue.shade300,
                                            width: 2)),
                                    child: ListTile(
                                      // style: ListTileStyle.drawer,
                                      // dense: true,
                                      tileColor: widget.selectedHS
                                              .contains(seekingOptions[index])
                                          ? Colors.blue.shade300
                                          : null,
                                      onTap: () {
                                        if (widget.selectedHS
                                            .contains(seekingOptions[index])) {
                                          setState(() {
                                            widget.selectedHS
                                                .remove(seekingOptions[index]);
                                          });
                                        } else {
                                          setState(() {
                                            widget.selectedHS
                                                .add(seekingOptions[index]);
                                          });
                                        }
                                        setState(() {
                                          print(widget.selectedHS);
                                        });
                                      },
                                      leading: Icon(
                                        helpIcons[seekingOptions[index]],
                                        color: !widget.selectedHS
                                                .contains(seekingOptions[index])
                                            ? Colors.blue
                                            : Colors.white,
                                      ),
                                      title: Text(
                                        seekingOptions[index],
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          // Text('Filter: $selectedFilter'),
                          // SizedBox(
                          //   height: 20,
                          // ),
                          if (widget.selectedHS.isNotEmpty)
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade100,
                                side: BorderSide(
                                  color: Colors.blue.shade300,
                                  width: 2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: () {
                                print('Selected HS: ${widget.selectedHS}');
                                markersList.add(Marker(
                                  markerId: MarkerId('currentLocation'),
                                  icon: BitmapDescriptor.defaultMarker,
                                  position: currentLocation,
                                ));
                                sendToFire(currentLocation, isHelping,
                                    widget.selectedHS);
                                Navigator.pop(context);
                                widget.selectedHS = [];
                                snack('Submitted successfully!', context,
                                    color: Colors.green);
                              },
                              child: Text('Submit'),
                            )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: Icon(
          isHelping
              ? FontAwesomeIcons.handHoldingHeart
              : FontAwesomeIcons.handsHelping,
          color: Colors.white,
        ),
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
                  onTap: (argument) {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(25.0)),
                      ),
                      enableDrag: true,
                      showDragHandle: true,
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) =>
                                  Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              height: 470,

                              // color: Colors.blue,
                              child: Center(
                                child: Column(
                                  children: [
                                    TextField(
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                      controller: TextEditingController(
                                          text: isHelping
                                              ? 'Helping'
                                              : 'Seeking Help'),
                                      decoration: InputDecoration(
                                        prefixIconColor: Colors.red,
                                        prefixIcon: Icon(
                                          isHelping
                                              ? FontAwesomeIcons
                                                  .handHoldingHeart
                                              : FontAwesomeIcons.handsHelping,
                                          color: Colors.red.shade300,
                                        ),
                                      ),
                                      enabled: false,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    if (isHelping)
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: helpingOptions.length,
                                          itemBuilder: (context, index) {
                                            // if (index == helpingOptions.length) {
                                            //   return SizedBox(
                                            //     height: 30,
                                            //   );
                                            // }
                                            return Card(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  side: BorderSide(
                                                      color:
                                                          Colors.blue.shade300,
                                                      width: 2)),
                                              child: ListTile(
                                                // style: ListTileStyle.drawer,
                                                // dense: true,
                                                tileColor: widget.selectedHS
                                                        .contains(
                                                            helpingOptions[
                                                                index])
                                                    ? Colors.blue.shade300
                                                    : null,
                                                onTap: () {
                                                  if (widget.selectedHS
                                                      .contains(helpingOptions[
                                                          index])) {
                                                    setState(() {
                                                      widget.selectedHS.remove(
                                                          helpingOptions[
                                                              index]);
                                                    });
                                                  } else {
                                                    setState(() {
                                                      widget.selectedHS.add(
                                                          helpingOptions[
                                                              index]);
                                                    });
                                                  }
                                                  setState(() {
                                                    print(widget.selectedHS);
                                                  });
                                                },
                                                leading: Icon(
                                                  helpIcons[
                                                      helpingOptions[index]],
                                                  color: !widget.selectedHS
                                                          .contains(
                                                              helpingOptions[
                                                                  index])
                                                      ? Colors.blue
                                                      : Colors.white,
                                                ),
                                                title: Text(
                                                  helpingOptions[index],
                                                  style: const TextStyle(
                                                      fontSize: 18),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    if (!isHelping)
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: helpingOptions.length,
                                          itemBuilder: (context, index) {
                                            // if (index == helpingOptions.length) {
                                            //   return SizedBox(
                                            //     height: 30,
                                            //   );
                                            // }
                                            return Card(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  side: BorderSide(
                                                      color:
                                                          Colors.blue.shade300,
                                                      width: 2)),
                                              child: ListTile(
                                                // style: ListTileStyle.drawer,
                                                // dense: true,
                                                tileColor: widget.selectedHS
                                                        .contains(
                                                            helpingOptions[
                                                                index])
                                                    ? Colors.blue.shade300
                                                    : null,
                                                onTap: () {
                                                  if (widget.selectedHS
                                                      .contains(helpingOptions[
                                                          index])) {
                                                    setState(() {
                                                      widget.selectedHS.remove(
                                                          helpingOptions[
                                                              index]);
                                                    });
                                                  } else {
                                                    setState(() {
                                                      widget.selectedHS.add(
                                                          helpingOptions[
                                                              index]);
                                                    });
                                                  }
                                                  setState(() {
                                                    print(widget.selectedHS);
                                                  });
                                                },
                                                leading: Icon(
                                                  helpIcons[
                                                      helpingOptions[index]],
                                                  color: !widget.selectedHS
                                                          .contains(
                                                              helpingOptions[
                                                                  index])
                                                      ? Colors.blue
                                                      : Colors.white,
                                                ),
                                                title: Text(
                                                  helpingOptions[index],
                                                  style: const TextStyle(
                                                      fontSize: 18),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    if (widget.selectedHS.isNotEmpty)
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue.shade100,
                                          side: BorderSide(
                                            color: Colors.blue.shade300,
                                            width: 2,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                        onPressed: () {
                                          sendToFire(currentLocation, isHelping,
                                              widget.selectedHS);
                                          widget.selectedHS = [];
                                          Navigator.of(context).pop();
                                          snack('Submitted successfully!',
                                              context,
                                              color: Colors.green);
                                        },
                                        child: Text('Submit'),
                                      )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
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
