import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:onwords_home/firstPage/gridFirstPage.dart';
import 'package:onwords_home/firstPage/listFirstPage.dart';
import 'package:overlay_support/overlay_support.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:wifi_iot/wifi_iot.dart';

import '../home_page.dart';




FirebaseAuth auth = FirebaseAuth.instance;

final databaseReference = FirebaseDatabase.instance.reference();

class FirstPage extends StatefulWidget {

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage>{

  var dataJson;
  var personalDataJson;
  SharedPreferences loginData;
  String userName = " ";
  String ip;
  String username;
  bool notifier = false;
  bool mobNotifier = false;
  bool wifiNotifier = false;
  bool currentIndex = false;
  bool _pinned = true;
  bool _floating = false;
  Timer timer;
  bool hasInternet = false;
  List data = [];
  List<String> dumVariable = [];
  var sharedDataValues;

  List<String> localDataVal = [ ];
  ConnectivityResult result = ConnectivityResult.none;
  Gradient g1 = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Colors.grey[800],
        Colors.grey[800],
      ]);
  var count =0;
  String ipAddress = null;
  String ipLocal = " ";
  String onlineIp = " ";


  var smartHome;
  bool offline ;
  bool waterTankAutoStatus ;
  bool farmAutoStatus ;
  bool smartHomeStatus ;
  bool bothOffOn ;
  String customerName;
  String staticIp;
  String offlineIp;
  String phoneNumber;
  String email = " ";
  String name = " ";
  bool noLocalServer;
  var localServer;
  String authKey = " ";
  var ownerId;



  keyValues() async {

    loginData = await SharedPreferences.getInstance();
    final locIp = loginData.getString('ip') ?? null;
    final onIp = loginData.getString('onlineIp') ?? null;
    // print("line:93 from first page $locIp ");
    if((locIp != null)&&(locIp != "false")){
      try{
        http.Response response = await http.get(Uri.parse("http://$locIp/")).timeout(const Duration(milliseconds: 500), onTimeout: () {
          data.clear();
          setState((){
            ipAddress = onIp;
           });
          initial();
          return;
        });
        if(response.statusCode > 0){
          setState(() {
            data.clear();
            ipAddress = locIp;
            initial();
          });
        }
      }catch(e){
        // print(e);
      }
      //localDataVariableStorage();
    }else if(locIp == " false"){
      setState(() {
        ipAddress = locIp;
        initial();
      });

    }

  }

   initial() async {
    // print("im inside the initial first page");
    loginData = await SharedPreferences.getInstance();
      setState(() {
        username = loginData.getString('username');
      });
    localDataVariableStorage();
  }

  localData() async {
    loginData = await SharedPreferences.getInstance();
    setState(()
    {
      username = loginData.getString('username');
    });
    if(username == " "){
      // print("11111111111111111111111111");
      firstProcess();
    }
  }


  localDataVariableStorage() async {

    if ((ipAddress.toString() != "false")&& (ipAddress != null)) {
          // print("151 first $ipAddress ");
      if(result == ConnectivityResult.wifi)
      {
         // print("154 first ************  inside wifi");
        final response = await http.get(Uri.parse(
          "http://$ipAddress/",
        ));
        var fetchdata = jsonDecode(response.body);
        if (response.statusCode >0) {

          setState(() {
            localDataVal.clear();
            dumVariable.clear();
            var dumData = fetchdata;
            for (int i = 0; i < dumData.length; i++)
            {
              dumVariable.add(dumData[i]["Room"].toString());
            }
            localDataVal= dumVariable.toSet().toList();
            data = localDataVal;

          });
        }
        if (count < 1) {
          showSimpleNotification(
            Text(
              " you are on wifi network ",
              style: TextStyle(color: Colors.white),
            ),
            background: Colors.green,
          );
          count = 2;
        }
      }else if(result == ConnectivityResult.mobile){
        if(count < 1) {
          showSimpleNotification(
            Text(
              " you are on Online network ",
              style: TextStyle(color: Colors.white),
            ),
            background: Colors.green,
          );
          count = 2;
        }
      }
    }else if ((ipAddress.toString() == "false") && (ipAddress != null)){
      // print("im inisde the else if line:209 on firstPage $ipAddress ");
      if(result == ConnectivityResult.mobile){
        setState(() {
          //print("im from line: 195 on first page  ip:false mob condition ");
          var len = smartHome['Devices'].length;
          for(int i =1;i<=len;i++)
          {
            data.add(smartHome['Devices']['Id$i']['Room']);
          }

        });
        if(count < 1) {
          showSimpleNotification(
            Text(
              " you are on Demo Login   ",
              style: TextStyle(color: Colors.white),
            ),
            background: Colors.green,
          );
          count = 2;
        }
      } else if(result == ConnectivityResult.wifi){
        //print some add some functionality
        //print("line 215 from firstPAge ");
        if(count < 1) {
          showSimpleNotification(
            Text(" please switch to Mobile Internet ",
              style: TextStyle(color: Colors.white),), background: Colors.red,
          );
          count = 2;
        }
        //print("********* im inside the else if of ip Address and inside the esle state********");
      }
    }
    else{
      initial();
    }
    sharedDataValues = loginData.getStringList('dataValues');
  }


  firstProcess() async {
    // loginData = await SharedPreferences.getInstance();
    // databaseReference.child('family').once().then((value){
    //   value.snapshot.children.forEach((element) {
    //     for (var element in value.snapshot.children){
    //       ownerId = element.value;
    //       if(element.key == auth.currentUser.uid){
    //         loginData.setString('ownerId', ownerId['owner-uid']);
    //         authKey = loginData.getString('ownerId');
    //         fireData();
    //         break;
    //       }else{
    //         loginData.setString('ownerId', auth.currentUser.uid);
    //         authKey = loginData.getString('ownerId');
    //         fireData();
    //       }
    //     }
    //   });
    // });
    //changed on 19.08.2022
    loginData = await SharedPreferences.getInstance();
    databaseReference.child('family').once().then((value) {
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

  Future<void> fireData() async {
    //print("im at before atlast of firedata");

    databaseReference.child(auth.currentUser.uid).once().then((value) async{
      personalDataJson = value.snapshot.value;
      setState((){
        userName = personalDataJson["name"];
        email = personalDataJson['email'];
        phoneNumber = personalDataJson['phone'].toString();
      });
    });

    databaseReference.child(authKey).once().then((snapshot) async {

      // dataJson = snapshot.value;
      dataJson = snapshot.snapshot.value;

      setState(() {
        // bothOffOn = dataJson['localServer']['BothOfflineAndOnline'];
        noLocalServer = dataJson['noLocalServer'];
        localServer = dataJson['localServer'];
        bothOffOn = localServer != null ? localServer["BothOfflineAndOnline"]: false;


        if (noLocalServer != true) {
          if (bothOffOn == true) {
            ipLocal = localServer['offlineIp'].toString();
            onlineIp = localServer['staticIp'].toString();
            checkData();
            //firebase ****************
          } else {
            ipLocal = dataJson['offlineIp'].toString();
            onlineIp = "false";
            checkData();
          }
        } else {
          smartHome = dataJson['SmartHome'];
          ipLocal = "false";
          onlineIp = "false";
          checkData();
        }
      });
    });
  }

  checkData() async {
    // print("im inside the check data of first page");
    loginData = await SharedPreferences.getInstance();
    if(ipLocal == "false"){
      loginData.setString('username', userName);
      loginData.setString('ip', ipLocal );
      loginData.setString('onlineIp', onlineIp);
      localData();
      keyValues();
    }else{
      loginData.setString('ip', ipLocal );
      loginData.setString('onlineIp', onlineIp);
      loginData.setString('username', userName);
      localData();
      keyValues();
    }

  }


  internet() async {
    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        this.result = result;
      });
    });
    InternetConnectionChecker().onStatusChange.listen((status) async {
      final hasInternet = status == InternetConnectionStatus.connected;
      setState(() {
        this.hasInternet = hasInternet;
      });
    });
    hasInternet = await InternetConnectionChecker().hasConnection;
    result = await Connectivity().checkConnectivity();
  }

  @override
  void initState() {
    firstProcess();
    internet();
    // fireData();
    localData();
    // timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
    //   getData();
    // });
    super.initState();
  }

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return WillPopScope(
      onWillPop: () => showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
          title: Text('Warning',style: Theme.of(context).dialogTheme.titleTextStyle,),
          content: Text('Do you really want to exit',
            style: Theme.of(context).dialogTheme.contentTextStyle,),
          actions: [
            TextButton(
              child: Text('Yes'),
              // onPressed: () => Navigator.pop(context,true),
              onPressed: () {
                Navigator.pop(context,true);
              },
            ),
            TextButton(
              child: Text('No'),
              onPressed: () => Navigator.pop(context, false),
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: Scaffold(
          key: scaffoldKey,
          //backgroundColor: Color.fromRGBO(26, 28, 30, 0.6),
          backgroundColor: Theme.of(context).backgroundColor,
          body: Container(
            height: height * 1.0,
            width: width * 1.0,
            //color: Color.fromRGBO(26, 28, 30, 0.6),
            color: Theme.of(context).backgroundColor,
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  // backgroundColor: Color.fromRGBO(40, 36, 36, 1.0),
                  //backgroundColor: Color.fromRGBO(26, 28, 30, 0.6),
                  backgroundColor: Theme.of(context).backgroundColor,
                  collapsedHeight: height * 0.16,
                  pinned: _pinned,
                  // snap: _snap,
                  floating: _floating,
                  expandedHeight: height * 0.05,
                  flexibleSpace: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image.asset('images/logo re@4x.png',height: height*0.09,),
                              Text(
                                "Welcome to PS Castle",
                                style: TextStyle(fontSize: height*0.04,fontFamily: 'Monotype',fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                username??" ",
                                style: TextStyle(fontSize: width*0.050,fontFamily: 'Monotype'),),
                              ///
                              // currentIndex ?
                              // IconButton(
                              //   icon: Icon(
                              //     Icons.menu,
                              //     size: height*0.042,
                              //     color: Theme.of(context).iconTheme.color,
                              //   ),
                              //   onPressed: () {
                              //     setState(() {
                              //       if (currentIndex == false) {
                              //         currentIndex = true;
                              //       } else if (currentIndex == true) {
                              //         currentIndex = false;
                              //       }
                              //     });
                              //   },
                              // ):
                              // IconButton(
                              //   icon: Icon(
                              //     Icons.grid_view,
                              //     size: height*0.032,
                              //     color: Theme.of(context).iconTheme.color,
                              //   ),
                              //   onPressed: () {
                              //     setState(() {
                              //       if (currentIndex == false) {
                              //         currentIndex = true;
                              //       } else if (currentIndex == true) {
                              //         currentIndex = false;
                              //       }
                              //     });
                              //   },
                              // ),
                              ///
                              // SpeedDial(
                              //   direction: SpeedDialDirection.down,
                              //       // marginBottom: 10, //margin bottom
                              //       icon: Icons.menu, //icon on Floating action button
                              //       activeIcon: Icons.close, //icon when menu is expanded on button
                              //       backgroundColor: Colors.deepOrangeAccent, //background color of button
                              //       foregroundColor: Colors.white, //font color, icon color in button
                              //       activeBackgroundColor: Colors.deepPurpleAccent, //background color when menu is expanded
                              //       activeForegroundColor: Colors.white,
                              //       // buttonSize: 56.0, //button size
                              //       visible: true,
                              //       closeManually: false,
                              //       curve: Curves.bounceIn,
                              //       overlayColor: Colors.black,
                              //       overlayOpacity: 0.5,
                              //       onOpen: () => print('OPENING DIAL'), // action when menu opens
                              //       onClose: () => print('DIAL CLOSED'), //action when menu closes
                              //       elevation: 8.0, //shadow elevation of button
                              //       shape: CircleBorder(), //shape of button
                              //
                              //       children: [
                              //         SpeedDialChild( //speed dial child
                              //           child: SvgPicture.asset(
                              //             "images/light.svg",
                              //             color: Colors.black,
                              //             height: MediaQuery.of(context).size.height * 0.030,
                              //           ),
                              //           backgroundColor: Colors.red,
                              //           foregroundColor: Colors.white,
                              //           label: 'First Menu Child',
                              //           labelStyle: TextStyle(fontSize: 18.0),
                              //           onTap: () => print('FIRST CHILD'),
                              //           onLongPress: () => print('FIRST CHILD LONG PRESS'),
                              //         ),
                              //         SpeedDialChild(
                              //           child: SvgPicture.asset(
                              //             "images/light.svg",
                              //             color: Colors.black,
                              //             height: MediaQuery.of(context).size.height * 0.030,
                              //           ),
                              //           backgroundColor: Colors.blue,
                              //           foregroundColor: Colors.white,
                              //           label: 'Second Menu Child',
                              //           labelStyle: TextStyle(fontSize: 18.0),
                              //           onTap: () => print('SECOND CHILD'),
                              //           onLongPress: () => print('SECOND CHILD LONG PRESS'),
                              //         ),
                              //         SpeedDialChild(
                              //           child: SvgPicture.asset(
                              //             "images/light.svg",
                              //             color: Colors.black,
                              //             height: MediaQuery.of(context).size.height * 0.030,
                              //           ),
                              //           foregroundColor: Colors.white,
                              //           backgroundColor: Colors.green,
                              //           label: 'Third Menu Child',
                              //           labelStyle: TextStyle(fontSize: 18.0),
                              //           onTap: () => print('THIRD CHILD'),
                              //           onLongPress: () => print('THIRD CHILD LONG PRESS'),
                              //         ),
                              //
                              //         //add more menu item children here
                              //       ],
                              //     ),
                            ],
                          ),
                          // SizedBox(
                          //   height: height * 0.020,
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //   children: [
                          //     ElevatedButton(
                          //       style:ButtonStyle(
                          //         // shape: MaterialStateProperty.all(CircleBorder()),
                          //         backgroundColor:  MaterialStateProperty.all(Colors.grey),
                          //         elevation: MaterialStateProperty.all(5.0),
                          //       ),
                          //       onPressed: () {  },
                          //       child: Container(
                          //         height:height*0.048,
                          //         width:width*0.09,
                          //         // padding: EdgeInsets.all(10.0),
                          //         child: Column(
                          //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //           children: [
                          //             SvgPicture.asset(
                          //               "images/light.svg",
                          //               color: Colors.black,
                          //               height: MediaQuery.of(context).size.height * 0.030,
                          //             ),
                          //             Text("Lights",style: TextStyle(fontSize: height*0.009),)
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //     ElevatedButton(
                          //       style:ButtonStyle(
                          //         // shape: MaterialStateProperty.all(CircleBorder()),
                          //         backgroundColor:  MaterialStateProperty.all(Colors.grey),
                          //         elevation: MaterialStateProperty.all(5.0),
                          //       ),
                          //       onPressed: () {  },
                          //       child: Container(
                          //         height:height*0.048,
                          //         width:width*0.09,
                          //         // padding: EdgeInsets.all(10.0),
                          //         child: Column(
                          //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //           children: [
                          //         Image(image: AssetImage("images/socket.png",),
                          //               color: Colors.black,
                          //               height: MediaQuery.of(context).size.height * 0.030,
                          //             ),
                          //             Text("Sockets",style: TextStyle(fontSize: height*0.009),)
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //     ElevatedButton(
                          //       style:ButtonStyle(
                          //         // shape: MaterialStateProperty.all(CircleBorder()),
                          //         backgroundColor:  MaterialStateProperty.all(Colors.grey),
                          //         elevation: MaterialStateProperty.all(5.0),
                          //       ),
                          //       onPressed: () {  },
                          //       child: Container(
                          //         height:height*0.048,
                          //         width:width*0.09,
                          //         // padding: EdgeInsets.all(10.0),
                          //         child: Column(
                          //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //           children: [
                          //             SvgPicture.asset(
                          //               "images/light.svg",
                          //               color: Colors.black,
                          //               height: MediaQuery.of(context).size.height * 0.030,
                          //             ),
                          //             Text("Lights",style: TextStyle(fontSize: height*0.009),)
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
                // SliverToBoxAdapter(
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //       children: [
                //         ElevatedButton(
                //           style:ButtonStyle(
                //             // shape: MaterialStateProperty.all(CircleBorder()),
                //             backgroundColor:  MaterialStateProperty.all(Colors.grey),
                //             elevation: MaterialStateProperty.all(5.0),
                //           ),
                //           onPressed: () {  },
                //           child: Container(
                //             height:height*0.050,
                //             width:width*0.20,
                //             // padding: EdgeInsets.all(10.0),
                //             child: Column(
                //               children: [
                //                 SvgPicture.asset(
                //                   "images/light.svg",
                //                   color: Colors.black,
                //                   height: MediaQuery.of(context).size.height * 0.030,
                //                 ),
                //                 Text("Lights",style: TextStyle(fontSize: height*0.010),)
                //               ],
                //             ),
                //           ),
                //         ),
                //         ElevatedButton(
                //           style:ButtonStyle(
                //             // shape: MaterialStateProperty.all(CircleBorder()),
                //             backgroundColor:  MaterialStateProperty.all(Colors.grey),
                //             elevation: MaterialStateProperty.all(5.0),
                //           ),
                //           onPressed: () {  },
                //           child: Container(
                //             height:height*0.050,
                //             width:width*0.20,
                //             // padding: EdgeInsets.all(10.0),
                //             child: Column(
                //               children: [
                //                 SvgPicture.asset(
                //                   "images/light.svg",
                //                   color: Colors.black,
                //                   height: MediaQuery.of(context).size.height * 0.030,
                //                 ),
                //                 Text("Lights",style: TextStyle(fontSize: height*0.010),)
                //               ],
                //             ),
                //           ),
                //         ),
                //         ElevatedButton(
                //           style:ButtonStyle(
                //             // shape: MaterialStateProperty.all(CircleBorder()),
                //             backgroundColor:  MaterialStateProperty.all(Colors.grey),
                //             elevation: MaterialStateProperty.all(5.0),
                //           ),
                //           onPressed: () {  },
                //           child: Container(
                //             height:height*0.050,
                //             width:width*0.20,
                //             // padding: EdgeInsets.all(10.0),
                //             child: Column(
                //               children: [
                //                 SvgPicture.asset(
                //                   "images/light.svg",
                //                   color: Colors.black,
                //                   height: MediaQuery.of(context).size.height * 0.030,
                //                 ),
                //                 Text("Lights",style: TextStyle(fontSize: height*0.010),)
                //               ],
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                // ),
                // currentIndex? FirstPageGridContainer(): FirstPageListContainers(),
                FirstPageListContainers(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showAnotherAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = TextButton(
      child: Text("ok"),
      onPressed: (){
        WiFiForIoTPlugin.setEnabled(false,shouldOpenSettings: true);
        initial();
        fireData();
        //localDataVariableStorage();
        Navigator.pop(context, false);
      },
    );
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      title: Text("Oops!!!! ",style: Theme.of(context).dialogTheme.titleTextStyle,),
      content: Text("please connect your device with Local WiFi Network ",style: Theme.of(context).dialogTheme.contentTextStyle,),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert ;
      },
    );
  }
}
