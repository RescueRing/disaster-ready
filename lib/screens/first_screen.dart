import 'package:disaster_ready/screens/add_emergency_number.dart';
import 'package:disaster_ready/screens/home_screen.dart';
import 'package:disaster_ready/screens/temp_home.dart';
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
    TempScreen()
  ];
  List<String> titles = ['Home', 'Edit Emergency Number', 'Temp'];
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
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                setState(() {
                  index = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Edit Emergency Number'),
              onTap: () {
                setState(() {
                  index = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Temp'),
              onTap: () {
                setState(() {
                  index = 2;
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
