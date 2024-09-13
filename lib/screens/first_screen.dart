import 'package:disaster_ready/generated/l10n.dart';
import 'package:disaster_ready/providers/locale_provider.dart';
import 'package:disaster_ready/screens/main/add_emergency_number.dart';
import 'package:disaster_ready/screens/main/disaster_screen.dart';
import 'package:disaster_ready/screens/main/home_screen.dart';
import 'package:disaster_ready/screens/main/schemes_screen.dart';
import 'package:disaster_ready/screens/volunteer/dashboard/volunteer_dashboard.dart';
import 'package:disaster_ready/screens/volunteer/registering/volunteer_first_screen.dart';
import 'package:disaster_ready/screens/volunteer/registering/volunteer_intro.dart';
// import 'package:disaster_ready/util/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart' as prv;
import 'package:skeletonizer/skeletonizer.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  bool isLoading = true;
  // SharedPreferences? prefs;
  bool isVolunteer = false;

  @override
  void initState() {
    super.initState();
    // prefs = SharedPreferences.getInstance();
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getBool('isVolunteer') == null) {
        prefs.setBool('isVolunteer', false);
      } else {
        setState(() {
          isVolunteer = prefs.getBool('isVolunteer')!;
        });
      }
      if (prefs.getInt('screenIndex') != null) {
        setState(() {
          index = prefs.getInt('screenIndex')!;
        });
      } else {
        prefs.setInt('screenIndex', 0);
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  int index = 3;
  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      HomeScreen(context: context),
      const AddEmergencyNumber(),
      SchemesScreen(),
      DisasterScreen(),
      Container()
    ];
    final localization = S.of(context);

    List<String> titles = [
      localization.rescuering,
      localization.editEmergencyNumber,
      localization.govSchemes,
      localization.disaster,
    ];
    return !isLoading
        ? Skeletonizer(
            enabled: isLoading,
            child: Scaffold(
              drawer: Drawer(
                width: 300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.blue.shade600,
                      ),
                      child: Expanded(
                        child: Stack(
                          children: [
                            Positioned(
                              top: 5,
                              left: 70,
                              child: Text(
                                localization.rescuering,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 5,
                              left: 10,
                              child: Text(
                                localization.rescuedescription,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 16,
                              right: 100,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                constraints: BoxConstraints(
                                  maxWidth: 100,
                                ),
                                child: Image.asset('assets/images/logo.png'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    for (int i = 0; i < titles.length; i++)
                      ListTile(
                        tileColor: i == index ? Colors.blue.shade100 : null,
                        title: Text(titles[i]),
                        onTap: () {
                          setState(() {
                            index = i;
                          });
                          SharedPreferences.getInstance().then((prefs) {
                            prefs.setInt('screenIndex', i);
                          });
                          Navigator.pop(context);
                        },
                      ),
                  ],
                ),
              ),
              appBar: AppBar(
                title: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    titles[index],
                    softWrap: true,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                backgroundColor: Colors.transparent,
                actions: [
                  IconButton(
                      onPressed: () {
                        if (isVolunteer) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => VolunteerDashboard()));
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  VolunteerRegistrationApp()));
                        }
                      },
                      icon: Icon(FontAwesomeIcons.crown)),
                  IconButton(
                      onPressed: () {
                        SharedPreferences.getInstance().then((prefs) {
                          String newLocale =
                              prefs.getString('locale') == 'en' ? 'kn' : 'en';
                          prefs.setString('locale', newLocale);
                          Locale newLocaleObj = Locale(newLocale);
                          prv.Provider.of<LocaleProvider>(context,
                                  listen: false)
                              .setLocale(newLocaleObj);
                        });

                        print(S.of(context).hello);
                      },
                      icon: Icon(Icons.language)),
                  // IconButton(
                  //   icon: const Icon(Icons.delete),
                  //   onPressed: () {
                  //     SharedPreferences.getInstance().then((prefs) {
                  //       prefs.clear();
                  //       snack(
                  //         'Cleared all data',
                  //         context,
                  //       );
                  //     });
                  //   },
                  // )
                ],
              ),
              body: screens[index],
            ),
          )
        : Scaffold(
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/images/logo.png', height: 100),
                  Gap(20),
                  SizedBox(height: 50, child: CircularProgressIndicator()),
                ],
              ),
            ),
            // ),
          );
  }
}
