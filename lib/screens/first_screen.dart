import 'package:disaster_ready/screens/main/add_emergency_number.dart';
import 'package:disaster_ready/screens/main/disaster_screen.dart';
import 'package:disaster_ready/screens/main/home_screen.dart';
import 'package:disaster_ready/screens/main/schemes_screen.dart';
import 'package:disaster_ready/screens/main/temp_home.dart';
import 'package:disaster_ready/util/snack.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  List<Widget> screens = [
    HomeScreen(),
    const AddEmergencyNumber(),
    SchemesScreen(),
    DisasterScreen(),
  ];
  List<String> titles = [
    'Home',
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
                color: Colors.blue.shade900,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
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
            icon: const Icon(Icons.delete),
            onPressed: () {
              SharedPreferences.getInstance().then((prefs) {
                prefs.clear();
                snack(
                  'Cleared all data',
                  context,
                );
              });
            },
          )
        ],
      ),
      body: screens[index],
    );
  }
}
