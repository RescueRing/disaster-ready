import 'package:flutter/material.dart';

class GuidelinesScreen extends StatelessWidget {
  const GuidelinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: const [
        Text(
          'Responsibilities and Rules',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 20),
        GuidelineItem(
          text: 'Always prioritize your safety and the safety of others',
        ),
        GuidelineItem(
          text:
              'Follow instructions from authorized personnel during emergencies',
        ),
        GuidelineItem(
          text: 'Maintain confidentiality of sensitive information',
        ),
        GuidelineItem(
          text: 'Report any misuse of the app or inappropriate behavior',
        ),
        SizedBox(height: 20),
        Text(
          'Warning: Misuse of app features may result in account suspension',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class GuidelineItem extends StatelessWidget {
  final String text;

  const GuidelineItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, size: 24, color: Colors.green),
          SizedBox(width: 16),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
