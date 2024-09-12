// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Hello`
  String get hello {
    return Intl.message(
      'Hello',
      name: 'hello',
      desc: 'Hello message',
      args: [],
    );
  }

  /// `Welcome to our app!!!!!`
  String get welcome {
    return Intl.message(
      'Welcome to our app!!!!!',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Disaster`
  String get disaster {
    return Intl.message(
      'Disaster',
      name: 'disaster',
      desc: '',
      args: [],
    );
  }

  /// `Rescue Ring`
  String get rescuering {
    return Intl.message(
      'Rescue Ring',
      name: 'rescuering',
      desc: '',
      args: [],
    );
  }

  /// `A network of support for those in need`
  String get rescuedescription {
    return Intl.message(
      'A network of support for those in need',
      name: 'rescuedescription',
      desc: '',
      args: [],
    );
  }

  /// `Edit Emergency Number`
  String get editEmergencyNumber {
    return Intl.message(
      'Edit Emergency Number',
      name: 'editEmergencyNumber',
      desc: '',
      args: [],
    );
  }

  /// `Government Schemes`
  String get govSchemes {
    return Intl.message(
      'Government Schemes',
      name: 'govSchemes',
      desc: '',
      args: [],
    );
  }

  /// `Helping`
  String get helping {
    return Intl.message(
      'Helping',
      name: 'helping',
      desc: '',
      args: [],
    );
  }

  /// `Need Help`
  String get needHelp {
    return Intl.message(
      'Need Help',
      name: 'needHelp',
      desc: '',
      args: [],
    );
  }

  /// `Medical`
  String get medical {
    return Intl.message(
      'Medical',
      name: 'medical',
      desc: '',
      args: [],
    );
  }

  /// `Food`
  String get food {
    return Intl.message(
      'Food',
      name: 'food',
      desc: '',
      args: [],
    );
  }

  /// `Shelter`
  String get shelter {
    return Intl.message(
      'Shelter',
      name: 'shelter',
      desc: '',
      args: [],
    );
  }

  /// `Clothing`
  String get clothing {
    return Intl.message(
      'Clothing',
      name: 'clothing',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get other {
    return Intl.message(
      'Other',
      name: 'other',
      desc: '',
      args: [],
    );
  }

  /// `Seeking Help`
  String get seekHelp {
    return Intl.message(
      'Seeking Help',
      name: 'seekHelp',
      desc: '',
      args: [],
    );
  }

  /// `Volunteer`
  String get volunteer {
    return Intl.message(
      'Volunteer',
      name: 'volunteer',
      desc: '',
      args: [],
    );
  }

  /// `Donate`
  String get donate {
    return Intl.message(
      'Donate',
      name: 'donate',
      desc: '',
      args: [],
    );
  }

  /// `Provide Shelter`
  String get provideShelter {
    return Intl.message(
      'Provide Shelter',
      name: 'provideShelter',
      desc: '',
      args: [],
    );
  }

  /// `Provide Food`
  String get provideFood {
    return Intl.message(
      'Provide Food',
      name: 'provideFood',
      desc: '',
      args: [],
    );
  }

  /// `Provide Medical`
  String get provideMedical {
    return Intl.message(
      'Provide Medical',
      name: 'provideMedical',
      desc: '',
      args: [],
    );
  }

  /// `We prioritize your well-being. Save your emergency number for enhanced support.`
  String get editNumberDescription {
    return Intl.message(
      'We prioritize your well-being. Save your emergency number for enhanced support.',
      name: 'editNumberDescription',
      desc: '',
      args: [],
    );
  }

  /// `Select Contact`
  String get selectContact {
    return Intl.message(
      'Select Contact',
      name: 'selectContact',
      desc: '',
      args: [],
    );
  }

  /// `Earthquake`
  String get earthquake {
    return Intl.message(
      'Earthquake',
      name: 'earthquake',
      desc: '',
      args: [],
    );
  }

  /// `Flood`
  String get flood {
    return Intl.message(
      'Flood',
      name: 'flood',
      desc: '',
      args: [],
    );
  }

  /// `Cyclone`
  String get cyclone {
    return Intl.message(
      'Cyclone',
      name: 'cyclone',
      desc: '',
      args: [],
    );
  }

  /// `Fire`
  String get fire {
    return Intl.message(
      'Fire',
      name: 'fire',
      desc: '',
      args: [],
    );
  }

  /// `Landslide`
  String get landslide {
    return Intl.message(
      'Landslide',
      name: 'landslide',
      desc: '',
      args: [],
    );
  }

  /// `Tsunami`
  String get tsunami {
    return Intl.message(
      'Tsunami',
      name: 'tsunami',
      desc: '',
      args: [],
    );
  }

  /// `Drought`
  String get drought {
    return Intl.message(
      'Drought',
      name: 'drought',
      desc: '',
      args: [],
    );
  }

  /// `Volcano`
  String get volcano {
    return Intl.message(
      'Volcano',
      name: 'volcano',
      desc: '',
      args: [],
    );
  }

  /// `Tornado`
  String get tornado {
    return Intl.message(
      'Tornado',
      name: 'tornado',
      desc: '',
      args: [],
    );
  }

  /// `Hurricane`
  String get hurricane {
    return Intl.message(
      'Hurricane',
      name: 'hurricane',
      desc: '',
      args: [],
    );
  }

  /// `Wildfire`
  String get wildfire {
    return Intl.message(
      'Wildfire',
      name: 'wildfire',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message(
      'Done',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `Consequences`
  String get consequences {
    return Intl.message(
      'Consequences',
      name: 'consequences',
      desc: '',
      args: [],
    );
  }

  /// `Preparedness`
  String get Preparedness {
    return Intl.message(
      'Preparedness',
      name: 'Preparedness',
      desc: '',
      args: [],
    );
  }

  /// `Emergency Contact`
  String get emergencyContact {
    return Intl.message(
      'Emergency Contact',
      name: 'emergencyContact',
      desc: '',
      args: [],
    );
  }

  /// `Target Beneficiaries`
  String get targetBeneficiaries {
    return Intl.message(
      'Target Beneficiaries',
      name: 'targetBeneficiaries',
      desc: '',
      args: [],
    );
  }

  /// `Provided Benefits`
  String get providedBenifits {
    return Intl.message(
      'Provided Benefits',
      name: 'providedBenifits',
      desc: '',
      args: [],
    );
  }

  /// `How to Access`
  String get howToAccess {
    return Intl.message(
      'How to Access',
      name: 'howToAccess',
      desc: '',
      args: [],
    );
  }

  /// `Visit Website`
  String get visitWebsite {
    return Intl.message(
      'Visit Website',
      name: 'visitWebsite',
      desc: '',
      args: [],
    );
  }

  /// `Call`
  String get call {
    return Intl.message(
      'Call',
      name: 'call',
      desc: '',
      args: [],
    );
  }

  /// `Eruption`
  String get volcanicEruption {
    return Intl.message(
      'Eruption',
      name: 'volcanicEruption',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'kn'),
      Locale.fromSubtags(languageCode: 'messages'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
