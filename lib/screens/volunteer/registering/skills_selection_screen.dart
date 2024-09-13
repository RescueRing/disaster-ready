import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SkillsSelectionScreen extends StatefulWidget {
  const SkillsSelectionScreen({super.key});

  @override
  _SkillsSelectionScreenState createState() => _SkillsSelectionScreenState();
}

class _SkillsSelectionScreenState extends State<SkillsSelectionScreen> {
  List<String> skills = [
    'First Aid and CPR',
    'Swimming Skills',
    'Boat Handling and Navigation',
    'Rescue and Evacuation Techniques',
    'Medical Transportation',
    'Fracture and Sprain Management',
    'Water Purification and Safety',
    'Food and Water Source',
    'Debris Removal and Clearance',
    'Emergency Childbirth and Neonatal Care',
    'Fire Safety and Extinguishment',
    'Search and Rescue Team',
    'Electrical Safety and Emergency Response',
  ];

  List<String> selectedSkills = [];

  SharedPreferences? prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPreferences.getInstance().then((value) {
      prefs = value;
      setState(() {
        selectedSkills = prefs!.getStringList('volunteerSkill') ?? [];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: skills.length,
            itemBuilder: (context, index) {
              final skill = skills[index];
              return Card(
                margin: EdgeInsets.only(left: 10, right: 16, bottom: 4),
                child: ListTile(
                  onTap: () {
                    setState(() {
                      if (selectedSkills.contains(skill)) {
                        selectedSkills.remove(skill);
                      } else {
                        selectedSkills.add(skill);
                      }
                    });
                  },
                  // contentPadding: EdgeInsets.only(left: 16, right: 16),
                  leading: Text((index + 1).toString(),
                      style: TextStyle(fontSize: 18)),
                  title: CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(skills[index]),
                    value: selectedSkills.contains(skill),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          selectedSkills.add(skill);
                        } else {
                          selectedSkills.remove(skill);
                        }
                        prefs!.setStringList('volunteerSkill', selectedSkills);
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
