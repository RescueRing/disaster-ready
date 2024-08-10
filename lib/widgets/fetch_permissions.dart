// ignore_for_file: library_private_types_in_public_api

import 'package:disaster_ready/screens/main/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FetchPermissions extends StatefulWidget {
  FetchPermissions({super.key});

  @override
  _GetPermissionsState createState() => _GetPermissionsState();
}

class _GetPermissionsState extends State<FetchPermissions> {
  bool locationPermissionGranted = false;
  bool smsPermissionGranted = false;

  void _updatePermissionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    if (locationPermissionGranted && smsPermissionGranted) {
      await prefs.setBool('permissionsGranted', true);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
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
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Rescue Ring requires the following permissions to function properly.',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
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
              // SizedBox(height: 10),
              // PermissionRequestTile(
              //   permission: Permission.sms,
              //   title: 'SMS Permission',
              //   description:
              //       'We use SMS as an API to communicate with our servers in case of no internet, ensuring the app remains functional.',
              //   isGranted: smsPermissionGranted,
              //   onGranted: () => setState(() {
              //     smsPermissionGranted = true;
              //   }),
              // ),
              SizedBox(height: 20),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(0, 0, 0, 0.8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  onPressed: locationPermissionGranted && smsPermissionGranted
                      ? _updatePermissionStatus
                      : null,
                  child: const Text(
                    'Submit',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(description),
          trailing: isGranted
              ? Icon(Icons.check, color: Colors.green)
              : IconButton(
                  icon: Icon(Icons.chevron_right),
                  onPressed: () => _requestPermission(context),
                ),
        ),
      ),
    );
  }
}
