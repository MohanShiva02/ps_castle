import 'dart:async';
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'individual_page.dart';

FirebaseAuth auth = FirebaseAuth.instance;
final databaseReference = FirebaseDatabase.instance.reference();

class FirstPageListContainers extends StatefulWidget {
  @override
  _FirstPageListContainersState createState() =>
      _FirstPageListContainersState();
}

Route _createRoute(String word, int index, String ip, Gradient g1) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Button(
      word,
      index,
      ip,
      g1,
    ),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.slowMiddle;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class _FirstPageListContainersState extends State<FirstPageListContainers> {
  String ip;
  Gradient g1 = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Colors.grey[800],
        Colors.grey[800],
      ]);
  List<String> name = [];
  List<String> pg = [];
  List data = [];
  List data1 = [];
  SharedPreferences loginData;
  var sharedDataValues;
  String userName = " ";
  String ipAddress = null;
  String ipLocal = " ";
  String onlineIp = " ";
  Timer timer;
  bool hasInternet = false;
  String username = " ";
  ConnectivityResult result = ConnectivityResult.none;
  var acount = 0;
  var dataJson;
  var personalDataJson;
  List<String> localDataVal = [];
  List<String> dumVariable = [];
  var count = 0;
  List onlineData = [];
  var smartHome;
  bool offline;
  bool waterTankAutoStatus;
  bool farmAutoStatus;
  bool smartHomeStatus;
  bool bothOffOn;
  String customerName;
  String staticIp;
  String offlineIp;
  String phoneNumber = " ";
  String email = " ";
  bool noLocalServer;
  var localServer;
  bool loader = false;
  bool vibrate = false;
  String authKey = " ";
  var ownerId;
  bool owner = false;
  bool smartDoor = false;
  var doorData;
  bool isDescending = false;
  List<String> roomName = [];



  keyValues() async {
    loginData = await SharedPreferences.getInstance();
    final locIp = loginData.getString('ip') ?? null;
    final onIp = loginData.getString('onlineIp') ?? null;

    if ((locIp != null)&&(locIp != "false")){
      try{
        http.Response response = await http.get(Uri.parse("http://$locIp/")).timeout(const Duration(milliseconds: 500), onTimeout: () {
          data.clear();
          ipAddress = onIp;
          initial();
          return;
        });
        if (response.statusCode > 0) {
          data.clear();
          ipAddress = locIp;
          initial();
        }
      }catch(e){
         // print(e);
      }// initial();
    } else if (locIp == "false") {
      initial();
      ipAddress = locIp;
    }
  }

  Future<void> initial() async {
    loginData = await SharedPreferences.getInstance();
    setState((){
      username = loginData.getString('username');
    });


      if (username == " ") {
        setState(() {
          username = userName;
        });
      }
      vibrate = loginData.get('vibrationStatus') ?? false;
      if (ipAddress == null) {
        fireData();
      } else if ((data == null) || (data.length == 0))
      {
        if (ipAddress.toString() != 'false') {
          // print("ipAddddddddddd $ipAddress ");
          final response = await http.get(Uri.parse(
            "http://$ipAddress/",
          ));
          var fetchdata = jsonDecode(response.body);

          setState(() {
            localDataVal.clear();
            dumVariable.clear();
            var dumData = fetchdata;
            for (int i = 0; i < dumData.length; i++) {
              dumVariable.add(dumData[i]["Room"].toString());
            }
            localDataVal = dumVariable.toSet().toList();
            data = localDataVal;
            // print(data);
            loginData.setStringList('dataValues', localDataVal);
            initial();
          });
        }
        else if ((ipAddress.toString() == 'false')) {
          // print("im inside the false");
          setState(() {
            getName();
          });
          //showAnotherAlertDialog(context);
        }
      } else{
        setState(() {
          loader = true;
          // print("im going into the getName of list in initial ************************************ ");
          getName();
        });
      }
    }

  readData() async {
    loginData = await SharedPreferences.getInstance();
    var da = loginData.getStringList('roomNames')??null;
    // print("da ================== $da");
    if(da == null)
    {
      // print("roooooooooooo $roomName ");
      keyValues();
    }else{
      // print("------------------------------------------------------------------------");
      setState(() {
        roomName = loginData.getStringList('roomNames');
        // print( "$roomName -------------------------------------------- " );
      });
    }
  }

  firstProcess() async {
    // loginData = await SharedPreferences.getInstance();
    // databaseReference.child('family').once().then((value) {
    //   for (var element in value.snapshot.children) {
    //     ownerId = element.value;
    //     if (element.key == auth.currentUser.uid) {
    //       loginData.setString('ownerId', ownerId['owner-uid']);
    //       authKey = loginData.getString('ownerId');
    //       fireData();
    //       break;
    //     } else {
    //       loginData.setString('ownerId', auth.currentUser.uid);
    //       authKey = loginData.getString('ownerId');
    //       fireData();
    //     }
    //   }
    // });
    ///changed on 19.08.2022
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
    databaseReference.child(auth.currentUser.uid).once().then((value) async {
      personalDataJson = value.snapshot.value;
      setState(() {
        userName = personalDataJson["name"];
        email = personalDataJson['email'];
        phoneNumber = personalDataJson['phone'].toString();
        owner = personalDataJson['owner'];
      });
    });

    databaseReference.child(authKey).once().then((snapshot) async {
      dataJson = snapshot.snapshot.value;
      setState(() {
        // bothOffOn = dataJson['localServer']['BothOfflineAndOnline'];
        noLocalServer = dataJson['noLocalServer'];
        localServer = dataJson['localServer'];
        bothOffOn =
            localServer != null ? localServer["BothOfflineAndOnline"] : false;

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
          doorData = dataJson['SmartHome'];
          smartDoor = doorData != null ? doorData['smartDoor'] : false;
          var len = smartHome['Devices'].length;
          for (int i = 1; i <= len; i++) {
            data.add(smartHome['Devices']['Id$i']['Room']);
          }
          // print(data);
          // localDataVal = data.toSet().toList() as List<String>;
          // loginData.setStringList('dataValues', data);
          // print(data);
          checkData();
          getName();
        }
      });
    });
  }

  checkData() async {
    //print("im inside the check data of first page");
    loginData = await SharedPreferences.getInstance();
    if (ipLocal == "false") {
      loginData.setString('username', userName);
      loginData.setString('ip', ipLocal);
      loginData.setString('onlineIp', onlineIp);
      loginData.setBool('owner', owner);
      // loginData.setBool('smartDoor', smartDoor);
      keyValues();
    } else {
      loginData.setString('ip', ipLocal);
      loginData.setString('onlineIp', onlineIp);
      loginData.setString('username', userName);
      loginData.setBool('owner', owner);
      loginData.setBool('smartDoor', smartDoor);
      keyValues();
    }
  }

  Future getName() async {
    // print("im inside the getname of list funtion");
    // print("data is 8888888888888888888888888888888888 $data");
    for (int i = 0; i < data.length; i++) {
      if (data[i].toString().contains("Admin Room") &&
          (!name.contains(data[i].toString().contains("Admin Room")))) {
        name.add("Admin Room");
        pg.add("Admin Room");
      } else if (data[i].toString().contains("Hall") &&
          (!name.contains(data[i].toString().contains("Hall")))) {
        name.add("Hall");
        pg.add("Hall");
      } else if (data[i].toString().contains("Living Room") &&
          (!name.contains(data[i].toString().contains("Living Room")))) {
        name.add("Living Room");
        pg.add("Living Room");
      } else if (data[i].toString().contains("Garage") &&
          (!name.contains(data[i].toString().contains("Garage")))) {
        name.add("Garage");
        pg.add("Garage");
      } else if (data[i].toString().contains("Kitchen") &&
          (!name.contains(data[i].toString().contains("Kitchen")))) {
        name.add("Kitchen");
        pg.add("Kitchen");
      } else if (data[i].toString().contains("Bathroom1") &&
          (!name.contains(data[i].toString().contains("Bathroom1")))) {
        name.add("Bathroom1");
        pg.add("Bathroom1");
      } else if (data[i].toString().contains("Bathroom2") &&
          (!name.contains(data[i].toString().contains("Bathroom2")))) {
        name.add("Bathroom2");
        pg.add("Bathroom2");
      } else if (data[i].toString().contains("Bathroom") &&
          (!name.contains(data[i].toString().contains("Bathroom")))) {
        name.add("Bathroom");
        pg.add("Bathroom");
      } else if (data[i].toString().contains("Master Bedroom") &&
          (!name.contains(data[i].toString().contains("Master Bedroom")))) {
        name.add("Master Bedroom");
        pg.add("Master Bedroom");
      } else if (data[i].toString().contains("Bedroom1") &&
          !name.contains(data[i].toString().contains("Bedroom1"))) {
        name.add("Bedroom1");
        //print("----- bedroom1 $name name -------");
        pg.add("Bedroom1");
        //print("----- bedroom1 $pg pg -------");
      } else if (data[i].toString().contains("Bedroom2") &&
          (!name.contains(data[i].toString().contains("Bedroom2")))) {
        name.add("Bedroom2");
        //print("----- bedroom1 $name name -------");
        pg.add("Bedroom2");
        //print("----- bedroom1 $pg pg -------");
      } else if (data[i].toString().contains("Bedroom") &&
          (!name.contains(data[i].toString().contains("Bedroom")))) {
        name.add("Bedroom");
        pg.add("Bedroom");
      } else if (data[i].toString().contains("Store Room") &&
          (!name.contains(data[i].toString().contains("Store Room")))) {
        name.add("Store Room");
        pg.add("Store Room");
      } else if (data[i].toString().contains("Outside") &&
          (!name.contains(data[i].toString().contains("Outside")))) {
        name.add("Outside");
        pg.add("Outside");
      } else if (data[i].toString().contains("Parking") &&
          (!name.contains(data[i].toString().contains("Parking")))) {
        name.add("Parking");
        pg.add("Parking");
      } else if (data[i].toString().contains("Garden") &&
          (!name.contains(data[i].toString().contains("Garden")))) {
        name.add("Garden");
        pg.add("Garden");
      } else if (data[i].toString().contains("Farm") &&
          (!name.contains(data[i].toString().contains("Farm")))) {
        name.add("Farm");
        pg.add("Farm");
      } else if (data[i].toString().contains("Dining Room") &&
          (!name.contains(data[i].toString().contains("Dining Room")))) {
        name.add("Dining Room");
        pg.add("Dining Room");
      }else if (data[i].toString().contains("Green Room") &&
          (!name.contains(data[i].toString().contains("Green Room")))) {
        name.add("Green Room");
        pg.add("Green Room");
      }
    }

    setState(() {
      name = name.toSet().toList();
      pg = pg.toSet().toList();
      loginData.setStringList('roomNames',name);
      roomName = name;
    });
    //return "success";
  }

  Future<void> internet() async {
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
    readData();
    // timer = Timer.periodic(Duration(seconds: 3), (Timer t) {
    //   // keyValues();
    //   // readData();
    //   // internet();
    // });

    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          // final sortItems = roomName..sort((item1,item2)=> isDescending?item2.compareTo(item1): item1.compareTo(item2));
          // final item = sortItems[index];
          return Container(
                  //color: Color.fromRGBO(26, 28, 30, 0.6),
                  color: Theme.of(context).backgroundColor,
                  child: Padding(
                    padding: EdgeInsets.all(18.0),
                    child: GestureDetector(
                      onTap: () {
                        if (vibrate) {
                          Vibration.vibrate(duration: 50, amplitude: 25);
                        } else {
                          Vibration.cancel();
                        }
                        // print(roomName[index]);
                        // print(index);
                        // print(ipAddress);
                        Navigator.of(context).push(_createRoute(
                          roomName[index].toString(),
                          // sortItems[index].toString(),
                          index,
                          ipAddress,
                          g1,
                        ));
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white38,
                                offset: Offset(
                                  0.0,
                                  0.0,
                                ),
                                blurRadius: 0.0,
                                spreadRadius: 1.0,
                              ),
                              BoxShadow(
                                color: Colors.black,
                                offset: Offset(
                                  2.5,
                                  2.5,
                                ),
                                blurRadius: 5.0,
                                spreadRadius: 1.0,
                              ),
                            ],
                          ),
                          child: Container(
                            height: height * 0.20,
                            width: width * 0.80,
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(10.0),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.7),
                                    BlendMode.dstATop),
                                image: roomName[index].toString().contains("Hall")
                                    ? AssetImage(
                                        "images/room/hall.png",
                                      )
                                    : roomName[index].toString().contains("Admin")
                                        ? AssetImage(
                                            "images/room/admin room.jpg",
                                          )
                                        : roomName[index]
                                                .toString()
                                                .contains("Garage")
                                            ? AssetImage(
                                                "images/room/garage.png",
                                              )
                                            : roomName[index]
                                                    .toString()
                                                    .contains("Kitchen")
                                                ? AssetImage(
                                                    "images/room/kitchen.png",
                                                  )
                                                : roomName[index]
                                                        .toString()
                                                        .contains("Bathroom1")
                                                    ? AssetImage(
                                                        "images/room/bathroom 1.png",
                                                      )
                                                    : roomName[index]
                                                            .toString()
                                                            .contains(
                                                                "Bathroom2")
                                                        ? AssetImage(
                                                            "images/room/bathroom 2.png",
                                                          )
                                                        : roomName[index]
                                                                .toString()
                                                                .contains(
                                                                    "Bathroom")
                                                            ? AssetImage(
                                                                "images/room/bathroom 1.png",
                                                              )
                                                            : roomName[index]
                                                                    .toString()
                                                                    .contains(
                                                                        "Bedroom1")
                                                                ? AssetImage(
                                                                    "images/room/bedroom 1.png",
                                                                  )
                                                                : roomName[index]
                                                                        .toString()
                                                                        .contains(
                                                                            "Bedroom2")
                                                                    ? AssetImage(
                                                                        "images/room/bedroom 2.png",
                                                                      )
                                                                    : roomName[index]
                                                                            .toString()
                                                                            .contains("Kids Room")
                                                                        ? AssetImage(
                                                                            "images/room/kids bedroom.png",
                                                                          )
                                                                        : roomName[index].toString().contains("Master Bedroom")
                                                                            ? AssetImage(
                                                                                "images/room/master bedroom.png",
                                                                              )
                                                                            : roomName[index].toString().contains("Bedroom")
                                                                                ? AssetImage(
                                                                                    "images/room/bedroom 2.png",
                                                                                  )
                                                                                : roomName[index].toString().contains("Outside")
                                                                                    ? AssetImage(
                                                                                        "images/room/outside.png",
                                                                                      )
                                                                                    : roomName[index].toString().contains("Garden")
                                                                                        ? AssetImage(
                                                                                            "images/room/garden.png",
                                                                                          )
                                                                                        : roomName[index].toString().contains("Parking")
                                                                                            ? AssetImage(
                                                                                                "images/room/parking.png",
                                                                                              )
                                                                                            : roomName[index].toString().contains("Living Room")
                                                                                                ? AssetImage(
                                                                                                    "images/room/living room.png",
                                                                                                  )
                                                                                                : roomName[index].toString().contains("Store Room")
                                                                                                    ? AssetImage(
                                                                                                        "images/room/store room.png",
                                                                                                      )
                                                                                                    : roomName[index].toString().contains("Farm")
                                                                                                        ? AssetImage(
                                                                                                            "images/room/farm.jpg",
                                                                                                          )
                                                                                                        : roomName[index].toString().contains("Green Room")
                                                                                                          ? AssetImage(
                                                                                                        "images/room/green_room.png",
                                                                                                      ):AssetImage(""),
                                //farm added here
                              ),
                            ),
                            child: Padding(
                              padding:
                                  EdgeInsets.only(left: 10.0, bottom: 10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        child: roomName[index]
                                                .toString()
                                                .contains("Hall")
                                            ? Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${roomName
                                                    [index].toString().replaceAll("_", " ")}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6,
                                                    //style: TextStyle(fontSize: height * 0.025, fontWeight: FontWeight.w900,color: Colors.white),
                                                  ),
                                                  // Text(roomName
                                                  // [index].toString()),
                                                ],
                                              )
                                            : roomName
                                        [index]
                                                    .toString()
                                                    .contains("Admin")
                                                ? Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "${roomName
                                                        [index].toString().replaceAll("_", " ")}",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline6,
                                                        //style: TextStyle(color: Colors.white, fontSize: height * 0.025, fontWeight: FontWeight.w900),
                                                      ),
                                                    ],
                                                  )
                                                : roomName
                                        [index]
                                                        .toString()
                                                        .contains("Garage")
                                                    ? Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "${roomName
                                                            [index].toString().replaceAll("_", " ")}",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .headline6,
                                                            // style: TextStyle(
                                                            //     color:
                                                            //     Colors.white,
                                                            //     fontSize: height *
                                                            //         0.025,
                                                            //     fontWeight:
                                                            //     FontWeight
                                                            //         .w900),
                                                          ),
                                                        ],
                                                      )
                                                    : roomName
                                        [index]
                                                            .toString()
                                                            .contains("Kitchen")
                                                        ? Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "${roomName
                                                                [index].toString().replaceAll("_", " ")}",
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .headline6,
                                                                // style: TextStyle(
                                                                //     color: Colors
                                                                //         .white,
                                                                //     fontSize:
                                                                //     height *
                                                                //         0.025,
                                                                //     fontWeight:
                                                                //     FontWeight
                                                                //         .w900),
                                                              ),
                                                            ],
                                                          )
                                                        : roomName
                                        [index]
                                                                .toString()
                                                                .contains(
                                                                    "Bathroom1")
                                                            ? Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "${roomName
                                                                    [index].toString().replaceAll("_", " ")}",
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .headline6,
                                                                    // style: TextStyle(
                                                                    //     color: Colors
                                                                    //         .white,
                                                                    //     fontSize:
                                                                    //     height *
                                                                    //         0.025,
                                                                    //     fontWeight:
                                                                    //     FontWeight
                                                                    //         .w900),
                                                                  ),
                                                                ],
                                                              )
                                                            : roomName
                                        [index]
                                                                    .toString()
                                                                    .contains(
                                                                        "Bathroom2")
                                                                ? Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .end,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        "${roomName
                                                                        [index].toString().replaceAll("_", " ")}",
                                                                        // style: TextStyle(
                                                                        //     color: Colors
                                                                        //         .white,
                                                                        //     fontSize: height *
                                                                        //         0.025,
                                                                        //     fontWeight:
                                                                        //     FontWeight.w900),
                                                                        style: Theme.of(context)
                                                                            .textTheme
                                                                            .headline6,
                                                                      ),
                                                                    ],
                                                                  )
                                                                : roomName
                                        [index]
                                                                        .toString()
                                                                        .contains(
                                                                            "Bathroom")
                                                                    ? Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.end,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            "${roomName
                                                                            [index].toString().replaceAll("_", " ")}",
                                                                            // style: TextStyle(
                                                                            //     color: Colors
                                                                            //         .white,
                                                                            //     fontSize: height *
                                                                            //         0.025,
                                                                            //     fontWeight:
                                                                            //     FontWeight.w900),
                                                                            style:
                                                                                Theme.of(context).textTheme.headline6,
                                                                          ),
                                                                        ],
                                                                      )
                                                                    : roomName
                                        [index]
                                                                            .toString()
                                                                            .contains("Bedroom1")
                                                                        ? Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.end,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                "${roomName
                                                                                [index].toString().replaceAll("_", " ")}",
                                                                                style: Theme.of(context).textTheme.headline6,
                                                                                // style: TextStyle(
                                                                                //     color: Colors.white,
                                                                                //     fontSize: height * 0.025,
                                                                                //     fontWeight: FontWeight.w900),
                                                                              ),
                                                                            ],
                                                                          )
                                                                        : roomName
                                        [index].toString().contains("Bedroom2")
                                                                            ? Column(
                                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(
                                                                                    "${roomName
                                                                                    [index].toString().replaceAll("_", " ")}",
                                                                                    style: Theme.of(context).textTheme.headline6,
                                                                                    //style: TextStyle(color: Colors.white, fontSize: height * 0.025, fontWeight: FontWeight.w900),
                                                                                  ),
                                                                                ],
                                                                              )
                                                                            : roomName
                                        [index].toString().contains("Master Bedroom")
                                                                                ? Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text(
                                                                                        "${roomName
                                                                                        [index].toString().replaceAll("_", " ")}",
                                                                                        style: Theme.of(context).textTheme.headline6,
                                                                                        //style: TextStyle(color: Colors.white, fontSize: height * 0.025, fontWeight: FontWeight.w900),
                                                                                      ),
                                                                                    ],
                                                                                  )
                                                                                : roomName
                                        [index].toString().contains("Bedroom")
                                                                                    ? Column(
                                                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Text(
                                                                                            "${roomName
                                                                                            [index].toString().replaceAll("_", " ")}",
                                                                                            style: Theme.of(context).textTheme.headline6,
                                                                                            // style: TextStyle(color: Colors.white, fontSize: height * 0.025, fontWeight: FontWeight.w900),
                                                                                          ),
                                                                                        ],
                                                                                      )
                                                                                    : roomName
                                        [index].toString().contains("Outside")
                                                                                        ? Column(
                                                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: [
                                                                                              Text(
                                                                                                "${roomName
                                                                                                [index].toString().replaceAll("_", " ")}",
                                                                                                style: Theme.of(context).textTheme.headline6,
                                                                                                //style: TextStyle(color: Colors.white, fontSize: height * 0.025, fontWeight: FontWeight.w900),
                                                                                              ),
                                                                                            ],
                                                                                          )
                                                                                        : roomName
                                        [index].toString().contains("Garden")
                                                                                            ? Column(
                                                                                                mainAxisAlignment: MainAxisAlignment.end,
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                children: [
                                                                                                  Text(
                                                                                                    "${roomName
                                                                                                    [index].toString().replaceAll("_", " ")}",
                                                                                                    style: Theme.of(context).textTheme.headline6,
                                                                                                    //style: TextStyle(color: Colors.white, fontSize: height * 0.025, fontWeight: FontWeight.w900),
                                                                                                  ),
                                                                                                ],
                                                                                              )
                                                                                            : roomName
                                        [index].toString().contains("Parking")
                                                                                                ? Column(
                                                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                    children: [
                                                                                                      Text(
                                                                                                        "${roomName
                                                                                                        [index].toString().replaceAll("_", " ")}",
                                                                                                        style: Theme.of(context).textTheme.headline6,
                                                                                                        //style: TextStyle(color: Colors.white, fontSize: height * 0.025, fontWeight: FontWeight.w900),
                                                                                                      ),
                                                                                                    ],
                                                                                                  )
                                                                                                : roomName
                                        [index].toString().contains("Living Room")
                                                                                                    ? Column(
                                                                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                        children: [
                                                                                                          Text(
                                                                                                            "${roomName
                                                                                                            [index].toString().replaceAll("_", " ")}",
                                                                                                            style: Theme.of(context).textTheme.headline6,
                                                                                                            //style: TextStyle(color: Colors.white, fontSize: height * 0.025, fontWeight: FontWeight.w900),
                                                                                                          ),
                                                                                                        ],
                                                                                                      )
                                                                                                    : roomName
                                        [index].toString().contains("Store Room")
                                                                                                        ? Column(
                                                                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                            children: [
                                                                                                              Text(
                                                                                                                "${roomName
                                                                                                                [index].toString().replaceAll("_", " ")}",
                                                                                                                style: Theme.of(context).textTheme.headline6,
                                                                                                                //style: TextStyle(color: Colors.white, fontSize: height * 0.025, fontWeight: FontWeight.w900),
                                                                                                              ),
                                                                                                            ],
                                                                                                          )
                                                                                                              :roomName
                                        [index].toString().contains("Farm")
                                                                                                              ? Column(
                                                                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                            children: [
                                                                                                              Text(
                                                                                                                "${roomName
                                                                                                                [index].toString().replaceAll("_", " ")}",
                                                                                                                style: Theme.of(context).textTheme.headline6,
                                                                                                                //style: TextStyle(color: Colors.white, fontSize: height * 0.025, fontWeight: FontWeight.w900),
                                                                                                              ),
                                                                                                            ],
                                                                                                          ):
                                                                                                                roomName
                                                                                                                [index].toString().contains("Green Room")
                                                                                                              ? Column(
                                                                                                            mainAxisAlignment: MainAxisAlignment.end,
                                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                            children: [
                                                                                                              Text(
                                                                                                                "${roomName
                                                                                                                [index].toString().replaceAll("_", " ")}",
                                                                                                                style: Theme.of(context).textTheme.headline6,
                                                                                                                //style: TextStyle(color: Colors.white, fontSize: height * 0.025, fontWeight: FontWeight.w900),
                                                                                                              ),
                                                                                                            ],
                                                                                                          )
                                                                                                        : Container(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // decoration: BoxDecoration(
                            //   color: Colors.black26,
                            //   borderRadius: BorderRadius.circular(10.0),
                            //   image: DecorationImage(
                            //     fit: BoxFit.cover,
                            //     colorFilter: ColorFilter.mode(
                            //         Colors.black.withOpacity(0.7),
                            //         BlendMode.dstATop),
                            //     image: sortItems[index].toString().contains("Hall")
                            //         ? AssetImage(
                            //       "images/room/hall.png",
                            //     )
                            //         : sortItems[index].toString().contains("Admin")
                            //         ? AssetImage(
                            //       "images/room/admin room.jroomName",
                            //     )
                            //         : sortItems[index]
                            //         .toString()
                            //         .contains("Garage")
                            //         ? AssetImage(
                            //       "images/room/garage.png",
                            //     )
                            //         : sortItems[index]
                            //         .toString()
                            //         .contains("Kitchen")
                            //         ? AssetImage(
                            //       "images/room/kitchen.png",
                            //     )
                            //         : sortItems[index]
                            //         .toString()
                            //         .contains("Bathroom1")
                            //         ? AssetImage(
                            //       "images/room/bathroom 1.png",
                            //     )
                            //         : sortItems[index]
                            //         .toString()
                            //         .contains(
                            //         "Bathroom2")
                            //         ? AssetImage(
                            //       "images/room/bathroom 2.png",
                            //     )
                            //         : sortItems[index]
                            //         .toString()
                            //         .contains(
                            //         "Bathroom")
                            //         ? AssetImage(
                            //       "images/room/bathroom 1.png",
                            //     )
                            //         : sortItems[index]
                            //         .toString()
                            //         .contains(
                            //         "Bedroom1")
                            //         ? AssetImage(
                            //       "images/room/bedroom 1.png",
                            //     )
                            //         : sortItems[index]
                            //         .toString()
                            //         .contains(
                            //         "Bedroom2")
                            //         ? AssetImage(
                            //       "images/room/bedroom 2.png",
                            //     )
                            //         : sortItems[index]
                            //         .toString()
                            //         .contains("Kids Room")
                            //         ? AssetImage(
                            //       "images/room/kids bedroom.png",
                            //     )
                            //         : sortItems[index].toString().contains("Master Bedroom")
                            //         ? AssetImage(
                            //       "images/room/master bedroom.png",
                            //     )
                            //         : sortItems[index].toString().contains("Bedroom")
                            //         ? AssetImage(
                            //       "images/room/bedroom 2.png",
                            //     )
                            //         : sortItems[index].toString().contains("Outside")
                            //         ? AssetImage(
                            //       "images/room/outside.png",
                            //     )
                            //         : sortItems[index].toString().contains("Garden")
                            //         ? AssetImage(
                            //       "images/room/garden.png",
                            //     )
                            //         : sortItems[index].toString().contains("Parking")
                            //         ? AssetImage(
                            //       "images/room/parking.png",
                            //     )
                            //         : sortItems[index].toString().contains("Living Room")
                            //         ? AssetImage(
                            //       "images/room/living room.png",
                            //     )
                            //         : sortItems[index].toString().contains("Store Room")
                            //         ? AssetImage(
                            //       "images/room/store room.png",
                            //     )
                            //         : sortItems[index].toString().contains("Farm")
                            //         ? AssetImage(
                            //       "images/room/farm.jroomName",
                            //     )
                            //         : AssetImage(""),
                            //     //farm added here
                            //   ),
                            // ),
                            // child: Padding(
                            //   padding:
                            //   EdgeInsets.only(left: 10.0, bottom: 10.0),
                            //   child: Row(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     mainAxisAlignment: MainAxisAlignment.start,
                            //     children: [
                            //       Column(
                            //         mainAxisAlignment: MainAxisAlignment.end,
                            //         crossAxisAlignment:
                            //         CrossAxisAlignment.start,
                            //         children: [
                            //           Container(
                            //             padding: EdgeInsets.symmetric(
                            //                 horizontal: 4.0),
                            //             child: sortItems[index]
                            //                 .toString()
                            //                 .contains("Hall")
                            //                 ? Column(
                            //               mainAxisAlignment:
                            //               MainAxisAlignment.end,
                            //               crossAxisAlignment:
                            //               CrossAxisAlignment.start,
                            //               children: [
                            //                 Text(
                            //                   "${sortItems[index].toString().replaceAll("_", " ")}",
                            //                   style: Theme.of(context)
                            //                       .textTheme
                            //                       .headline6,
                            //                   //style: TextStyle(fontSize: height * 0.025, fontWeight: FontWeight.w900,color: Colors.white),
                            //                 ),
                            //                 // Text(roomName
                            //                 [index].toString()),
                            //               ],
                            //             )
                            //                 : sortItems[index]
                            //                 .toString()
                            //                 .contains("Admin")
                            //                 ? Column(
                            //               mainAxisAlignment:
                            //               MainAxisAlignment.end,
                            //               crossAxisAlignment:
                            //               CrossAxisAlignment
                            //                   .start,
                            //               children: [
                            //                 Text(
                            //                   "${sortItems[index].toString().replaceAll("_", " ")}",
                            //                   style: Theme.of(context)
                            //                       .textTheme
                            //                       .headline6,
                            //                   //style: TextStyle(color: Colors.white, fontSize: height * 0.025, fontWeight: FontWeight.w900),
                            //                 ),
                            //               ],
                            //             )
                            //                 : sortItems[index]
                            //                 .toString()
                            //                 .contains("Garage")
                            //                 ? Column(
                            //               mainAxisAlignment:
                            //               MainAxisAlignment
                            //                   .end,
                            //               crossAxisAlignment:
                            //               CrossAxisAlignment
                            //                   .start,
                            //               children: [
                            //                 Text(
                            //                   "${sortItems[index].toString().replaceAll("_", " ")}",
                            //                   style: Theme.of(
                            //                       context)
                            //                       .textTheme
                            //                       .headline6,
                            //                   // style: TextStyle(
                            //                   //     color:
                            //                   //     Colors.white,
                            //                   //     fontSize: height *
                            //                   //         0.025,
                            //                   //     fontWeight:
                            //                   //     FontWeight
                            //                   //         .w900),
                            //                 ),
                            //               ],
                            //             )
                            //                 : sortItems[index]
                            //                 .toString()
                            //                 .contains("Kitchen")
                            //                 ? Column(
                            //               mainAxisAlignment:
                            //               MainAxisAlignment
                            //                   .end,
                            //               crossAxisAlignment:
                            //               CrossAxisAlignment
                            //                   .start,
                            //               children: [
                            //                 Text(
                            //                   "${sortItems[index].toString().replaceAll("_", " ")}",
                            //                   style: Theme.of(
                            //                       context)
                            //                       .textTheme
                            //                       .headline6,
                            //                   // style: TextStyle(
                            //                   //     color: Colors
                            //                   //         .white,
                            //                   //     fontSize:
                            //                   //     height *
                            //                   //         0.025,
                            //                   //     fontWeight:
                            //                   //     FontWeight
                            //                   //         .w900),
                            //                 ),
                            //               ],
                            //             )
                            //                 : sortItems[index]
                            //                 .toString()
                            //                 .contains(
                            //                 "Bathroom1")
                            //                 ? Column(
                            //               mainAxisAlignment:
                            //               MainAxisAlignment
                            //                   .end,
                            //               crossAxisAlignment:
                            //               CrossAxisAlignment
                            //                   .start,
                            //               children: [
                            //                 Text(
                            //                   "${sortItems[index].toString().replaceAll("_", " ")}",
                            //                   style: Theme.of(
                            //                       context)
                            //                       .textTheme
                            //                       .headline6,
                            //                   // style: TextStyle(
                            //                   //     color: Colors
                            //                   //         .white,
                            //                   //     fontSize:
                            //                   //     height *
                            //                   //         0.025,
                            //                   //     fontWeight:
                            //                   //     FontWeight
                            //                   //         .w900),
                            //                 ),
                            //               ],
                            //             )
                            //                 : sortItems[index]
                            //                 .toString()
                            //                 .contains(
                            //                 "Bathroom2")
                            //                 ? Column(
                            //               mainAxisAlignment:
                            //               MainAxisAlignment
                            //                   .end,
                            //               crossAxisAlignment:
                            //               CrossAxisAlignment
                            //                   .start,
                            //               children: [
                            //                 Text(
                            //                   "${sortItems[index].toString().replaceAll("_", " ")}",
                            //                   // style: TextStyle(
                            //                   //     color: Colors
                            //                   //         .white,
                            //                   //     fontSize: height *
                            //                   //         0.025,
                            //                   //     fontWeight:
                            //                   //     FontWeight.w900),
                            //                   style: Theme.of(context)
                            //                       .textTheme
                            //                       .headline6,
                            //                 ),
                            //               ],
                            //             )
                            //                 : sortItems[index]
                            //                 .toString()
                            //                 .contains(
                            //                 "Bathroom")
                            //                 ? Column(
                            //               mainAxisAlignment:
                            //               MainAxisAlignment.end,
                            //               crossAxisAlignment:
                            //               CrossAxisAlignment.start,
                            //               children: [
                            //                 Text(
                            //                   "${sortItems[index].toString().replaceAll("_", " ")}",
                            //                   // style: TextStyle(
                            //                   //     color: Colors
                            //                   //         .white,
                            //                   //     fontSize: height *
                            //                   //         0.025,
                            //                   //     fontWeight:
                            //                   //     FontWeight.w900),
                            //                   style:
                            //                   Theme.of(context).textTheme.headline6,
                            //                 ),
                            //               ],
                            //             )
                            //                 : sortItems[index]
                            //                 .toString()
                            //                 .contains("Bedroom1")
                            //                 ? Column(
                            //               mainAxisAlignment:
                            //               MainAxisAlignment.end,
                            //               crossAxisAlignment:
                            //               CrossAxisAlignment.start,
                            //               children: [
                            //                 Text(
                            //                   "${sortItems[index].toString().replaceAll("_", " ")}",
                            //                   style: Theme.of(context).textTheme.headline6,
                            //                   // style: TextStyle(
                            //                   //     color: Colors.white,
                            //                   //     fontSize: height * 0.025,
                            //                   //     fontWeight: FontWeight.w900),
                            //                 ),
                            //               ],
                            //             )
                            //                 : sortItems[index].toString().contains("Bedroom2")
                            //                 ? Column(
                            //               mainAxisAlignment: MainAxisAlignment.end,
                            //               crossAxisAlignment: CrossAxisAlignment.start,
                            //               children: [
                            //                 Text(
                            //                   "${sortItems[index].toString().replaceAll("_", " ")}",
                            //                   style: Theme.of(context).textTheme.headline6,
                            //                   //style: TextStyle(color: Colors.white, fontSize: height * 0.025, fontWeight: FontWeight.w900),
                            //                 ),
                            //               ],
                            //             )
                            //                 : sortItems[index].toString().contains("Master Bedroom")
                            //                 ? Column(
                            //               mainAxisAlignment: MainAxisAlignment.end,
                            //               crossAxisAlignment: CrossAxisAlignment.start,
                            //               children: [
                            //                 Text(
                            //                   "${sortItems[index].toString().replaceAll("_", " ")}",
                            //                   style: Theme.of(context).textTheme.headline6,
                            //                   //style: TextStyle(color: Colors.white, fontSize: height * 0.025, fontWeight: FontWeight.w900),
                            //                 ),
                            //               ],
                            //             )
                            //                 : sortItems[index].toString().contains("Bedroom")
                            //                 ? Column(
                            //               mainAxisAlignment: MainAxisAlignment.end,
                            //               crossAxisAlignment: CrossAxisAlignment.start,
                            //               children: [
                            //                 Text(
                            //                   "${sortItems[index].toString().replaceAll("_", " ")}",
                            //                   style: Theme.of(context).textTheme.headline6,
                            //                   // style: TextStyle(color: Colors.white, fontSize: height * 0.025, fontWeight: FontWeight.w900),
                            //                 ),
                            //               ],
                            //             )
                            //                 : sortItems[index].toString().contains("Outside")
                            //                 ? Column(
                            //               mainAxisAlignment: MainAxisAlignment.end,
                            //               crossAxisAlignment: CrossAxisAlignment.start,
                            //               children: [
                            //                 Text(
                            //                   "${sortItems[index].toString().replaceAll("_", " ")}",
                            //                   style: Theme.of(context).textTheme.headline6,
                            //                   //style: TextStyle(color: Colors.white, fontSize: height * 0.025, fontWeight: FontWeight.w900),
                            //                 ),
                            //               ],
                            //             )
                            //                 : sortItems[index].toString().contains("Garden")
                            //                 ? Column(
                            //               mainAxisAlignment: MainAxisAlignment.end,
                            //               crossAxisAlignment: CrossAxisAlignment.start,
                            //               children: [
                            //                 Text(
                            //                   "${sortItems[index].toString().replaceAll("_", " ")}",
                            //                   style: Theme.of(context).textTheme.headline6,
                            //                   //style: TextStyle(color: Colors.white, fontSize: height * 0.025, fontWeight: FontWeight.w900),
                            //                 ),
                            //               ],
                            //             )
                            //                 : sortItems[index].toString().contains("Parking")
                            //                 ? Column(
                            //               mainAxisAlignment: MainAxisAlignment.end,
                            //               crossAxisAlignment: CrossAxisAlignment.start,
                            //               children: [
                            //                 Text(
                            //                   "${sortItems[index].toString().replaceAll("_", " ")}",
                            //                   style: Theme.of(context).textTheme.headline6,
                            //                   //style: TextStyle(color: Colors.white, fontSize: height * 0.025, fontWeight: FontWeight.w900),
                            //                 ),
                            //               ],
                            //             )
                            //                 : sortItems[index].toString().contains("Living Room")
                            //                 ? Column(
                            //               mainAxisAlignment: MainAxisAlignment.end,
                            //               crossAxisAlignment: CrossAxisAlignment.start,
                            //               children: [
                            //                 Text(
                            //                   "${sortItems[index].toString().replaceAll("_", " ")}",
                            //                   style: Theme.of(context).textTheme.headline6,
                            //                   //style: TextStyle(color: Colors.white, fontSize: height * 0.025, fontWeight: FontWeight.w900),
                            //                 ),
                            //               ],
                            //             )
                            //                 : sortItems[index].toString().contains("Store Room")
                            //                 ? Column(
                            //               mainAxisAlignment: MainAxisAlignment.end,
                            //               crossAxisAlignment: CrossAxisAlignment.start,
                            //               children: [
                            //                 Text(
                            //                   "${sortItems[index].toString().replaceAll("_", " ")}",
                            //                   style: Theme.of(context).textTheme.headline6,
                            //                   //style: TextStyle(color: Colors.white, fontSize: height * 0.025, fontWeight: FontWeight.w900),
                            //                 ),
                            //               ],
                            //             )
                            //                 : Container(),
                            //           ),
                            //         ],
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
        },
        childCount: roomName.length??0,
      ),
    );
  }

  showAnotherAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = TextButton(
      child: Text("ok"),
      onPressed: () {
        acount = 0;
        keyValues();
        //wiFiChecker();
        Navigator.pop(context, false);
      },
    );
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      title: Text(
        "  No Internet ",
        style: TextStyle(color: Colors.white60, fontWeight: FontWeight.bold),
      ),
      content: Text(
        "please connect your device with Local WiFi network ",
        style: TextStyle(color: Colors.white60),
      ),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
