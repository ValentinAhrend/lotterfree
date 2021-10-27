import 'dart:convert';

import 'package:flutter/services.dart';

class Type {
  int def;
  String lang;
  Type(this.def, this.lang);

  Future<String>_loadFromAsset() async {
  return await rootBundle.loadString("lang/lottery_$lang.json");
  } 

String name;
String chance;
String des;
String wer;
double chanced;
String prize;
int starttime;
String loggedtime;

void update(String p, String l, int s){
  this.prize=p;
  this.loggedtime=l;
  this.starttime=s;
}

Future<Type> loadInfo() async {
    String jsonString = await _loadFromAsset();
    Map valueMap = json.decode(jsonString);
    Map data = valueMap['l$def'];
    name = data['name'];
    chance = data['chance'];
    des = data['des'];
    wer = data['wer'];
    print("and now");
    return this;
    
}
}