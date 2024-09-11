// import 'dart:math';

// import 'package:disaster_ready/screens/add_emergency_number.dart';
import 'package:disaster_ready/screens/auth_screen.dart';
import 'package:disaster_ready/screens/first_screen.dart';
// import 'package:disaster_ready/screens/home_screen.dart';
// import 'package:disaster_ready/widgets/fetch_permissions.dart';
import 'package:disaster_ready/widgets/phone_number.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  runApp(ProviderScope(
    child: MyApp(
        authed: authed ?? false,
        phoneNumber: phoneNumber ?? '',
        permissionGiven: permissionsGiven),
  ));
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
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      //   textTheme: GoogleFonts.exo2TextTheme(),
      // ),
      theme: FlexThemeData.light(
        colors: const FlexSchemeColor(
          primary: Color(0xff004881),
          primaryContainer: Color(0xffd0e4ff),
          secondary: Color(0xffac3306),
          secondaryContainer: Color(0xffffdbcf),
          tertiary: Color(0xff006875),
          tertiaryContainer: Color(0xff95f0ff),
          appBarColor: Color(0xffffdbcf),
          error: Color(0xffb00020),
        ),
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 7,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 10,
          blendOnColors: false,
          useTextTheme: true,
          useM2StyleDividerInM3: true,
          alignedDropdown: true,
          useInputDecoratorThemeInDialogs: true,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        swapLegacyOnMaterial3: true,
      ).copyWith(
        textTheme: GoogleFonts.exo2TextTheme(),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
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
          if (!widget.authed) {
            return const AuthScreen();
          }
          if (widget.phoneNumber.length >= 10) {
            return const FirstScreen();
          } else {
            return PhoneNumber();
          }
        },
      ),
    );
  }
}
