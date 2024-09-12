import 'dart:math';

import 'package:contacts_service/contacts_service.dart';
import 'package:disaster_ready/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ContactSelectionScreen extends StatefulWidget {
  const ContactSelectionScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ContactSelectionScreenState createState() => _ContactSelectionScreenState();
}

class _ContactSelectionScreenState extends State<ContactSelectionScreen> {
  List<Contact> contacts = [];
  List<String> selectedContacts = [];
  List<String> selectedNames = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future<void> _fetchContacts() async {
    setState(() {
      isLoading = true;
    });
    if (await Permission.contacts.request().isGranted) {
      final contact = await ContactsService.getContacts();
      setState(() {
        contacts = contact.toList();
      });
      SharedPreferences.getInstance().then((prefs) {
        selectedContacts = prefs.getStringList('emergency_contacts') ?? [];
        selectedNames = prefs.getStringList('emergency_names') ?? [];

        // Debugging statements
        // print('Contacts length: ${contacts.length}');
        // print('Selected contacts length: ${selectedContacts.length}');
        // print('Selected names length: ${selectedNames.length}');
        // print(contact);
        // Ensure indices are within valid range
        for (int i = 0; i < selectedContacts.length; i++) {
          if (i < contacts.length) {
            print('Contact $i: ${contacts[i]}');
          } else {
            print('Index $i is out of range for contacts list');
          }
        }
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  // Future<void> _fetchContacts() async {
  //   if (await Permission.contacts.request().isGranted) {
  //     final contact = await ContactsService.getContacts();
  //     setState(() {
  //       contacts = contact.toList();
  //     });
  //     SharedPreferences.getInstance().then((prefs) {
  //       selectedContacts = prefs.getStringList('emergency_contacts') ?? [];
  //       selectedNames = prefs.getStringList('emergency_names') ?? [];
  //     });
  //   }
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).selectContact),
      ),
      body: !isLoading
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: max(contacts.length, 5),
                itemBuilder: (context, index) {
                  final contact = contacts[index];

                  if (contact.phones!.isEmpty ||
                      contact.displayName == null ||
                      contact.phones!.first.value == null ||
                      contact.phones!.first.value!.length < 10) {
                    return const SizedBox.shrink();
                  }
                  return Card(
                    shadowColor:
                        const Color.fromARGB(255, 0, 0, 0).withOpacity(1),
                    color: selectedContacts.contains(contact
                                .phones!.first.value ??
                            ''
                                '{contact.phones!.first.value!.substring(0, 3)}0000{contact.phones!.first.value!.substring(7)}')
                        ? Colors.green.shade200
                        : null,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: const Color.fromARGB(255, 0, 0, 0)
                              .withOpacity(0.1),
                          width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 2.0, bottom: 2.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(contact.initials()),
                        ),
                        title: Text(contact.displayName ?? ''),
                        subtitle: Text(contact.phones!.isNotEmpty
                            ? contact.phones!.first.value!
                            // '{contact.phones!.first.value!.substring(0, 3)}0000{contact.phones!.first.value!.substring(7)}'
                            : ''),
                        onTap: () {
                          setState(() {
                            if (selectedContacts.contains(
                                contact.phones!.first.value!
                                // '{contact.phones!.first.value!.substring(0, 3)}0000{contact.phones!.first.value!.substring(7)}',
                                )) {
                              selectedNames.remove(contact.displayName!);
                              selectedContacts.remove(
                                  contact.phones!.first.value!
                                  // '${contact.phones!.first.value!.substring(0, 3)}0000{contact.phones!.first.value!.substring(7)}'
                                  );
                            } else {
                              selectedNames.add(contact.displayName!);
                              selectedContacts.add(
                                contact.phones!.first.value!,
                                // '{contact.phones!.first.value!.substring(0, 3)}0000{contact.phones!.first.value!.substring(7)}'
                              );
                            }
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: LinearProgressIndicator(),
                  ),
                  subtitle: Text('Getting contacts',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 18)),
                ),
              ),
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: selectedContacts.isNotEmpty
            ? ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(
                    color: Colors.green,
                    width: 1,
                  ),
                  backgroundColor: const Color.fromARGB(255, 115, 216, 118),
                ),
                onPressed: () {
                  SharedPreferences.getInstance().then((prefs) {
                    prefs.setStringList('emergency_contacts', selectedContacts);
                    prefs.setStringList('emergency_names', selectedNames);
                  });
                  Navigator.pop(context, selectedContacts);
                },
                child: const Text(
                  'Done',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : null,
      ),
    );
  }
}
