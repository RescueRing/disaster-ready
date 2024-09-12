import 'package:disaster_ready/generated/l10n.dart';
import 'package:disaster_ready/providers/locale_provider.dart';
import 'package:disaster_ready/screens/main/add_emergency_number.dart';
import 'package:disaster_ready/screens/main/disaster_screen.dart';
import 'package:disaster_ready/screens/main/home_screen.dart';
import 'package:disaster_ready/screens/main/schemes_screen.dart';
import 'package:flutter/material.dart';
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
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
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

  List<Widget> screens = [
    HomeScreen(),
    const AddEmergencyNumber(),
    SchemesScreen(),
    DisasterScreen(),
    Container()
  ];

  int index = 3;
  @override
  Widget build(BuildContext context) {
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
                                'Rescue Ring',
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
                                'A network of support for those in need',
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
                title: Text(titles[index]),
                backgroundColor: Colors.transparent,
                actions: [
                  IconButton(
                      onPressed: () {
                        print('Language changed');

                        SharedPreferences.getInstance().then((prefs) {
                          String newLocale =
                              prefs.getString('locale') == 'en' ? 'kan' : 'en';
                          prefs.setString('locale', newLocale);
                          Locale newLocaleObj = Locale(newLocale);
                          // LocaleProvider(newLocaleObj).setLocale(newLocaleObj);
                          prv.Provider.of<LocaleProvider>(context,
                                  listen: false)
                              .setLocale(newLocaleObj);
                          // setState(() {
                          //   // Rebuild the widget with the new locale
                          // });
                        });

                        print(S.of(context).hello);
                        // });
                        // LocaleProvider(Locale('es')).setLocale(Locale('es'));
                      },
                      icon: Icon(Icons.language))
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
