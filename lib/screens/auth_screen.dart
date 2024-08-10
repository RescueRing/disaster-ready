import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:disaster_ready/screens/first_screen.dart';
// import 'package:disaster_ready/screens/first_screen.dart';
import 'package:disaster_ready/util/snack.dart';
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
    // Future.delayed(const Duration(seconds: 20), () {
    //   setState(() {
    //     authing = false;
    //   });
    // });
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
      // FirebaseFirestore.instance
      //     .collection('users')
      //     .doc(userCredential.user?.email)
      //     .set({
      //   'email': userCredential.user?.email,
      //   'name': userCredential.user?.displayName,
      //   'photo': userCredential.user?.photoURL,
      //   'uid': userCredential.user?.uid,
      //   'deviceInfo': deviceInfo,
      // });
    } on Exception catch (e) {
      print(e);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const FirstScreen(),
        ),
      );
      // snack('Authentication failed', context);
      setState(() {
        authing = false;
      });
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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg2.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
        child: Container(
          height: 500,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(15),
            color: Colors.black.withOpacity(0.1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Center(
                      //   child: ClipRRect(
                      //     borderRadius: BorderRadius.circular(100),
                      //     child: Image.asset(
                      //       fit: BoxFit.cover,
                      //       '_______icon_______',
                      //       height: 100,
                      //       width: 100,
                      //     ),
                      //   ),
                      // ),
                      // const Gap(8),
                      Center(
                        child: Text(
                          "Welcome to !",
                          style: GoogleFonts.exo2(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Unlock Your Future: Discover Your Ideal College Match!',
                                // textAlign: TextAlign.center,
                                style: GoogleFonts.exo2(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Gap(6),
                              const Text(
                                'Tell us about your preferences, and let our website work its magic to predict the perfect colleges for you. Say goodbye to uncertainty and hello to your dream education!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          signInWithGoogle();
                        },
                        child: !authing
                            ? Container(
                                height: 40,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/google_icon.png',
                                      height: 50,
                                      width: 50,
                                    ),
                                    const Text(
                                      "Continue with Google",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const Center(
                                child: CircularProgressIndicator(),
                              ),
                      ),
                      const Spacer(),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
