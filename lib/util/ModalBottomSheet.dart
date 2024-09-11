// import 'package:disaster_ready/providers/marker_provider.dart';
import 'package:disaster_ready/util/snack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void ModelBottomSheet(
  BuildContext context,
  bool isHelping,
  List<String> helpingOptions,
  Map<String, IconData> helpIcons,
  Function sendToFire,
  LatLng currentLocation,
) {
  showModalBottomSheet(
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    enableDrag: true,
    showDragHandle: true,
    context: context,
    builder: (BuildContext context) {
      List selectedHS = [];
      return StatefulBuilder(
        builder: (context, setState) {
          //ref.watch(markedLocationProvider);
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              height: 400,

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
                                      color: Colors.blue.shade300, width: 2)),
                              child: ListTile(
                                // style: ListTileStyle.drawer,
                                // dense: true,
                                tileColor:
                                    selectedHS.contains(helpingOptions[index])
                                        ? Colors.blue.shade300
                                        : null,
                                onTap: () {
                                  if (selectedHS
                                      .contains(helpingOptions[index])) {
                                    setState!(() {
                                      selectedHS.remove(helpingOptions[index]);
                                    });
                                  } else {
                                    setState(() {
                                      selectedHS.add(helpingOptions[index]);
                                    });
                                  }
                                  setState(() {
                                    print(selectedHS);
                                  });
                                },
                                leading: Icon(
                                  helpIcons[helpingOptions[index]],
                                  color: !selectedHS
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
                                      color: Colors.blue.shade300, width: 2)),
                              child: ListTile(
                                // style: ListTileStyle.drawer,
                                // dense: true,
                                tileColor:
                                    selectedHS.contains(helpingOptions[index])
                                        ? Colors.blue.shade300
                                        : null,
                                onTap: () {
                                  if (selectedHS
                                      .contains(helpingOptions[index])) {
                                    setState(() {
                                      selectedHS.remove(helpingOptions[index]);
                                    });
                                  } else {
                                    setState(() {
                                      selectedHS.add(helpingOptions[index]);
                                    });
                                  }
                                  setState(() {
                                    print(selectedHS);
                                  });
                                },
                                leading: Icon(
                                  helpIcons[helpingOptions[index]],
                                  color: !selectedHS
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
                    if (selectedHS.isNotEmpty)
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
                          sendToFire(currentLocation, isHelping, selectedHS);
                          //  selectedHS = [];
                          Navigator.of(context).pop();
                          snack('Submitted successfully!', context,
                              color: Colors.green);
                        },
                        child: Text('Submit'),
                      )
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
