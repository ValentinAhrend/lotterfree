
import 'dart:async';
import 'dart:ui';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lotterfree/ads.dart';
import 'package:lotterfree/datasync.dart';
import 'package:lotterfree/help.dart';
import 'package:lotterfree/product.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:url_launcher/url_launcher.dart';

import 'AppLocalizations.dart';
import 'MColor.dart';
import 'lottery.dart';
import 'style.dart';
import 'type.dart';
import 'unx.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseAdMob.instance.initialize(appId: AdManager.appId);
  var style= SystemUiOverlayStyle.light.copyWith(systemNavigationBarColor: Colors.transparent);
  SystemChrome.setSystemUIOverlayStyle(style);
  SystemChrome.setEnabledSystemUIOverlays([]);
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp]
     ).then((value) {
runApp(MaterialApp(
   supportedLocales: [
      const Locale('en','US'),
      const Locale('de','DE'),
    ], 
  theme: ThemeData(
     brightness: Brightness.light,
      
      textTheme: TextTheme(
        title: TitleTextStyle,
        body1: Body1TextStyle,
        body2: Body2TextStyle,
      ),
    ),
     debugShowCheckedModeBanner: false
,
    darkTheme: 
    ThemeData(
    brightness: Brightness.dark,
      textTheme: TextTheme(
        title: TitleTextStyle1,
        body1: Body1TextStyle1,
        body2: Body2TextStyle1,
      ),
    ), 
    localizationsDelegates: [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate
    ],

    localeResolutionCallback: (locale, supportedLocales){
      
      
      for (var supportedLocale in supportedLocales) {
      if (locale!=null && locale.languageCode!=null && locale.countryCode!=null && supportedLocale.languageCode == locale.languageCode &&
          supportedLocale.countryCode == locale.countryCode){
        return supportedLocale;
      }
    }
    // If the locale of the device is not supported, or locale returns null
    // use the last one from the list (Hindi, in your case).
    return supportedLocales.last;
    }, 
    home: MyHomePage(),
));
     });
  
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
      ),
    );
  }
}

class MyHomePage extends StatefulWidget{

  _MyHomePageState state;

  @override
  _MyHomePageState createState(){this.state = _MyHomePageState();return state;}
}

class _MyHomePageState extends State<MyHomePage>  with WidgetsBindingObserver,TickerProviderStateMixin  {
 
  Animation<Offset> _x;
  AnimationController _y;

  Animation shop_fade;
  AnimationController shop_fade_controller;

  Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addObserver(this);

    _timer = new Timer.periodic(Duration(seconds: 10), 
      (Timer timer) => timer.cancel());
   
    super.initState();


    _y = AnimationController(vsync: this, duration: Duration(seconds: 1));
   
    _x = Tween<Offset>(
      begin: Offset(1000.0,1000.0),
      end: Offset(1000.0,1000.0),
    ).animate(CurvedAnimation(parent: _y, curve: Curves.easeInExpo));

    shop_fade_controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
    shop_fade = Tween(begin: 0.0, end: 1.0).animate(shop_fade_controller);

    lottery_fade_controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
    lottery_fade = Tween(begin: 0.0, end: 1.0).animate(lottery_fade_controller);
    
    bool dark2 = WidgetsBinding.instance.window.platformBrightness==Brightness.dark;
    /*color_tap = ColorTween(begin: dark2?MColor.event4:MColor.event3, end: dark2?MColor.event6:MColor.event5).animate(color_tapc);

    color_tapc2 = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    color_tap2 = ColorTween(begin: dark2?MColor.event2:MColor.event1, end: dark2?MColor.blue1:MColor.blue1).animate(color_tapc2);

 color_tapc3 = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    color_tap3 = ColorTween(begin: dark2?MColor.event2A:MColor.event1A, end: dark2?MColor.green1:MColor.green1).animate(color_tapc3);
*/
    colorc1 = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    colortap1 = ColorTween(begin: dark2?Colors.black:Colors.white, end: dark2?MColor.event2:MColor.event1).animate(colorc1);
    colortap2 = ColorTween(end: dark2?Colors.black:Colors.white, begin: dark2?MColor.event2:MColor.event1).animate(colorc1);

    colorc2 = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    colortap3 = ColorTween(begin: dark2?Colors.black:Colors.white, end: dark2?MColor.event2:MColor.event1).animate(colorc2);
    colortap4 = ColorTween(end: dark2?Colors.black:Colors.white, begin: dark2?MColor.event2:MColor.event1).animate(colorc2);


    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);

    Future.delayed(Duration(seconds: 1)).then((value){
      setState(() {
         start = true;
         loadLottery();
         _controller.forward();
         _y.forward();
      });
     
    });

    

    getSharedData();
  }


int _currentPage = 1;
  Future<void> getSharedData() async {
  SharedPreferences.getInstance().then((value){
setState(() {
      isAlreadyThere = value.getBool("startScreen");
    if(isAlreadyThere==null)isAlreadyThere=false;
    });
  });

    
  }

  bool isAlreadyThere = false;

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    _y.dispose();
    shop_fade_controller.dispose();
    _controller.dispose();
    lottery_fade_controller.dispose();
    colorc1.dispose();
    colorc2.dispose();
    
    super.dispose();
    
  }

  @override
  void didChangePlatformBrightness() {
    // TODO: implement didChangePlatformBrightness
    super.didChangePlatformBrightness();
    setState(() {
      dark = WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
    });
  }

  bool dark;
 
  bool start = false;

  final _pages = [
   //Start now!
  ];

  void skipPages(){
    isAlreadyThere=true;
    SharedPreferences.getInstance().then((value){
      value.setBool("startScreen", isAlreadyThere);
      
    });
    setState(() {
      isAlreadyThere=true;
      loadLottery();
    });
  }

  Animation _animation;
  AnimationController _controller;

  final textes1 = ["a0","a7","a8","a9"];
  final textes2 = ["a1","a2","a4","a6"];

  void updatePage(BuildContext context,int index){
   
    
    String _s1 = trans(context,textes1[index]);
    String _s2 = trans(context,textes2[index]);  



    setState(() {
      this._s1_control=_s1;
      this._s2_control=_s2;
      this._s1 = _s1;
      this._s2 = _s2;
       if(index==3){_x = Tween<Offset>(
      begin: const Offset(0.0, 1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _y, curve: Curves.easeInExpo));
    _y.forward();}else{
       _x = Tween<Offset>(
      begin:  Offset(1000.0,1000.0),
      end: Offset(1000.0,1000.0),
    ).animate(CurvedAnimation(parent: _y, curve: Curves.linear));
    _y.forward();
    print("sls");
    }
      
      _controller.reset();
      _controller.forward();
      
    });
  }



  
  String _s1,_s2,_s3;
  String _s1_control,_s2_control,_s3_control;

  int images_pos=0;

  List<Image> shop_images = [];

  Image current;

  Animation colortap1,colortap2;
  AnimationController colorc1;

  Animation colortap3,colortap4;
  AnimationController colorc2;

  Animation lottery_fade;
  AnimationController lottery_fade_controller;

  

  List<_LotteryFeatureState> states = [];

  String starttime2;
  String prize2;
  String chance;
  String des;
  String wer;
  String name = "";
  int starttime;

  Type t;

  void loadLottery(){
    
    Future.delayed(Duration(milliseconds: 200)).then((value){
    FirebaseDatabase database = FirebaseDatabase.instance;
    DatabaseReference main =  database.reference().child('BaseLottery');

    print("firebase action");

    DatabaseReference ref1 = main.child('starttime');
    DatabaseReference ref0 = main.child('prize');
    DatabaseReference ref2 = main.child('type');
    ref0.once().then((value1){
      this.prize2 = handlePrize(int.parse(value1.value));
      print(prize2);
    });
    ref1.once().then((value2){
      this.starttime=int.parse(value2.value);
      this.starttime2 = handleTime(int.parse(value2.value));
      print(starttime2);
    });
    ref2.once().then((value3) async{
      t = Type(value3.value as int,Localizations.localeOf(context).languageCode.toString());
      t = await t.loadInfo();
        this.chance=t.chance;
        this.des=t.des;
        this.wer=t.wer;
        this.name=t.name;
        t.update(prize2, starttime2,starttime );

        print("last action");

        List data = [prize2, chance, trans(context, "z7"), starttime2];

        try{

        print(states.last);
        setState(() {
          lottery_fade_controller.forward();
          this.name=t.name;
        });
        states.forEach((element) {
          element.updateData(data);
        });

        }catch(ignored){
          //this error happnes by first install
        }

      });
    });

    
    
  }

  String handleTime(int i){
    DateTime time1 = DateTime.fromMillisecondsSinceEpoch(i+172800000);
    DateTime now = DateTime.now();
    int dif = time1.difference(now).inHours;
    if(dif==0){
      int dif3 = time1.difference(now).inMinutes;
      return "$dif3"+"min";
    }else{
      return "$dif"+"hrs";
    }
  }

  String handlePrize(int prize){
    return "$prize"+"LFC";
  }

  PageController p  = PageController(initialPage: 1);

  GlobalKey key = GlobalKey();

  void more(){
    Navigator.push(context, MoreRoute());  
  }

  void reloadLotteryTime(){
    LotteryStartTimeSync().getLotteryStartTimeFutureString().then((value){
       states[3].changeText(handleTime(value));
    });
  }


  @override 
  Widget build(BuildContext context) {


    dark = WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
    AssetImage asset = dark?AssetImage("images/logo_black.png"):AssetImage("images/logo_white.png");
    Image _image = Image(image: asset);
    AssetImage asset2 = AssetImage("images/s1.jpg");
    Image _image2 = Image(image: asset2);
    if(start){  
      

          AssetImage a1 = AssetImage('images/itunes_card.png');
          AssetImage a2 = AssetImage('images/google_card.png');



          shop_images.add(Image(image: a1,));
          shop_images.add(Image(image: a2,));

          LotteryFeature feature1 =  LotteryFeature(1,this);
          LotteryFeature feature2 = new LotteryFeature(2,this);
          LotteryFeature feature3 = new LotteryFeature(3,this);
          LotteryFeature feature4 = new LotteryFeature(4,this);
        
          double w = MediaQuery.of(context).size.width;//320
          double h = MediaQuery.of(context).size.height;//643

          colortap1 = ColorTween(begin: dark?Colors.black:Colors.white, end: dark?MColor.event2:MColor.event1).animate(colorc1);
          colortap2 = ColorTween(end: dark?Colors.black:Colors.white, begin: dark?MColor.event2:MColor.event1).animate(colorc1);

          colortap3 = ColorTween(begin: dark?Colors.black:Colors.white, end: dark?MColor.event2:MColor.event1).animate(colorc2);
          colortap4 = ColorTween(end: dark?Colors.black:Colors.white, begin: dark?MColor.event2:MColor.event1).animate(colorc2);


          return Scaffold(

                key: key,

                appBar: AppBar(
                  
                  backgroundColor: MColor.event3,
                
                centerTitle: true,
              
                title: Text(trans(context,"title"), style: TextStyle(fontWeight: FontWeight.w400, fontSize: 29),),

                actions: <Widget>[
                  Center(
                    child: FlatButton(
                      child: Icon(Icons.more_horiz, color: Colors.white),
                      color: Colors.transparent,
                      hoverColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      
                      padding: EdgeInsets.only(left: 2.0),
                      onPressed: more,
                    )
                  )
                ],
                
                ),

                body: Container(
                  color: dark?Colors.black:Colors.white,
                width: w,
                height: h,
                  child: Column(
                    children: <Widget> [
                      Container(
                        height: h/32.15
                      ),
                     AnimatedBuilder(
                       animation: colortap1,
                       builder: (context, child){
                         return AnimatedBuilder(animation: colortap2, builder: 
                         (context,child) {     
                         return GestureDetector(
                        onTap: (){animOnTap1();},
                                              
                                                onLongPressEnd: (va){animOnFinishLongTap1();},
                                                onLongPressStart: (va){animOnLongTap1();},
                                                child:Container(
                                                width: w/1.2,
                                                height: h/3.38,
                        
                                                child: Container(
                                                  height: h/3.38,
                                                  width: w/1.2,
                                                  child: Column(
                                                  
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: h/9.89,
                                                    child: FadeTransition(
                                                      opacity: lottery_fade,
                                                      child: Center(child:Text(
                                                      name,
                                                      style: TextStyle(color: colortap2.value, fontWeight: FontWeight.w400, fontSize: 30),
                                                      textAlign: TextAlign.center,
                                                      )))),
                                                    
                                                    
                                                    SizedBox(
                                                      width: w/1.27,
                                                      
                                                     child:Row(
                                                      children: <Widget>[
                                                        Center(child:Column(
                                                              children: <Widget>[
                                                                Center(child:feature1),
                                                               
                                                                Center(child:feature3),
                                                              ]
                                                        )),
                                                        Center(child:Column(
                                                          children: <Widget>[
                                                            Center(child:feature2),
                                                            
                                                                Center(child:feature4),
                                                          ]
                                                        ))
                                                      ]
                                                    )
                                                    )  
                                                  ]
                                                    )
                                                ),
                                                decoration: BoxDecoration(
                                                  color: colortap1.value,
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
                                                ));});}),
                                              Container(
                                                height: h/25.72, 
                                              ),
                                              AnimatedBuilder(
                                                animation: colortap3,
                                                builder: (context,child) {
                                                  return AnimatedBuilder(
                                                animation: colortap4,
                                                builder: (context,child) {return GestureDetector(
                                                  onTap: (){animOnTap2();},
                                                  onLongPressEnd: (x){animOnFinishLongTap2();},
                                                  onLongPressStart: (x){animOnLongTap2();},
                                                child:Container(
                                                width: w/1.2,
                                                height: h/3.38,
                                                decoration: BoxDecoration(
                                                  color: colortap3.value,
                                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                                  border: Border.all(color: dark?MColor.event2:MColor.event1, width: 3.0),
                                                  boxShadow: [
                              BoxShadow(
                                color:  dark?MColor.event2.withOpacity(0.4):MColor.event1.withOpacity(0.4),
                                spreadRadius: 1,
                                blurRadius: 3,
                                
                                offset: Offset(0.5, 2), 
                                // changes position of shadow
                              ),]
                                              ),
                                              child: Column(
                                                children: <Widget>[
                                                    SizedBox(
                                                      height: h/9.89,
                                                    child: Center(child:Text(
                                                      trans(context, "s3"),
                                                      style: TextStyle(color: colortap4.value, fontWeight: FontWeight.w400, fontSize: 30),
                                                      textAlign: TextAlign.center,
                                                      
                                                    ))),
                                                  /*FadeTransition(
                                                    opacity: shop_fade,*/
                                                    SizedBox(
                                                    width: w/2.91,
                                                    height: h/5.85,
                                                    child: ImageRotater(shop_images),
                                                    ) 
                                                  
                                                ]
                                              ),
                                              ));});}),
                                              Container(
                                                height: h/25.72, 
                                              ),
                                              Container(
                        decoration: BoxDecoration(
                                                  color:dark?MColor.event2:MColor.event1,
                                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                                   border: Border.all(color: dark?MColor.event2:MColor.event1, width: 3.0),
                                                  boxShadow: [
                              BoxShadow(
                                color:dark?MColor.event2.withOpacity(0.4):MColor.event1.withOpacity(0.4),
                                spreadRadius: 1,
                                blurRadius: 3,
                                
                                offset: Offset(0.5, 2), 
                                // changes position of shadow
                              ),]
                                              ),
                                              width: w/1.066,
                                              height: h/12.86,
                                              child: AuthDisplayer(this),
                                              ),
                                              Container(height: 25,),
                                           
                                              
                                              
                                            ]
                                          ),
                                        ),
                        
                        
                                  );
                        
                            
                              
                            }else{
                              return SizedBox(width: double.infinity,height: double.infinity,
                              child:Container(
                                color: dark?Colors.black:Colors.white,
                              child: Center(
                                child: Container(
                                
                                  width: 100,height: 100,child: _image)
                              )));
                            }
                          }

                          void addState(_LotteryFeatureState _state){
                            states.add(_state);
                          }
                        
                          void animOnTap1(){
                            states.forEach((element) {
                              element.animOnTap1();
                            });
                            setState(() {
                              colorc1 = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
                              colortap1 = ColorTween(begin: dark?Colors.black:Colors.white,end: dark?MColor.event2:MColor.event1).animate(colorc1);
                              colortap2 = ColorTween(end: dark?Colors.black:Colors.white, begin: dark?MColor.event2:MColor.event1).animate(colorc1);

                            });
                          
                            colorc1.forward().whenComplete((){
                              colorc1.reverse();
                              Navigator.push(
  context,
  LotteryRoute(t)
);
                            });
                          }
                          void animOnLongTap1(){
                            states.forEach((element) {
                              element.animOnLongTap1();
                            });
setState(() {
                              colorc1 = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
                              colortap1 = ColorTween(begin: dark?Colors.black:Colors.white,end: dark?MColor.event2:MColor.event1).animate(colorc1);
                              colortap2 = ColorTween(end: dark?Colors.black:Colors.white, begin: dark?MColor.event2:MColor.event1).animate(colorc1);

                            });
                             
                           
                            colorc1.forward();
                          }
                          void animOnFinishLongTap1(){
                            states.forEach((element) {
                              element.animOnFinishLongTap1();
                            });
setState(() {
                              colorc1 = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
                              colortap1 = ColorTween(end: dark?Colors.black:Colors.white,begin: dark?MColor.event2:MColor.event1).animate(colorc1);
                              colortap2 = ColorTween(begin: dark?Colors.black:Colors.white, end: dark?MColor.event2:MColor.event1).animate(colorc1);

                            });
                             
                            colorc1.forward();
                          }

                          void animOnTap2(){
                            
                            setState(() {
                              colorc2 = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
                              colortap3 = ColorTween(begin: dark?Colors.black:Colors.white,end: dark?MColor.event2:MColor.event1).animate(colorc2);
                              colortap4 = ColorTween(end: dark?Colors.black:Colors.white, begin: dark?MColor.event2:MColor.event1).animate(colorc2);

                            });
                          
                            colorc2.forward().whenComplete((){
                              colorc2.reverse();

                              Navigator.push(context, NRoute(starttime));

                            });
                          }
                          void animOnLongTap2(){
                            
setState(() {
                              colorc2 = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
                              colortap3 = ColorTween(begin: dark?Colors.black:Colors.white,end: dark?MColor.event2:MColor.event1).animate(colorc2);
                              colortap4 = ColorTween(end: dark?Colors.black:Colors.white, begin: dark?MColor.event2:MColor.event1).animate(colorc2);

                            });
                             
                           
                            colorc2.forward();
                          }
                          void animOnFinishLongTap2(){
setState(() {
                              colorc2 = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
                              colortap3 = ColorTween(end: dark?Colors.black:Colors.white,begin: dark?MColor.event2:MColor.event1).animate(colorc2);
                              colortap4 = ColorTween(begin: dark?Colors.black:Colors.white, end: dark?MColor.event2:MColor.event1).animate(colorc2);

                            });
                             
                            colorc2.forward();
                          }

                          /*void simpleAnimStart() {
                            setState(() {
                              color_tapc = new AnimationController(vsync: this, duration: Duration(milliseconds: 500));
                              color_tap = new ColorTween(begin: dark?MColor.event4:MColor.event3, end:dark?MColor.list2[color_pos]:MColor.list1[color_pos]).animate(color_tapc);
                        
                            });
                            color_tapc.forward().whenComplete((){
                                print("reverse");
                              color_tapc.reverse();
                            });
                          }
                        
                          
                        
                          int color_pos=0, color_pos_x=-1, color_pos2=0, color_pos_x2 = -1;  
                        
                          bool beginning = false,stop=false;
                          bool beginning2 = false,stop2=false;
                        
                          void animStart(){
                        
                            if(stop)return;
                        
                            if(color_pos==MColor.list1.length)color_pos=0;
                            if(color_pos_x==MColor.list1.length)color_pos_x=0;
                        
                            setState(() {
                            
                              color_tapc = new AnimationController(vsync: this, duration: Duration(milliseconds: 2000));
                              color_tap = new ColorTween(begin: !beginning?dark?MColor.event4:MColor.event3:dark?MColor.list2[color_pos_x]:MColor.list1[color_pos_x], end:dark?MColor.list2[color_pos]:MColor.list1[color_pos]).animate(color_tapc);
                              
                            });
                            color_pos++;
                            color_pos_x++;
                            beginning=true;
                            
                            color_tapc.forward().whenComplete((){
                                animStart();
                            });
                          }
                          void animEnd(){
                        setState(() {
                              color_tapc = new AnimationController(vsync: this, duration: Duration(milliseconds: 750));
                              color_tap = new ColorTween(end: dark?MColor.event4:MColor.event3, begin:dark?MColor.list2[color_pos]:MColor.list1[color_pos]).animate(color_tapc);
                              
                            });
                            beginning=false;
                            stop=true;
                            color_tapc.forward();
                          }
                        
                          void onSingleAnim() {
                            setState(() {
                              color_tapc2 = new AnimationController(vsync: this, duration: Duration(milliseconds: 500));
                              color_tap2 = new ColorTween(begin: dark?MColor.event2:MColor.event1, end:dark?MColor.list3[color_pos2]:MColor.list3[color_pos2]).animate(color_tapc2);
                        
                            });
                            color_tapc2.forward().whenComplete((){
                                print("reverse");
                              color_tapc2.reverse();
                            });
                          }
                          void onSingleAnim2() {
                            setState(() {
                              color_tapc3 = new AnimationController(vsync: this, duration: Duration(milliseconds: 500));
                              color_tap3 = new ColorTween(begin: dark?MColor.event2A:MColor.event1A, end:dark?MColor.list4[color_pos3]:MColor.list4[color_pos3]).animate(color_tapc3);
                        
                            });
                            color_tapc3.forward().whenComplete((){
                                print("reverse");
                              color_tapc3.reverse();
                            });
                          }
                          void animEnd2(){
                            setState(() {
                              color_tapc2 = new AnimationController(vsync: this, duration: Duration(milliseconds: 750));
                              color_tap2 = new ColorTween(end: dark?MColor.event2:MColor.event1, begin:dark?MColor.list3[color_pos2]:MColor.list3[color_pos2]).animate(color_tapc2);
                              
                            });
                            beginning2=false;
                            stop2=true;
                            color_tapc2.stop();                            
                            color_tapc2.forward();
                          }
                           void animEnd3(){
                            setState(() {
                              color_tapc3 = new AnimationController(vsync: this, duration: Duration(milliseconds: 750));
                              color_tap3 = new ColorTween(end: dark?MColor.event2A:MColor.event1A, begin:dark?MColor.list4[color_pos3]:MColor.list4[color_pos3]).animate(color_tapc3);
                              
                            });
                            beginning3=false;
                            stop3=true;
                            color_tapc3.stop();                            
                            color_tapc3.forward();
                          }
                          void arrivingAnimStart2(){
                            stop2=false;
                            animStart2();
                          }
                          void animStart2(){
                            if(stop2)return;
                            if(color_pos2==MColor.list3.length)color_pos2=0;
                            if(color_pos_x2==MColor.list3.length)color_pos_x2=0;
                        
                            setState(() {
                            
                              color_tapc2 = new AnimationController(vsync: this, duration: Duration(milliseconds: 2000));
                              color_tap2 = new ColorTween(begin: !beginning2?dark?MColor.event2:MColor.event1:dark?MColor.list3[color_pos_x2]:MColor.list3[color_pos_x2], end:dark?MColor.list3[color_pos2]:MColor.list3[color_pos2]).animate(color_tapc2);
                              
                            });
                            color_pos2++;
                            color_pos_x2++;
                            beginning2=true;


                            
                            color_tapc2.forward().whenComplete((){
                                animStart2();
                            });
                          }
                          bool stop3 = false, beginning3 = false;
                          int color_pos3=0,color_pos_x3=-1;
                          void arrivingAnimStart3(){
                            stop3=false;
                            animStart3();
                          }
                          void animStart3(){
                            if(stop3)return;
                            if(color_pos3==MColor.list4.length)color_pos3=0;
                            if(color_pos_x3==MColor.list4.length)color_pos_x3=0;
                        
                            setState(() {
                            
                              color_tapc3 = new AnimationController(vsync: this, duration: Duration(milliseconds: 2000));
                              color_tap3 = new ColorTween(begin: !beginning3?dark?MColor.event2A:MColor.event1A:dark?MColor.list4[color_pos_x3]:MColor.list4[color_pos_x3], end:dark?MColor.list4[color_pos3]:MColor.list4[color_pos3]).animate(color_tapc3);
                              
                            });
                            color_pos3++;
                            color_pos_x3++;
                            beginning3=true;


                            
                            color_tapc3.forward().whenComplete((){
                                animStart3();
                            });
                          }*/


                          
    
  
  
  }
  
    String trans(BuildContext _c, String _key){
  
    return AppLocalizations.of(_c).translate(_key);
  }
  
  class LotteryFeature extends StatefulWidget {
  
    int val;
    _MyHomePageState _state2;
    LotteryFeature(this.val, this._state2);

  _LotteryFeatureState _state;
  
    @override
    _LotteryFeatureState createState(){ _state = _LotteryFeatureState(val);return _state;}
  
  
  }
  
  class _LotteryFeatureState extends State<LotteryFeature> with WidgetsBindingObserver, TickerProviderStateMixin{
  
    int val;
    _LotteryFeatureState(int val){
      this.val=val;
    }

    void changeText(String value){
      setState(() {
        super_data = value;
      });
    }

    @override
  void didChangePlatformBrightness() {
    setState(() {
      dark = WidgetsBinding.instance.window.platformBrightness==Brightness.dark;
    });
  }

  void updateData(List string){
    setState(() {
      print("next super"+string[val-1]);
       super_data = string[val-1];
       fc.forward();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    fc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    dark = WidgetsBinding.instance.window.platformBrightness==Brightness.dark;
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    fc = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    fade = Tween(begin: 0.0, end:1.0).animate(fc);
    color_anim = ColorTween(begin: dark?MColor.event2:MColor.event1, end: dark?Colors.black:Colors.white).animate(controller);
    super.initState();
    widget._state2.addState(this);
  }

 void animOnTap1(){
                           
                            setState(() {
                              controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
                              color_anim = ColorTween(end: dark?Colors.black:Colors.white, begin: dark?MColor.event2:MColor.event1).animate(controller);
                            });
                          
                            controller.forward().whenComplete((){
                              controller.reverse();
                            });
                          }
                          void animOnLongTap1(){
setState(() {
                              controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
                              color_anim = ColorTween(end: dark?Colors.black:Colors.white, begin: dark?MColor.event2:MColor.event1).animate(controller);

                            });
                             
                           
                            controller.forward();
                          }
                          void animOnFinishLongTap1(){
setState(() {
                              controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
                              color_anim = ColorTween(begin: dark?Colors.black:Colors.white, end: dark?MColor.event2:MColor.event1).animate(controller);

                            });
                             
                            controller.forward();
                          }
  
  Animation color_anim;
  AnimationController controller;

  Animation fade;
  AnimationController fc;

  String super_data = "hello";

    bool dark;
  
    final colors = [Colors.green,Colors.red,Colors.pink,Colors.blue];
  
    @override
    Widget build(BuildContext context) {
      dark = WidgetsBinding.instance.window.platformBrightness==Brightness.dark;
      double w = MediaQuery.of(context).size.width;
      double h = MediaQuery.of(context).size.height;

      print("size: $w $h $val");

      return FadeTransition(
        opacity: fade,
        child: AnimatedBuilder(
        animation: color_anim,
        builder: (context,child) {
          return Container(
              child:SizedBox(width: w/2.6,
        height: h/11.48,
        child: Center(
          child:Column(
          children: <Widget>[
            SizedBox(
              
              height: h/25.72,
              child: Text(super_data, style: TextStyle(color:color_anim.value, fontSize: 24), textAlign: TextAlign.center,),
            ),
            SizedBox(
              height: h/20.74,
              child: Text(trans(context, "f$val"), style: TextStyle(color:color_anim.value, fontSize: 16), textAlign: TextAlign.center,),
            )
          ] 
            
        )
        )
      ));}));
    }
  }
  
  /*
  Es gibt verschiedene Arten von Lotterien
  
  Erste Lottery: Passwort Knacker
  
  7 Stelliges Passwort: XXX XXX, 100K Möglichkeiten
  
  2. Lottery: Farbeimer
  
  Wähle eine Farbe mit RGB Wert: 255 * 255 * 255 
  
  
  
  */
  class ImageRotater extends StatefulWidget {
    List<Image> photos;
  
    ImageRotater(this.photos);
  
    @override
    State<StatefulWidget> createState() => new ImageRotaterState();
  }
  
  class ImageRotaterState extends State<ImageRotater> with SingleTickerProviderStateMixin{
    int _pos = 0;
    Timer _timer;
  
    AnimationController _controller;
    Animation _animation;

    @override
    dispose(){
      _controller.dispose();
      _timer.cancel();
      _timer = null;
            super.dispose();

    }
  
    @override
    void initState() {
  
      _controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
      _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
  
      _controller.forward();
  
      _timer = Timer.periodic(new Duration(seconds: 7), (ticker) {
        
        setState(() {
          print(_pos);
          if(_pos==widget.photos.length)_pos=0;
          else _pos = (_pos + 1) % widget.photos.length;
  
          _controller.reset();
          _controller.forward();
        });
        
      });
      super.initState();
    }
  
  
  
    @override
    Widget build(BuildContext context) {
      return FadeTransition(opacity: _animation, child: widget.photos[_pos]);
    }
  
  
  }
  
  class AuthDisplayer extends StatefulWidget {
    _MyHomePageState _myHomePageState;
    AuthDisplayer(this._myHomePageState);
  
    @override
    _AuthDisplayerState createState() => _AuthDisplayerState();
  }
  
  class _AuthDisplayerState extends State<AuthDisplayer> with TickerProviderStateMixin, WidgetsBindingObserver{
  
    bool isSignedIn=false;
    bool email_v=false;
    bool loaded = false;

    @override
    didChangePlatformBrightness(){
      setState(() {
        dark = WidgetsBinding.instance.window.platformBrightness==Brightness.dark;
      });
    }
    @override
    dispose(){
      controller.dispose();
      super.dispose();
    }

    FirebaseUser _user;
  
    Animation _animation;
    AnimationController controller;
  
    @override
    void initState() {
      // TODO: implement initState
  
      controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
      _animation = Tween(begin: 0.0, end: 1.0).animate(controller);
  
      FirebaseAuth.fromApp(FirebaseApp.instance).currentUser().then((value){
        this._user=value;
        loaded=true;
        if(value==null){
          
            displayAction$1(false);
            return;
        }
        if(value.isEmailVerified){
            displayAction$2(true);
        }else{
            displayAction$2(false);
        }
      }); 
      startTicker();
      super.initState();
    }
    bool isMinute= false;
    void startTicker(){
      Timer.periodic(Duration(seconds: 30), (timer) async { 

        widget._myHomePageState.reloadLotteryTime();

        isMinute=!isMinute;

        try{
          if(_user!=null){
       void empty = await _user.reload();
          
 print(_user);
        if(_user==null){
          
            displayAction$1(false);
            return;
        }
        if(_user.isEmailVerified){
            displayAction$2(true);

        }else{
            displayAction$2(false);
        }
        
          }
        }catch(e){

        }
      
      
      });
     
    }

    void update(){
      FirebaseAuth.fromApp(FirebaseApp.instance).currentUser().then((value){
        this._user=value;
        print(value);
        if(value==null){
          
            displayAction$1(false);
            return;
        }
        if(value.isEmailVerified){
            displayAction$2(true);
        }else{
            displayAction$2(false);
        }
      });
    }
  
    void displayAction$1(bool b){
      Future.delayed(Duration(milliseconds: 100)).then((val){
        setState(() {
           isSignedIn=b;
           controller.forward();
        });
  
      });
    }
  
    void displayAction$2(bool b){
      Future.delayed(Duration(milliseconds: 100)).then((value){
        setState(() {
           email_v=b;
        isSignedIn=true;
        controller.forward();
        });
       
      });
      
    }
  
    void showAccountDetails(){
  Navigator.push(context, new FRoute(this));
    }
    void verifyEmail(){
        Navigator.push(context, new ThirdPageRoute(this));
    }
    void signin(){
      Navigator.push(context, new SecondPageRoute(this));
    }

  bool dark;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    dark = WidgetsBinding.instance.window.platformBrightness==Brightness.dark;
    if(!loaded){
      return Container(
          height: double.infinity,
          width: double.infinity,
      );
    }

    if(isSignedIn && email_v){
        String email = _user.email;
         return FadeTransition(opacity: _animation,
          child: SizedBox(
            width: w/1.066,
            height: h/12.86,
            child: FlatButton(
              onPressed:(){showAccountDetails();},
              onLongPress: (){showAccountDetails();},
              child: Center(child: Text(trans(context, "e3").toString()+email, style: TextStyle(color:  dark?Colors.black:Colors.white,
            fontSize: 20, fontWeight: FontWeight.w300),textAlign: TextAlign.center,)),
          ),
        ));
    }
    if(isSignedIn && !email_v){
       return FadeTransition(opacity: _animation,
          child: SizedBox(
            width: w/1.066,
            height:h/12.86,
            child: FlatButton(
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed:(){verifyEmail();},
              onLongPress: (){verifyEmail();},
              child: Center(child: Text(trans(context, "e2"), style: TextStyle(color: dark?Colors.black:Colors.white,
            fontSize: 20, fontWeight: FontWeight.w300),textAlign: TextAlign.center,)),
          ),
        ));
    }
    if(!isSignedIn){
       return FadeTransition(opacity: _animation,
        
          child: SizedBox(
            width: w/1.066,
            height: h/12.86,
            child: FlatButton(
              onPressed:(){signin();},
              onLongPress: (){signin();},
              color: Colors.transparent,
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Center(child: Text(trans(context, "e1"), style: TextStyle(color:  dark?Colors.black:Colors.white,
            fontSize: 23, fontWeight: FontWeight.w300),textAlign: TextAlign.center,)),
            )
          ),
        );
    }

    return Container(

    );
  }
  

  void forceAnim(){
    print("force anim");
  }
  void forceStop(){
    print("force stop");
  }
}
/*
class SettingDisplay extends StatefulWidget {
  @override
  _SettingDisplayState createState() => _SettingDisplayState();
}

class _SettingDisplayState extends State<SettingDisplay> with WidgetsBindingObserver, TickerProviderStateMixin{
  bool dark;
  @override
  void didChangePlatformBrightness() {
    setState(() {
      dark = WidgetsBinding.instance.window.platformBrightness==Brightness.dark;
    });
    // TODO: implement didChangePlatformBrightness
    super.didChangePlatformBrightness();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
    anim = Tween(begin: 0.0, end: 1.0).animate(controller);
    
    Future.delayed(Duration(milliseconds: 200)).then((value){
        controller.forward();
    });
  }

  Animation anim;
  AnimationController controller;

  @override
  Widget build(BuildContext context) {
    dark = WidgetsBinding.instance.window.platformBrightness==Brightness.dark;
    return FadeTransition(
      opacity: anim,
      child: Center(
        child: Text(trans(context, "e4"), style: TextStyle(fontSize: 25, color: dark?Colors.black:Colors.white), textAlign: TextAlign.center,)
       )
    );
  }
}
*/
class ThirdPageRoute extends CupertinoPageRoute {

  

   ThirdPageRoute(_AuthDisplayerState _state)
      : super(builder: (BuildContext context) => new ThirdPage(_state));
}
class ThirdPage extends StatefulWidget {
  _AuthDisplayerState state;
  ThirdPage(this.state);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ThirdPageState();
  }

}
class _ThirdPageState extends State<ThirdPage> with WidgetsBindingObserver {
  bool dark;
  @override
  void didChangePlatformBrightness() {
    setState(() {
      dark = WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
    });
    // TODO: implement didChangePlatformBrightness
    super.didChangePlatformBrightness();
  }
  @override
  Widget build(BuildContext context) {
    dark  = WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
    // TODO: implement build
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(trans(context, "e2"), style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize:29),),
        backgroundColor: MColor.event3,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            RawMaterialButton(onPressed: sendPwd,
          shape:new RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          constraints: BoxConstraints.tight(Size(w/1.089 , h/22.4)),
          elevation: 3.0,
          fillColor: dark?MColor.event2:MColor.event1,
          child: Center(
            child: Text(trans(context, "l18"), style: TextStyle(fontSize: 24, color: Colors.white),textAlign: TextAlign.center,)
          )
          ),
          Container(height: 30),
          RawMaterialButton(onPressed: signOut,
          shape:new RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          constraints: BoxConstraints.tight(Size(w/1.089 , h/22.4)),
          elevation: 3.0,
          fillColor: dark?MColor.event2:MColor.event1,
          child: Center(
            child: Text(trans(context, "l19"), style: TextStyle(fontSize: 24, color: Colors.white),textAlign: TextAlign.center,)
          )
          ),
          ]
        ),
      ),
    );

  }

  void sendPwd(){
    FirebaseAuth.instance.currentUser().then((value){
      value.sendEmailVerification().then((value){
        back();
      });
    });
  }
  void signOut(){
    FirebaseAuth.instance.signOut().then((value){
      back();
    });
  }
  void back(){
    Navigator.pop(context);
    widget.state.update();
  }
  
}
class SecondPageRoute extends CupertinoPageRoute {
  SecondPageRoute(_AuthDisplayerState state)
      : super(builder: (BuildContext context) => new SecondPage(state));


  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  /*@override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: new SecondPage());
  }*/
  
}

class LotteryRoute extends CupertinoPageRoute{
  LotteryRoute(Type type)
  : super(builder: (BuildContext context) => new Lottery(type));
}

class SecondPage extends StatefulWidget {
  _AuthDisplayerState state;
  SecondPage(this.state);

  @override
  _SecondPageState createState() => new _SecondPageState();
}

class _SecondPageState extends State<SecondPage> with WidgetsBindingObserver{
  bool dark;

  @override
  void dispose() {
    // TODO: implement dispose
    try{
    FocusScope.of(context).unfocus();
    }catch(e){}

    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    /*KeyboardVisibilityNotification().addNewListener(onChange: ((bool val){
      print(val);
      if(val){
        //is Visible
        SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
      }else{
        SystemChrome.setEnabledSystemUIOverlays([]);
      }
    }));*/
    super.initState();
  }

  @override
  void didChangePlatformBrightness() {
    // TODO: implement didChangePlatformBrightness
    setState(() {
          dark = WidgetsBinding.instance.window.platformBrightness==Brightness.dark;
    });    
    super.didChangePlatformBrightness();


  }



  final key = GlobalKey<FormState>();
    final key2 = GlobalKey<FormState>();

  final key3 = GlobalKey<FormState>();


  String email,pass;

  void onChange(String s){
    this.email=s;
  }
   void onChange2(String s){
    this.pass=s;
  }

  Color action_color,action_color2;
    Color action_color3,action_color4,action_color5;

  String errortext;

  StateSetter _setter;
  StateSetter _setter2,_setter3,_setter4,_setter5;



  bool signIn = true;

  @override
  Widget build(BuildContext context) {
    dark =  WidgetsBinding.instance.window.platformBrightness==Brightness.dark;
    action_color = dark?MColor.event2:MColor.event1;
    action_color2 = dark?MColor.event2:MColor.event1;
    action_color3 = dark?MColor.event2:MColor.event1;
    action_color4 = dark?MColor.event2:MColor.event1;
    action_color5 = dark?MColor.event2:MColor.event1;

    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    if(resetpwd){
      return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        centerTitle: true,
        backgroundColor: MColor.event3,
        title: new Text(trans(context, "e1"),style: TextStyle(fontWeight: FontWeight.w400, fontSize: 29)),
      ),
      body: Form(
            key: key3,child: FlatButton(
        focusColor: Colors.transparent,
        color: Colors.transparent,
        hoverColor: Colors.transparent,highlightColor: Colors.transparent,
      
          splashColor: Colors.transparent,
          onPressed: (){FocusScope.of(context).requestFocus(new FocusNode());},
        child: Column(children: <Widget>[
          Container(height: h/40.9,),
         

          SizedBox(width: w/1.217,height: h/5.97,child: Center(child: Text(trans(context, "l5r"), textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w400, fontSize: 28, color: dark?Colors.white:Colors.black)))),
           Center(child: Text(trans(context, "l15"), style: TextStyle(color: dark?Colors.white:Colors.black, fontSize: 23, fontWeight: FontWeight.w400),textAlign: TextAlign.center,),),
                    Container(height: h/44.8,),
             Center(
              child: SizedBox(
                width: w/1.217, height: h/9.95,
              child: StatefulBuilder(
                
                builder: (context, x){
                  _setter5 = x;
                  return  TextFormField(
                onChanged: onChange,
                keyboardType: TextInputType.emailAddress,
                obscureText: false,
                decoration: InputDecoration(
                  
                  labelText: trans(context, "l2"),
                  labelStyle: TextStyle(color: action_color5, fontSize: 19),
                  focusColor: dark?MColor.event2:MColor.event1,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: dark?MColor.event2:MColor.event1,
                      width: 2.0,

                    ),
                    borderRadius: BorderRadius.circular(5)
                  ),
                  errorText: errortext,
                  errorStyle: TextStyle(color: dark?Colors.redAccent:Colors.red),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                    color: dark?Colors.redAccent:Colors.red,
                    width: 2.0
                  ), borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: dark?MColor.event2:MColor.event1, width:2.0),
                    borderRadius: BorderRadius.circular(5)
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: dark?MColor.event2:MColor.event1, width:2.0),
                    borderRadius: BorderRadius.circular(5)
                  )
                ),
                validator: (val){
                   if(val==""){
                     _setter5((){
 action_color5 = dark?Colors.redAccent:Colors.red;
                     });
                     return trans(context, "l13");}
String e = ex1(val);
                    _setter5(() {
                      if(e!=null)action_color5 = dark?Colors.redAccent:Colors.red;
                      else action_color5 = dark?MColor.event2:MColor.event1;
                    }); 
                    return e;                },
              );}),
            )
            ),
           Container(height: 9),
          
        

          RawMaterialButton(onPressed: sendPwd,
          shape:new RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          constraints: BoxConstraints.tight(Size(380 , 40)),
          elevation: 3.0,
          fillColor: dark?MColor.event2:MColor.event1,
          child: Center(
            child: Text(trans(context, "s2"), style: TextStyle(fontSize: 24, color: Colors.white),textAlign: TextAlign.center,)
          )
          ),
Container(height: 5,),
           RawMaterialButton(onPressed: back,
          shape:new RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          constraints: BoxConstraints.tight(Size(210 , 40)),
          elevation: 3.0,
          fillColor: dark?MColor.event2:MColor.event1,
          child: Center(
            child: Text(trans(context, "l3i"), style: TextStyle(fontSize: 24, color: Colors.white),textAlign: TextAlign.center,)
          )
          )

        ],
        
        
        
        
        )
      ),
      )
    );
    }


    if(signIn)return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        centerTitle: true,
        backgroundColor: MColor.event3,
        title: new Text(trans(context, "e1"),style: TextStyle(fontWeight: FontWeight.w400, fontSize: 29)),
      ),
      body: Form(
            key: key,child: FlatButton(
        focusColor: Colors.transparent,
        color: Colors.transparent,
        hoverColor: Colors.transparent,highlightColor: Colors.transparent,
      
          splashColor: Colors.transparent,
          onPressed: (){FocusScope.of(context).requestFocus(new FocusNode());},
        child: Column(children: <Widget>[
          Container(height: h/40.9,),
          SizedBox(width: w/1.217,height: h/5.97,child: Center(child: Text(trans(context, "l1"), textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w400, fontSize: 28, color: dark?Colors.white:Colors.black)))),
          
             Center(
              child: SizedBox(
                width: w/1.217, height: h/9.95,
              child: StatefulBuilder(
                
                builder: (context, x){
                  _setter = x;
                  return  TextFormField(
                onChanged: onChange,
                keyboardType: TextInputType.emailAddress,
                obscureText: false,
                decoration: InputDecoration(
                  
                  labelText: trans(context, "l2"),
                  labelStyle: TextStyle(color: action_color, fontSize: 19),
                  focusColor: dark?MColor.event2:MColor.event1,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: dark?MColor.event2:MColor.event1,
                      width: 2.0,

                    ),
                    borderRadius: BorderRadius.circular(5)
                  ),
                  errorText: errortext,
                  errorStyle: TextStyle(color: dark?Colors.redAccent:Colors.red),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                    color: dark?Colors.redAccent:Colors.red,
                    width: 2.0
                  ), borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: dark?MColor.event2:MColor.event1, width:2.0),
                    borderRadius: BorderRadius.circular(5)
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: dark?MColor.event2:MColor.event1, width:2.0),
                    borderRadius: BorderRadius.circular(5)
                  )
                ),
                validator: (val){
                   if(val==""){_setter((){
 action_color = dark?Colors.redAccent:Colors.red;
                     });return trans(context, "l13");}
String e = ex1(val);
                    _setter(() {
                      if(e!=null)action_color = dark?Colors.redAccent:Colors.red;
                    else action_color = dark?MColor.event2:MColor.event1;
                    });
                    return e;                },
              );}),
            )
            ),
           Container(height: 9),
          
          Center(
              child: SizedBox(
                width: w/1.217, height: h/ 9.95,
              child: StatefulBuilder(
                
                builder: (context, x){
                  _setter2 = x;
                  return TextFormField(
                onChanged: onChange2,

                obscureText: true,
                decoration: InputDecoration(
                  
                  labelText: trans(context, "l4"),
                  labelStyle: TextStyle(color: action_color2, fontSize: 19),
                  focusColor: dark?MColor.event2:MColor.event1,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: dark?MColor.event2:MColor.event1,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(5)
                  ),
                  errorText: errortext,
                  errorStyle: TextStyle(color: dark?Colors.redAccent:Colors.red),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                    color: dark?Colors.redAccent:Colors.red,
                    width: 2.0
                  ), borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: dark?MColor.event2:MColor.event1, width:2.0),
                    borderRadius: BorderRadius.circular(5)
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: dark?MColor.event2:MColor.event1, width:2.0),
                    borderRadius: BorderRadius.circular(5)
                  )
                ),
                validator: (val){
                  if(val==""){_setter2((){
 action_color2 = dark?Colors.redAccent:Colors.red;
                     });return trans(context, "l14");}
                    String e = ex2(val);
                    _setter2(() {
                      if(e!=null)action_color2 = dark?Colors.redAccent:Colors.red;
                    else action_color2 = dark?MColor.event2:MColor.event1;
                    });
                    return e;
                    
                },
              );}),
            )
            ),

           FlatButton(
            onPressed: ((){resetPwd();}),
            color: Colors.transparent,
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Text(trans(context, "l5"), style: TextStyle(color: dark?MColor.event2:MColor.event1, fontSize: 19),),
          ),


          Container(height: h/29.86,),

          Builder(
            builder: (BuildContext context) {
              return RawMaterialButton(onPressed:(){ next(context);},
            
          shape:new RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          constraints: BoxConstraints.tight(Size(w/ 1.97 , h/22.4)),
          elevation: 3.0,
          fillColor: dark?MColor.event2:MColor.event1,
          child: Center(
            child: Text(trans(context, "e1"), style: TextStyle(fontSize: 24, color: Colors.white),textAlign: TextAlign.center,)
          )
          );}),
Container(height: 5,),
           RawMaterialButton(onPressed: back,
          shape:new RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          constraints: BoxConstraints.tight(Size(w/1.08 , h/22.4)),
          elevation: 3.0,
          fillColor: dark?MColor.event2:MColor.event1,
          child: Center(
            child: Text(trans(context, "l3"), style: TextStyle(fontSize: 24, color: Colors.white),textAlign: TextAlign.center,)
          )
          )

        ],
        
        
        
        )
      ),
      )
    );
    else return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        centerTitle: true,
        backgroundColor: MColor.event3,
        title: new Text(trans(context, "e1"),style: TextStyle(fontWeight: FontWeight.w400, fontSize: 29)),
      ),
      body: Form(
            key: key2,child: FlatButton(
        focusColor: Colors.transparent,
        color: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
      
          splashColor: Colors.transparent,
          onPressed: (){FocusScope.of(context).requestFocus(new FocusNode());},
        child: Column(children: <Widget>[
          Container(height: h/44.8,),
          SizedBox(width: w/1.217,height: h/5.97,child: Center(child: Text(trans(context, "l3"), textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w400, fontSize: 28, color: dark?Colors.white:Colors.black)))),
          
             Center(
              child: SizedBox(
                width: w/1.217, height: h/9.95,
              child: StatefulBuilder(
                
                builder: (context, x){
                  _setter3 = x;
                  return  TextFormField(
                onChanged: onChange,
                keyboardType: TextInputType.emailAddress,
                obscureText: false,
                decoration: InputDecoration(
                  
                  labelText: trans(context, "l2"),
                  labelStyle: TextStyle(color: action_color3, fontSize: 19),
                  focusColor: dark?MColor.event2:MColor.event1,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: dark?MColor.event2:MColor.event1,
                      width: 2.0,

                    ),
                    borderRadius: BorderRadius.circular(5)
                  ),
                  errorText: errortext,
                  errorStyle: TextStyle(color: dark?Colors.redAccent:Colors.red),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                    color: dark?Colors.redAccent:Colors.red,
                    width: 2.0
                  ), borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: dark?MColor.event2:MColor.event1, width:2.0),
                    borderRadius: BorderRadius.circular(5)
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: dark?MColor.event2:MColor.event1, width:2.0),
                    borderRadius: BorderRadius.circular(5)
                  )
                ),
                validator: (val){
                   if(val==""){_setter3((){
 action_color3 = dark?Colors.redAccent:Colors.red;
                     });return trans(context, "l13");}
String e = ex1(val);
                    _setter3(() {
                      if(e!=null)action_color3 = dark?Colors.redAccent:Colors.red;
                    else action_color3 = dark?MColor.event2:MColor.event1;
                    });
                    return e;                },
              );}),
            )
            ),
           Container(height: 9),
          
          Center(
              child: SizedBox(
                width: w/1.217, height: h/9.95,
              child: StatefulBuilder(
                
                builder: (context, x){
                  _setter4 = x;
                  return TextFormField(
                onChanged: onChange2,

                obscureText: true,
                decoration: InputDecoration(
                  
                  labelText: trans(context, "l4"),
                  labelStyle: TextStyle(color: action_color4, fontSize: 19),
                  focusColor: dark?MColor.event2:MColor.event1,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: dark?MColor.event2:MColor.event1,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(5)
                  ),
                  errorText: errortext,
                  errorStyle: TextStyle(color: dark?Colors.redAccent:Colors.red),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                    color: dark?Colors.redAccent:Colors.red,
                    width: 2.0
                  ), borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: dark?MColor.event2:MColor.event1, width:2.0),
                    borderRadius: BorderRadius.circular(5)
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: dark?MColor.event2:MColor.event1, width:2.0),
                    borderRadius: BorderRadius.circular(5)
                  )
                ),
                validator: (val){
                  if(val==""){_setter4((){
 action_color4 = dark?Colors.redAccent:Colors.red;
                     });return trans(context, "l14");}
                    String e = ex2(val);
                    _setter4(() {
                      if(e!=null)action_color4 = dark?Colors.redAccent:Colors.red;
                    else action_color4 = dark?MColor.event2:MColor.event1;
                    });
                    return e;
                    
                },
              );}),
            )
            ),

          


          Container(height: h/29.86,),

          Builder(
            builder: (BuildContext context){
          return  RawMaterialButton(onPressed:(){ register(context);},
          shape:new RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          constraints: BoxConstraints.tight(Size(w/1.089 , h/22.4)),
          elevation: 3.0,
          fillColor: dark?MColor.event2:MColor.event1,
          child: Center(
            child: Text(trans(context, "l3r"), style: TextStyle(fontSize: 24, color: Colors.white),textAlign: TextAlign.center,)
          )
          );}),
Container(height: 5,),
           RawMaterialButton(onPressed: back,
          shape:new RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          constraints: BoxConstraints.tight(Size(w/1.97 , h/22.4)),
          elevation: 3.0,
          fillColor: dark?MColor.event2:MColor.event1,
          child: Center(
            child: Text(trans(context, "l3i"), style: TextStyle(fontSize: 24, color: Colors.white),textAlign: TextAlign.center,)
          )
          )

        ],
        
        
        
        
        )
      ),
      )
    );
  }
  bool resetpwd=false;
  void resetPwd(){
    setState(() {
      resetpwd=true;
    });
  }

  void noMatches(BuildContext context){
    Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: dark?MColor.event2:MColor.event1,
      content: Text(trans(context, "z6")),
    ));
  }

  Future<void> signIn$void(BuildContext context) async {
    try{
    AuthResult user =  await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pass);
    Navigator.pop(context);
    widget.state.update();
    }catch(ex){
      try{
        switch(ex.code){
           case 'ERROR_WRONG_PASSWORD':{
           wrongPass(context);break;}
           case 'ERROR_TOO_MANY_REQUESTS':{
             tooManyRequests(context);break;
           }
           case 'ERROR_USER_NOT_FOUND':{
             noMatches(context);break;
           }
           default:{failed(context);break;}
        }
      }catch(e){}
        print(ex.code);
      }
  }

  void tooManyRequests(BuildContext context){
    Scaffold.of(context).showSnackBar(new SnackBar(
      backgroundColor: dark?MColor.event2:MColor.event1,
      content: Text(trans(context, "o3")),
    ));
  }

  void sendPwd() async{

    if(key3.currentState.validate()){
try{
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((value){
       showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          content: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey,
            child: Center(
              child: Text(trans(context, "l16")+email, style: TextStyle(color: dark?Colors.white:Colors.black, fontSize: 20),)
            ),
          ),
          actions: <Widget>[
            //ok
            Container(
              width: double.infinity,
              child: FlatButton(
                onPressed: ((){
                  Navigator.pop(context);
                }),
                color: Colors.grey,
                hoverColor: Colors.transparent,
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
                child: Center(
                  child: Text(
                    trans(context, "s0"),
                    style: 
                    TextStyle(
                      color: dark?Colors.white:Colors.black,
                      fontSize: 23
                    ), 
                  )
                ),
              )
            )
          ],
        );
      },
    );
    }).catchError((){

    });
    
    }catch(e){
      switch(e.code){
        case 'ERROR_USER_NOT_FOUND':{
          noMatches(context);break;
        }
        default:{
          failed(context);break;
        }
      }
    }
  }
  }
  

  void failed(BuildContext context){
    Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: dark?MColor.event2:MColor.event1,
      content: Text(trans(context, "o1")),
    ));
  }

  void wrongPass(BuildContext context){
    Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: dark?MColor.event2:MColor.event1,
      content: Text(trans(context, "o2")),
    ));
  }

  void next(BuildContext context){
    bool b = key.currentState.validate();
    if(b)signIn$void(context);
  }

  void back(){
    if(resetpwd){
      setState(() {
        resetpwd=false;
      });
    }else{
    setState(() {
      signIn=!signIn;
    });
    }
  }

  void accountAlreadyExists(BuildContext context){
    Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: dark?MColor.event2:MColor.event1,
      content: Text(trans(context, "l6")),
    ));
  }

  Future<void> register(BuildContext context) async{
    if(key2.currentState.validate()){
      try{
        AuthResult user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: pass);
        
        widget.state.update();

        Navigator.pop(context);

        FirebaseAuth.instance.currentUser().then((valueXs){
          print(email);
          DatabaseReference rootRef = FirebaseDatabase.instance.reference();
          rootRef.child('Users').child(valueXs.getSaveEmail()).set("0/0");
          valueXs.sendEmailVerification().then((value){
            
          });
        });
    
      }on PlatformException catch(ex){
        switch(ex.code){
           case 'ERROR_EMAIL_ALREADY_IN_USE':{
           accountAlreadyExists(context);break;}
           case 'ERROR_TOO_MANY_REQUESTS':{
             tooManyRequests(context);break;
           }
           default:{failed(context);break;}
        }
      }
    
    }
  }

  String ex1(String val){
                    return !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val)?trans(context, "l7"):null;
  }
  String ex2(String val){
if(val.length>5){
                        if(val.length<41){
                          if(val.toLowerCase()!="password" && val.toLowerCase() != "passwort"){
                            if(val.toLowerCase().trim()!=email.toLowerCase().trim()){
                              return null;
                            }else{
return trans(context, "l11");
                            }
                          }else{
                            return trans(context, "l10");
                          }
                        }else{
                          return trans(context, "l9");
                        }
                    }else{
                      return trans(context, "l8");
                    }
  }
}

class FRoute extends CupertinoPageRoute {
  _AuthDisplayerState state;
  FRoute(this.state)
   : super(builder: (BuildContext context) => new FPage(state));
}

class FPage extends StatefulWidget {

  _AuthDisplayerState state;
  FPage(this.state);
  @override
  _FPageState createState() => _FPageState();
}

class _FPageState extends State<FPage> with WidgetsBindingObserver{
  bool dark;
  @override
  void initState() {
     /*KeyboardVisibilityNotification().addNewListener(onChange: ((bool val){
      print(val);
      if(val){
        //is Visible
        SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
      }else{
        SystemChrome.setEnabledSystemUIOverlays([]);
      }
    }));*/
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
   FocusScope.of(context).unfocus();
    super.dispose();
  }
   void sendPwd(BuildContext context){
    FirebaseAuth.instance.currentUser().then((value) async {
      try{
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      }catch(e){
        switch(e.code){
          case 'ERROR_TOO_MANY_REQUESTS':{
            tooManyRequests(context);break;
          }
          default:{
            failed(context);break;
          }
        }
      }
    });
  }
  void signOut(){
    FirebaseAuth.instance.signOut().then((value){
      back();
    });
  }
  void back(){
    setState(() {
      changeEmail=false;
    });
  }
  void exx(){
    if(key3.currentState.validate()){
    setState(() {
      setPassword = true;
    });
    }
  }
  GlobalKey<FormState> key3 = new GlobalKey();
    GlobalKey<FormState> key4 = new GlobalKey();


  StateSetter _setter5;StateSetter _setter6;

  bool setPassword = false;

  Color action_color5;
  @override
  void didChangePlatformBrightness() {
    setState(() {
      dark = WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
    });
    super.didChangePlatformBrightness();
  }

  String getEmail(String email){
    if(email.length>30){
      email = email.substring(0, 28) + "...";
    }
    return email;
  }

  Future fin(BuildContext context) async{

    if(key4.currentState.validate()){

      FirebaseAuth.instance.currentUser().then((value) async {
        print(value.email);
      try{
      
        await value.updateEmail(newemailadress);
        Navigator.pop(context);
        widget.state.update();
      
      }catch(ex){
        print(ex);
        try{
        switch(ex.code){
          case 'ERROR_WRONG_PASSWORD':{
            wrongPass(context);break;
          }
          case 'ERROR_EMAIL_ALREADY_IN_USE':{
            accountAlreadyExists(context);break;
          }
          case 'ERROR_TOO_MANY_REQUESTS':{
            tooManyRequests(context);break;
          }
          default:{
            failed(context);break;
          }
        }
        }catch(e){

        }
      }
      });
    }
  }


  bool changeEmail = false;
  bool resetPwdb = false;
  void resetPwd(){
    setState(() {
      resetPwdb = true;
    });
  }
  String errorText;

  FirebaseUser user;
void tooManyRequests(BuildContext context){
    Scaffold.of(context).showSnackBar(new SnackBar(
      backgroundColor: dark?MColor.event2:MColor.event1,
      content: Text(trans(context, "o3")),
    ));
  }
  void back3(){
    setState(() {
      resetPwdb=false;
    });
  }
  String email;
  void onChange3(String s){
    this.email=s;
  }
  @override
  Widget build(BuildContext context) {
    user = widget.state._user;
    String email = getEmail(user.email);

    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    
    dark  = WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
if(resetPwdb){
      return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        centerTitle: true,
        backgroundColor:  MColor.event3,
        title: new Text(trans(context, "e1"),style: TextStyle(fontWeight: FontWeight.w400, fontSize: 29)),
      ),
      body: Form(
            key: key3,child: FlatButton(
        focusColor: Colors.transparent,
        color: Colors.transparent,
        hoverColor: Colors.transparent,highlightColor: Colors.transparent,
      
          splashColor: Colors.transparent,
          onPressed: (){FocusScope.of(context).requestFocus(new FocusNode());},
        child: Column(children: <Widget>[
          Container(height: 20,),
         

          SizedBox(width: w/1.22,height: h/5.97,child: Center(child: Text(trans(context, "l5r"), textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w400, fontSize: 28, color: dark?Colors.white:Colors.black)))),
           Center(child: Text(trans(context, "l15"), style: TextStyle(color: dark?Colors.white:Colors.black, fontSize: 23, fontWeight: FontWeight.w400),textAlign: TextAlign.center,),),
                    Container(height: h/44.8,),
             Center(
              child: SizedBox(
                width: w/1.22, height: h/9.95,
              child: StatefulBuilder(
                
                builder: (context, x){
                  _setter5 = x;
                  return  TextFormField(
                onChanged: onChange3,
                keyboardType: TextInputType.emailAddress,
                obscureText: false,
                decoration: InputDecoration(
                  
                  labelText: trans(context, "l2"),
                  labelStyle: TextStyle(color: action_color5, fontSize: 19),
                  focusColor: dark?MColor.event2:MColor.event1,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: dark?MColor.event2:MColor.event1,
                      width: 2.0,

                    ),
                    borderRadius: BorderRadius.circular(5)
                  ),
                  errorText: errorText,
                  errorStyle: TextStyle(color: dark?Colors.redAccent:Colors.red),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                    color: dark?Colors.redAccent:Colors.red,
                    width: 2.0
                  ), borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: dark?MColor.event2:MColor.event1, width:2.0),
                    borderRadius: BorderRadius.circular(5)
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: dark?MColor.event2:MColor.event1, width:2.0),
                    borderRadius: BorderRadius.circular(5)
                  )
                ),
                validator: (val){
                   if(val==""){
                     _setter5((){
 action_color5 = dark?Colors.redAccent:Colors.red;
                     });
                     return trans(context, "l13");}
String e = ex1(val);
                    _setter5(() {
                      if(e!=null)action_color5 = dark?Colors.redAccent:Colors.red;
                      else action_color5 = dark?MColor.event2:MColor.event1;
                    }); 
                    return e;                },
              );}),
            )
            ),
           Container(height: 9),
          
        

          Builder(builder: (BuildContext context) {return RawMaterialButton(onPressed: (){sendPwd(context);},
          shape:new RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          constraints: BoxConstraints.tight(Size(w/1.22 , h/22.4)),
          elevation: 3.0,
          fillColor: dark?MColor.event2:MColor.event1,
          child: Center(
            child: Text(trans(context, "s2"), style: TextStyle(fontSize: 24, color: Colors.white),textAlign: TextAlign.center,)
          )
          );}),
Container(height: 5,),
           RawMaterialButton(onPressed: back3,
          shape:new RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          constraints: BoxConstraints.tight(Size(w/1.97 , 20.45)),
          elevation: 3.0,
          fillColor: dark?MColor.event2:MColor.event1,
          child: Center(
            child: Text(trans(context, "z1"), style: TextStyle(fontSize: 24, color: Colors.white),textAlign: TextAlign.center,)
          )
          )

        ],
        
        
        
        
        )
      ),
      )
    );
    }
    if(setPassword){
      return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        centerTitle:true,
        backgroundColor:  MColor.event3,
        title: new Text(trans(context, "z2"),style: TextStyle(fontWeight: FontWeight.w400, fontSize: 29)),
      ),
      body: Form(
            key: key4,child: FlatButton(
        focusColor: Colors.transparent,
        color: Colors.transparent,
        hoverColor: Colors.transparent,highlightColor: Colors.transparent,
      
          splashColor: Colors.transparent,
          onPressed: (){FocusScope.of(context).requestFocus(new FocusNode());},
        child: Center(child: SizedBox(width: double.infinity, height: h/1.792, child: Column(children: <Widget>[
          Container(height: h/44.8,),
         

           Center(child: Text(trans(context, "z3"), style: TextStyle(color: dark?Colors.white:Colors.black, fontSize: 23, fontWeight: FontWeight.w400),textAlign: TextAlign.center,),),
                    Container(height: h/44.8,),
             Center(
               
              child: SizedBox(
                width: w/1.217, height: h/9.95,
              child: StatefulBuilder(
                
                builder: (context, x){
                  _setter6 = x;
                  return  TextFormField(
                onChanged: onChang2e,
                                
                                obscureText: true,
                                decoration: InputDecoration(
                                  
                                  labelText: trans(context, "l4"),
                                  labelStyle: TextStyle(color: action_color5, fontSize: 19),
                                  focusColor: dark?MColor.event2:MColor.event1,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: dark?MColor.event2:MColor.event1,
                                      width: 2.0,
                
                                    ),
                                    borderRadius: BorderRadius.circular(5)
                                  ),
                                  errorText: errorText,
                                  errorStyle: TextStyle(color: dark?Colors.redAccent:Colors.red),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                    color: dark?Colors.redAccent:Colors.red,
                                    width: 2.0
                                  ), borderRadius: BorderRadius.all(Radius.circular(5)),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: dark?MColor.event2:MColor.event1, width:2.0),
                                    borderRadius: BorderRadius.circular(5)
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: dark?MColor.event2:MColor.event1, width:2.0),
                                    borderRadius: BorderRadius.circular(5)
                                  )
                                ),
                                validator: (val){
                                   if(val==""){
                                     _setter6((){
                 action_color5 = dark?Colors.redAccent:Colors.red;
                                     });
                                     return trans(context, "l13");}
                String e = ex2(val);
                                    _setter6(() {
                                      if(e!=null)action_color5 = dark?Colors.redAccent:Colors.red;
                                      else action_color5 = dark?MColor.event2:MColor.event1;
                                    }); 
                                    return e;                },
                              );}),
                            )
                            ),
                          
                          FlatButton(
            onPressed: ((){resetPwd();}),
            color: Colors.transparent,
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Text(trans(context, "l5"), style: TextStyle(color: dark?MColor.event2:MColor.event1, fontSize: 19),),
          ),
                
                Container(height: 9,),

                          Builder(
                            builder: (BuildContext context){
                              return RawMaterialButton(onPressed: ((){fin(context);}),
                          shape:new RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          constraints: BoxConstraints.tight(Size(w/1.22 , h/22.4)),
                          elevation: 3.0,
                          fillColor: dark?MColor.event2:MColor.event1,
                          child: Center(
                            child: Text(trans(context, "s2"), style: TextStyle(fontSize: 24, color: Colors.white),textAlign: TextAlign.center,)
                          )
                          );}),
                Container(height: 5),
                           RawMaterialButton(onPressed: back2,
                          shape:new RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          constraints: BoxConstraints.tight(Size(w/1.97 , h/22.4)),
                          elevation: 3.0,
                          fillColor: dark?MColor.event2:MColor.event1,
                          child: Center(
                            child: Text(trans(context, "z1"), style: TextStyle(fontSize: 24, color: Colors.white),textAlign: TextAlign.center,)
                          )
                          )
                
                        ],
                        
                        
                        
                        
                        )
                      ),
                      )
                    )));
    }

    if(!changeEmail)return  Scaffold(
      appBar: AppBar(
        title: Text(trans(context, "o4"), style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize:29),),
        backgroundColor:  MColor.event3,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [

            GestureDetector(
              onTap: ((){
                setState(() {
                  changeEmail=true;
                });
              }),
              child: Container(
            width: w/1.22,
            height: h/22.4,
              decoration: BoxDecoration(
                color:  dark?MColor.event2:MColor.event1,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: w/11.5,
                    height: h/24.89,
                    child: Icon(
                      Icons.alternate_email,
                      color: Colors.white
                    ),
                  ),
                  Container(
                    width: w/41.1
                  ),
                  Center(child:SizedBox(
                    width: w/1.6,
                    height: h/36.89,
                    child: Center(child: Text(email, style: TextStyle(fontSize: 21, color: Colors.white),textAlign: TextAlign.left,)),
                  ))
                ]
              ),)
            ),

            Container(height: h/17.92),
            GestureDetector(
              onTap: ((){
                FirebaseAuth.instance.signOut().then((value){
                  Navigator.pop(context);
                  widget.state.update();
                });
              }),
              child: Container(
            width: w/1.089,
            height: h/22.4,
              decoration: BoxDecoration(
                color:  dark?MColor.event2:MColor.event1,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              
                  child: Center(child:SizedBox(
                    width: w/1.089,
                    height: h/22.4,
                    child: Center(child: Text(trans(context, "l19"), style: TextStyle(fontSize: 21, color: Colors.white),textAlign: TextAlign.center,)),
                  ))
                
            )),

            
          ]
        ),
      ),
    );
  else{
    action_color5 = dark?MColor.event2:MColor.event1;
return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        centerTitle: false,
        backgroundColor:  MColor.event3,
        title: new Text(trans(context, "o6"),style: TextStyle(fontWeight: FontWeight.w400, fontSize: 29)),
      ),
      body: Form(
            key: key3,child: FlatButton(
        focusColor: Colors.transparent,
        color: Colors.transparent,
        hoverColor: Colors.transparent,highlightColor: Colors.transparent,
      
          splashColor: Colors.transparent,
          onPressed: (){FocusScope.of(context).requestFocus(new FocusNode());},
        child: Center(child: SizedBox(width: double.infinity, height: 400, child: Column(children: <Widget>[
          Container(height: 20,),
         

           Center(child: Text(trans(context, "o7"), style: TextStyle(color: dark?Colors.white:Colors.black, fontSize: 23, fontWeight: FontWeight.w400),textAlign: TextAlign.center,),),
                    Container(height: 20,),
             Center(
               
              child: SizedBox(
                width: w/1.217, height: h/9.95,
              child: StatefulBuilder(
                
                builder: (context, x){
                  _setter5 = x;
                  return  TextFormField(
                onChanged: onChange,
                                keyboardType: TextInputType.emailAddress,
                                obscureText: false,
                                decoration: InputDecoration(
                                  
                                  labelText: trans(context, "z4"),
                                  labelStyle: TextStyle(color: action_color5, fontSize: 19),
                                  focusColor: dark?MColor.event2:MColor.event1,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: dark?MColor.event2:MColor.event1,
                                      width: 2.0,
                
                                    ),
                                    borderRadius: BorderRadius.circular(5)
                                  ),
                                  errorText: errorText,
                                  errorStyle: TextStyle(color: dark?Colors.redAccent:Colors.red),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                    color: dark?Colors.redAccent:Colors.red,
                                    width: 2.0
                                  ), borderRadius: BorderRadius.all(Radius.circular(5)),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(color: dark?MColor.event2:MColor.event1, width:2.0),
                                    borderRadius: BorderRadius.circular(5)
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: dark?MColor.event2:MColor.event1, width:2.0),
                                    borderRadius: BorderRadius.circular(5)
                                  )
                                ),
                                validator: (val){
                                   if(val==""){
                                     _setter5((){
                 action_color5 = dark?Colors.redAccent:Colors.red;
                                     });
                                     return trans(context, "l13");}
                String e = ex1(val);
                                    _setter5(() {
                                      if(e!=null)action_color5 = dark?Colors.redAccent:Colors.red;
                                      else action_color5 = dark?MColor.event2:MColor.event1;
                                    }); 
                                    return e;                },
                              );}),
                            )
                            ),
                           Container(height: 9),
                          
                         
                          RawMaterialButton(onPressed: exx,
                          shape:new RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          constraints: BoxConstraints.tight(Size(w/1.089 , h/22.4)),
                          elevation: 3.0,
                          fillColor: dark?MColor.event2:MColor.event1,
                          child: Center(
                            child: Text(trans(context, "o8"), style: TextStyle(fontSize: 24, color: Colors.white),textAlign: TextAlign.center,)
                          )
                          ),
                Container(height: 5),
                           RawMaterialButton(onPressed: back,
                          shape:new RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          constraints: BoxConstraints.tight(Size(w/1.97 , h/22.4)),
                          elevation: 3.0,
                          fillColor: dark?MColor.event2:MColor.event1,
                          child: Center(
                            child: Text(trans(context, "z1"), style: TextStyle(fontSize: 24, color: Colors.white),textAlign: TextAlign.center,)
                          )
                          )
                
                        ],
                        
                        
                        
                        
                        )
                      ),
                      )
                    )));
                    }
                  }
                  String newemailadress;
                  String pass;
                  void onChange(String value) {
                    this.newemailadress=value;
                   }
                   void onChang2e(String value) {
                    this.pass=value;
                   }
                   void wrongPass(BuildContext context){
    Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: dark?MColor.event2:MColor.event1,
      content: Text(trans(context, "o2")),
    ));
  }
  void accountAlreadyExists(BuildContext context){
    Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: dark?MColor.event2:MColor.event1,
      content: Text(trans(context, "l6")),
    ));
  }
  String ex1(String val){
    if(val==user.email)return trans(context, "z5");
    else return !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val)?trans(context, "l7"):null;
  }
  void back2(){
    setState(() {
      setPassword=false;
    });
  }
  void failed(BuildContext context){
    Scaffold.of(context).showSnackBar(SnackBar(
      backgroundColor: dark?MColor.event2:MColor.event1,
      content: Text(trans(context, "o1")),
    ));
  }
  String ex2(String val){
if(val.length>5){
                        if(val.length<41){
                          
                            
                              return null;
                            
                        }else{
                          return trans(context, "l9");
                        }
                    }else{
                      return trans(context, "l8");
                    }
  }
}

class NRoute extends CupertinoPageRoute {
  NRoute(int time)
   : super(builder: (BuildContext context) => new N(time));
}

class N extends StatefulWidget {
  int time;
  N(this.time);

  @override
  _NState createState() => _NState();
}



class _NState extends State<N> with WidgetsBindingObserver, TickerProviderStateMixin{

  bool dark;


  @override
  void didChangePlatformBrightness() {
    // TODO: implement didChangePlatformBrightness
    super.didChangePlatformBrightness();
    dark  = WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    ff.dispose();
    coinc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
   
    ff = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    fadex = Tween(begin: 0.0, end: 1.0).animate(ff);

    coinc = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    coinf = Tween(begin: 0.0, end:1.0).animate(coinc);
    

     super.initState();

     loadData();
     loadCoins(widget.time);
  }

  List<Product> products;

  String name1 = "";
  String name2 = "";

  void loadData(){

    Future.delayed(Duration(milliseconds: 200)).then((value){
      Loader l = new Loader(Localizations.localeOf(context).languageCode);
      l.load().then((value){
      setState(() {
        this.products=value;
        this.name1 = products[0].name;
        this.name2 = products[1].name;
      });
      print("finished loading");
      ff.forward();
    });
    });
  }

  void loadCoins(int lotterystarttime){
    FirebaseAuth.instance.currentUser().then((value){
    if(value!=null)CoinsDataSync().getCoinsFutureString(value, lotterystarttime).then((value2){

      

      int mcoins;

      if(value2==null){
        mcoins = 0;
      }else{
        mcoins = int.parse(value2);
      }
      print(mcoins);

      setState(() {
        coins = mcoins;
        coinc.forward();
      });
    });
    });
  }

  Animation fadex;
  AnimationController ff;

  PageController controller;

  void more(){
    Navigator.push(context, ZRoute(products, current_page, coins, this));
  }

  int current_page = 0;
  bool info_page = false;

  int coins;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;

    AssetImage i1 = AssetImage('images/itunes_card.png');
    AssetImage i2 = AssetImage('images/google_card.png');

    Image _i1 = new Image(image: i1);
    Image _i2 = new Image(image: i2);

    controller = new PageController(initialPage: 0);
    
    dark  = WidgetsBinding.instance.window.platformBrightness == Brightness.dark;

      
      if(!info_page){
      return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        centerTitle: true,
        backgroundColor:  MColor.event3,
        title: new Text(trans(context, "s3"),style: TextStyle(fontWeight: FontWeight.w400, fontSize: 29)),
      ),
      body: FadeTransition(opacity: fadex,
      child: Container(
        width: w,
        height: h,
        color: dark?Colors.black:Colors.white,
        child: Center(child: SizedBox(
          width: w/1.05,
          height: h/1.5,
          child: Column(children: <Widget>[         Container(height: h/8),
SizedBox(height: h/3, width: w/1.05, child: PageView(
          children: <Widget>[
            Center(
              child: GestureDetector( onTap: more,child: Column(
              children: <Widget>[
                SizedBox(
                  width: w/1.05,
                  height: h/19,
                  child: Center(child: Text(name1, style: TextStyle(color: dark?MColor.event2:MColor.event1, fontSize: 26, fontWeight: FontWeight.w400),))
                ),
                SizedBox(
                width: w/2.07,
                height: h/4.48,
                child: _i1
                )
              
              ]
              )
            )),
              Center(
              child: GestureDetector( onTap: more,child: Column(
              children: <Widget>[
                SizedBox(
                  width: w/1.05,
                  height: h/19.9,
                  child: Center(child: Text(name2, style: TextStyle(color: dark?MColor.event2:MColor.event1, fontSize: 26, fontWeight: FontWeight.w400),))
                ),
                SizedBox(
                width: w/2.07,
                height: h/4.48,
                child: _i2
                )
              
              ]
              )
            )),
          ],
          onPageChanged: ((f){
            this.current_page=f;
          }),
          controller: controller,
        )),
        Container(height: h/6),
        FadeTransition(opacity: coinf,
        child: Center(child: Text(trans(context, "p10")+coins.toString()+"LFC",style: TextStyle(color: dark?MColor.event2:MColor.event1, fontSize: 21, fontWeight: FontWeight.w400),)) 
        )
        ]))
      ))),
      );
      }else{
      }
  
}

Animation coinf;
AnimationController coinc;

}

class ZRoute extends MaterialPageRoute{
   ZRoute(List<Product> p, int index, int coins, _NState state)
   : super(builder: (BuildContext context) => new Z(p, index,coins, state));
}

class Z extends StatefulWidget {

  List<Product> p;

  int index;

  int coins;

  _NState state;

  Z(this.p, this.index, this.coins, this.state);

  @override
  _ZState createState() => _ZState();
}

class _ZState extends State<Z> with WidgetsBindingObserver{
  PageController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.products=widget.p;
  }
 
  @override
  void didChangePlatformBrightness() {
    // TODO: implement didChangePlatformBrightness
    super.didChangePlatformBrightness();
    setState(() {
      dark = WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
    });
  }

  

  bool dark;

  List<Product> products;

  @override
  Widget build(BuildContext context) {

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    AssetImage img1 = AssetImage('images/itunes_card.png');
    AssetImage img2 = AssetImage('images/google_card.png');

    Image i1 = Image(image: img1);
    Image i2 = Image(image: img2);

    dark = WidgetsBinding.instance.window.platformBrightness==Brightness.dark;

    controller = PageController(initialPage: widget.index);

    String p9 = trans(context, "p9");
    String p9a = p9.replaceRange(p9.indexOf('price'), p9.indexOf('price')+'price'.length , products[0].prize.toString());
    String p9b = p9.replaceRange(p9.indexOf('price'), p9.indexOf('price')+'price'.length , products[1].prize.toString());

    String p8aa = products[0].worth;
    String p8ab = products[0].currency;
    String p8ba = products[1].worth;
    String p8bb = products[1].currency;

    String p8a = trans(context,"p8").toString()+p8aa.toString()+p8ab.toString();
    String p8b = trans(context,"p8").toString()+p8ba.toString()+p8bb.toString();


    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        centerTitle: true,
        backgroundColor:  MColor.event3,
        title: new Text(trans(context, "s3"),style: TextStyle(fontWeight: FontWeight.w400, fontSize: 29)),
      ),
      body:  Container(
        color: dark?Colors.black:Colors.white,
        width: w,
        height: h,
        child: Center(child: SizedBox(
          
          width: w/1.05,
          height: h,
          child: PageView(
            
          children: <Widget>[
            Center(
              child: Column(
              children: <Widget>[
                
                SizedBox(
                width: w/2.07,
                height: h/4.48,
                child: i1
                ),
                SizedBox(
                  width: w/1.05,
                  height: h/19,
                  child: Center(child: Text(products[0].name, style: TextStyle(color: dark?MColor.event2:MColor.event1, fontSize: 26, fontWeight: FontWeight.w400),))
                ),
                Container(height: h/29.2,),
                Container(
            width: w/1.0666,
            height: h/19.1,
              decoration: BoxDecoration(
                color:  dark?MColor.event2:MColor.event1,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: 
                  Center(child: Text(p8a, style: TextStyle(fontSize: 21, color: Colors.white),textAlign: TextAlign.center,)),
                  
            ),
             Container(height: h/29.2,),
 GestureDetector(onTap: buy1, child:Container(
            width: w/1.0666,
            height: h/19.1,
              decoration: BoxDecoration(
                color:  dark?MColor.event2:MColor.event1,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: 
                  Center(child: Text(p9a, style: TextStyle(fontSize: 21, color: Colors.white),textAlign: TextAlign.center,)),
                  
            )),
             Container(height: h/29.2,),
             Center(child: Text(products[0].des, style: TextStyle(color: dark?MColor.event2:MColor.event1, fontSize: 17), textAlign: TextAlign.center,),),
              Container(height: h/29.2,),
            Center(child: Text(products[0].info,style: TextStyle(color: dark?MColor.event2:MColor.event1, fontSize: 17), textAlign: TextAlign.center,)),
             Container(height: h/29.2,),
            Center(child: Text(products[0].warn,style: TextStyle(color: dark?MColor.event2:MColor.event1, fontSize: 17), textAlign: TextAlign.center,)),
           
              
              ]
              )
            ),
              Center(
              child: Column(
              children: <Widget>[
               
                SizedBox(
                width: w/2.07,
                height: h/4.48,
                child: i2
                ),
                 SizedBox(
                  width: w/1.05,
                  height: h/19.9,
                  child: Center(child: Text(products[1].name, style: TextStyle(color: dark?MColor.event2:MColor.event1, fontSize: 26, fontWeight: FontWeight.w400),))
                ),
                 Container(height: h/29.2,),
                Container(
            width: w/1.0666,
            height: h/19.1,
              decoration: BoxDecoration(
                color:  dark?MColor.event2:MColor.event1,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: 
                  Center(child: Text(p8b, style: TextStyle(fontSize: 21, color: Colors.white),textAlign: TextAlign.center,)),
                  
            ),
             Container(height: h/29.2,),
 GestureDetector(onTap: buy2, child:Container(
             width: w/1.0666,
             height: h/19.1,
               decoration: BoxDecoration(
                 color:  dark?MColor.event2:MColor.event1,
                 borderRadius: BorderRadius.all(Radius.circular(20)),
               ),
               child: 
                   Center(child: Text(p9b, style: TextStyle(fontSize: 21, color: Colors.white),textAlign: TextAlign.center,)),
                   
             )),
              Container(height: h/29.2,),
              Center(child: Text(products[1].des, style: TextStyle(color: dark?MColor.event2:MColor.event1, fontSize: 17), textAlign: TextAlign.center,),),
               Container(height: h/29.2,),
             Center(child: Text(products[1].info,style: TextStyle(color: dark?MColor.event2:MColor.event1, fontSize: 17), textAlign: TextAlign.center,),),
              Container(height: h/29.2,),
             Center(child: Text(products[1].warn,style: TextStyle(color: dark?MColor.event2:MColor.event1, fontSize: 17), textAlign: TextAlign.center,),),
            
               
               ]
               )
             ),
           ],
           controller: controller,
         ))
       )));
   }

 
    void buy2() {

      if(widget.coins>=products[1].prize){
      
      FirebaseAuth.instance.currentUser().then((value){
      DatabaseReference ref = FirebaseDatabase.instance.reference();
      DatabaseReference ref2 = ref.child('product2').child(value.getSaveEmail());
      String safeemail = value.getSaveEmail();
      ref2.once().then((value){
        if(value.value!=null){
          print(value.value);
          int times = (value.value.runtimeType=="".runtimeType)?int.parse(value.value)+1:value.value+1;
          ref2.set(times).then((values){
        int current = widget.coins - products[0].prize;
        DatabaseReference ref = FirebaseDatabase.instance.reference();
        ref.child('Users').child(safeemail).set(current.toString()+"x"+mainunx.getTime()).then((value){
           widget.state.coins=current;
          Navigator.pop(context);
        });
      });
        }else{
  ref2.set("0").then((values){
        int current = widget.coins - products[0].prize;
        DatabaseReference ref = FirebaseDatabase.instance.reference();
        ref.child('Users').child(safeemail).set(current.toString()+"x"+mainunx.getTime()).then((value){
           widget.state.coins=current;
          Navigator.pop(context);
        });
      });
        }
      
    
      });
      });
      

      }
  }
    void buy1(){
if(widget.coins>=products[0].prize){
      
      FirebaseAuth.instance.currentUser().then((value){
      DatabaseReference ref = FirebaseDatabase.instance.reference();
      DatabaseReference ref2 = ref.child('product1').child(value.getSaveEmail());
      String safeemail = value.getSaveEmail();
      ref2.once().then((value){
        if(value.value!=null){
          print(value.value);
          int times = (value.value.runtimeType=="".runtimeType)?int.parse(value.value)+1:value.value+1;
          ref2.set(times).then((values){
        int current = widget.coins - products[0].prize;
        DatabaseReference ref = FirebaseDatabase.instance.reference();
        ref.child('Users').child(safeemail).set(current.toString()+"x"+mainunx.getTime()).then((value){
           widget.state.coins=current;
          Navigator.pop(context);
        });
      });
        }else{
  ref2.set("0").then((values){
        int current = widget.coins - products[0].prize;
        DatabaseReference ref = FirebaseDatabase.instance.reference();
        ref.child('Users').child(safeemail).set(current.toString()+"x"+mainunx.getTime()).then((value){
           widget.state.coins=current;
          Navigator.pop(context);
        });
      });
        }
      
    
      });
      });
      

      }
  }
}



extension on DateTime{

  DateTime roundDown({Duration delta = const Duration(seconds: 15)}){
    return DateTime.fromMillisecondsSinceEpoch(
        this.millisecondsSinceEpoch -
        this.millisecondsSinceEpoch % delta.inMilliseconds
    );
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

class MoreRoute extends CupertinoPageRoute{
  MoreRoute()
  : super(builder: (BuildContext context) => More());
}

class HelpRoute extends CupertinoPageRoute{
  HelpRoute()
  : super(builder: (BuildContext context) => Help());
}

class More extends StatefulWidget {
  @override
  _MoreState createState() => _MoreState();
}

class _MoreState extends State<More> with WidgetsBindingObserver{

  bool dark;

  @override
  didChangePlatformBrightness(){
    dark = WidgetsBinding.instance.window.platformBrightness==Brightness.dark;
  }

  void share(){
    Share.share(trans(context, "share1"));
  }
  void help(){


    Navigator.push(context, HelpRoute());
  }
  terms() async {
  const url = 'https://lotterfree.com';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
  
}
  void contact(){

  }

  @override
  Widget build(BuildContext context) {
    dark = WidgetsBinding.instance.window.platformBrightness==Brightness.dark;

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: MColor.event3,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(child: Text(trans(context, "t5"), style: TextStyle(fontWeight: FontWeight.w400, fontSize: 29)))
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        width: w,
        height: h,
        color:dark?Colors.black:Colors.white,
        child: Center(child: SizedBox(
          width: w,
           height: h,
           child: Column(
            children: <Widget>[
              Container(
                height: h/21
              ),
              GestureDetector(
                onTap: share,
                child:Container(
                        decoration: BoxDecoration(
                                                  color:dark?MColor.event2:MColor.event1,
                                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                                   border: Border.all(color: dark?MColor.event2:MColor.event1, width: 3.0),
                                                  boxShadow: [
                              BoxShadow(
                                color:dark?MColor.event2.withOpacity(0.4):MColor.event1.withOpacity(0.4),
                                spreadRadius: 1,
                                blurRadius: 3,
                                
                                offset: Offset(0.5, 2), 
                                // changes position of shadow
                              ),]
                                              ),
                                              width: w/1.066,
                                              height: h/4,
                                              child: Center(
                                                child: Text(trans(context, "share"), style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w400), textAlign: TextAlign.center,),
                                              ),
                                              )),
              Container(
                height: h/21,
              ),
              GestureDetector(onTap: help, child: Container(
                        decoration: BoxDecoration(
                                                  color:dark?MColor.event2:MColor.event1,
                                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                                   border: Border.all(color: dark?MColor.event2:MColor.event1, width: 3.0),
                                                  boxShadow: [
                              BoxShadow(
                                color:dark?MColor.event2.withOpacity(0.4):MColor.event1.withOpacity(0.4),
                                spreadRadius: 1,
                                blurRadius: 3,
                                
                                offset: Offset(0.5, 2), 
                                // changes position of shadow
                              ),]
                                              ),
                                              width: w/1.066,
                                              height: h/13,
                                              child: Center(
                                                child: Text(trans(context, "t4"), style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w400), textAlign: TextAlign.center,),
                                              ),
                                              )),
                                              Container(
                                                height: h/21
                                              ),
              GestureDetector(onTap: terms, child:Container(
                        decoration: BoxDecoration(
                                                  color:dark?MColor.event2:MColor.event1,
                                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                                   border: Border.all(color: dark?MColor.event2:MColor.event1, width: 3.0),
                                                  boxShadow: [
                              BoxShadow(
                                color:dark?MColor.event2.withOpacity(0.4):MColor.event1.withOpacity(0.4),
                                spreadRadius: 1,
                                blurRadius: 3,
                                
                                offset: Offset(0.5, 2), 
                                // changes position of shadow
                              ),]
                                              ),
                                              width: w/1.066,
                                              height: h/13,
                                              child: Center(
                                                child: Text(trans(context, "t6"), style: TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w400), textAlign: TextAlign.center,),
                                              ),
                                              )),
                                              Container(height: h/21),
              
                                              Container(
                                                height: h/21
                                              ),                                
                                                                           
            ],
           ))
        ))
    );
  }
  void instagram(){
    launch('https://www.instagram.com/lotterfreeapp/');
  
  }
  void facebook(){
    launch('https://www.facebook.com/LotterFree-103056384846075');
  }
  void twitter(){
    launch('https://www.twitter.com/LotterFree_App');
  }
}

UNX mainunx;


  
