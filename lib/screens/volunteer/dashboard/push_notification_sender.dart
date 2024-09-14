// import 'dart:ffi';
// import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:disaster_ready/services/fetch_address.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PushNotificationSender extends StatefulWidget {
  @override
  _PushNotificationSenderState createState() => _PushNotificationSenderState();
}

class _PushNotificationSenderState extends State<PushNotificationSender> {
  final _formKey = GlobalKey<FormState>();
  String _message = '';
  String _intensity = 'Moderate';
  List<String> _intensityLevels = ['Low', 'Moderate', 'High', 'Severe'];

  List<Icon> _icons = [
    Icon(Icons.warning),
    Icon(Icons.warning_amber),
    Icon(Icons.dangerous),
    Icon(Icons.error),
  ];
  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Emergency Alert'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Compose Emergency Alert',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: 16),
              TextFormField(
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Alert Message',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an alert message';
                  }
                  return null;
                },
                onSaved: (value) {
                  _message = value ?? '';
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _intensity,
                decoration: InputDecoration(
                  labelText: 'Emergency Intensity',
                  border: OutlineInputBorder(),
                ),
                items: _intensityLevels.map((String intensity) {
                  return DropdownMenuItem<String>(
                    value: intensity,
                    child: Text(intensity),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _intensity = newValue!;
                  });
                },
              ),
              SizedBox(height: 24),
              ElevatedButton(
                child: Text('Send Alert'),
                style: ElevatedButton.styleFrom(
                  // primary: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                onPressed: _showConfirmationDialog,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Emergency Alert'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Are you sure you want to send this alert?'),
                  SizedBox(height: 16),
                  Text('Message: $_message'),
                  Text('Intensity: $_intensity'),
                  SizedBox(height: 16),
                  Text(
                    'WARNING: Sending false alarms or misusing this feature can result in severe consequences, including legal action and permanent ban from the platform.',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Send Alert'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _sendAlert();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _sendAlert() async {
    try {
      // Create a new document in Firestore to trigger the Cloud Function
      final location = await getUserLocation();
      final phoneNumber = await SharedPreferences.getInstance().then((prefs) {
        return prefs.getString('phoneNumber');
      });
      await FirebaseFirestore.instance.collection('emergency_alerts').add({
        'message': _message,
        'intensity': _intensity,
        'timestamp': FieldValue.serverTimestamp(),
        'location': location.toJson(),
        'subAdministrativeArea': location.subAdministrativeArea,
        'phoneNumber': phoneNumber,
      });
      FirebaseMessaging.instance
          .subscribeToTopic('emergency_alerts')
          .then((value) {
        print('Subscribed to emergency_alerts topic');
      });
      FirebaseMessaging.instance.onTokenRefresh.listen((event) {
        print(event.allMatches('emergency_alerts'));
        print('Token refreshed: $event');
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Emergency alert sent successfully'),
          backgroundColor: Colors.green,
        ),
      );

      FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
        fcmToken = fcmToken;
        print('FCM Token: $fcmToken');
      });

      // Clear the form after sending
      _formKey.currentState!.reset();
      setState(() {
        _intensity = 'Moderate';
      });
    } catch (e) {
      print('Error sending notification: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send alert. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
