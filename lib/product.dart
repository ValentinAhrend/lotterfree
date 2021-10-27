
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

class Loader{
  String lang;
  Loader(this.lang);


  Future<List<Product>> load() async {
    String data = await _loadFromAsset();
     Map valueMap = json.decode(data);
     Map d1 = valueMap['1'];
     Map d2 = valueMap['2'];
     Product product1 = new Product(d1);
     Product product2 = new Product(d2);

     print("resolving products");

     if(Platform.isIOS){
       product2.num=1;
       product1.num=0;
       return [product1,product2];
     }
     if(Platform.isAndroid){
        product2.num=0;
       product1.num=1;
       return [product2, product1];
     }

     return [];

  }

  Future<String>_loadFromAsset() async {
  return await rootBundle.loadString("lang/products_$lang.json");
  } 

}

class Product{

  Product(Map map){
    this.name = map['name'];
    this.worth = map['worth'];
    this.currency = map['currency'];
    this.des = map['des'];
    this.warn = map['warn'];
    this.info = map['info'];
    this.prize = int.parse(map['price']);
  }

  int num;

  String name;
  String worth;
  String currency;
  String des;
  String warn;
  String info;
  int prize;

}