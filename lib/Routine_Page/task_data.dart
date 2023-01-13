import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data.dart';
import 'dart:collection';
import 'package:intl/intl.dart';



class TaskData extends ChangeNotifier{

  Timer timer;
  DateTime now ;
  var timeFormat ;
  int time = 0;
  int sharedTime = 0;

  // _getTime() async {
  //   loginData = await SharedPreferences.getInstance();
  // DateTime now = DateTime.now();
  // timeFormat = DateFormat('HH').format(now);
  // time = int.parse(timeFormat.toString());
  // print("the time is $time");
  // loginData.setInt('time', time);
  //   autoTime();
  // }

  // getTime() async {
  //   loginData = await SharedPreferences.getInstance();
  //   sharedTime  = loginData.getInt('ti') ?? 0;
  //   print("the time is sharedTime  $sharedTime");
  // }

  ThemeMode _themeMode;
  SharedPreferences loginData;

  ThemeMode dar = ThemeMode.dark;
  ThemeMode lig = ThemeMode.light;
  ThemeMode sys = ThemeMode.system;
  ThemeMode aud ;


  _time() {
    //ignore:avoid_print
    //print(" 2.2 im printing time in getime state");
    DateTime now = DateTime.now();
    timeFormat = DateFormat('HH').format(now);
    time = int.parse(timeFormat.toString());
    //ignore:avoid_print
    //print("time is $time");
  }


  TaskData(int darkValue , int darkTime) {

    _time();

    // if(_themeMode == null){
    //   print(" im no more of _themeMode");
    //   //_getTime();
    // }

    if(darkValue == 3){
      // getTime();
      sharedTime = time;
      //print("im inisde the if loop ");
      // print("time is $sharedTime");
      if((sharedTime >= 18)||(sharedTime <= 7)){
        //print("im inside the if dark value = 3");
        aud = ThemeMode.dark;
      }else{
        //print("im inside the ******** else ******* of aud");
        aud = ThemeMode.light;
      }
    }


    //ignore:avoid_print
    //print("the theme provider value is $darkValue  @@@@@@@@@@@@@@2");
    _themeMode = (darkValue == 0)? sys : (darkValue == 1) ? lig :(darkValue == 2) ? dar : aud;
    //ignore:avoid_print
    //print("%%%%%%%%%%%%%%%%%%%%  $_themeMode ");

  }
  // autoTime() async {
  //   if((loginData.getInt('time') >= 18)||(loginData.getInt('time') <= 7))
  //   {
  //
  //     aud = dar;
  //     //ignore:avoid_print
  //     await loginData.setInt("darValue", 3);
  //   }else{
  //     //ignore:avoid_print
  //     //print("this . $_themeMode");
  //     //ignore:avoid_print
  //     //print("this is time  ------------- of else");
  //     //_themeMode = lig;
  //     aud = lig;
  //     //ignore:avoid_print
  //     //print("this is time  ------------- of else aud is $aud");
  //     await loginData.setInt("darValue", 3);
  //   }
  //   return aud;
  // }

  Future<void> swapTheme() async {
    loginData = await SharedPreferences.getInstance();

    if(loginData.getInt("val") == 0){
      // ignore:avoid_print
      //print("inside the iff off swap theme ${loginData.getInt("val")}");
      _themeMode = sys;
      //ignore:avoid_print
      //print("this . $_themeMode");
      await loginData.setInt("darValue", 0);
    } else if(loginData.getInt("val") == 3){
      //ignore:avoid_print
      //print("im inisde the ");
      if((loginData.getInt('time') >= 18)||(loginData.getInt('time') <= 7))
      {
        //ignore:avoid_print
        //print("this . $_themeMode");
        //ignore:avoid_print
        //print("this . ${loginData.getInt('time')}");
        //ignore:avoid_print
        //print("this is time  ------------- of iffff");
        _themeMode = dar;
        //aud = dar;
        //ignore:avoid_print
        //print("this is time  ------------- of iffff of aud is $aud");
        await loginData.setInt("darValue", 3);
      }else{
        //ignore:avoid_print
        //print("this . $_themeMode");
        //ignore:avoid_print
        //print("this is time  ------------- of else");
        _themeMode = lig;
        //aud = lig;
        //ignore:avoid_print
        //print("this is time  ------------- of else aud is $aud");
        await loginData.setInt("darValue", 3);
      }
    }


    //print("above swaptheme $_themeMode");
    if((_themeMode == dar)&&(loginData.getInt("val") == 2)) {
      // ignore: avoid_print
      //print("im inside the light of light $_themeMode");
      // ignore: avoid_print
      //print("im inside the _themeMode of light 1!!!!!!!!!!!!!!!! ");
      _themeMode = lig;
      // ignore: avoid_print
      //print("im inside the light of light $_themeMode");
      await loginData.setInt("darValue", 1);
    }else if((_themeMode == lig)&&(loginData.getInt("val") == 1)){
      //ignore:avoid_print
      //print("im inside the light of light $_themeMode");
      //ignore:avoid_print
      //print("im inside the inside the else of swap");
      _themeMode = dar;
      // ignore: avoid_print
      //print("im inside the light of dark $_themeMode");
      await loginData.setInt("darValue", 2);
    }else if(_themeMode == sys){
      //ignore:avoid_print
      if(loginData.getInt("val") == 2){
        //ignore:avoid_print
        //print("inside of if in swap ##########");
        _themeMode = lig;
        await loginData.setInt("darValue", 1);
      }else if(loginData.getInt("val") == 1)
      {
        //ignore:avoid_print
        //print("inside of else if in swap @@@@@@@@@@@@@@@");
        _themeMode = dar;
        await loginData.setInt("darValue", 2);
      }else{
        //ignore:avoid_print
        //print("inside of else in swap +++++++++++++++++" );
        _themeMode = sys;
        await loginData.setInt("darValue", 0);
      }
    }

    notifyListeners();
  }

  logout(){
    _themeMode = aud;
    //print("log out theme mode is $_themeMode ");
    notifyListeners();
  }

  ThemeMode getTheme()=> _themeMode;


  List<Task> _tasks = [

  ];

  UnmodifiableListView<Task> get tasks {
    return UnmodifiableListView(_tasks);
  }

  int get taskCount{
    return _tasks.length;
  }

  int get selectedDeviceCount{
    return DevicesSelected.length;
  }


  void addTask(String newTaskTitle) {
    final task = Task(name: newTaskTitle,);
    _tasks.add(task);
    notifyListeners();
  }

  void deleteTask(Task task){
    _tasks.remove(task);
    notifyListeners();
  }

  List DevicesSelected =[];

  void addListData(List data){
    // print("data of $data");
    // print("data of ${data.length}");
    for(int i = 0 ;i < data.length; ++i)
    {
      print(data.length);
      print(i);
      print("hiiii");
      print(data[i].length);
      print(data[i]);
      for(int j = 0 ;j < data[i].length ;j++)
      {
        print(j);
        //print("hloo");
        //print(data[i][j]);
        DevicesSelected.add(data[i][j]);
      }
      //DevicesSelected.add(data[i]);
      notifyListeners();
    }
  }
}


class MyThemes {
  static final darkTheme = ThemeData(
    splashColor: Colors.black12,
    hoverColor: Color(0xff262626),
    cardColor: Color(0xff1a1a1a),
    // scaffoldBackgroundColor: Color.fromRGBO(30, 30, 30, 0.50),
    dividerColor: Colors.grey,
    canvasColor: Color.fromRGBO(54, 54, 54, 1.0),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.black,
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.white,
    ),
    primaryColor: Color.fromRGBO(0, 0, 0, 1.0),
    //accentColor:  Color.fromRGBO(38, 42, 45, 1.0),
    accentColor: Color.fromRGBO(38, 42, 45, 1.0),
    scaffoldBackgroundColor:Color.fromRGBO(38, 42, 45, 1.0) ,
    shadowColor: Color.fromRGBO(0, 2, 0, 1.0),
    // cardColor: Color.fromRGBO(0, 0, 0, 1.0),

    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(color: Colors.white30),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
    ),
    dialogTheme: DialogTheme(titleTextStyle: TextStyle(color: Colors.white60,fontWeight: FontWeight.bold),contentTextStyle: TextStyle(color: Colors.white60),
      backgroundColor: Colors.black.withOpacity(0.9),
    ),
    //colorScheme: ColorScheme.dark(),
    backgroundColor: Color.fromRGBO(26, 28, 30, 1.0),

    textTheme:TextTheme(
      headline2: TextStyle(color: Colors.grey,fontWeight: FontWeight.w800,),
      subtitle2: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.w800,fontSize:11.0),
      headline5: TextStyle(color: Colors.white,fontWeight: FontWeight.w800,),
      subtitle1: GoogleFonts.inter(color: Colors.white,fontWeight: FontWeight.w800,fontSize:11.0),
      bodyText2: GoogleFonts.inter(fontWeight: FontWeight.w300, color: Colors.white),
      headline4: GoogleFonts.inter(color: Colors.white,fontWeight: FontWeight.w900),
      headline6: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
      //fontSize: height * 0.031,
      button: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold),
      //fontSize: height * 0.016,
      bodyText1: GoogleFonts.inter(color: Colors.white,fontWeight: FontWeight.w100,fontSize:11.0),
    ),
    iconTheme: IconThemeData(color: Colors.white),
    appBarTheme: AppBarTheme(
        backgroundColor: Color.fromRGBO(26, 28, 30, 1.0),
        titleTextStyle:  GoogleFonts.inter(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            color: Colors.white),
        iconTheme: IconThemeData(
          color: Colors.white,
        )
    ),
  );

  static final lightTheme = ThemeData(
    splashColor: Colors.white54,
    hoverColor: Color(0xffA7A9AF),
    dividerColor: Colors.white,
    canvasColor: Color.fromRGBO(214, 214, 214, 0.6),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.black,
    ),
    backgroundColor: Colors.white,
    dialogBackgroundColor: Colors.white54,
    shadowColor: Colors.grey.shade400,
    cardColor: Color(0xffE7ECEF),
    // cardColor: Colors.white70,
    primaryColor: Color.fromRGBO(240, 240, 240, 1.0),
    accentColor:  Color.fromRGBO(230, 238, 248, 1.0),
    scaffoldBackgroundColor: Color.fromRGBO(220, 229, 242, 0.9),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(color: Color.fromRGBO(164, 164, 164, 1.0)),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.grey),
      ),
    ),
    // scaffoldBackgroundColor: Colors.white,
    dialogTheme: DialogTheme(
      titleTextStyle: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold),
      contentTextStyle: TextStyle(color: Colors.black87),
      backgroundColor: Colors.white.withOpacity(0.9),
    ),

    // primaryColor: Colors.grey.shade100,
    // colorScheme: ColorScheme.light(),
    appBarTheme: AppBarTheme(
        backgroundColor:Colors.white,
        titleTextStyle:  GoogleFonts.inter(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            color: Colors.black87),
        iconTheme: IconThemeData(
          color: Colors.black38,
        )
    ),
    textTheme:TextTheme(
      headline2: TextStyle(color: Colors.grey,fontWeight: FontWeight.w800,),
      headline5: TextStyle(color: Colors.black,fontWeight: FontWeight.w800,),
      subtitle1: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.w800,fontSize:11.0),
      bodyText2:  GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.black),
      button: GoogleFonts.inter( color: Color.fromRGBO(62, 62, 62, 0.5), fontWeight: FontWeight.bold),
      //fontSize: height * 0.016,
      headline6: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
      headline4: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.w900),
      //fontSize: height * 0.031,
      subtitle2: GoogleFonts.inter(color: Colors.black,fontWeight: FontWeight.w500,fontSize:11.0),
      bodyText1: GoogleFonts.inter(color: Colors.white,fontWeight: FontWeight.w800,fontSize:11.0),
    ),//163, 163, 163, 1.0
    iconTheme: IconThemeData(color: Colors.black),
  );
}

