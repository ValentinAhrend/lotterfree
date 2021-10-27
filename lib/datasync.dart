import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/physics.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'unx.dart';

class LotteryDataSync {

  
  final String valuename = "winner";


  List<String> values;

  

 

  Future<String> getWinnerFutureString(int lotteryStartTime) async{

    SharedPreferences sp = await SharedPreferences.getInstance();

    if(isSharedPreferencesDataRight(sp,lotteryStartTime)){
      var val = values;
      this.values=null;
      return val[1];
    }else{
      var snapshot = await FirebaseDatabase.instance.reference().child('BaseLottery').child(valuename).once();
      String val = snapshot.value;
      updateSharedPreferencesData(sp, val);
      return val;
    }
  }

  bool isSharedPreferencesDataRight(SharedPreferences sp, int lotteryStartTime){
    this.values = sp.getStringList(valuename);
    int parsedTime = values==null?0:int.parse(values[0]);
    return parsedTime<lotteryStartTime+172800000&&parsedTime!=0;
  }

  void updateSharedPreferencesData(SharedPreferences sp,String color){
    sp.setStringList(valuename, [DateTime.now().millisecondsSinceEpoch.toString(),color.toString()]);
  }
}

class CoinsDataSync {
  final String valuename1 = "coins";
  final String valuename2 = "spbool";
  final String valuename3 = "spop";

  List<String> values;
  int time;

  bool didYouEverWon(SharedPreferences sp){
    bool value = sp.getBool(valuename2);
    return value!=null && value;
  }

  bool spamOperator(SharedPreferences sp){
    if(time==null || time == 0){
       this.values = sp.getStringList(valuename1);
       this.time = int.parse(values[0]);
    }
    return time+10000<=DateTime.now().millisecondsSinceEpoch;
  }

  bool combinedsync(SharedPreferences sp, int lotteryStartTime){
    this.values = sp.getStringList(valuename1);
    this.time = values==null?0:int.parse(values[0]);
    return time < lotteryStartTime && time!=0;//no cloud needed
  }

  void updateIfYouEverWon(SharedPreferences sp, bool b){
    sp.setBool(valuename2, b);
  }

  void updateCoins(String coins) async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setStringList(valuename1, [DateTime.now().millisecondsSinceEpoch.toString(),coins]);
    if(coins=="0")updateIfYouEverWon(sp, false);
    else updateIfYouEverWon(sp, true);
  }


  Future<String> getCoinsFutureString(FirebaseUser user, int lotteryStartTime) async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    if(didYouEverWon(sp)){
      if(spamOperator(sp)){
        getCoinsFromCloud(user);
      }
    }else{
      if(combinedsync(sp, lotteryStartTime)){
        return values[1];
      }else{
         getCoinsFromCloud(user);
      }
    }
  }

  Future<String> getCoinsFromCloud(FirebaseUser user) async{
     var snapshot = await FirebaseDatabase.instance.reference().child('Users').child(user.getSaveEmail()).once();
        String val = UNX(snapshot.value).getCoins();
        updateCoins(val);
        return val;
  }
}

class LotteryStartTimeSync{

  final String valuename = "lst";

  Future<int> getLotteryStartTimeFutureString() async{
    SharedPreferences sp  = await SharedPreferences.getInstance();
    int lotterystarttime = sp.getInt(valuename);
    if(lotterystarttime==null)lotterystarttime=0;
    if(lotterystarttime+172810000>DateTime.now().millisecondsSinceEpoch){
      return lotterystarttime;
    }else{
      int value =  int.parse((await FirebaseDatabase.instance.reference().child('BaseLottery').child('starttime').once()).value.toString());
      sp.setInt(valuename, value);
      return value;
    }

  }
}

extension on FirebaseUser{
  String getSaveEmail(){
    List<String> bad_words = ['.','/','#',']','['];
    List<String> esg_words = ['%p','%s','%h','%o','%c'];

    String build_email = email;

    bad_words.forEach((element) {

      

      if(email.indexOf(element)>=0){
        
        build_email = build_email.replaceAll(element, esg_words[bad_words.indexOf(element)]);
      }
    });

    return build_email;
  }
}