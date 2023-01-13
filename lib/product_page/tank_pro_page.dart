import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // package
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart'; // package
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import '../log_ins/login_page.dart';
import '../settingsPage/family_members_adding_page.dart';
import 'package:http/http.dart' as http;// package


FirebaseAuth auth = FirebaseAuth.instance;

final databaseReference = FirebaseDatabase.instance.reference();


class TankPro extends StatefulWidget {
  final String deviceName;
  const TankPro({Key key, this.deviceName}) : super(key: key);

  @override
  State<TankPro> createState() => _TankProState();
}

class _TankProState extends State<TankPro> {

  bool status = false;
  Timer timer ;
  SharedPreferences loginData ;
  int waterLevel = 0;
  String authKey = " ";
  var dataJson;
  var waterTankAutomation;
  var deviceCount;
  String userName = " ";
  String email = " ";
  String phoneNumber = " ";
  var personalDataJson;
  bool owner = false;
  var ownerId;
  var ownerData;
  int count = 0;
  int id = 0;
  int savedIdValue = 0;

  personalData(){
    databaseReference.child(auth.currentUser.uid).once().then((value) async{
      personalDataJson = value.snapshot.value;
      userName = personalDataJson["name"];
      email = personalDataJson['email'];
      phoneNumber = personalDataJson['phone'].toString();
    });
  }

  firstProcess(){
    databaseReference.child('family').once().then((value) async{
      value.snapshot.children.forEach((element) {
        ownerId = element.value;
        if(element.key == auth.currentUser.uid){
          setState((){
            authKey = ownerId['owner-uid'];
            fireData();
          });
        }
      });
      if((authKey == " ")||(authKey == null)){
        setState((){
          authKey = auth.currentUser.uid;
        });
        fireData();
      }
    });
  }

  Future<void> fireData() async {
    loginData = await SharedPreferences.getInstance();
    databaseReference.child(auth.currentUser.uid).once().then((snapshot){
      ownerData = snapshot.snapshot.value;
      setState(() {
        owner = ownerData['owner'];
      });
    });
    databaseReference.child(authKey).child('WaterTankAutomation').once().then((snapshot) async {
      snapshot.snapshot.children.forEach((element) {
        dataJson = element.value;
        deviceCount = element.key;
         setState((){
           // waterLevel = dataJson['level'];
           // status = dataJson['status'];
           // waterTankAutomation = dataJson;
           // id = dataJson['id'];
           waterLevel = dataJson['Water_Level'];
           status = dataJson['status'];
           // loginData.setInt('wtaId', id);
           // setData();
         });
      });
    });
  }

  // setData(){
  //   setState((){
  //     savedIdValue = loginData.getInt('wtaId')??0;
  //     if((savedIdValue == 0)||(savedIdValue == null)){
  //       firstProcess();
  //     }else{
  //       readData();
  //     }
  //   });
  // }
  //
  // readData() async {
  //   final response = await http.get(Uri.parse("http://54.221.145.162/wta/$savedIdValue"));
  //   var val = jsonDecode(response.body);
  //   // print(val);
  //   setState(()
  //   {
  //     waterLevel = val['Water_Level'];
  //     status = val['Device_Status'];
  //   });
  // }


  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  @override
  void initState() {

    personalData();
    // firstProcess();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t)
    {
      firstProcess();
      // setData();
      // check().then((internet) {
      //   if (internet) {
      //     firstProcess();
      //     setState((){
      //       count = 0;
      //     });
      //   }else {
      //     if(count == 0){
      //       setState((){
      //         count = 1;
      //       });
      //       showDialog(
      //           context: context,
      //           builder: (_) => AlertDialog(
      //             backgroundColor: Colors.black,
      //             title: Text(
      //               "No Internet Connection",
      //               style: TextStyle(color: Colors.white),
      //             ),
      //             content: Text("Please check your Internet Connection",
      //                 style: TextStyle(color: Colors.white)),
      //           ));
      //     }
      //   }
      // });
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      drawerEnableOpenDragGesture: false,
      endDrawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
             DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
              ), //BoxDecoration
              child: UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.lightBlueAccent),
                accountName: Text(
                  userName,
                  style: TextStyle(fontSize: 18),
                ),
                accountEmail: Text(email),
                currentAccountPictureSize: Size.square(40),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white54,
                  child: Icon(Icons.person_sharp),
                ), //circleAvatar
              ), //UserAccountDrawerHeader
            ), //DrawerHeader
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(' My Profile ',
                style: GoogleFonts.inter(
                    fontSize: height*0.018,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.wb_sunny_rounded),
              title: Text(' Themes ',
                style: GoogleFonts.inter(
                  fontSize: height*0.018,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            owner ? ListTile(
              leading: const Icon(Icons.group_add),
              title: Text(' Add Family ',
                style: GoogleFonts.inter(
                  fontSize: height*0.018,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),),
              onTap: () {
                setState((){
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => FamilyMembersPage()));
                });
              },
            ):Container(),
            ListTile(
              leading: const Icon(Icons.vibration),
              title: Text(' Vibration ',style: GoogleFonts.inter(
                  fontSize: height*0.018,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications_active_rounded),
              title: Text(' Sound ',
                style: GoogleFonts.inter(
                    fontSize: height*0.018,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text('LogOut',
                style: GoogleFonts.inter(
                    fontSize: height*0.018,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),),
              onTap: ()async{
                loginData.setBool('login', true);
                  auth.signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
          ],
        ),
      ),
      body: Container(
        height: height*1.0,
        width: width*1.0,
        child: Stack(
          children: [
            Positioned(
                top: height * -0.02,
                left: width * 0.0,
                right: width * -0.5,
                child: Column(
                  children: [
                    Image.asset(
                      "images/white_tank.png",
                      scale: 0.7,
                    )
                  ],
                )),
            Positioned(
              top: height * 0.04,
              left: width * 0.04,
              right: width * 0.03,
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.deviceName,
                    style: GoogleFonts.inter(
                        fontSize: height*0.030,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                        onPressed: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                        icon: CircleAvatar(
                          backgroundColor: Colors.black26,
                          child: Icon(
                            Icons.person_sharp,
                            color: Colors.white,
                            size: height * 0.025,
                          ),
                        )
                    );
                  },
                  )
                ],
              ),
            ),
            Positioned(
              top: height * 0.34,
              left: width * 0.06,
              right: width * 0.06,
              child: Container(
                padding: EdgeInsets.all(30),
                height: height * 0.37,
                decoration: BoxDecoration(
                  color: Colors.white,
                  // color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black87,
                      offset: Offset(6.0, 6.0),
                      blurRadius: 30,
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(-4.0, -4.0),
                      blurRadius: 30,
                      spreadRadius: 15,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.deviceName,
                      style: GoogleFonts.inter(
                          fontSize: height*0.018,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    SizedBox(
                      height: height * 0.035,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          // height: 290.0,
                          // width: 120.0,
                          height: height * 0.24,
                          width: width * 0.29,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  colors: [
                                    Colors.white10,
                                    Colors.black12
                                    ,
                                  ],
                                  stops: [
                                    0.1,
                                    0.9
                                  ]),
                              borderRadius: BorderRadius.circular(20.0)),
                          child: LiquidLinearProgressIndicator(
                            value: waterLevel/100,
                            // Defaults to 0.5.
                            valueColor: AlwaysStoppedAnimation(
                              Color.fromRGBO(91, 156, 190, 1.0),
                            ),
                            // Defaults to the current Theme's accentColor.
                            backgroundColor: Colors.transparent,
                            // Defaults to the current Theme's backgroundColor.
                            borderColor: Colors.black12,
                            borderWidth: 0.30,
                            borderRadius: 20.0,
                            direction: Axis.vertical,
                            // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                            // center: Text(
                            //   "$waterLevel %",
                            //   style: GoogleFonts.inter(
                            //       color: Colors.grey.shade50, fontSize: 20.0),
                            // ),
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "$waterLevel",
                                     style: TextStyle(color: Colors.black,fontSize: height*0.070,fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    " %" ,
                                    style: GoogleFonts.inter(
                                      fontSize: height * 0.025,
                                      color: Colors.black,

                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              Text(
                                "of water is available in tank",
                                style: TextStyle(color: Colors.black,fontSize: height*0.011),
                                  textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),

                      ],
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: height * 0.8,
              left: width * 0.15,
              right: width * 0.15,
              child: ConfirmationSlider(
                backgroundShape: BorderRadius.circular(50),
                height: height * 0.08,
                width: width * 0.7,
                text: status == true ? 'Slide to Off': 'Slide to On',
                textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, color: Colors.black),
                backgroundColorEnd: Colors.white,
                backgroundColor: Colors.white,
                shadow: BoxShadow(spreadRadius: 0.15,color: Colors.grey),
                sliderButtonContent: Icon(
                  Icons.power_settings_new_rounded,
                  color: Colors.white54,
                ),
                foregroundColor: Color(0xff374957),
                onConfirmation: () => setState(() {
                  // status = !status;
                  databaseReference.child(authKey).child('WaterTankAutomation').child(deviceCount).update({
                    'status': !status,
                  });
                  // http.put(
                  //   Uri.parse('http://54.221.145.162/wta/$savedIdValue/'),
                  //   headers: <String, String>{
                  //     'Content-Type':
                  //     'application/json; charset=UTF-8',
                  //   },
                  //   body: jsonEncode(<String, bool>{
                  //     "Device_Status": !status,
                  //   }),
                  // );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}