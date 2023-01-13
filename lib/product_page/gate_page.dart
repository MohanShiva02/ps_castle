import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../log_ins/login_page.dart';
import '../settingsPage/family_members_adding_page.dart';


FirebaseAuth auth = FirebaseAuth.instance;

final databaseReference = FirebaseDatabase.instance.reference();


class GateLock extends StatefulWidget {
  final String deviceName;
  const GateLock({Key key, this.deviceName}) : super(key: key);

  @override
  State<GateLock> createState() => _GateLockState();
}

class _GateLockState extends State<GateLock> {
  bool closePressed  =false;
  bool openPressed  =false;
  bool pausePressed  =false;
  int count = 0 ;
  SharedPreferences loginData ;
  String ip ;
  var data ;
  var dataJson;
  String authKey = " ";
  var ownerId;
  var personalDataJson;
  bool openGate = false;
  bool closeGate = false;
  bool pauseGate = false;
  String userName = " ";
  String email = " ";
  String phoneNumber = " ";
  var deviceCount;
  Timer timer ;
  bool owner = true;
  var ownerData;
  int id = 0;
  int savedIdValue = 0;
  bool cycle = false;
  String gateType = " ";
  bool gateStatus = false;
  bool singleGateStatus = false;
  bool slideCycle = false;
  bool rollerCycle = false;



  personalData(){
    databaseReference.child(auth.currentUser.uid).once().then((value) async{
      personalDataJson = value.snapshot.value;
      userName = personalDataJson["name"];
      email = personalDataJson['email'];
      phoneNumber = personalDataJson['phone'].toString();
    });
  }

  firstProcess(){
    databaseReference.child('family').once().then((value){
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
    databaseReference.child(authKey).child('GateAutomation').once().then((snapshot) async {
      snapshot.snapshot.children.forEach((element) {
        dataJson = element.value;
        deviceCount = element.key;
        setState((){
          // openGate = dataJson['open'];
          // pauseGate = dataJson['pause'];
          // closeGate = dataJson['close'];
          // id = dataJson['id'];
          openGate = dataJson['Open'];
          pauseGate = dataJson['Pause'];
          closeGate = dataJson['Close'];
          gateType = dataJson['Gate_Type'];
          gateStatus = dataJson['Gate_Status'];
          cycle = dataJson['Cycle'];
          singleGateStatus = dataJson['Single_Gate_Status'];
          // loginData.setInt('gateId', id);
          // setData();
        });
      });
    });
  }

  // setData() async {
  //   loginData = await SharedPreferences.getInstance();
  //   setState((){
  //     savedIdValue = loginData.getInt('gateId')??0;
  //     if((savedIdValue == 0)||(savedIdValue == null)){
  //       firstProcess();
  //     }else{
  //       readData();
  //     }
  //   });
  // }
  //
  //
  // readData() async {
  //   final response = await http.get(Uri.parse("http://54.221.145.162/gate/$savedIdValue"));
  //   var val = jsonDecode(response.body);
  //   // print(val);
  //   setState(()
  //   {
  //     openGate = val['Open'];
  //     pauseGate = val['Pause'];
  //     closeGate = val['Close'];
  //     gateType = val['Gate_Type'];
  //     gateStatus = val['Gate_Status'];
  //     cycle = val['Cycle'];
  //     singleGateStatus = val['Single_Gate_Status'];
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
    firstProcess();
    // setData();
    // timer = Timer.periodic(Duration(seconds: 1), (Timer t)
    // {
    //   setData();
    //   // check().then((internet) {
    //   //   if (internet) {
    //   //     setData();
    //   //     setState((){
    //   //       count = 0;
    //   //     });
    //   //   }else {
    //   //     if(count == 0){
    //   //       setState((){
    //   //         count = 1;
    //   //       });
    //   //       showDialog(
    //   //           context: context,
    //   //           builder: (_) => AlertDialog(
    //   //             backgroundColor: Colors.black,
    //   //             title: Text(
    //   //               "No Internet Connection",
    //   //               style: TextStyle(color: Colors.white),
    //   //             ),
    //   //             content: Text("Please check your Internet Connection",
    //   //                 style: TextStyle(color: Colors.white)),
    //   //           ));
    //   //     }
    //   //   }
    //   // });
    // });
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
                top: height * -0.08,
                left: width * 0.0,
                right: width * -0.3,
                child: Column(
                  children: [
                    Image.asset(
                      "images/gate.png",
                      scale: 0.6,
                    )
                  ],
                )),
            Positioned(
              top: height * 0.04,
              left: width * 0.04,
              right: width * 0.04,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.deviceName,
                    style: GoogleFonts.inter(
                        fontSize: 30.0,
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
              top: height * 0.30,
              left: width * 0.06,
              right: width * 0.06,
              child: Container(
                padding: EdgeInsets.all(15),
                height: height * 0.40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(0.0, 0.0),
                      blurRadius: 30,
                      spreadRadius: 1,
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
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Text(
                      widget.deviceName,
                      style: GoogleFonts.inter(
                          fontSize: height*0.022,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    SizedBox(
                      height: height * 0.06,
                    ),
                    if(gateType == "Slider")
                        cycle == false?Container(
                          height: height * 0.18,
                          width: width * double.infinity,
                          margin: EdgeInsets.all(10.0),
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(214, 214, 214, 0.6),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    openPressed = !openPressed;
                                    databaseReference.child(authKey).child('GateAutomation').child(deviceCount).update({
                                      'Open': true,
                                    });
                                    // http.put(
                                    //   Uri.parse('http://54.221.145.162/gate/$savedIdValue/'),
                                    //   headers: <String, String>{
                                    //     'Content-Type':
                                    //     'application/json; charset=UTF-8',
                                    //   },
                                    //   body: jsonEncode(<String, bool>{
                                    //     "Open": true,
                                    //   }),
                                    // );
                                  });
                                },
                                child: Listener(
                                  onPointerUp: (_) => setState(() {
                                    openPressed = true;
                                  }),
                                  onPointerDown: (_) => setState(() {
                                    openPressed = true;
                                  }),
                                  child: AnimatedContainer(
                                    // height: 200,
                                    // width: 200,
                                    // duration: Duration(milliseconds: 100),
                                    decoration: BoxDecoration(
                                        // color: Theme.of(context).cardColor,
                                        color: Colors.white.withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(300),
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: openPressed ? 5.0 : 30.0,
                                            offset: openPressed ? -Offset(3, 3) : -Offset(10, 10),
                                            color: Colors.white54,
                                            // inset: openPressed,
                                          ),
                                          BoxShadow(
                                            blurRadius: openPressed ? 5.0 : 30.0,
                                            offset: openPressed ? Offset(6, 8) : Offset(10, 10),
                                            color: Color(0xffA7A9AF),
                                            // inset: openPressed,
                                            // inset: true,
                                          ),
                                        ]),
                                    duration: Duration(milliseconds: 100),
                                    child: CircleAvatar(
                                      radius:height*0.05,
                                      foregroundColor: Colors.transparent,
                                      backgroundColor: Colors.transparent,
                                      // height: height * 0.09,
                                      // width: width * 0.20,
                                      child: Center(
                                        child: Text(
                                          "Open",
                                          style:GoogleFonts.inter(
                                              fontSize: height*0.017,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    pausePressed = !pausePressed;
                                    databaseReference.child(authKey).child('GateAutomation').child(deviceCount).update({
                                      'Pause': true,
                                    });
                                    // http.put(
                                    //   Uri.parse('http://54.221.145.162/gate/$savedIdValue/'),
                                    //   headers: <String, String>{
                                    //     'Content-Type':
                                    //     'application/json; charset=UTF-8',
                                    //   },
                                    //   body: jsonEncode(<String, bool>{
                                    //     "Pause": true,
                                    //   }),
                                    // );
                                  });
                                },
                                child: Listener(
                                  onPointerUp: (_) => setState(() {
                                    pausePressed = true;
                                  }),
                                  onPointerDown: (_) => setState(() {
                                    pausePressed = true;
                                  }),
                                  child: AnimatedContainer(
                                    // height: 200,
                                    // width: 200,
                                    // duration: Duration(milliseconds: 100),
                                    decoration: BoxDecoration(
                                        // color: Theme.of(context).cardColor,
                                        color: Colors.white.withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(300),
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: pausePressed ? 5.0 : 30.0,
                                            offset: pausePressed ? -Offset(3, 3) : -Offset(10, 10),
                                            color: Colors.white54,
                                            // inset: pausePressed,
                                          ),
                                          BoxShadow(
                                            blurRadius: pausePressed ? 5.0 : 30.0,
                                            offset: pausePressed ? Offset(6, 8) : Offset(10, 10),
                                            color: Color(0xffA7A9AF),
                                            // inset: pausePressed,
                                            // inset: true,
                                          ),
                                        ]),
                                    duration: Duration(milliseconds: 100),
                                    child: CircleAvatar(
                                      radius: height*0.05,
                                      foregroundColor: Colors.transparent,
                                      backgroundColor: Colors.transparent,
                                      // height: height * 0.09,
                                      // width: width * 0.20,
                                      child: Center(
                                        child: Text(
                                          "Pause",
                                          style:GoogleFonts.inter(
                                              fontSize: height*0.017,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    closePressed = !closePressed;
                                    databaseReference.child(authKey).child('GateAutomation').child(deviceCount).update({
                                      'Close': true,
                                    });
                                    // http.put(
                                    //   Uri.parse('http://54.221.145.162/gate/$savedIdValue/'),
                                    //   headers: <String, String>{
                                    //     'Content-Type':
                                    //     'application/json; charset=UTF-8',
                                    //   },
                                    //   body: jsonEncode(<String, bool>{
                                    //     "Close": true,
                                    //   }),
                                    // );
                                  });
                                },
                                child: Listener(
                                  onPointerUp: (_) => setState(() {
                                    closePressed = true;
                                  }),
                                  onPointerDown: (_) => setState(() {
                                    closePressed = true;
                                  }),
                                  child: AnimatedContainer(
                                    // height: 200,
                                    // width: 200,
                                    // duration: Duration(milliseconds: 100),
                                    decoration: BoxDecoration(
                                        // color: Theme.of(context).cardColor,
                                        color: Colors.white.withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(300),
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: closePressed ? 5.0 : 30.0,
                                            offset: closePressed ? -Offset(3, 3) : -Offset(10, 10),
                                            color: Colors.white54,
                                            // inset: closePressed,
                                          ),
                                          BoxShadow(
                                            blurRadius: closePressed ? 5.0 : 30.0,
                                            offset: closePressed
                                                ? Offset(6, 8)
                                                : Offset(10, 10),
                                            color:  Color(0xffA7A9AF),
                                            // inset: closePressed,
                                            // inset: true,
                                          ),
                                        ]),
                                    duration: Duration(milliseconds: 100),
                                    child: CircleAvatar(
                                      radius: height*0.05,
                                      foregroundColor: Colors.transparent,
                                      backgroundColor: Colors.transparent,
                                      child: Center(
                                        child: Text(
                                          "Close",
                                          style:GoogleFonts.inter(
                                              fontSize: height*0.017,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ):
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                openPressed = !openPressed;
                                databaseReference.child(authKey).child('GateAutomation').child(deviceCount).update({
                                  "Gate_Status": true,
                                });
                                // http.put(
                                //   Uri.parse('http://54.221.145.162/gate/$savedIdValue/'),
                                //   headers: <String, String>{
                                //     'Content-Type':
                                //     'application/json; charset=UTF-8',
                                //   },
                                //   body: jsonEncode(<String, bool>{
                                //     "Gate_Status": true,
                                //   }),
                                // );
                              });
                            },
                            child: Listener(
                              onPointerUp: (_) => setState(() {
                                openPressed = true;
                              }),
                              onPointerDown: (_) => setState(() {
                                openPressed = true;
                              }),
                              child: AnimatedContainer(
                                // height: 200,
                                // width: 200,
                                // duration: Duration(milliseconds: 100),
                                decoration: BoxDecoration(
                                  // color: Theme.of(context).cardColor,
                                    color: Colors.white.withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(20.0),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: openPressed ? 5.0 : 30.0,
                                        offset: openPressed ? -Offset(3, 3) : -Offset(10, 10),
                                        color: Colors.white54,
                                        // inset: openPressed,
                                      ),
                                      BoxShadow(
                                        blurRadius: openPressed ? 5.0 : 30.0,
                                        offset: openPressed ? Offset(6, 8) : Offset(10, 10),
                                        color: Color(0xffA7A9AF),
                                        // inset: openPressed,
                                        // inset: true,
                                      ),
                                    ]),
                                duration: Duration(milliseconds: 100),
                                child: Container(
                                  height:height*0.2,
                                  width:width*0.5,
                                  color: Colors.transparent,
                                  child: Center(
                                    child: Text(
                                      "Open / Pause / Close",
                                      style:GoogleFonts.inter(
                                          fontSize: height*0.014,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    if(gateType == "Roller")
                        cycle == false?Container(
                        height: height * 0.18,
                        width: width * double.infinity,
                        margin: EdgeInsets.all(10.0),
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(214, 214, 214, 0.6),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  openPressed = !openPressed;
                                  databaseReference.child(authKey).child('GateAutomation').child(deviceCount).update({
                                    "Open": true,
                                  });
                                  // http.put(
                                  //   Uri.parse('http://54.221.145.162/gate/$savedIdValue/'),
                                  //   headers: <String, String>{
                                  //     'Content-Type':
                                  //     'application/json; charset=UTF-8',
                                  //   },
                                  //   body: jsonEncode(<String, bool>{
                                  //     "Open": true,
                                  //   }),
                                  // );
                                });
                              },
                              child: Listener(
                                onPointerUp: (_) => setState(() {
                                  openPressed = true;
                                }),
                                onPointerDown: (_) => setState(() {
                                  openPressed = true;
                                }),
                                child: AnimatedContainer(
                                  // height: 200,
                                  // width: 200,
                                  // duration: Duration(milliseconds: 100),
                                  decoration: BoxDecoration(
                                    // color: Theme.of(context).cardColor,
                                      color: Colors.white.withOpacity(0.9),
                                      borderRadius: BorderRadius.circular(300),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: openPressed ? 5.0 : 30.0,
                                          offset: openPressed ? -Offset(3, 3) : -Offset(10, 10),
                                          color: Colors.white54,
                                          // inset: openPressed,
                                        ),
                                        BoxShadow(
                                          blurRadius: openPressed ? 5.0 : 30.0,
                                          offset: openPressed ? Offset(6, 8) : Offset(10, 10),
                                          color: Color(0xffA7A9AF),
                                          // inset: openPressed,
                                          // inset: true,
                                        ),
                                      ]),
                                  duration: Duration(milliseconds: 100),
                                  child: CircleAvatar(
                                    radius:height*0.05,
                                    foregroundColor: Colors.transparent,
                                    backgroundColor: Colors.transparent,
                                    // height: height * 0.09,
                                    // width: width * 0.20,
                                    child: Center(
                                      child: Text(
                                        "Open",
                                        style:GoogleFonts.inter(
                                            fontSize: height*0.017,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  pausePressed = !pausePressed;
                                  databaseReference.child(authKey).child('GateAutomation').child(deviceCount).update({
                                    "Pause": true,
                                  });
                                  // http.put(
                                  //   Uri.parse('http://54.221.145.162/gate/$savedIdValue/'),
                                  //   headers: <String, String>{
                                  //     'Content-Type':
                                  //     'application/json; charset=UTF-8',
                                  //   },
                                  //   body: jsonEncode(<String, bool>{
                                  //     "Pause": true,
                                  //   }),
                                  // );
                                });
                              },
                              child: Listener(
                                onPointerUp: (_) => setState(() {
                                  pausePressed = true;
                                }),
                                onPointerDown: (_) => setState(() {
                                  pausePressed = true;
                                }),
                                child: AnimatedContainer(
                                  // height: 200,
                                  // width: 200,
                                  // duration: Duration(milliseconds: 100),
                                  decoration: BoxDecoration(
                                    // color: Theme.of(context).cardColor,
                                      color: Colors.white.withOpacity(0.9),
                                      borderRadius: BorderRadius.circular(300),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: pausePressed ? 5.0 : 30.0,
                                          offset: pausePressed ? -Offset(3, 3) : -Offset(10, 10),
                                          color: Colors.white54,
                                          // inset: pausePressed,
                                        ),
                                        BoxShadow(
                                          blurRadius: pausePressed ? 5.0 : 30.0,
                                          offset: pausePressed ? Offset(6, 8) : Offset(10, 10),
                                          color: Color(0xffA7A9AF),
                                          // inset: pausePressed,
                                          // inset: true,
                                        ),
                                      ]),
                                  duration: Duration(milliseconds: 100),
                                  child: CircleAvatar(
                                    radius: height*0.05,
                                    foregroundColor: Colors.transparent,
                                    backgroundColor: Colors.transparent,
                                    // height: height * 0.09,
                                    // width: width * 0.20,
                                    child: Center(
                                      child: Text(
                                        "Pause",
                                        style:GoogleFonts.inter(
                                            fontSize: height*0.017,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  closePressed = !closePressed;
                                  databaseReference.child(authKey).child('GateAutomation').child(deviceCount).update({
                                    "Close": true,
                                  });
                                  // http.put(
                                  //   Uri.parse('http://54.221.145.162/gate/$savedIdValue/'),
                                  //   headers: <String, String>{
                                  //     'Content-Type':
                                  //     'application/json; charset=UTF-8',
                                  //   },
                                  //   body: jsonEncode(<String, bool>{
                                  //     "Close": true,
                                  //   }),
                                  // );
                                });
                              },
                              child: Listener(
                                onPointerUp: (_) => setState(() {
                                  closePressed = true;
                                }),
                                onPointerDown: (_) => setState(() {
                                  closePressed = true;
                                }),
                                child: AnimatedContainer(
                                  // height: 200,
                                  // width: 200,
                                  // duration: Duration(milliseconds: 100),
                                  decoration: BoxDecoration(
                                    // color: Theme.of(context).cardColor,
                                      color: Colors.white.withOpacity(0.9),
                                      borderRadius: BorderRadius.circular(300),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: closePressed ? 5.0 : 30.0,
                                          offset: closePressed ? -Offset(3, 3) : -Offset(10, 10),
                                          color: Colors.white54,
                                          // inset: closePressed,
                                        ),
                                        BoxShadow(
                                          blurRadius: closePressed ? 5.0 : 30.0,
                                          offset: closePressed
                                              ? Offset(6, 8)
                                              : Offset(10, 10),
                                          color:  Color(0xffA7A9AF),
                                          // inset: closePressed,
                                          // inset: true,
                                        ),
                                      ]),
                                  duration: Duration(milliseconds: 100),
                                  child: CircleAvatar(
                                    radius: height*0.05,
                                    foregroundColor: Colors.transparent,
                                    backgroundColor: Colors.transparent,
                                    child: Center(
                                      child: Text(
                                        "Close",
                                        style:GoogleFonts.inter(
                                            fontSize: height*0.017,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ):
                        Container(
                        height: height * 0.18,
                        width: width * double.infinity,
                        margin: EdgeInsets.all(10.0),
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(214, 214, 214, 0.6),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  openPressed = !openPressed;
                                  databaseReference.child(authKey).child('GateAutomation').child(deviceCount).update({
                                    "Single_Gate_Status": true,
                                  });
                                  // http.put(
                                  //   Uri.parse('http://54.221.145.162/gate/$savedIdValue/'),
                                  //   headers: <String, String>{
                                  //     'Content-Type':
                                  //     'application/json; charset=UTF-8',
                                  //   },
                                  //   body: jsonEncode(<String, bool>{
                                  //     "Single_Gate_Status": true,
                                  //   }),
                                  // );
                                });
                              },
                              child: Listener(
                                onPointerUp: (_) => setState(() {
                                  openPressed = true;
                                }),
                                onPointerDown: (_) => setState(() {
                                  openPressed = true;
                                }),
                                child: AnimatedContainer(
                                  // height: 200,
                                  // width: 200,
                                  // duration: Duration(milliseconds: 100),
                                  decoration: BoxDecoration(
                                    // color: Theme.of(context).cardColor,
                                      color: Colors.white.withOpacity(0.9),
                                      borderRadius: BorderRadius.circular(300),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: openPressed ? 5.0 : 30.0,
                                          offset: openPressed ? -Offset(3, 3) : -Offset(10, 10),
                                          color: Colors.white54,
                                          // inset: openPressed,
                                        ),
                                        BoxShadow(
                                          blurRadius: openPressed ? 5.0 : 30.0,
                                          offset: openPressed ? Offset(6, 8) : Offset(10, 10),
                                          color: Color(0xffA7A9AF),
                                          // inset: openPressed,
                                          // inset: true,
                                        ),
                                      ]),
                                  duration: Duration(milliseconds: 100),
                                  child: CircleAvatar(
                                    radius:height*0.05,
                                    foregroundColor: Colors.transparent,
                                    backgroundColor: Colors.transparent,
                                    // height: height * 0.09,
                                    // width: width * 0.20,
                                    child: Center(
                                      child: Text(
                                        "Single",
                                        style:GoogleFonts.inter(
                                            fontSize: height*0.017,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  closePressed = !closePressed;
                                  databaseReference.child(authKey).child('GateAutomation').child(deviceCount).update({
                                    "Gate_Status": true,
                                  });
                                  // http.put(
                                  //   Uri.parse('http://54.221.145.162/gate/$savedIdValue/'),
                                  //   headers: <String, String>{
                                  //     'Content-Type':
                                  //     'application/json; charset=UTF-8',
                                  //   },
                                  //   body: jsonEncode(<String, bool>{
                                  //     "Gate_Status": true,
                                  //   }),
                                  // );
                                });
                              },
                              child: Listener(
                                onPointerUp: (_) => setState(() {
                                  closePressed = true;
                                }),
                                onPointerDown: (_) => setState(() {
                                  closePressed = true;
                                }),
                                child: AnimatedContainer(
                                  // height: 200,
                                  // width: 200,
                                  // duration: Duration(milliseconds: 100),
                                  decoration: BoxDecoration(
                                    // color: Theme.of(context).cardColor,
                                      color: Colors.white.withOpacity(0.9),
                                      borderRadius: BorderRadius.circular(300),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: closePressed ? 5.0 : 30.0,
                                          offset: closePressed ? -Offset(3, 3) : -Offset(10, 10),
                                          color: Colors.white54,
                                          // inset: closePressed,
                                        ),
                                        BoxShadow(
                                          blurRadius: closePressed ? 5.0 : 30.0,
                                          offset: closePressed
                                              ? Offset(6, 8)
                                              : Offset(10, 10),
                                          color:  Color(0xffA7A9AF),
                                          // inset: closePressed,
                                          // inset: true,
                                        ),
                                      ]),
                                  duration: Duration(milliseconds: 100),
                                  child: CircleAvatar(
                                    radius: height*0.05,
                                    foregroundColor: Colors.transparent,
                                    backgroundColor: Colors.transparent,
                                    child: Center(
                                      child: Text(
                                        "Both",
                                        style:GoogleFonts.inter(
                                            fontSize: height*0.017,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}