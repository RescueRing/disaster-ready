import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class BenefitsScreen extends StatelessWidget {
  const BenefitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: ListView(
        // shrinkWrap: true,
        padding: EdgeInsets.all(10),
        children: const [
          Text(
            'Exclusive Rights for Volunteers',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'As a volunteer, you get exclusive access to the community’s emergency network. Be the first to respond, take charge, and guide others.',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 13,
            ),
          ),
          Gap(20),
          BenefitItem(
            icon: Icons.star,
            text: 'Priority access to emergency information',
          ),
          BenefitItem(
            icon: Icons.people,
            text: 'Direct communication with disaster response teams',
          ),
          BenefitItem(
            icon: Icons.school,
            text: 'Free training and skill development opportunities',
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}

class BenefitItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const BenefitItem({Key? key, required this.icon, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 30),
          SizedBox(width: 16),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
