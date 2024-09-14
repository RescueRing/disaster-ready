// ignore_for_file: must_be_immutable, unused_local_variable

import 'package:disaster_ready/data/disaster_data.dart';
import 'package:disaster_ready/data/schemes_data.dart';
import 'package:disaster_ready/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:text_responsive/text_responsive.dart';
import 'package:url_launcher/url_launcher.dart';

class DisasterScreen extends StatefulWidget {
  DisasterScreen({super.key});
  int selectedIndex = -1;

  @override
  State<DisasterScreen> createState() => _DisasterScreenState();
}

class _DisasterScreenState extends State<DisasterScreen> {
  final ScrollController _scrollController = ScrollController();
  void _scrollToTop() {
    _scrollController.animateTo(
      360,
      duration: Duration(milliseconds: 700),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> translationMap = {
      'Earthquake': S.of(context).earthquake,
      'Flood': S.of(context).flood,
      'Hurricane': S.of(context).hurricane,
      'Tornado': S.of(context).tornado,
      'Wildfire': S.of(context).wildfire,
      'Tsunami': S.of(context).tsunami,
      'Volcano': S.of(context).volcano,
      'Drought': S.of(context).drought,
      'Landslide': S.of(context).landslide,
      'Cyclone': S.of(context).cyclone,
      'Volcanic Eruption': S.of(context).volcanicEruption,
    };
    Locale currentLocale = Localizations.localeOf(context);
    String languageCode = currentLocale.languageCode;
    final multilanguage = S.of(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                constraints: BoxConstraints(maxHeight: 360),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemCount: disasterData[languageCode]!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.selectedIndex = index;
                        });
                        _scrollToTop();
                      },
                      child: Container(
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
                              launchUrl(Uri.parse((schemes['en']![index]
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
                                      alignment: Alignment.center,
                                      constraints:
                                          BoxConstraints(maxHeight: 50),
                                      child: Image(
                                        image: AssetImage(
                                            disasterData[languageCode]![index]
                                                    ['image']!
                                                .toString()),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  ParagraphTextWidget(
                                    overflow: TextOverflow.ellipsis,
                                    // softWrap: true,
                                    // maxLines: 2,
                                    translationMap[disasterData['en']![index]
                                            ["disaster_name"]] ??
                                        'bro',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      textBaseline: TextBaseline.alphabetic,
                                    ),
                                  ),
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
              if (widget.selectedIndex != -1)
                ListTile(
                  title: Card(
                    color: Colors.blue.shade800,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        disasterData[languageCode]![widget.selectedIndex]
                                ['disaster_name']
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
                        Text(multilanguage.consequences,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                            '${disasterData[languageCode]![widget.selectedIndex]['consequences']}'),
                        SizedBox(height: 10),
                        Text(multilanguage.Preparedness,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        for (int i = 0;
                            i <
                                (disasterData[languageCode]![widget
                                        .selectedIndex]['preparedness'] as List)
                                    .length;
                            i++)
                          Text(
                              '${i + 1}. ${(disasterData[languageCode]![widget.selectedIndex]['preparedness'] as List)[i]}'),
                        SizedBox(height: 10),
                        Text(multilanguage.emergencyContact,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                            "${(disasterData[languageCode]![widget.selectedIndex]['emergency_contact'] as Map<String, dynamic>)['name']}"),
                        ElevatedButton.icon(
                            onPressed: () {
                              launchUrl(Uri.parse(
                                  "tel:${(disasterData[languageCode]![widget.selectedIndex]['emergency_contact'] as Map<String, dynamic>)['phone']}"));
                            },
                            label: Text((disasterData[languageCode]![widget
                                        .selectedIndex]['emergency_contact']
                                    as Map<String, dynamic>)['number'] ??
                                'Call'),
                            icon: Icon(Icons.call)),
                        SizedBox(height: 10),
                        // Text("Does and don'ts here",
                        //     style: TextStyle(
                        //         fontWeight: FontWeight.bold, fontSize: 30)),
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
