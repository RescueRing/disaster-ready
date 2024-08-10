import 'package:disaster_ready/screens/first_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhoneNumber extends StatefulWidget {
  @override
  State<PhoneNumber> createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  TextEditingController controller = TextEditingController();

  bool locationPermissionGranted = false;
  bool smsPermissionGranted = false;

  String initialCountry = 'IN';

  bool buttonEnabled = false;

  void setPhoneAndPermission() async {
    final prefs = await SharedPreferences.getInstance();
    if (locationPermissionGranted && smsPermissionGranted) {
      await prefs.setBool('permissionsGranted', true);
      await prefs.setString('phoneNumber', controller.text);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const FirstScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/background.png"),
          fit: BoxFit.cover,
        )),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // SizedBox(height: 85),
                  // Image.asset(
                  //   "assets/icon/icon.png",
                  //   height: 90,
                  // ),
                  const SizedBox(height: 5),
                  const Text(
                    "Disaster Ready",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    width: MediaQuery.of(context).size.width * 0.75,
                    decoration: const BoxDecoration(
                        // border: Border.all(width: 1, color: Colors.black),
                        // borderRadius: BorderRadius.circular(15),
                        ),
                    child: IntlPhoneField(
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          counter: const Offstage(),
                          labelText: '  Phone Number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Colors.red, width: 3.0),
                            // borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.black, width: 2.0),
                            borderRadius: BorderRadius.circular(12.0),
                          )),
                      initialCountryCode: initialCountry,
                      showDropdownIcon: true,
                      dropdownIconPosition: IconPosition.leading,
                      onChanged: (phone) {
                        setState(() {
                          buttonEnabled = phone.completeNumber.length == 13;
                        });
                        if (phone.completeNumber.length == 13) {
                          FocusScope.of(context).unfocus();
                        }
                      },
                      controller: controller,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    // child: Text(
                    //   'Rescue Ring requires the following permissions to function properly.',
                    //   style: TextStyle(
                    //     fontSize: 22,
                    //     fontWeight: FontWeight.w500,
                    //     color: Colors.black,
                    //   ),
                    // ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    child: PermissionRequestTile(
                      permission: Permission.location,
                      title: 'Location Permission',
                      description:
                          'To get the current location so people can request and recieve help at that particular location.',
                      isGranted: locationPermissionGranted,
                      onGranted: () => setState(() {
                        locationPermissionGranted = true;
                      }),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    child: PermissionRequestTile(
                      permission: Permission.sms,
                      title: 'SMS Permission',
                      description:
                          'We use SMS as an API to communicate with our servers in case of no internet, ensuring the app remains functional.',
                      isGranted: smsPermissionGranted,
                      onGranted: () => setState(() {
                        smsPermissionGranted = true;
                      }),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      onPressed: locationPermissionGranted &&
                              smsPermissionGranted &&
                              buttonEnabled
                          ? setPhoneAndPermission
                          : null,
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  //   ],
                  // ),
                  // ),
                ],
              ),
            ),
          ),
        ));
  }
}

class PermissionRequestTile extends StatelessWidget {
  final Permission permission;
  final String title;
  final String description;
  final bool isGranted;
  final VoidCallback onGranted;

  const PermissionRequestTile({
    Key? key,
    required this.permission,
    required this.title,
    required this.description,
    required this.isGranted,
    required this.onGranted,
  }) : super(key: key);

  void _requestPermission(BuildContext context) async {
    var status = await permission.request();
    if (status.isGranted) {
      onGranted();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Permission Denied'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: isGranted ? Colors.green[100] : null,
        borderRadius: BorderRadius.circular(10),
      ),
      child: GestureDetector(
        onTap: () => _requestPermission(context),
        child: ListTile(
          title:
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(description, style: const TextStyle(fontSize: 12)),
          trailing: isGranted
              ? const Icon(Icons.check, color: Colors.green)
              : IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => _requestPermission(context),
                ),
        ),
      ),
    );
  }
}
