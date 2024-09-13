import 'package:disaster_ready/screens/volunteer/registering/benefits_screen.dart';
import 'package:disaster_ready/screens/volunteer/registering/guidelines_screen.dart';
import 'package:disaster_ready/screens/volunteer/registering/personal_details_screen.dart';
import 'package:disaster_ready/screens/volunteer/registering/skills_selection_screen.dart';
import 'package:disaster_ready/services/fetch_address.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VolunteerRegistrationApp extends StatefulWidget {
  const VolunteerRegistrationApp({super.key});

  @override
  State<VolunteerRegistrationApp> createState() =>
      _VolunteerRegistrationAppState();
}

class _VolunteerRegistrationAppState extends State<VolunteerRegistrationApp> {
  List<String> title = [
    'Welcome Volunteers',
    'Benefits',
    'Guidelines',
    'Skills Selection',
    'Personal Details'
  ];

  List<Widget> screens = [
    VolunteerIntro(),
    BenefitsScreen(),
    GuidelinesScreen(),
    SkillsSelectionScreen(),
    PersonalDetailsScreen()
  ];

  List<String> nextButton = [
    'Sign up and be the lifeline people need!',
    'Next: Guidelines',
    'Next: Skills Selection',
    'Next: Personal Details',
    'Register as Volunteer'
  ];

  int index = 0;
  SharedPreferences? prefs;

// @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     SharedPreferences.getInstance().then((value) {
//       prefs = value;
//       if(prefs!.getBool('volunteer') == true){
//         Navigator.of(context).pushReplacementNamed('/volunteer_dashboard');
//       }
//     });
//   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title[index])),
      bottomNavigationBar: index != 4
          ? GestureDetector(
              onTap: () async {
                // print(await getUserLocation());
                // return;
                if (index == screens.length - 1) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Registration Successful'),
                      content: Text('Thank you for volunteering!'),
                      actions: [
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  );
                  print(getUserLocation());
                  return;
                }
                setState(() {
                  index++;
                });
              },
              child: Container(
                  // color: Colors.blue.shade100,
                  // height: 60,
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    backgroundBlendMode: BlendMode.darken,
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(FontAwesomeIcons.signInAlt),
                      Gap(10),
                      Text(
                        nextButton[index],
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )),
            )
          : null,
      body: screens[index],
    );
  }
}

class VolunteerIntro extends StatelessWidget {
  const VolunteerIntro({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Join Our Network of Heroes',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Become a community hero. In times of crisis, your skills can make the difference.',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
