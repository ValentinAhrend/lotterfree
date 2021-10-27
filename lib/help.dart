import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lotterfree/AppLocalizations.dart';
import 'package:lotterfree/MColor.dart';

class Help extends StatefulWidget {
  @override
  _HelpState createState() => _HelpState();
}

String trans(BuildContext _c, String _key){
  
    return AppLocalizations.of(_c).translate(_key);
  }

class _HelpState extends State<Help> with WidgetsBindingObserver{

  @override
  didChangePlatformBrightness(){
    dark = WidgetsBinding.instance.window.platformBrightness==Brightness.dark;
  }

  bool dark;

  var texts; 

  @override
  Widget build(BuildContext context) {
    dark = WidgetsBinding.instance.window.platformBrightness==Brightness.dark;
     double w = MediaQuery.of(context).size.width;
      double h = MediaQuery.of(context).size.height;

    texts = [trans(context, "help1"), "","","","","","",""];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: MColor.event3,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Center(child: Text(trans(context, "t4"), style: TextStyle(fontWeight: FontWeight.w400, fontSize: 29)))
          ],
        ),
        centerTitle: true,
      ),
      body: Container(
        color: dark?Colors.black:Colors.white,
        child: Center(child:SizedBox(width: w/1.05, child:ListView(
          children: <Widget>[
            Container(
              height: h/31
            ),
            Container(
              decoration: BoxDecoration(
                color: dark?Colors.black:Colors.white,
                border: Border.all(color: MColor.event1, width: 2.0),
                borderRadius: BorderRadius.circular(50.0),
                boxShadow: [
                              BoxShadow(
                                color:dark?MColor.event2.withOpacity(0.4):MColor.event1.withOpacity(0.4),
                                spreadRadius: 1,
                                blurRadius: 3,
                                
                                offset: Offset(0.5, 2), 
                                // changes position of shadow
                              ),
                ])
              ,
              child: Column(
                children: <Widget>[
                  Container(
                    height: h/36
                  ),
                  Container(
                    width: w,
                    child: Text(trans(context, "help1head"), textAlign: TextAlign.center,style: TextStyle(color: MColor.event1, fontSize: 19),)
                  ),
                  Container(
                    height: h/41
                  ),
                  Container(
                    width: w,
                    child: Text(trans(context, "help1"), textAlign: TextAlign.center,style: TextStyle(color: MColor.event1, fontSize: 19),)
                  )
                ]
              ),
            ),
            Container(
              height: h/31
            ),
            Container(
              decoration: BoxDecoration(
                color: dark?Colors.black:Colors.white,
                border: Border.all(color: MColor.event1, width: 2.0),
                borderRadius: BorderRadius.circular(50.0),
                boxShadow: [
                              BoxShadow(
                                color:dark?MColor.event2.withOpacity(0.4):MColor.event1.withOpacity(0.4),
                                spreadRadius: 1,
                                blurRadius: 3,
                                
                                offset: Offset(0.5, 2), 
                                // changes position of shadow
                              ),
                ])
              ,
              child: Column(
                children: <Widget>[
                  Container(
                    height: h/36
                  ),
                  Container(
                    width: w,
                    child: Text(trans(context, "help2head"), textAlign: TextAlign.center,style: TextStyle(color: MColor.event1, fontSize: 19),)
                  ),
                  Container(
                    height: h/41
                  ),
                  Container(
                    width: w,
                    child: Text(trans(context, "help2"), textAlign: TextAlign.center,style: TextStyle(color: MColor.event1, fontSize: 19),)
                  )
                ]
              ),
            ),
            Container(
              height: h/31
            ),
            Container(
              decoration: BoxDecoration(
                color: dark?Colors.black:Colors.white,
                border: Border.all(color: MColor.event1, width: 2.0),
                borderRadius: BorderRadius.circular(50.0),
                boxShadow: [
                              BoxShadow(
                                color:dark?MColor.event2.withOpacity(0.4):MColor.event1.withOpacity(0.4),
                                spreadRadius: 1,
                                blurRadius: 3,
                                
                                offset: Offset(0.5, 2), 
                                // changes position of shadow
                              ),
                ])
              ,
              child: Column(
                children: <Widget>[
                  Container(
                    height: h/36
                  ),
                  Container(
                    width: w,
                    child: Text(trans(context, "help3head"), textAlign: TextAlign.center,style: TextStyle(color: MColor.event1, fontSize: 19),)
                  ),
                  Container(
                    height: h/41
                  ),
                  Container(
                    width: w,
                    child: Text(trans(context, "help3"), textAlign: TextAlign.center,style: TextStyle(color: MColor.event1, fontSize: 19),)
                  )
                ]
              ),
            ),
            Container(
              height: h/31
            ),
            Container(
              decoration: BoxDecoration(
                color: dark?Colors.black:Colors.white,
                border: Border.all(color: MColor.event1, width: 2.0),
                borderRadius: BorderRadius.circular(50.0),
                boxShadow: [
                              BoxShadow(
                                color:dark?MColor.event2.withOpacity(0.4):MColor.event1.withOpacity(0.4),
                                spreadRadius: 1,
                                blurRadius: 3,
                                
                                offset: Offset(0.5, 2), 
                                // changes position of shadow
                              ),
                ])
              ,
              child: Column(
                children: <Widget>[
                  Container(
                    height: h/36
                  ),
                  Container(
                    width: w,
                    child: Text(trans(context, "help4head"), textAlign: TextAlign.center,style: TextStyle(color: MColor.event1, fontSize: 19),)
                  ),
                  Container(
                    height: h/41
                  ),
                  Container(
                    width: w,
                    child: Text(trans(context, "help4"), textAlign: TextAlign.center,style: TextStyle(color: MColor.event1, fontSize: 19),)
                  )
                ]
              ),
            ),
            Container(
              height: h/31
            ),
            Container(
              decoration: BoxDecoration(
                color: dark?Colors.black:Colors.white,
                border: Border.all(color: MColor.event1, width: 2.0),
                borderRadius: BorderRadius.circular(50.0),
                boxShadow: [
                              BoxShadow(
                                color:dark?MColor.event2.withOpacity(0.4):MColor.event1.withOpacity(0.4),
                                spreadRadius: 1,
                                blurRadius: 3,
                                
                                offset: Offset(0.5, 2), 
                                // changes position of shadow
                              ),
                ])
              ,
              child: Column(
                children: <Widget>[
                  Container(
                    height: h/36
                  ),
                  Container(
                    width: w,
                    child: Text(trans(context, "help5head"), textAlign: TextAlign.center,style: TextStyle(color: MColor.event1, fontSize: 19),)
                  ),
                  Container(
                    height: h/41
                  ),
                  Container(
                    width: w,
                    child: Text(trans(context, "help5"), textAlign: TextAlign.center,style: TextStyle(color: MColor.event1, fontSize: 19),)
                  )
                ]
              ),
            ),
            Container(
              height: h/31
            ),
            Container(
              decoration: BoxDecoration(
                color: dark?Colors.black:Colors.white,
                border: Border.all(color: MColor.event1, width: 2.0),
                borderRadius: BorderRadius.circular(50.0),
                boxShadow: [
                              BoxShadow(
                                color:dark?MColor.event2.withOpacity(0.4):MColor.event1.withOpacity(0.4),
                                spreadRadius: 1,
                                blurRadius: 3,
                                
                                offset: Offset(0.5, 2), 
                                // changes position of shadow
                              ),
                ])
              ,
              child: Column(
                children: <Widget>[
                  Container(
                    height: h/36
                  ),
                  Container(
                    width: w,
                    child: Text(trans(context, "help7head"), textAlign: TextAlign.center,style: TextStyle(color: MColor.event1, fontSize: 19),)
                  ),
                  Container(
                    height: h/41
                  ),
                  Container(
                    width: w,
                    child: Text(trans(context, "help7"), textAlign: TextAlign.center,style: TextStyle(color: MColor.event1, fontSize: 19),)
                  )
                ]
              ),
            ),
            Container(
              height: h/31
            ),
            Container(
              decoration: BoxDecoration(
                color: dark?Colors.black:Colors.white,
                border: Border.all(color: MColor.event1, width: 2.0),
                borderRadius: BorderRadius.circular(50.0),
                boxShadow: [
                              BoxShadow(
                                color:dark?MColor.event2.withOpacity(0.4):MColor.event1.withOpacity(0.4),
                                spreadRadius: 1,
                                blurRadius: 3,
                                
                                offset: Offset(0.5, 2), 
                                // changes position of shadow
                              ),
                ])
              ,
              child: Column(
                children: <Widget>[
                  Container(
                    height: h/36
                  ),
                  Container(
                    width: w,
                    child: Text(trans(context, "help8head"), textAlign: TextAlign.center,style: TextStyle(color: MColor.event1, fontSize: 19),)
                  ),
                  Container(
                    height: h/41
                  ),
                  Container(
                    width: w,
                    child: Text(trans(context, "help8"), textAlign: TextAlign.center,style: TextStyle(color: MColor.event1, fontSize: 19),)
                  )
                ]
              ),
            ),
          ]
        ),
      )))
    );
  }
}