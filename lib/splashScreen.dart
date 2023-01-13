import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:onwords_home/log_ins/login_page.dart';
import 'package:onwords_home/product_page/device_pages.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';
import 'log_ins/new_user_page.dart';

FirebaseAuth auth = FirebaseAuth.instance;

final databaseReference = FirebaseDatabase.instance.reference();

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> with TickerProviderStateMixin{
  bool isLoggedIn = false;
  AnimationController _controller;
  final QuickActions quickActions = QuickActions();
  String authKey = " ";
  var ownerId;
  SharedPreferences loginData;
  var dataJson;
  var personalDataJson;
  bool smartHome = false;
  bool home = false;
  bool wta = false;
  bool gate = false;
  String userName = " ";
  String email = " ";
  String phoneNumber = " ";

  firstProcess() async {
    // databaseReference.child('family').once().then((value){
    //   value.snapshot.children.forEach((element) {
    //      ownerId = element.value;
    //       if(element.key == auth.currentUser.uid){
    //         setState((){
    //           authKey = ownerId['owner-uid'];
    //           fireData();
    //         });
    //       }
    //   });
    //   fireData();
    // });
    loginData = await SharedPreferences.getInstance();
    databaseReference.child('family').once().then((value) async{
      for (var element in value.snapshot.children){
        ownerId = element.value;
        if(element.key == auth.currentUser.uid){
          loginData.setString('ownerId', ownerId['owner-uid']);
          setState(() {
            authKey = loginData.getString('ownerId');
          });
          break;
        }else{
          var val = auth.currentUser.uid;
          loginData.setString('ownerId',val);
          setState(() {
            authKey = loginData.getString('ownerId');
          });
        }
      }
    }).then((value) => fireData());
  }

  fireData(){
    // if(authKey == " "){
    //   setState((){
    //     authKey = auth.currentUser.uid;
    //   });
    //   databaseReference.child(authKey).once().then((snapshot){
    //     dataJson = snapshot.snapshot.value;
    //     setState(() {
    //       smartHome = dataJson['homeAutomate'];
    //       // print(smartHome);
    //       // loginData.setBool('home', smartHome);
    //       // loginData.setBool('wta', dataJson['WTA']);
    //       // loginData.setBool('gate', dataJson['Gate']);
    //       home = smartHome??false;
    //       // print(home);
    //       wta = dataJson['WTA']??false;
    //       gate = dataJson['Gate']??false;
    //       loginData.setBool('home', home);
    //       loginData.setBool('wta', wta);
    //       loginData.setBool('gate', gate);
    //     });
    //   }).then((value) {
    //     dependsActions();
    //   });
    // }else{
    // print(authKey);
      databaseReference.child(authKey).once().then((snapshot){
        dataJson = snapshot.snapshot.value;
        setState(() {
          smartHome = dataJson['homeAutomate']??false;
          // if(smartHome == null){
          //   print("smart home $smartHome ");
          //   fireData();
          // }
          // loginData.setBool('home', smartHome);
          // loginData.setBool('wta', dataJson['WTA']);
          // loginData.setBool('gate', dataJson['Gate']);
          home = smartHome??false;
          wta = dataJson['WTA']??false;
          gate = dataJson['Gate']??false;
          // loginData.setBool('home', smartHome);
          loginData.setBool('home', home);
          loginData.setBool('wta', wta);
          loginData.setBool('gate', gate);
        });
      }).then((value) {
        dependsActions();
      });
    // }
  }

  dependsActions(){
    if(home){
      handleQuickActions();
      setupQuickActions();
    }else{
      if((wta==false)&&(gate==false))
        {
          // print("nothing");
        }else
        {
        productQuickActions();
        productSetUpQuickActions();
      }
    }
  }

  setupQuickActions(){
    quickActions.setShortcutItems([
      // const ShortcutItem(
      //   type: 'home',
      //   localizedTitle: 'Home Page',
      //   icon: 'icon_home',
      // ),
      const ShortcutItem(
        type: 'dashboard',
        localizedTitle: 'DashBoard',
        icon: 'icon_dash',
      ),
      const ShortcutItem(
          type: 'routine',
          localizedTitle: 'Routines',
          icon: 'icon_routine'),

      const ShortcutItem(
          type: 'settings',
          localizedTitle: 'Settings',
          icon: 'icon_settings'),

      // const ShortcutItem(
      //     type: 'theme',
      //     localizedTitle: 'Themes',
      //     icon: 'icon_theme'),
    ]);
  }

  handleQuickActions(){
    quickActions.initialize((shortcutType) {
      setState(() {
        // if(shortcutType == "home"){
        //   // Navigator.push(context, MaterialPageRoute(builder: (context)=>FirstPage()));
        //   Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
        //   //Get.to(MyHomePage());
        // }else
        if (shortcutType == "dashboard") {
          //Get.to(const PageOneDemo());
          // Navigator.push(context, MaterialPageRoute(builder: (context)=>SecondDashBoard()));
          Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage(index: 1,)));
        }else if(shortcutType == "routine"){
          //Get.to(const PageTwoDemo());
          // Navigator.push(context, MaterialPageRoute(builder: (context)=> RoutinePage()));
          Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage(index: 2,)));
        }else if(shortcutType == "settings"){
          //Get.to(const PageTwoDemo());
          Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage(index: 3,)));
        }
        // else if(shortcutType == "theme"){
        //   //Get.to(const PageTwoDemo());
        //   Navigator.push(context, MaterialPageRoute(builder: (context)=> DummySettingsPage()));
        // }
      });
    });
  }

  productQuickActions(){
    quickActions.initialize((shortcutType) {
      setState(() {
        if (shortcutType == "device") {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>DevicePages(wta: wta,gate: gate,)));
        }
      });
    });
  }

  productSetUpQuickActions(){
    quickActions.setShortcutItems([
      const ShortcutItem(
          type: 'device',
          localizedTitle: 'Devices',
          icon: 'icon_device'),
    ]);
  }

  initial() async {
      loginData = await SharedPreferences.getInstance();
      setState(() {
        isLoggedIn = loginData.getBool('login') ?? true;
        home = loginData.getBool('home');
        wta = loginData.getBool('wta');
        gate = loginData.getBool('gate');
      });
      if(home==null){
        fireData();
      }
    }

  @override
  void initState() {
    firstProcess();
    initial();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    super.initState();
  }

  _navigateUser(){
    if(!isLoggedIn){
      if(home != null){
        if(home){
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomePage()));
        }else{
          if((wta == false)&&(gate==false))
          {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => NewUserPage()));
          }else{
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => DevicePages(wta: wta,gate: gate,)));
          }

        }
      }else{
        // print("smatttttt $home ");
        //fireData();
      }
    }else{
      Navigator.pushReplacement(
          context,MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor:  Colors.white,
      // backgroundColor:  Theme.of(context).backgroundColor,
        body: Container(
          height: height*1.0,
          width: width*1.0,
            child: Center(
          child: Lottie.asset(
          'images/ps logo.json',
          controller: _controller,
          height: MediaQuery.of(context).size.height * 1.0,
          width: width*1.0,
          animate: true,
          onLoaded: (composition) {
            _controller..duration = composition.duration..forward().whenComplete((){
              _navigateUser();
            });
          },
          ),
        ),
        ),
    );
  }
}