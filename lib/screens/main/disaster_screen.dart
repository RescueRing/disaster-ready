// ignore_for_file: must_be_immutable, unused_local_variable

import 'package:disaster_ready/data/disaster_data.dart';
import 'package:disaster_ready/data/schemes_data.dart';
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
  ScrollController _scrollController = ScrollController();
  void _scrollToTop() {
    _scrollController.animateTo(
      250,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  // @override
  // void initState() {
  //   super.initState();
  //   widget.addListener(() {
  //     if (widget.selectedIndex != 0) {
  //       _scrollToTop();
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: SingleChildScrollView(
          controller: _scrollController,
          // reverse: true,
          child: Column(
            children: [
              Container(
                constraints: BoxConstraints(maxHeight: 250),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: schemes.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.selectedIndex = index;
                        });
                        _scrollToTop();
                      },
                      child: Container(
                        // height: 200,
                        padding:
                            const EdgeInsets.only(top: 4, left: 5, right: 5),
                        child: Card(
                          color: widget.selectedIndex == index
                              ? Colors.blue.shade200
                              : Colors.blue.shade100.withOpacity(0.5),
                          shadowColor:
                              const Color.fromARGB(255, 0, 0, 0).withOpacity(1),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Colors.blue.withOpacity(0.3),
                                width: 1.5),
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
                              padding:
                                  const EdgeInsets.only(top: 4.0, bottom: 4.0),
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
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              ListTile(
                title: Card(
                  color: Colors.blue.shade800,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(
                      disasterData[widget.selectedIndex]['disaster_name']
                          .toString(),
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Consequences',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                          '${disasterData[widget.selectedIndex]['consequences']}'),
                      SizedBox(height: 10),
                      Text('Preparedness',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      for (int i = 0;
                          i <
                              (disasterData[widget.selectedIndex]
                                      ['preparedness'] as List)
                                  .length;
                          i++)
                        Text(
                            '${i + 1}. ${(disasterData[widget.selectedIndex]['preparedness'] as List)[i]}'),
                      SizedBox(height: 10),
                      Text('Emergency Contact',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                          "${(disasterData[widget.selectedIndex]['emergency_contact'] as Map<String, dynamic>)['name']}"),
                      ElevatedButton.icon(
                          onPressed: () {
                            launchUrl(Uri.parse(
                                "tel:${(disasterData[widget.selectedIndex]['emergency_contact'] as Map<String, dynamic>)['phone']}"));
                          },
                          label: Text((disasterData[widget.selectedIndex]
                                          ['emergency_contact']
                                      as Map<String, dynamic>)['number']
                                  .toString() ??
                              'Call'),
                          icon: Icon(Icons.call)),
                      SizedBox(height: 10),
                      Text("Does and don'ts here",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 30)),
                      SizedBox(height: 230),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
