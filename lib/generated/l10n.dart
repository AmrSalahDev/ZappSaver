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
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
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
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `ZappSaver`
  String get appName {
    return Intl.message('ZappSaver', name: 'appName', desc: '', args: []);
  }

  /// `Save it before it’s gone`
  String get shortAppName {
    return Intl.message(
      'Save it before it’s gone',
      name: 'shortAppName',
      desc: '',
      args: [],
    );
  }

  /// `With us, you won’t miss a thing`
  String get subtitle {
    return Intl.message(
      'With us, you won’t miss a thing',
      name: 'subtitle',
      desc: '',
      args: [],
    );
  }

  /// `Get Started`
  String get getStarted {
    return Intl.message('Get Started', name: 'getStarted', desc: '', args: []);
  }

  /// `Select Language`
  String get selectLanguage {
    return Intl.message(
      'Select Language',
      name: 'selectLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `All in one status saver app`
  String get allInOneStatusSaver {
    return Intl.message(
      'All in one status saver app',
      name: 'allInOneStatusSaver',
      desc: '',
      args: [],
    );
  }

  /// `Whatsapp`
  String get whatsapp {
    return Intl.message('Whatsapp', name: 'whatsapp', desc: '', args: []);
  }

  /// `WA Business`
  String get whatsappBusiness {
    return Intl.message(
      'WA Business',
      name: 'whatsappBusiness',
      desc: '',
      args: [],
    );
  }

  /// `WA Web`
  String get whatsappWeb {
    return Intl.message('WA Web', name: 'whatsappWeb', desc: '', args: []);
  }

  /// `Direct Chat`
  String get directChat {
    return Intl.message('Direct Chat', name: 'directChat', desc: '', args: []);
  }

  /// `Saved Files`
  String get savedFiles {
    return Intl.message('Saved Files', name: 'savedFiles', desc: '', args: []);
  }

  /// `Rate Us`
  String get rateUs {
    return Intl.message('Rate Us', name: 'rateUs', desc: '', args: []);
  }

  /// `Share App`
  String get shareApp {
    return Intl.message('Share App', name: 'shareApp', desc: '', args: []);
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Statuses`
  String get statuses {
    return Intl.message('Statuses', name: 'statuses', desc: '', args: []);
  }

  /// `Photos`
  String get photos {
    return Intl.message('Photos', name: 'photos', desc: '', args: []);
  }

  /// `Videos`
  String get videos {
    return Intl.message('Videos', name: 'videos', desc: '', args: []);
  }

  /// `Download`
  String get donwload {
    return Intl.message('Download', name: 'donwload', desc: '', args: []);
  }

  /// `Status saved successfully`
  String get statusSavedSuccessfully {
    return Intl.message(
      'Status saved successfully',
      name: 'statusSavedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Your status has been saved to`
  String get statusHasBeenSavedTo {
    return Intl.message(
      'Your status has been saved to',
      name: 'statusHasBeenSavedTo',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message('OK', name: 'ok', desc: '', args: []);
  }

  /// `Status already saved`
  String get statusAlreadySaved {
    return Intl.message(
      'Status already saved',
      name: 'statusAlreadySaved',
      desc: '',
      args: [],
    );
  }

  /// `Status deleted successfully`
  String get statusDeleted {
    return Intl.message(
      'Status deleted successfully',
      name: 'statusDeleted',
      desc: '',
      args: [],
    );
  }

  /// `View`
  String get view {
    return Intl.message('View', name: 'view', desc: '', args: []);
  }

  /// `Recover deleted messages`
  String get recoverDeletedMessages {
    return Intl.message(
      'Recover deleted messages',
      name: 'recoverDeletedMessages',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `About`
  String get about {
    return Intl.message('About', name: 'about', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Message`
  String get message {
    return Intl.message('Message', name: 'message', desc: '', args: []);
  }

  /// `Photo`
  String get photo {
    return Intl.message('Photo', name: 'photo', desc: '', args: []);
  }

  /// `Video`
  String get video {
    return Intl.message('Video', name: 'video', desc: '', args: []);
  }

  /// `GIF`
  String get gif {
    return Intl.message('GIF', name: 'gif', desc: '', args: []);
  }

  /// `Sticker`
  String get sticker {
    return Intl.message('Sticker', name: 'sticker', desc: '', args: []);
  }

  /// `Audio`
  String get audio {
    return Intl.message('Audio', name: 'audio', desc: '', args: []);
  }

  /// `Voice`
  String get recording {
    return Intl.message('Voice', name: 'recording', desc: '', args: []);
  }

  /// `Documents`
  String get documents {
    return Intl.message('Documents', name: 'documents', desc: '', args: []);
  }

  /// `Recovery Messages`
  String get recoveryMessages {
    return Intl.message(
      'Recovery Messages',
      name: 'recoveryMessages',
      desc: '',
      args: [],
    );
  }

  /// `Type country name or code`
  String get typeCountryNameOrCode {
    return Intl.message(
      'Type country name or code',
      name: 'typeCountryNameOrCode',
      desc: '',
      args: [],
    );
  }

  /// `Enter your number`
  String get enterYourNumber {
    return Intl.message(
      'Enter your number',
      name: 'enterYourNumber',
      desc: '',
      args: [],
    );
  }

  /// `Write your message...`
  String get writeYourMessage {
    return Intl.message(
      'Write your message...',
      name: 'writeYourMessage',
      desc: '',
      args: [],
    );
  }

  /// `Enter valid number`
  String get enterValidNumber {
    return Intl.message(
      'Enter valid number',
      name: 'enterValidNumber',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message('Send', name: 'send', desc: '', args: []);
  }

  /// `Terms of Service | Privacy Policy`
  String get termsAndPolicy {
    return Intl.message(
      'Terms of Service | Privacy Policy',
      name: 'termsAndPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Comming Soon`
  String get commingSoon {
    return Intl.message(
      'Comming Soon',
      name: 'commingSoon',
      desc: '',
      args: [],
    );
  }

  /// `No videos found`
  String get noVideosFound {
    return Intl.message(
      'No videos found',
      name: 'noVideosFound',
      desc: '',
      args: [],
    );
  }

  /// `No photos found`
  String get noPhotosFound {
    return Intl.message(
      'No photos found',
      name: 'noPhotosFound',
      desc: '',
      args: [],
    );
  }

  /// `Storage permission is required to load statuses`
  String get storagePermissionRequired {
    return Intl.message(
      'Storage permission is required to load statuses',
      name: 'storagePermissionRequired',
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
      Locale.fromSubtags(languageCode: 'ar'),
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
