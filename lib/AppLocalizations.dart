import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations{
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of (BuildContext _c){
    return Localizations.of<AppLocalizations>(_c,   AppLocalizations);
  
  
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocationsDelegate();

  Map<String, String> _lS;
  Future<bool> load() async {
    print("lang:"+locale.languageCode);
    String jsonBundle = 
      await rootBundle.loadString('lang/${locale.languageCode}.json');
      Map<String, dynamic> jsonMap = json.decode(jsonBundle);
      _lS = jsonMap.map((key, value){
      return MapEntry(key, value.toString());});

      return true;
    
  }

  String translate(String key){
    return _lS[key];
  }
}
  class _AppLocationsDelegate extends LocalizationsDelegate<AppLocalizations> {
      const _AppLocationsDelegate();

      @override
  bool isSupported(Locale locale) {
    print(locale.languageCode);

    print(['en','de'].contains(locale.languageCode));
    return ['en','de'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
        AppLocalizations localizations = new AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;


  }