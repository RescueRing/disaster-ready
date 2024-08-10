import 'dart:math';

import 'package:disaster_ready/screens/auth_screen.dart';
import 'package:disaster_ready/screens/first_screen.dart';
import 'package:disaster_ready/widgets/fetch_permissions.dart';
import 'package:disaster_ready/widgets/phone_number.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print("Error loading .env file: $e");
  }
  final prefs = await SharedPreferences.getInstance();
  var authed = prefs.getBool('authed');
  var phoneNumber = prefs.getString('phoneNumber');
  var permissionsGiven = prefs.getBool('permissionsGranted') ?? false;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp(
      authed: authed ?? false,
      phoneNumber: phoneNumber ?? '',
      permissionGiven: permissionsGiven));
}

class MyApp extends StatefulWidget {
  MyApp(
      {super.key,
      required this.authed,
      required this.phoneNumber,
      required this.permissionGiven});
  final bool authed;
  final String phoneNumber;
  final bool permissionGiven;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SharedPreferences? prefs;
  bool authed = false;

  void setPrefs() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      authed = prefs?.getBool('authed') ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Disaster Ready',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.exo2TextTheme(),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.none) {
            return const Scaffold(
              body: Center(
                heightFactor: 10,
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.hasData && snapshot.data != null) {
            return const FirstScreen();
          }
          if (widget.authed) {
            if (widget.phoneNumber == '' || !widget.permissionGiven) {
              print(widget.phoneNumber);
              print(widget.permissionGiven);
              return PhoneNumber();
            }
            return const FirstScreen();
          } else {
            return const AuthScreen();
          }
          // return const AuthScreen();
        },
      ),
    );
  }
}
