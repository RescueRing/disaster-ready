import 'package:disaster_ready/providers/locale_provider.dart';
import 'package:disaster_ready/services/firebase_notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:disaster_ready/screens/auth_screen.dart';
import 'package:disaster_ready/screens/first_screen.dart';
import 'package:disaster_ready/widgets/phone_number.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:disaster_ready/generated/l10n.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart' as prv;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final prefs = await SharedPreferences.getInstance();
  var authed = prefs.getBool('authed');
  var phoneNumber = prefs.getString('phoneNumber');
  var permissionsGiven = prefs.getBool('permissionsGranted') ?? false;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  await FirebaseNotification().initNotification();
  runApp(prv.ChangeNotifierProvider(
    create: (context) {
      final localeProvider = LocaleProvider(Locale('en'));
      if (prefs.getString('locale') != null) {
        localeProvider.setLocale(Locale(prefs.getString('locale') ?? 'en'));
      } else {
        localeProvider.setLocale(const Locale('kn'));
      }
      return localeProvider;
    },
    child: ProviderScope(
      child: MyApp(
          authed: authed ?? false,
          phoneNumber: phoneNumber ?? '',
          permissionGiven: permissionsGiven),
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp(
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
    setPrefs();
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = prv.Provider.of<LocaleProvider>(context);
    return MaterialApp(
      locale: localeProvider.locale,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      title: 'Disaster Ready',
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
