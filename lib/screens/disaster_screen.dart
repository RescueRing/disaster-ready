import 'package:disaster_ready/models/disaster_data.dart';
import 'package:disaster_ready/models/schemes_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class DisasterScreen extends StatefulWidget {
  DisasterScreen({super.key});
  int selectedIndex = 0;

  @override
  State<DisasterScreen> createState() => _DisasterScreenState();
}

class _DisasterScreenState extends State<DisasterScreen> {
  // int selectedIndex = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: [
            Container(
              constraints: BoxConstraints(maxHeight: 270),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,

                  // crossAxisSpacing: 10,
                  // mainAxisSpacing: 10,
                ),
                itemCount: schemes.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      print('Tapped');
                      print(index);
                      setState(() {
                        print('Set State');
                        widget.selectedIndex = index;
                        print(widget.selectedIndex);
                      });
                      setState(() {
                        widget.selectedIndex = index;
                      });
                    },
                    child: Container(
                      height: 200,
                      // color: Colors.blue.withOpacity(0.1),
                      padding: const EdgeInsets.only(
                          top: 4, bottom: 4, left: 5, right: 5),
                      child: Card(
                        color: widget.selectedIndex == index
                            ? Colors.blue.shade200
                            : Colors.blue.shade100.withOpacity(0.5),
                        shadowColor:
                            const Color.fromARGB(255, 0, 0, 0).withOpacity(1),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Colors.blue.withOpacity(0.3), width: 1.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: GestureDetector(
                          onLongPress: () {
                            HapticFeedback.lightImpact();
                            launchUrl(Uri.parse((schemes[index]
                                        ['contactInformation']
                                    as Map<String, dynamic>)['website']!
                                .toString()));
                          },
                          child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 12.0, bottom: 12.0),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    child: Container(
                                      constraints:
                                          BoxConstraints(maxHeight: 50),
                                      child: Image(
                                        image: AssetImage(disasterData[index]
                                                ['image']!
                                            .toString()),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                      '${disasterData[index]['disaster_name']}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18)),
                                ],
                              )),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text(
                disasterData[widget.selectedIndex]['disaster_name'].toString(),
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Text('Consequences',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('${disasterData[widget.selectedIndex]['consequences']}'),
                  SizedBox(height: 10),
                  // Text(
                  //     'Precautions: ${disasterData[widget.selectedIndex]['precautions']}'),
                  SizedBox(height: 10),
                  Text('Preparedness',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  for (int i = 0;
                      i <
                          (disasterData[widget.selectedIndex]['preparedness']
                                  as List)
                              .length;
                      i++)
                    Text(
                        '${i + 1}. ${(disasterData[widget.selectedIndex]['preparedness'] as List)[i]}'),
                  Text(
                      "Emergency Contact: ${disasterData[widget.selectedIndex]['emergency_contact']}"),
                  // Text(
                  //     'Description: ${disasterData[widget.selectedIndex]['preparedness']}'),
                  // Text(
                  //     'Emergency Contact: ${disasterData[widget.selectedIndex]['emergency_contact']}'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
