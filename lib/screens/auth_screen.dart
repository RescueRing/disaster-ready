// ignore_for_file: unused_local_variable

import 'dart:ui';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:disaster_ready/widgets/phone_number.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

void navigateWithFadeAnimation(BuildContext context, Widget page) {
  Navigator.of(context).push(FadeRoute(page: page));
}

class DisableBackButton extends StatelessWidget {
  final Widget child;

  const DisableBackButton({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: child,
    );
  }
}

class FadeRoute extends PageRouteBuilder {
  final Widget page;

  FadeRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  SharedPreferences? prefs;
  bool authing = false;

  Future<dynamic> signInWithGoogle() async {
    prefs?.setBool('authed', true);
    setState(() {
      authing = true;
    });
    try {
      String android = dotenv.env['ANDROID_CLIENT_ID']!;

      Map<String, dynamic>? deviceInfo;
      try {
        var something = await DeviceInfoPlugin().androidInfo;
        deviceInfo = something.data;
      } catch (e) {
        deviceInfo = {};
      }
      final GoogleSignInAccount? googleUser;
      googleUser = await GoogleSignIn(clientId: android).signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      prefs?.setString('email', userCredential.user!.email!);
    } on Exception catch (e) {
      print(e);
      // Future.delayed(const Duration(milliseconds: 400), () {
      //   Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(
      //       builder: (context) => const FirstScreen(),
      //     ),
      // );
      // snack('Signed in successfully!', context, color: Colors.green);
      // Future.delayed(const Duration(milliseconds: 400), () {
      //   setState(() {
      //     authing = false;
      //   });
      // });
      // });

      // snack('Authentication failed', context);
      setState(() {
        authing = false;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => PhoneNumber(),
        ),
      );
    }
  }

  void setPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    setPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: GestureDetector(
        onTap: () {
          signInWithGoogle();
        },
        child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              backgroundBlendMode: BlendMode.darken,
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!authing)
                  Image.asset(
                    'assets/images/google_icon.png',
                    height: 50,
                    width: 50,
                  ),
                if (!authing)
                  const Text(
                    "Continue with Google",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (authing) CircularProgressIndicator()
              ],
            )),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          image: DecorationImage(
            image: AssetImage('assets/images/screens/city_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        height: double.infinity,
        width: double.infinity,
        // alignment: Alignment.center,
        child: Column(
          children: [
            Spacer(),
            Positioned(
              bottom: 1000,
              top: 200,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Rescue Ring',
                          style: GoogleFonts.exo2(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          )),
                      Text(
                        'A network of support for those in need....',
                        style: GoogleFonts.exo2(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
