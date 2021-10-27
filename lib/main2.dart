
import 'dart:async';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AppLocalizations.dart';
import 'MColor.dart';
import 'lottery.dart';
import 'style.dart';
import 'type.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
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


  @override
  _MyHomePageState createState() => _MyHomePageState();
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

  Future<void> getSharedData() async {
  SharedPreferences.getInstance().then((value){
setState(() {
      isAlreadyThere = value.getBool("startScreen");
    if(isAlreadyThere==null)isAlreadyThere=false;
    });
  });

    
  }

  bool isAlreadyThere = true;

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
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

    DatabaseReference ref1 = main.child('starttime');
    DatabaseReference ref0 = main.child('prize');
    DatabaseReference ref2 = main.child('type');
    ref0.once().then((value){
      this.prize2 = handlePrize(value.value);
      print(prize2);
    });
    ref1.once().then((value){
      this.starttime=value.value;
      this.starttime2 = handleTime(value.value);
      print(starttime2);
    });
    ref2.once().then((value2) async{
      t = Type(value2.value as int,Localizations.localeOf(context).languageCode.toString());
      t = await t.loadInfo();
        this.chance=t.chance;
        this.des=t.des;
        this.wer=t.wer;
        this.name=t.name;
        t.update(prize2, starttime2,starttime );

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
  

  @override
  Widget build(BuildContext context) {
    AssetImage asset = AssetImage("images/i3.png");
    Image _image = Image(image: asset);
    AssetImage asset2 = AssetImage("images/s1.jpg");
    Image _image2 = Image(image: asset2);
    dark = WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
    if(start){
      if(isAlreadyThere){
          shop_images.add(_image);
          shop_images.add(_image2);

          LotteryFeature feature1 = new LotteryFeature(1,this);
          LotteryFeature feature2 = new LotteryFeature(2,this);
          LotteryFeature feature3 = new LotteryFeature(3,this);
          LotteryFeature feature4 = new LotteryFeature(4,this);
        
          return Scaffold(

                appBar: AppBar(
                  
                  backgroundColor: dark?MColor.event2:MColor.event1,
                
                centerTitle: true,
              
                title: Text(trans(context,"title"), style: TextStyle(fontWeight: FontWeight.w400, fontSize: 29),)
                
                ),

                body: Container(
                  color: dark?Colors.black:Colors.white,
                width: double.infinity,
                height: double.infinity,
                  child: Column(
                    children: <Widget> [
                      Container(
                        height: 20
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
                                                width: 300,
                                                height: 190,
                        
                                                child: Container(
                                                  padding: EdgeInsets.only(left:5, right: 5),
                                                  child:Column(
                                                  
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: 65,
                                                    child: FadeTransition(
                                                      opacity: lottery_fade,
                                                      child: Center(child:Text(
                                                      name,
                                                      style: TextStyle(color: colortap2.value, fontWeight: FontWeight.w400, fontSize: 30),
                                                      textAlign: TextAlign.center,
                                                      
                                                    )))),
                                                    SizedBox(
                                                      width: 260,
                                                      
                                                      child:Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                                    )  )
                                                   
                        
                                                  ]
                                                )),
                        
                        
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
                                                height: 25, 
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
                                                width: 300,
                                                height: 190,
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
                                                      height: 65,
                                                    child: Center(child:Text(
                                                      trans(context, "s3"),
                                                      style: TextStyle(color: colortap4.value, fontWeight: FontWeight.w400, fontSize: 30),
                                                      textAlign: TextAlign.center,
                                                      
                                                    ))),
                                                  /*FadeTransition(
                                                    opacity: shop_fade,*/
                                                    SizedBox(
                                                    width: 110,
                                                    height: 110,
                                                    child: ImageRotater(shop_images),
                                                    ) 
                                                  
                                                ]
                                              ),
                                              ));});}),
                                              Container(
                                                height: 25, 
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
                                              width: 340,
                                              height: 50,
                                              child: AuthDisplayer(this),
                                              ),
                                              Container(height: 25,),
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
                                              width: 340,
                                              height: 50,
                                              child: Center(
                                                child: SettingDisplay(),

                                              ),
                                              ),
                                              
                                              
                                            ]
                                          ),
                                        ),
                        
                        
                                  );
                              }else{
                        
                                AssetImage asset1 = new AssetImage("images/s1.jpg");
                                AssetImage asset2 = new AssetImage("images/s2.jpg");
                                AssetImage asset3 = new AssetImage("images/s3.jpg");
                                AssetImage asset4 = new AssetImage("images/s4.jpg");
                        
                                Image _i1 =  Image(image: asset1);
                                Image _i2 =  Image(image: asset2);
                                Image _i3 =  Image(image: asset3);
                                Image _i4 =  Image(image: asset4);
                        
                                _s1 = _s1_control==null?trans(context, "a0"):_s1_control;
                                _s2 = _s2_control==null?trans(context, "a1"):_s2_control;
                                _s3 = _s3_control==null?trans(context, "s1"):_s3_control;
                        
                            return Scaffold(
                              
                              body:  Container(
                                width: double.infinity,
                                height: double.infinity,
                                child: Column(
                                  children: <Widget> [
                                    Container(
                                    height: 40,
                                    child: Row(//Menu bar 
                                      children: <Widget> [
                                          Container(
                                            width: 120,
                                            child: Text(
                                              trans(context, "title"),
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context).textTheme.title,
                                            )
                                          ), 
                                          Container(
                                            width: 120
                                          ),
                                          
                                          Container(
                                            width: 120,
                                          )
                                      ]
                                    ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 443,
                                    child: PageView(
                        
                                      
                                      scrollDirection: Axis.horizontal,
                                      
                                      children: <Widget>[
                                        Container(width: double.infinity,
                                      height: 443,
                                      decoration: BoxDecoration(
                                        color: dark?MColor.mF1:MColor.mF,
                                      ),
                                      child: _i1),
                                      Container(width: double.infinity,
                                      height: 443,
                                      decoration: BoxDecoration(
                                        color: dark?MColor.mF1:MColor.mF,
                                      ),
                                      child: Center(
                                          child: _i2,
                                      ),),
                                      Container(width: double.infinity,
                                      height: 443,
                                      decoration: BoxDecoration(
                                        color: dark?MColor.mF1:MColor.mF,
                                      ),
                                      child: Center(
                                          child: _i3,
                                      ),),
                                      Container(width: double.infinity,
                                      height: 443,
                                      decoration: BoxDecoration(
                                        color: dark?MColor.mF1:MColor.mF,
                                      ),
                                      child: Center(
                                          child: _i4,
                                      ),)
                                      ],
                                      
                                    onPageChanged: ((index){
                                        updatePage(context, index);
                                    }),
                                      //this is the body block in the middle
                                      //here should be the image
                                      
                                    ),),
                                    Container(height: 8),
                                    FadeTransition(
                                    
                                      opacity: _animation,
                                      child: Container(
                                      //Headers
                                      width: double.infinity,
                                      
                                      child: Text(
                                          _s1,
                                          style: TextStyle(
                                            color: dark?Colors.white:Colors.black,
                                            fontSize: 35,
                                            fontWeight: FontWeight.w500,
                                          ),
                                      ),
                                      )
                                    ),
                                    Container(height: 10),
                                    FadeTransition (
                                      opacity: _animation,
                                      child: Container(
                                       width: double.infinity,
                                       height: 100,
                                       child: Text(
                                         _s2,
                                         style: TextStyle(
                                           color: dark?Colors.white:Colors.black,
                                           fontSize: 23,
                                           fontWeight: FontWeight.w300
                                         ),
                                       ),   
                                      
                                    )),
                                  ]
                                ),
                            ),//Welcome Page
                              floatingActionButton: SlideTransition(
                                position: _x,
                                child: Container(
                                width: 100,
                                height: 100,
                                child: RawMaterialButton(
                                  
                                onPressed: skipPages,
                                child: Row(
                                  children: <Widget>[
                                    Text(trans(context, "s2"), style: TextStyle(color: dark?MColor.mF1:MColor.mF, fontSize: 25),),
                                    Icon(Icons.arrow_forward_ios, color: dark?MColor.mF1:MColor.mF,),
                                  
                                    ]
                                  
                                
                                )
                                )
                              ),
                              )
                            );
                              }
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
  PageRouteBuilder(
    pageBuilder: (c, a1, a2) => Lottery(t),
    transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
    transitionDuration: Duration(milliseconds: 500),
  ),
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

    @override
  void didChangePlatformBrightness() {
    setState(() {
      dark = WidgetsBinding.instance.window.platformBrightness==Brightness.dark;
    });
  }

  void updateData(List string){
    setState(() {
       super_data = string[val-1];
       fc.forward();
    });
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

  String super_data = "";

    bool dark;
  
    final colors = [Colors.green,Colors.red,Colors.pink,Colors.blue];
  
    @override
    Widget build(BuildContext context) {
      dark = WidgetsBinding.instance.window.platformBrightness==Brightness.dark;
      return FadeTransition(
        opacity: fade,
        child: AnimatedBuilder(
        animation: color_anim,
        builder: (context,child) {
          return Container(
              child:SizedBox(width: 130,
        height: 56,
        child: Center(
          child:Column(
          children: <Widget>[
            SizedBox(
              
              height: 25,
              child: Text(super_data, style: TextStyle(color:color_anim.value, fontSize: 24), textAlign: TextAlign.center,),
            ),
            SizedBox(
              height: 31,
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
  
  class ImageRotaterState extends State<ImageRotater> with TickerProviderStateMixin{
    int _pos = 0;
    Timer _timer;
  
    AnimationController _controller;
    Animation _animation;
  
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
  
    @override
    void dispose() {
      _timer.cancel();
      _timer = null;
      super.dispose();
    }
  }
  
  class AuthDisplayer extends StatefulWidget {
    _MyHomePageState _myHomePageState;
    AuthDisplayer(this._myHomePageState);
  
    @override
    _AuthDisplayerState createState() => _AuthDisplayerState();
  }
  
  class _AuthDisplayerState extends State<AuthDisplayer> with TickerProviderStateMixin{
  
    bool isSignedIn=false;
    bool email_v=false;
    bool loaded = false;
  
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

    void startTicker(){
      Timer.periodic(Duration(seconds: 30), (timer) { 
        try{
        _user.reload().then((value){
          
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
        });
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


  @override
  Widget build(BuildContext context) {

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
            width: 340,
            height: 50,
            child: FlatButton(
              onPressed:(){showAccountDetails();},
              onLongPress: (){showAccountDetails();},
              child: Center(child: Text(trans(context, "e3").toString()+email, style: TextStyle(color: Colors.white,
            fontSize: 20, fontWeight: FontWeight.w300),textAlign: TextAlign.center,)),
          ),
        ));
    }
    if(isSignedIn && !email_v){
       return FadeTransition(opacity: _animation,
          child: SizedBox(
            width: 340,
            height:50,
            child: FlatButton(
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed:(){verifyEmail();},
              onLongPress: (){verifyEmail();},
              child: Center(child: Text(trans(context, "e2"), style: TextStyle(color: Colors.white,
            fontSize: 20, fontWeight: FontWeight.w300),textAlign: TextAlign.center,)),
          ),
        ));
    }
    if(!isSignedIn){
       return FadeTransition(opacity: _animation,
        
          child: SizedBox(
            width: 340,
            height: 50,
            child: FlatButton(
              onPressed:(){signin();},
              onLongPress: (){signin();},
              color: Colors.transparent,
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Center(child: Text(trans(context, "e1"), style: TextStyle(color: Colors.white,
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
    return Scaffold(
      appBar: AppBar(
        title: Text(trans(context, "e2"), style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize:29),),
        backgroundColor: dark?MColor.event2:MColor.event1,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget> [
            RawMaterialButton(onPressed: sendPwd,
          shape:new RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          constraints: BoxConstraints.tight(Size(380 , 40)),
          elevation: 3.0,
          fillColor: dark?MColor.event2:MColor.event1,
          child: Center(
            child: Text(trans(context, "l18"), style: TextStyle(fontSize: 24, color: Colors.white),textAlign: TextAlign.center,)
          )
          ),
          Container(height: 30),
          RawMaterialButton(onPressed: signOut,
          shape:new RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          constraints: BoxConstraints.tight(Size(380 , 40)),
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
    FocusScope.of(context).unfocus();
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

    if(resetpwd){
      return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        centerTitle: true,
        backgroundColor: dark?MColor.event2:MColor.event1,
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
         

          SizedBox(width: 340,height: 150,child: Center(child: Text(trans(context, "l5r"), textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w400, fontSize: 28, color: dark?Colors.white:Colors.black)))),
           Center(child: Text(trans(context, "l15"), style: TextStyle(color: dark?Colors.white:Colors.black, fontSize: 23, fontWeight: FontWeight.w400),textAlign: TextAlign.center,),),
                    Container(height: 20,),
             Center(
              child: SizedBox(
                width: 340, height: 90,
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
        backgroundColor: dark?MColor.event2:MColor.event1,
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
          Container(height: 20,),
          SizedBox(width: 340,height: 150,child: Center(child: Text(trans(context, "l1"), textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w400, fontSize: 28, color: dark?Colors.white:Colors.black)))),
          
             Center(
              child: SizedBox(
                width: 340, height: 90,
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
                width: 340, height: 90,
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


          Container(height: 30,),

          Builder(
            builder: (BuildContext context) {
              return RawMaterialButton(onPressed:(){ next(context);},
            
          shape:new RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          constraints: BoxConstraints.tight(Size(210 , 40)),
          elevation: 3.0,
          fillColor: dark?MColor.event2:MColor.event1,
          child: Center(
            child: Text(trans(context, "e1"), style: TextStyle(fontSize: 24, color: Colors.white),textAlign: TextAlign.center,)
          )
          );}),
Container(height: 5,),
           RawMaterialButton(onPressed: back,
          shape:new RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          constraints: BoxConstraints.tight(Size(380 , 40)),
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
        backgroundColor: dark?MColor.event2:MColor.event1,
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
          Container(height: 20,),
          SizedBox(width: 340,height: 150,child: Center(child: Text(trans(context, "l3"), textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w400, fontSize: 28, color: dark?Colors.white:Colors.black)))),
          
             Center(
              child: SizedBox(
                width: 340, height: 90,
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
                width: 340, height: 90,
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

          


          Container(height: 30,),

          Builder(
            builder: (BuildContext context){
          return  RawMaterialButton(onPressed:(){ register(context);},
          shape:new RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          constraints: BoxConstraints.tight(Size(380 , 40)),
          elevation: 3.0,
          fillColor: dark?MColor.event2:MColor.event1,
          child: Center(
            child: Text(trans(context, "l3r"), style: TextStyle(fontSize: 24, color: Colors.white),textAlign: TextAlign.center,)
          )
          );}),
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
        
        Navigator.pop(context);
        widget.state.update();


        FirebaseAuth.instance.currentUser().then((value){
          value.sendEmailVerification().then((value){
                Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(trans(context, "l17")),
                    backgroundColor: dark?MColor.event2:MColor.event1,
                ));
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
   FocusScope.of(context).requestFocus(FocusNode());
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
    
    dark  = WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
if(resetPwdb){
      return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(
        centerTitle: true,
        backgroundColor: dark?MColor.event2:MColor.event1,
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
         

          SizedBox(width: 340,height: 150,child: Center(child: Text(trans(context, "l5r"), textAlign: TextAlign.center,style: TextStyle(fontWeight: FontWeight.w400, fontSize: 28, color: dark?Colors.white:Colors.black)))),
           Center(child: Text(trans(context, "l15"), style: TextStyle(color: dark?Colors.white:Colors.black, fontSize: 23, fontWeight: FontWeight.w400),textAlign: TextAlign.center,),),
                    Container(height: 20,),
             Center(
              child: SizedBox(
                width: 340, height: 90,
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
          constraints: BoxConstraints.tight(Size(380 , 40)),
          elevation: 3.0,
          fillColor: dark?MColor.event2:MColor.event1,
          child: Center(
            child: Text(trans(context, "s2"), style: TextStyle(fontSize: 24, color: Colors.white),textAlign: TextAlign.center,)
          )
          );}),
Container(height: 5,),
           RawMaterialButton(onPressed: back3,
          shape:new RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          constraints: BoxConstraints.tight(Size(210 , 40)),
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
        backgroundColor: dark?MColor.event2:MColor.event1,
        title: new Text(trans(context, "z2"),style: TextStyle(fontWeight: FontWeight.w400, fontSize: 29)),
      ),
      body: Form(
            key: key4,child: FlatButton(
        focusColor: Colors.transparent,
        color: Colors.transparent,
        hoverColor: Colors.transparent,highlightColor: Colors.transparent,
      
          splashColor: Colors.transparent,
          onPressed: (){FocusScope.of(context).requestFocus(new FocusNode());},
        child: Center(child: SizedBox(width: double.infinity, height: 500, child: Column(children: <Widget>[
          Container(height: 20,),
         

           Center(child: Text(trans(context, "z3"), style: TextStyle(color: dark?Colors.white:Colors.black, fontSize: 23, fontWeight: FontWeight.w400),textAlign: TextAlign.center,),),
                    Container(height: 20,),
             Center(
               
              child: SizedBox(
                width: 340, height: 90,
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
                          constraints: BoxConstraints.tight(Size(380 , 40)),
                          elevation: 3.0,
                          fillColor: dark?MColor.event2:MColor.event1,
                          child: Center(
                            child: Text(trans(context, "s2"), style: TextStyle(fontSize: 24, color: Colors.white),textAlign: TextAlign.center,)
                          )
                          );}),
                Container(height: 5),
                           RawMaterialButton(onPressed: back2,
                          shape:new RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          constraints: BoxConstraints.tight(Size(210 , 40)),
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
        backgroundColor: dark?MColor.event2:MColor.event1,
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
            width: 380,
            height: 40,
              decoration: BoxDecoration(
                color:  dark?MColor.event2:MColor.event1,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: Icon(
                      Icons.alternate_email,
                      color: Colors.white
                    ),
                  ),
                  Container(
                    width: 10
                  ),
                  Center(child:SizedBox(
                    width: 300,
                    height: 36,
                    child: Center(child: Text(email, style: TextStyle(fontSize: 21, color: Colors.white),textAlign: TextAlign.left,)),
                  ))
                ]
              ),)
            ),

            Container(height: 50),
            GestureDetector(
              onTap: ((){
                FirebaseAuth.instance.signOut().then((value){
                  Navigator.pop(context);
                  widget.state.update();
                });
              }),
              child: Container(
            width: 380,
            height: 40,
              decoration: BoxDecoration(
                color:  dark?MColor.event2:MColor.event1,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              
                  child: Center(child:SizedBox(
                    width: 300,
                    height: 36,
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
        backgroundColor: dark?MColor.event2:MColor.event1,
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
                width: 340, height: 90,
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
                          constraints: BoxConstraints.tight(Size(380 , 40)),
                          elevation: 3.0,
                          fillColor: dark?MColor.event2:MColor.event1,
                          child: Center(
                            child: Text(trans(context, "o8"), style: TextStyle(fontSize: 24, color: Colors.white),textAlign: TextAlign.center,)
                          )
                          ),
                Container(height: 5),
                           RawMaterialButton(onPressed: back,
                          shape:new RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          constraints: BoxConstraints.tight(Size(210 , 40)),
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
extension on DateTime{

  DateTime roundDown({Duration delta = const Duration(seconds: 15)}){
    return DateTime.fromMillisecondsSinceEpoch(
        this.millisecondsSinceEpoch -
        this.millisecondsSinceEpoch % delta.inMilliseconds
    );
  }
}


  
