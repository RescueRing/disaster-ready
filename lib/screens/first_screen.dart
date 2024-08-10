import 'package:disaster_ready/screens/home_screen.dart';
import 'package:disaster_ready/util/snack.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  List<Widget> screens = [const HomeScreen()];
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
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
              title: const Text('Settings'),
              onTap: () {
                setState(() {
                  index = 1;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
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
