// ignore_for_file: unnecessary_const, prefer_const_constructors

import 'package:disaster_ready/widgets/select_contacts.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddEmergencyNumber extends StatefulWidget {
  const AddEmergencyNumber({super.key});

  @override
  State<AddEmergencyNumber> createState() => _AddEmergencyNumberState();
}

class _AddEmergencyNumberState extends State<AddEmergencyNumber> {
  List<String> emergencyNumbers = [];
  List<String> emergencyNames = [];

  @override
  void initState() {
    super.initState();
    _loadEmergencyNumber();
  }

  Future<void> _loadEmergencyNumber() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      emergencyNumbers = prefs.getStringList('emergency_contacts') ?? [];
      emergencyNames = prefs.getStringList('emergency_names') ?? [];
    });
  }

  Future<void> _selectContact() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ContactSelectionScreen()),
    );
    _loadEmergencyNumber();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'We prioritize your well-being. Save your emergency number for enhanced support.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 16.0),
                GestureDetector(
                  onTap: _selectContact,
                  child: Card(
                    color: Colors.blue.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.3),
                          width: 2),
                    ),
                    child: Center(
                      child: ListTile(
                        title: const Text(
                          'Select Contact',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                Expanded(
                  child: ListView.builder(
                    itemCount: emergencyNumbers.length,
                    itemBuilder: (context, index) {
                      return Card(
                        shadowColor:
                            const Color.fromARGB(255, 0, 0, 0).withOpacity(1),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.3),
                              width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 2.0, bottom: 2.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text((index + 1).toString()),
                            ),
                            title: Text(emergencyNames[index]),
                            subtitle: Text(emergencyNumbers[index]),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: -20,
            right: 0,
            child:
                Image.asset('assets/images/screens/emergency.png', width: 200),
          )
        ],
      ),
    );
  }
}
