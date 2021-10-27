

import 'dart:ui';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:lotterfree/datasync.dart';
import 'package:lotterfree/main.dart';
import 'package:lotterfree/unx.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AppLocalizations.dart';
import 'MColor.dart';
import 'ads.dart';
import 'type.dart';
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
class Lottery extends StatefulWidget {

  final Type type;

  

  Lottery(this.type);

  @override
  _LotteryState createState() => _LotteryState();
}

String trans(BuildContext context, String key){
  return AppLocalizations.of(context).translate(key);
}

class _LotteryState extends State<Lottery> with WidgetsBindingObserver, TickerProviderStateMixin{
  bool dark;

  bool editing = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    lotc = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    lottefr = Tween(begin: 0.0,end:1.0).animate(lotc);

    ck = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    kk = Tween(begin: 0.0, end:1.0).animate(ck);

     cc = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    kc = Tween(begin: 0.0, end:1.0).animate(ck);

    loadLastVote();
    loadLastWinner();

  }

  @override
  void dispose(){
    cc.dispose();
    ck.dispose();
    lotc.dispose();
    super.dispose();
  }



  Animation kk;
  AnimationController ck;

  Animation kc;
  AnimationController cc;

  int lastcolor = Colors.white.value;
  int lasttime = DateTime.now().millisecondsSinceEpoch-600000;

  void loadLastVote(){
    SharedPreferences.getInstance().then((value) {
        int lastcolor = value.getInt("last_color");
        int lasttime = value.getInt("last_time");

        lotc.forward();

        if(lastcolor!=null && lasttime!=null){

          setState(() {
            this.lastcolor=lastcolor;
            this.lasttime=lasttime;
          });

          ck.forward();
        }

    });
  }

  void loadLastWinner(){

    LotteryDataSync().getWinnerFutureString(int.parse(widget.type.prize.substring(0, widget.type.prize.length-3))).then((value){
       setState(() {
        lastwinner = HexColor.fromHex(value);
      });
      cc.forward();
    });

  }

  /*Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }*/

  @override
  void didChangePlatformBrightness() {
    // TODO: implement didChangePlatformBrightness
    setState(() {
      dark =  WidgetsBinding.instance.window.platformBrightness==Brightness.dark;
    });
  }

  @override
  Widget build(BuildContext context) {

    dark = WidgetsBinding.instance.window.platformBrightness==Brightness.dark;


    String a1 = widget.type.prize.substring(0, widget.type.prize.length-3);

    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    int a = int.parse(a1) ~/ 10;
    int time = 172800000;
    int start = widget.type.starttime - (a*time) + time;

    String date = DateFormat('dd.MM.yyyy').format(DateTime.fromMillisecondsSinceEpoch(start));

  if(editing){
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor:MColor.event3,
        title: Text(trans(context, "z10"), style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w500),),
      ),
      body: LotteryAd(widget, unx),
    );
  }else{
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: MColor.event3,
        title: Text(widget.type.name, style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w500),),
      ),
      body: Container(
        child: Center(
          child: SizedBox(
            width: double.infinity,
            height: h/1.49,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(height: h/44.8),
                //first the prize
                Container(
                  width: w/1.22,
                  height: h/7.47,
                  decoration: BoxDecoration(
                                                  color: dark?Colors.black:Colors.white,
                                                  border: Border.all(color: dark?MColor.event2:MColor.event1, width: 3.0),
                                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                                  boxShadow: [
                              BoxShadow(  
                                color: dark?MColor.event2.withOpacity(0.4):MColor.event1.withOpacity(0.4),
                                spreadRadius: 1,
                                blurRadius: 3,
                                
                                offset: Offset(0.5, 2), 
                                // changes position of shadow
                              ),
                            ]
                                                ),
                                                child: Column(
                                                  children: <Widget>[
                                                    Container(
                                                      width:double.infinity,
                                                      height: h/15.19,
                                                      child: Column(children: <Widget>[
                                                        Center(child: Text(widget.type.prize, style: TextStyle(color: dark?MColor.event2:MColor.event1, fontWeight: FontWeight.w400, fontSize: w/500*30 ))),
                                                        Center(child: Text(trans(context, "f1"), style: TextStyle(color: dark?MColor.event2:MColor.event1, fontWeight: FontWeight.w400, fontSize: w/500*18 )))
                                                      ])
                                                    ),
                                                    Container(
                                                      width: double.infinity,
                                                      height: h/19.91,
                                                      child: Row(
                                                        children: <Widget>[
                                                          Container(width: w/69,),
                                                          SizedBox(width: w/2.76,height: h/19.91,
                                                          child: Column(children: <Widget>[
                                                            Container(height: h/35.84,child: Center(child: Text("10LFC", style: TextStyle(color: dark?MColor.event2:MColor.event1, fontWeight: FontWeight.w400, fontSize: w/500*24 )))),
                                                            Container(height: h/47.16,child: Center(child: Text(trans(context, "z8"), style: TextStyle(color: dark?MColor.event2:MColor.event1, fontWeight: FontWeight.w400, fontSize: w/500*16 )))),

                                                            
                                                          ],),),
                                                          Container(width: w/17.25,),
                                                          Container(
                                                      height: h/19.91,
                                                      child: Row(
                                                        children: <Widget>[
                                                          SizedBox(width: w/2.76,height: h/19.91,
                                                          child: Column(children: <Widget>[
                                                            Container(height: h/35.84,child: Center(child: Text(date, style: TextStyle(color: dark?MColor.event2:MColor.event1, fontWeight: FontWeight.w400, fontSize: w/500*24 )))),
                                                            Container(height: h/47.16,child: Center(child: Text(trans(context, "z9"), style: TextStyle(color: dark?MColor.event2:MColor.event1, fontWeight: FontWeight.w400, fontSize: w/500*16 )))),

                                                            
                                                          ],),)
                                                        ]
                                                      ),

                                                    ),
                                                        ]
                                                      ),

                                                    ),
                                                    
                                                  
                                                  ]
                                                ),
                ),
                Container(height: h/44.8),
                 StatefulBuilder(builder:(contextx, v){return Container(
                  width: w/1.2,
                  height: h/22.4,
                  decoration: BoxDecoration(
                                                  color: dark?MColor.event2:MColor.event1,
                                                  border: Border.all(color: dark?MColor.event2:MColor.event1, width: 3.0),
                                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                                  boxShadow: [
                              BoxShadow(  
                                color: dark?MColor.event2.withOpacity(0.4):MColor.event1.withOpacity(0.4),
                                spreadRadius: 1,
                                blurRadius: 3,
                                
                                offset: Offset(0.5, 2), 
                                // changes position of shadow
                              ),
                            ]
                 ),
                 child: FadeTransition(opacity: lottefr, child:GestureDetector(child: Center(child: Text(trans(context, "z10", ), style: TextStyle(color: Colors.white, fontSize: 23),textAlign: TextAlign.center,)),
                 onTap: (){newAttempt(contextx);},
                 )));}), 
                Container(height: h/44.8),
                   FadeTransition(opacity: kk,child:Container(
                  width: w/1.2,
                  height: h/22.4,
                  decoration: BoxDecoration(
                                                  color: Color(lastcolor),
                                                  border: Border.all(color: dark?MColor.event2:MColor.event1, width: 3.0),
                                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                                  boxShadow: [
                              BoxShadow(  
                                color: dark?MColor.event2.withOpacity(0.4):MColor.event1.withOpacity(0.4),
                                spreadRadius: 1,
                                blurRadius: 3,
                                
                                offset: Offset(0.5, 2), 
                                // changes position of shadow
                              ),
                            ]
                 ),
                child: Center(child: Text( handleTime(lasttime), style: TextStyle(color: Colors.white, fontSize: 23),textAlign: TextAlign.center,)),
                 
                 )
                 
                   ) ,
                   Container(height: h/44.8),
                   FadeTransition(opacity: kc,child:Container(
                  width: w/1.2,
                  height: h/22.4,
                  decoration: BoxDecoration(
                                                  color: lastwinner,
                                                  border: Border.all(color: dark?MColor.event2:MColor.event1, width: 3.0),
                                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                                  boxShadow: [
                              BoxShadow(  
                                color: dark?MColor.event2.withOpacity(0.4):MColor.event1.withOpacity(0.4),
                                spreadRadius: 1,
                                blurRadius: 3,
                                
                                offset: Offset(0.5, 2), 
                                // changes position of shadow
                              ),
                            ]
                 ),
                child: Center(child: Text( lastwinner.toHex(leadingHashSign: true), style: TextStyle(color: Colors.white, fontSize: 23),textAlign: TextAlign.center,)),
                 
                 )
                 
                   )  
              ]
            ),
          ),
        )
      ),
    );
    
  }
  
  }

  Color lastwinner = Colors.transparent;

  String handleTime(int i){
    String s = trans(context, "p5");
    return  s.replaceRange(s.indexOf('time'), s.indexOf('time')+'time'.length, handleTime2(i));
  }

  String handleTime2(int i){
    DateTime time1 = DateTime.fromMillisecondsSinceEpoch(i);
    DateTime now = DateTime.now();
    int dif = time1.difference(now).inHours*-1;
    if(dif==0){
      int dif3 = time1.difference(now).inMinutes*-1;
      return "$dif3"+" min";
    }else{
      return "$dif"+" hrs";
    }
  }

  Animation lottefr;
  AnimationController lotc;

  UNX unx;

  void newAttempt(BuildContext context){

    int min10 = 600000;

    FirebaseAuth.instance.currentUser().then((value){

    if(value!=null){

    if(value.isEmailVerified){

      print("$lasttime +lasttime");

    if(lasttime+min10<=DateTime.now().millisecondsSinceEpoch){

    FirebaseDatabase.instance.reference().child('Users').child(value.getSaveEmail()).once().then((value){
      unx = UNX(value.value);
      if(int.parse(unx.getTime())+600000<=DateTime.now().millisecondsSinceEpoch){
        //nice

    setState(() {
      editing=true;
    });
      }else{
              Scaffold.of(context).showSnackBar(SnackBar(content: Text(trans(context, "p7")), backgroundColor: dark?MColor.event2:MColor.event1,));
      }
    });

    }else{
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(trans(context, "p7")), backgroundColor: dark?MColor.event2:MColor.event1,));
    }

    }else{
            Scaffold.of(context).showSnackBar(SnackBar(content: Text(trans(context, "t1")), backgroundColor: dark?MColor.event2:MColor.event1,));
    }

    }else{
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(trans(context, "t2")), backgroundColor: dark?MColor.event2:MColor.event1,));
    }
    });
  }

  @override
  void didChangeAccessibilityFeatures() {
    // TODO: implement didChangeAccessibilityFeatures
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
      // TODO: implement didChangeAppLifecycleState
    }
  
  
  
    @override
    void didChangeMetrics() {
      // TODO: implement didChangeMetrics
    }
  
    @override
    void didChangeTextScaleFactor() {
      // TODO: implement didChangeTextScaleFactor
    }
  
    @override
    void didHaveMemoryPressure() {
      // TODO: implement didHaveMemoryPressure
    }
  
    @override
    Future<bool> didPopRoute() {
      // TODO: implement didPopRoute
      throw UnimplementedError();
    }

  @override
  void didChangeLocales(List<Locale> locale) {
      // TODO: implement didChangeLocales
    }

  @override
  Future<bool> didPushRoute(String route) {
    // TODO: implement didPushRoute
  }
  
}
  class LotteryAd extends StatefulWidget {

    Lottery _state;

    UNX unx;

    LotteryAd(this._state, this.unx);

    @override
    _LotteryAdState createState() => _LotteryAdState();
  }
  
  class _LotteryAdState extends State<LotteryAd> with WidgetsBindingObserver{

    bool dark;

    @override
  void didChangePlatformBrightness() {
    // TODO: implement didChangePlatformBrightness
    super.didChangePlatformBrightness();

    dark = WidgetsBinding.instance.window.platformBrightness==Brightness.dark;

  }

  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     _isRewardedAdReady = false;
      dark = WidgetsBinding.instance.window.platformBrightness==Brightness.dark;

     currentColor = currentColor2();
    pickerColor = pickerColor2();
 
  // TODO: Set Rewarded Ad event listener
  RewardedVideoAd.instance.listener = _onRewardedAdEvent;

  // TODO: Load a Rewarded Ad
  

  }

bool _isRewardedAdReady;

  

  // TODO: Implement _loadRewardedAd()
  void _loadRewardedAd() {
      RewardedVideoAd.instance.listener = _onRewardedAdEvent;

    print("load ad");

    RewardedVideoAd.instance.load(
        targetingInfo: MobileAdTargetingInfo(testDevices: ["kGADSimulatorID"]),
      adUnitId: AdManager.rewardedAdUnitIdEntry,
    ).then((value){
      _isRewardedAdReady = true;
    
    });
  }
  void _onRewardedAdEvent(RewardedVideoAdEvent event,
      {String rewardType, int rewardAmount}) {
    switch (event) {
      case RewardedVideoAdEvent.loaded:
        setState(() {
          _isRewardedAdReady = true;
        });
              RewardedVideoAd.instance.show();

        break;
      case RewardedVideoAdEvent.closed:
        setState(() {
          _isRewardedAdReady = false;
        });
        break;
      case RewardedVideoAdEvent.failedToLoad:
        setState(() {
          _isRewardedAdReady = false;
        });
        print('Failed to load a rewarded ad');
        break;
      case RewardedVideoAdEvent.rewarded:
        setState(() {
          adfinished=true;
        });
        break;
      default:
      // do nothing
    }
  }
  bool _isRewardedAdReady2;
  void _onRewardedAdEvent2(RewardedVideoAdEvent event,
      {String rewardType, int rewardAmount,BuildContext context,}) {
    switch (event) {
      case RewardedVideoAdEvent.loaded:
        setState(() {
          _isRewardedAdReady2= true;
          
        });
              RewardedVideoAd.instance.show();

        break;
      case RewardedVideoAdEvent.closed:
        setState(() {
          _isRewardedAdReady2 = false;
        });
        break;
      case RewardedVideoAdEvent.failedToLoad:
        setState(() {
          _isRewardedAdReady2 = false;
        });
        print('Failed to load a rewarded ad');
        break;
      case RewardedVideoAdEvent.rewarded:
       finish(context);
        break;
      default:
      // do nothing
    }
  }

// create some values
Color pickerColor2 (){return dark?MColor.event2:MColor.event1;}
Color currentColor2 (){return dark?MColor.event2:MColor.event1;}

Color pickerColor,currentColor;

// ValueChanged<Color> callback
void changeColor(Color color) {
  setState(() => pickerColor = color);
  print("picker color:$pickerColor");
}

    bool adfinished = false;
    bool adstart2 = false;

    @override
  void dispose() {
    // TODO: implement dispose
     RewardedVideoAd.instance.listener = null;
    super.dispose();
  }

  shoColorPicker(){
showDialog(
  context: context,
  child: AlertDialog(
    title: Text(trans(context, "p1")),
    backgroundColor: dark?Colors.black:Colors.white,
    content: SingleChildScrollView(
      child: ColorPicker(
        pickerColor: pickerColor,
        onColorChanged: changeColor,
        showLabel: true,
        enableAlpha: false,
        
        pickerAreaHeightPercent: 0.8,
      ),
      // Use Material color picker:
      //
      // child: MaterialPicker(
      //   pickerColor: pickerColor,
      //   onColorChanged: changeColor,
      //   showLabel: true, // only on portrait mode
      // ),
      //
      // Use Block color picker:
      //
      // child: BlockPicker(
      //   pickerColor: currentColor,
      //   onColorChanged: changeColor,
      // ),
    ),
    actions: <Widget>[
      FlatButton(
        color: Colors.transparent,
        splashColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        child: Text(trans(context, "p3"), style: TextStyle(color:dark?MColor.event2:MColor.event1,)),
        onPressed: () {
          print(pickerColor);
          c(() => currentColor = pickerColor);
          this.currentColor = pickerColor;
          Navigator.of(context).pop();
        },
      ),
    ],
  ),
                );
  }

  void finish(BuildContext context){
   

      FirebaseAuth.instance.currentUser().then((user){

          if(user==null){
             Scaffold.of(m_c).showSnackBar(SnackBar(content: Text(trans(m_c, "p6")),backgroundColor: dark?MColor.event2:MColor.event1,));
            Navigator.pop(m_c);
            return;
          }

          if(!user.isEmailVerified){
            Scaffold.of(m_c).showSnackBar(SnackBar(content: Text(trans(m_c, "e2")),backgroundColor: dark?MColor.event2:MColor.event1,));
            Navigator.pop(m_c);
            return;
          }

          DatabaseReference reference = FirebaseDatabase.instance.reference().child('BaseLottery').child('requests').child(HexColor.roundColor(currentColor).toHex(leadingHashSign: false));
          reference.once().then((valuex){
            print("firebase last service update");
              if(valuex.value==null){
 reference.set(user.email).then((value){
SharedPreferences.getInstance().then((value){
          value.setInt("last_color", HexColor.roundColor(currentColor).value);
          value.setInt("last_time", DateTime.now().millisecondsSinceEpoch);

          Navigator.pop(m_c);

          FirebaseDatabase.instance.reference().child('Users').child(user.getSaveEmail()).set(widget.unx.getCoins()+"x"+DateTime.now().millisecondsSinceEpoch.toString());
});
 });
              }else{
 reference.set(valuex.value+","+user.email).then((value){
SharedPreferences.getInstance().then((value){
          value.setInt("last_color", HexColor.roundColor(currentColor).value);
          value.setInt("last_time", DateTime.now().millisecondsSinceEpoch);

 Navigator.pop(m_c);

           FirebaseDatabase.instance.reference().child('Users').child(user.getSaveEmail()).set(widget.unx.getCoins()+"x"+DateTime.now().millisecondsSinceEpoch.toString());

              });
 });
 }
          
         
    
           
      });

    });
  }

  void loadSecondAd(BuildContext context){
    RewardedVideoAd.instance.listener = _onRewardedAdEvent2;
    RewardedVideoAd.instance.load(
      targetingInfo: MobileAdTargetingInfo(testDevices: ["kGADSimulatorID"]),
      adUnitId: AdManager.rewardedAdUnitIdExit,
    ).then((value){
      _isRewardedAdReady2=true;
      
    });
  }

    BuildContext m_c;

    StateSetter c;

    @override
    Widget build(BuildContext context) {
      this.m_c=context;
      dark = WidgetsBinding.instance.window.platformBrightness==Brightness.dark;
      
      double h = MediaQuery.of(context).size.height;
      double w = MediaQuery.of(context).size.width;
      if(adfinished){
        return Container(
          width: w,
          height: h,
          child: Column(
            children: <Widget>[
              Container(height: h/23),
              Center(child: Text(widget._state.type.des, style: TextStyle(color: dark?MColor.event2:MColor.event1, fontSize: 23, fontWeight: FontWeight.w400),textAlign: TextAlign.center,),),
              Container(height: h/23),
              GestureDetector(
              onTap: ((){
                  shoColorPicker();
                }),
              child: Container(
            width: w/1.0666,
            height: h/19.1,
              decoration: BoxDecoration(
                color:  dark?MColor.event2:MColor.event1,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: 
                  Center(child: Text(trans(context,"p1"), style: TextStyle(fontSize: 21, color: Colors.white),textAlign: TextAlign.left,)),
                  
            )
            ),
            Container(height: h/23),

            StatefulBuilder(builder: (v,c){
              this.c=c;
              return GestureDetector(
              onTap: shoColorPicker,
              child:Container(
              width: w/1.06,
              height: h/19.1,
              decoration: BoxDecoration(color: currentColor,
              borderRadius: BorderRadius.all(Radius.circular(20),
              ),
              border: Border.all(color: dark?MColor.event2:MColor.event1, width: 2.0)
            )
            ));}),
Container(height: h/23),
            Center(child: Text(widget._state.type.wer, style: TextStyle(color: dark?MColor.event2:MColor.event1, fontSize: 23, fontWeight: FontWeight.w400),textAlign: TextAlign.center,),),
             Container(height: h/23),
             StatefulBuilder(builder: (context,c){return GestureDetector(
              onTap: ((){
                loadSecondAd(context);
              }),
              child: Container(
            width: w/1.0666,
            height: h/19.1,
              decoration: BoxDecoration(
                color:  dark?MColor.event2:MColor.event1,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Center(child: Text(trans(context,"p2"), style: TextStyle(fontSize: 21, color: Colors.white),textAlign: TextAlign.center,)),
                )
            );}),Container(height: h/23),
                          Center(child: Text(trans(context, "p4"), style: TextStyle(color: dark?MColor.event2:MColor.event1, fontSize:19, fontWeight: FontWeight.w400),textAlign: TextAlign.center,),),

            ]
          )
        );
      }else{
      return Container(
        width: w,
        height: h,
        child: Center(
          child: GestureDetector(
              onTap: ((){
                _loadRewardedAd();
              }),
              child: Container(
            width: w/1.0666,
            height: h/19.1,
              decoration: BoxDecoration(
                color:  dark?MColor.event2:MColor.event1,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child:
                  Center(child: Text(trans(context,"z11"), style: TextStyle(fontSize: 21, color: Colors.white),textAlign: TextAlign.center,)),
                  
                
              )
            ,
        ),)
      );
      }
    }
  }
  extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  static Color roundColor(Color color){
    int r = (color.red/3).round();
    int g = (color.green/3).round();
    int b = (color.blue).round();
    return Color.fromARGB(255, r, g, b);
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
   
  
