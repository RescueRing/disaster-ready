import 'package:disaster_ready/screens/volunteer/dashboard/push_notification_sender.dart';
import 'package:flutter/material.dart';

class VolunteerDashboard extends StatelessWidget {
  const VolunteerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Volunteer Dashboard'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome Volunteer',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'You are now a registered volunteer.\nThank you for your service.',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PushNotificationSender()));
                },
                child: Text('Report Emergency'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
