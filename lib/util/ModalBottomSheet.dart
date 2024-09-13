// ignore_for_file: non_constant_identifier_names

import 'package:disaster_ready/generated/l10n.dart';
import 'package:disaster_ready/util/helper_functions.dart';
import 'package:flutter/material.dart';

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
  // String getTranslatedString(String key, BuildContext context) {

  //   return S.of(context).$key;
  // }
  // helpingOptions = [
  //   S.of(widget.context).volunteer,
  //   S.of(widget.context).donate,
  //   S.of(widget.context).provideShelter,
  //   S.of(widget.context).food,
  //   S.of(widget.context).medical
  // ];
  // seekingOptions = [
  //   S.of(widget.context).medical,
  //   S.of(widget.context).food,
  //   S.of(widget.context).shelter,
  //   S.of(widget.context).clothing,
  //   S.of(widget.context).other
  // ];

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
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              height: 400,
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
                              ? S.of(context).helping
                              : S.of(context).needHelp),
                      decoration: InputDecoration(
                        prefixIconColor: const Color.fromRGBO(244, 67, 54, 1),
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
                    Expanded(
                      child: ListView.builder(
                        itemCount: helpingOptions.length,
                        itemBuilder: (context, index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(
                                    color: Colors.blue.shade300, width: 2)),
                            child: ListTile(
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
                                setState(() {});
                              },
                              leading: Icon(
                                helpIcons[helpingOptions[index]],
                                color:
                                    !selectedHS.contains(helpingOptions[index])
                                        ? Colors.blue
                                        : Colors.white,
                              ),
                              title: Text(
                                translationMap[helpingOptions[index]]!,
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
                          sendToFire(
                            currentLocation,
                            isHelping: isHelping,
                            selectedFilter: selectedHS,
                          );
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
