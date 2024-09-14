import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:disaster_ready/screens/first_screen.dart';
import 'package:disaster_ready/services/fetch_address.dart';
import 'package:disaster_ready/util/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  SharedPreferences? prefs;
  var fullNameController = TextEditingController();
  var phoneNumberController = TextEditingController();
  var currentLocationController = TextEditingController();
  var administrativeAreaController = TextEditingController();
  var subAdministrativeAreaController = TextEditingController();
  var localityController = TextEditingController();
  var subLocalityController = TextEditingController();
  var postalCodeController = TextEditingController();
  ScrollController scrollController = ScrollController();

  bool agreed = false;

  Placemark? location;
  var positon;
  void getLocation() async {
    positon = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    location = await getUserLocation();
    location!.locality;
    location!.administrativeArea;
    // print(location!.toJson());
    setState(() {
      administrativeAreaController.text = location!.administrativeArea ?? '';
      subAdministrativeAreaController.text =
          location!.subAdministrativeArea ?? '';
      localityController.text = location!.locality ?? '';
      subLocalityController.text = location!.subLocality ?? '';
      postalCodeController.text = location!.postalCode ?? '';
    });
    setState(() {
      phoneNumberController.text = prefs?.getString('phoneNumber') ?? '82';
    });
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      prefs = value;
    });

    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: GestureDetector(
        onTap: () {
          if (!agreed) {
            snack('Please agree to the terms and conditions', context,
                color: Colors.red);
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
            return;
          }
          if (fullNameController.text.length < 5) {
            snack('Please enter your phone number', context, color: Colors.red);
            scrollController.animateTo(
              scrollController.position.minScrollExtent,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );

            return;
          }
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    'Thank you for volunteering!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  content: Text(
                      'We will review your information and get back to you shortly. Together, we can make a difference in times of need!'),
                  actions: [
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => FirstScreen()));
                        // Navigator.of(context).pop();
                        // Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
          prefs?.setBool('isVolunteer', true);

          FirebaseFirestore.instance
              .collection('main')
              .doc('volunteers')
              .update({
            'waiting_list_volunteers': FieldValue.arrayUnion([
              {
                'volunteerSkill': prefs?.get('volunteerSkill'),
                'fullName': fullNameController.text,
                'phoneNumber': phoneNumberController.text,
                'locality': localityController.text,
                'state': administrativeAreaController.text,
                'division': subAdministrativeAreaController.text,
                'address': location!.toJson(),
                'latitute': positon.latitude.toString(),
                'longitude': positon.longitude.toString(),
                'position': positon.toJson()
              }
            ]),
          });
        },
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            backgroundBlendMode: BlendMode.darken,
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.done_all_outlined),
              Gap(10),
              Text(
                'Register as Volunteer',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Full Name'),
              controller: fullNameController,
              keyboardType: TextInputType.name,
              keyboardAppearance: Brightness.dark,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]'))
              ],
            ),
            SizedBox(height: 16),
            TextField(
              enabled: phoneNumberController.text.isEmpty,
              decoration: InputDecoration(labelText: 'Phone Number'),
              controller: phoneNumberController,
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            TextField(
              enabled: administrativeAreaController.text.isEmpty,
              decoration: InputDecoration(labelText: 'State'),
              controller: administrativeAreaController,
            ),
            SizedBox(height: 16),
            TextField(
              enabled: subAdministrativeAreaController.text.isEmpty,
              decoration: InputDecoration(labelText: 'Division'),
              controller: subAdministrativeAreaController,
            ),
            SizedBox(height: 16),
            TextField(
              // enabled: localityController.text.isEmpty,
              decoration: InputDecoration(labelText: 'Locality'),
              controller: localityController,
            ),
            SizedBox(height: 16),
            TextField(
              // enabled: subLocalityController.text.isEmpty,
              decoration: InputDecoration(labelText: 'Sub Locality'),
              controller: subLocalityController,
            ),
            SizedBox(height: 16),
            TextField(
              // enabled: postalCodeController.text.isEmpty,
              decoration: InputDecoration(labelText: 'Postal Code'),
              controller: postalCodeController,
            ),
            SizedBox(height: 16),

            // TextField(
            //   decoration: InputDecoration(labelText: 'Current Location'),
            // ),
            Text('Terms and Conditions',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    )),
            SizedBox(height: 8),
            Text(
              'By registering as a volunteer, you agree to:\n'
              '• Provide accurate information\n'
              '• Respect and support the community\n'
              '• Maintain confidentiality\n'
              '• Follow safety guidelines\n'
              '• Use the app responsibly',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            SizedBox(height: 32),
            CheckboxListTile(
              value: agreed,
              checkColor: Colors.green,
              activeColor: Colors.white,
              tileColor: Colors.lightBlue.shade50,
              onChanged: (value) {
                setState(() {
                  agreed = value!;
                });
              },
              title: Text(
                'I agree to the terms and conditions',
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 13),
              ),
            ),
            SizedBox(height: 38),
          ],
        ),
      ),
    );
  }
}
