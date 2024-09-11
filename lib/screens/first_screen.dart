import 'package:disaster_ready/screens/main/add_emergency_number.dart';
import 'package:disaster_ready/screens/main/disaster_screen.dart';
import 'package:disaster_ready/screens/main/home_screen.dart';
import 'package:disaster_ready/screens/main/schemes_screen.dart';
// import 'package:disaster_ready/util/snack.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
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
    });
  }

  List<Widget> screens = [
    HomeScreen(),
    const AddEmergencyNumber(),
    SchemesScreen(),
    DisasterScreen(),
  ];

  List<String> titles = [
    'Rescue Ring',
    'Edit Emergency Number',
    'Government Schemes',
    'Disaster Guide'
  ];
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        child: Image.asset('assets/images/logo.png'),
                        padding: const EdgeInsets.all(8),
                        constraints: BoxConstraints(
                          maxWidth: 100,
                        ),
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
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.delete),
        //     onPressed: () {
        //       SharedPreferences.getInstance().then((prefs) {
        //         prefs.clear();
        //         snack(
        //           'Cleared all data',
        //           context,
        //         );
        //       });
        //     },
        //   )
        // ],
      ),
      body: screens[index],
    );
  }
}
