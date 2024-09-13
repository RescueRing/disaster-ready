import 'package:disaster_ready/data/schemes_data.dart';
import 'package:disaster_ready/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class SchemesScreen extends StatelessWidget {
  const SchemesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Locale currentLocale = Localizations.localeOf(context);
    String languageCode = currentLocale.languageCode;
    final multilanguage = S.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: schemes[languageCode]!.length,
          itemBuilder: (context, index) {
            return Container(
              color: Colors.blue.withOpacity(0.1),
              padding:
                  const EdgeInsets.only(top: 10, bottom: 10, left: 5, right: 5),
              child: Card(
                shadowColor: const Color.fromARGB(255, 0, 0, 0).withOpacity(1),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: Colors.blue.withOpacity(0.3), width: 1.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                  child: Column(
                    children: [
                      ListTile(
                        title: Card(
                          color: Colors.blue.shade900,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              schemes[languageCode]![index]['schemeName']!
                                  .toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            Text(schemes[languageCode]![index]['objective']!
                                .toString()),
                            const SizedBox(height: 10),
                            Text(multilanguage.targetBeneficiaries,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            Text(
                              (schemes[languageCode]![index]['coverage']
                                      as Map<String, dynamic>)["whoItHelps"]!
                                  .toString(),
                            ),
                            const SizedBox(height: 10),
                            Text(multilanguage.providedBenifits,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            // const SizedBox(height: 10),
                            Text(
                              (schemes[languageCode]![index]['coverage']
                                      as Map<String, dynamic>)["whatItOffers"]!
                                  .toString(),
                            ),
                            const SizedBox(height: 10),
                            Text(multilanguage.howToAccess,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            for (int i = 0;
                                i <
                                    (schemes[languageCode]![index]
                                            ['howToAccess'] as List)
                                        .length;
                                i++)
                              Text(
                                  '${i + 1}. ${(schemes[languageCode]![index]['howToAccess'] as List)[i]}'
                                      .toString()),
                            const SizedBox(height: 10),
                            Wrap(
                              // child: Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton.icon(
                                    icon: const Icon(
                                      Icons.open_in_new,
                                      color: Colors.white,
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty.all(
                                          Colors.blue.shade800),
                                    ),
                                    onPressed: () {
                                      HapticFeedback.lightImpact();
                                      launchUrl(Uri.parse(
                                          (schemes[languageCode]![index]
                                                          ['contactInformation']
                                                      as Map<String, dynamic>)[
                                                  'website']!
                                              .toString()));
                                    },
                                    label: Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: Text(multilanguage.visitWebsite,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10)),
                                    )),
                                const SizedBox(width: 4),
                                if ((schemes[languageCode]![index]
                                                ['contactInformation']
                                            as Map<String, dynamic>)['helpline']
                                        .toString()
                                        .length <
                                    12)
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.phone),
                                    style: ButtonStyle(
                                      side: WidgetStateProperty.all(
                                        BorderSide(
                                          color: Colors.lightBlue.shade100,
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      HapticFeedback.lightImpact();
                                      launchUrl(Uri.parse(
                                          'tel:${(schemes[languageCode]![index]['contactInformation'] as Map<String, dynamic>)['helpline'].toString()}'));
                                    },
                                    label: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        (schemes[languageCode]![index]
                                                        ['contactInformation']
                                                    as Map<String, dynamic>)[
                                                'helpline']
                                            .toString(),
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            // )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
