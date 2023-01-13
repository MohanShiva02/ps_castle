import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:onwords_home/firstPage/motion_sensor_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:vibration/vibration.dart';

import 'custom_widget.dart';
import 'led_lights_page.dart';


FirebaseAuth auth = FirebaseAuth.instance;
final databaseReference = FirebaseDatabase.instance.reference();


class Button extends StatefulWidget {
  final String place;
  final int ind;
  final String ipAddress;
  final Gradient g1;

  Button(this.place, this.ind, this.ipAddress, this.g1);

  @override
  _ButtonState createState() => _ButtonState();
}


class _ButtonState extends State<Button> {

  List data = [];
  List name = [];
  List pg = [];
  bool check;
  String localIp;
  int pageLoader;

  String ip = null;
  SharedPreferences loginData;
  var dataJson;
  var smartHome;
  bool bothOffOn;

  bool noLocalServer;
  var localServer;
  String authKey = " ";
  var ownerId;
  var personalDataJson;

  // Timer timer;


  keyValues() async {
    loginData = await SharedPreferences.getInstance();
    final locIp = loginData.getString('ip') ?? null;
    final onIp = loginData.getString('onlineIp') ?? null;

    if ((locIp != null) && (locIp != "false")) {
      try {
        final response = await http.get(Uri.parse("http://$locIp/")).timeout(
            const Duration(milliseconds: 500), onTimeout: () {
          //ignore:avoid_print
          //print(" inside the timeout ");
          data.clear();
          ip = onIp;
          // print(ip);
          loginData.setString('individualIp', ip);
          // setState(() {
          //   ip = onIp;
          //   loginData.setString('individualIp', ip);
          // });
          // data.clear();
          initial();
          return;
        });
        // print("81 individual    ***************************   ${response.statusCode}");
        if (response.statusCode >= 200) {
          setState(() {
            data.clear();
            ip = locIp;
            loginData.setString('individualIp', ip);
            initial();
          });
        }
      } catch (e) {
        // print("eeeeeeeeeeeeeeee $e");
      }
    } else if (locIp == "false") {
      setState(() {
        ip = locIp;
        loginData.setString('individualIp', ip);
        getName();
      });
      //print("im inisde the keyvalue");
      //initial();
    }
  }

  initial() async {
    loginData = await SharedPreferences.getInstance();
    var dataPlz = loginData.getStringList('dataValues');
    // print(dataPlz);
    if (dataPlz != null) {
      setState(() {
        data = dataPlz;
      });
      getName();
    } else {
      firstProcess();
    }
  }

  Future getName() async {
    pageLoader = 0;

    setState(() {
      pageLoader = 1;
    });

    //initial();

    // print("${data} the lenth of the in inidiviul");

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
        pg.add("Bedroom1");
      } else if (data[i].toString().contains("Bedroom2") &&
          (!name.contains(data[i].toString().contains("Bedroom2")))) {
        name.add("Bedroom2");
        pg.add("Bedroom2");
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
      } else if (data[i].toString().contains("Outside") &&
          (!name.contains(data[i].toString().contains("Outside")))) {
        name.add("Outside");
        pg.add("Outside");
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
      } else if (data[i].toString().contains("Green Room") &&
          (!name.contains(data[i].toString().contains("Green Room")))) {
        name.add("Green Room");
        pg.add("Green Room");
      }
    }

    setState(() {
      name = name.toSet().toList();
      pg = pg.toSet().toList();
      // print('name values = ${name}');
    });
    return "success";
  }

  firstProcess() async {
    loginData = await SharedPreferences.getInstance();
    databaseReference.child('family').once().then((value) {
      for (var element in value.snapshot.children) {
        ownerId = element.value;
        // print(ownerId);
        // print(auth.currentUser.uid);
        // print(element.key);
        if (element.key == auth.currentUser.uid) {
          loginData.setString('ownerId', ownerId['owner-uid']);
          setState(() {
            authKey = loginData.getString('ownerId');
            // fireData();
          });
          break;
        } else {
          loginData.setString('ownerId', auth.currentUser.uid);
          setState(() {
            authKey = loginData.getString('ownerId');
            // fireData();
          });
        }
      }
    }).then((value) => fireData());
  }


  Future<void> fireData() async {
    // print("im at before atlast of firedata $authKey");
    databaseReference.child(authKey).once().then((snap) async {
      dataJson = snap.snapshot.value;

      setState(() {
        bothOffOn = dataJson['localServer']['BothOfflineAndOnline'];
        noLocalServer = dataJson['noLocalServer'];
        localServer = dataJson['localServer'];

        if (noLocalServer != true) {
          if (bothOffOn == true) {
            //print("both on off in button");
            keyValues();
            //firebase ****************
          } else {
            keyValues();
          }
        } else {
          smartHome = dataJson['SmartHome'];
          var len = smartHome['Devices'].length;
          // print(len);
          for (int i = 1; i <= len; i++) {
            data.add(smartHome['Devices']['Id$i']['Room']);
          }
          // print(data);
          getName();
        }
      });
    });
  }

  @override
  void initState() {
    initial();
    firstProcess();
    keyValues();
    initial();
    // timer = Timer.periodic(Duration(seconds: 1), (Timer t)
    // {
    //   keyValues();
    // });

    super.initState();
  }

  // @override
  // void dispose() {
  //   timer?.cancel();
  //   // TODO: implement dispose
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery
        .of(context)
        .size
        .height;
    final width = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .backgroundColor,
      body: Container(
          height: height * 1.0,
          width: width * 1.0,
          child: PageView.builder(
              itemCount: pg.length,
              itemBuilder: (context, index) {
                if (index == 0) {
                  // print("index========================= $index");
                  return Pages(
                      name[widget.ind].toString(), widget.g1, widget.ind,
                      widget.ipAddress);
                } else if (index == widget.ind) {
                  // print("index //////////////////// $index");
                  return Pages(name[0].toString(), widget.g1, widget.ind,
                      widget.ipAddress);
                } else {
                  // print("index ++++++++++++++++++++  $index");
                  return Pages(name[index].toString(), widget.g1, widget.ind,
                      widget.ipAddress);
                }
              })
      ),
    );
  }
}


class Pages extends StatefulWidget {
  final String roomName;
  final int index;
  final Gradient g1;
  final String localIp;

  Pages(this.roomName, this.g1, this.index, this.localIp);

  @override
  _PagesState createState() => _PagesState();
}

class _PagesState extends State<Pages> with WidgetsBindingObserver {

  List data = [];

  List dataValue = [];

  List<Container> buttonsList = List<Container>();
  String title;
  bool result = false;
  bool result2 = false;
  bool result3 = false;
  bool isSwitched;
  Timer timer;
  Timer timer1;
  List name = [];
  List pg = [];
  String buttonName;
  String localIp;
  String up;
  SharedPreferences loginData;
  String ip;
  var dataJson;
  var daKey;
  var daValue;
  var smartHome;
  bool bothOffOn;

  bool noLocalServer;
  var localServer;
  bool vibrate = false;
  String authKey = " ";
  var ownerId;
  var personalDataJson;
  List boolStatusValue = [];
  DateTime currentPhoneDate;
  String username;
  String userName;


  List<Widget> _buildButtonsWithNames() {
    // print(" im inside the buildbutton--------------=========== $data");
    buttonsList.clear();
    for (int i = 0; i < data.length; i++) {
      //print("im inside the build button");
      if (ip.toLowerCase().toString() == 'false') {
        //print(" !!!!!!!!!!!!!!!!!!!!!!!!! im inside the button online!!!!!!!!!!!!!!!!!!!!1 ");
        buttonOnline(i);
      }
      else {
        //print("----------------- im inside the  buttonoffline ------------");
        buttonOffline(i);
      }
    }
    setState(() {
      buttonsList = buttonsList.toSet().toList();
    });
    return buttonsList;
  }


  List fanName = [];
  var fanNameList;

  void buttonOnline(int i) {
    if (dataValue[i]["Device_Type"].toString().contains("Light") &&
        dataValue[i]["Room"].toString() == widget.roomName) {
      //print("im inside the button above button list container ${dataValue[i]}");
      // print("$buttonsList ");
      buttonsList.add(Container(
        child: InkWell(
            onTap: () {
              // print("im inside the inkwell on Tap()");
              // print(dataValue[i]["Room"]);
              // print(dataValue[i]["Device_Type"]);
              // print(dataValue[i]["Device_Name"]);
              // print(dataValue[i]['id']);
              // print(dataValue[i]["Device_Status"]);
              setState(() {
                if (vibrate) {
                  Vibration.vibrate(duration: 50, amplitude: 25);
                } else {
                  Vibration.cancel();
                }
                dataValue[i]["Device_Status"] = !dataValue[i]["Device_Status"];
                //print(dataValue[i]["Device_Status"]);
                updateValue(dataValue[i]["id"], dataValue[i]["Device_Name"],
                    dataValue[i]["Device_Status"], 0);
              });
              //print(dataValue[i]["Device_Status"]);
              // check().then((intenet) {
              //   //print("im inside the inkwell");
              //   if (intenet) {
              //     // Internet Present Case
              //     //print("im inside the button above if ");
              //     if ((dataValue[0][i] == 1) || (dataValue[0][i] == "1")) {
              //       //print("im inside the if of inkwell ++++++++++");
              //       setState(() {
              //         dataValue[0][i] = 0;
              //         up = "False";
              //       });
              //     } else {
              //       setState(() {
              //         dataValue[0][i] = 1;
              //         up = "True";
              //       });
              //     }
              //     setState(() {
              //       // if(widget.check_url==false){
              //       //   update_value(data[i],data_value[0][i], i);
              //       // }else{
              //       //   update_value(data[i],up, i);
              //       // }
              //       updateValue(data[i],up, i);
              //       // print("${data_value[0][i]} data value is =================");
              //       // print("$up the value of up is *************");
              //       // print("$i after i is+++++++++++++++++------");
              //       _buildButtonsWithNames();
              //     });
              //     //print("Connection: present");
              //   } else {
              //     showDialog(
              //         context: context,
              //         builder: (_) => AlertDialog(
              //           backgroundColor: Colors.black,
              //           title: Text(
              //             "No Internet Connection",
              //             style: TextStyle(color: Colors.white),
              //           ),
              //           content: Text(
              //               "Please check your Internet Connection",
              //               style: TextStyle(color: Colors.white)),
              //         ));
              //     //print("Connection: not present");
              //   }
              // });
            },
            child: Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.17,
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.37,
                padding: const EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: !dataValue[i]["Device_Status"]
                        ? Colors.grey[900]
                        : Colors.orange,
                    //color: Colors.orange,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 0),
                          color: Colors.grey[700],
                          blurRadius: 1,
                          spreadRadius: 1),
                      BoxShadow(
                          offset: Offset(1, 1),
                          color: Colors.black87,
                          blurRadius: 1,
                          spreadRadius: 1)
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.08,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.25,
                      child:
                      SvgPicture.asset(
                        "images/light.svg",
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.010,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.015,
                    ),
                    Container(
                      child: Column(
                        children: [
                          AutoSizeText(
                            dataValue[i]["Device_Name"].toString(),
                            style: GoogleFonts.robotoSlab(
                              /*fontSize: 12,*/
                                color: Colors.white),
                            maxLines: 1,
                            minFontSize: 7,
                          )
                        ],
                      ),
                    ),
                  ],
                ))),
      ));
    }
    else if (dataValue[i]["Device_Type"].toString().contains("Valve") &&
        dataValue[i]["Room"].toString() == widget.roomName) {
      //print("im inside the button above button list container ${dataValue[i]}");
      // print("$buttonsList ");
      buttonsList.add(Container(
        child: InkWell(
            onTap: () {
              // print("im inside the inkwell on Tap()");
              // print(dataValue[i]["Room"]);
              // print(dataValue[i]["Device_Type"]);
              // print(dataValue[i]["Device_Name"]);
              // print(dataValue[i]["id"]);
              // print(dataValue[i]["Device_Status"]);
              setState(() {
                if (vibrate) {
                  Vibration.vibrate(duration: 50, amplitude: 25);
                } else {
                  Vibration.cancel();
                }
                dataValue[i]["Device_Status"] = !dataValue[i]["Device_Status"];
                //print(dataValue[i]["Device_Status"]);
                updateValue(dataValue[i]["id"], dataValue[i]["Device_Name"],
                    dataValue[i]["Device_Status"], 0);
              });
              //print(dataValue[i]["Device_Status"]);
              // check().then((intenet) {
              //   //print("im inside the inkwell");
              //   if (intenet) {
              //     // Internet Present Case
              //     //print("im inside the button above if ");
              //     if ((dataValue[0][i] == 1) || (dataValue[0][i] == "1")) {
              //       //print("im inside the if of inkwell ++++++++++");
              //       setState(() {
              //         dataValue[0][i] = 0;
              //         up = "False";
              //       });
              //     } else {
              //       setState(() {
              //         dataValue[0][i] = 1;
              //         up = "True";
              //       });
              //     }
              //     setState(() {
              //       // if(widget.check_url==false){
              //       //   update_value(data[i],data_value[0][i], i);
              //       // }else{
              //       //   update_value(data[i],up, i);
              //       // }
              //       updateValue(data[i],up, i);
              //       // print("${data_value[0][i]} data value is =================");
              //       // print("$up the value of up is *************");
              //       // print("$i after i is+++++++++++++++++------");
              //       _buildButtonsWithNames();
              //     });
              //     //print("Connection: present");
              //   } else {
              //     showDialog(
              //         context: context,
              //         builder: (_) => AlertDialog(
              //           backgroundColor: Colors.black,
              //           title: Text(
              //             "No Internet Connection",
              //             style: TextStyle(color: Colors.white),
              //           ),
              //           content: Text(
              //               "Please check your Internet Connection",
              //               style: TextStyle(color: Colors.white)),
              //         ));
              //     //print("Connection: not present");
              //   }
              // });
            },
            child: Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.17,
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.37,
                padding: const EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: !dataValue[i]["Device_Status"]
                        ? Colors.grey[900]
                        : Colors.orange,
                    //color: Colors.orange,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 0),
                          color: Colors.grey[700],
                          blurRadius: 1,
                          spreadRadius: 1),
                      BoxShadow(
                          offset: Offset(1, 1),
                          color: Colors.black87,
                          blurRadius: 1,
                          spreadRadius: 1)
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.08,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.25,
                      child:
                      SvgPicture.asset(
                        "images/valve.svg",
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.010,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.015,
                    ),
                    Container(
                      child: Column(
                        children: [
                          AutoSizeText(
                            dataValue[i]["Device_Name"].toString(),
                            style: GoogleFonts.robotoSlab(
                              /*fontSize: 12,*/
                                color: Colors.white),
                            maxLines: 1,
                            minFontSize: 7,
                          )
                        ],
                      ),
                    ),
                  ],
                ))),
      ));
    }
    else if (dataValue[i]["Device_Type"].toString().contains("Switch") &&
        dataValue[i]["Room"].toString() == widget.roomName) {
      buttonsList.add(Container(
          child: InkWell(
              onTap: () {
                setState(() {
                  if (vibrate) {
                    Vibration.vibrate(duration: 50, amplitude: 25);
                  } else {
                    Vibration.cancel();
                  }
                  dataValue[i]["Device_Status"] =
                  !dataValue[i]["Device_Status"];
                  updateValue(dataValue[i]["id"], dataValue[i]["Device_Name"],
                      dataValue[i]["Device_Status"], 0);
                  //updateValue(dataValue[i]["id"],dataValue[i]["Device_Status"]);
                });

                // check().then((intenet) {
                //   if (intenet) {
                //     // Internet Present Case
                //     if ((dataValue[0][i] == 1) || (dataValue[0][i] == "1")) {
                //       setState(() {
                //         dataValue[0][i] = 0;
                //         up = "False";
                //       });
                //     } else {
                //       setState(() {
                //         dataValue[0][i] = 1;
                //         up = "True";
                //       });
                //     }
                //     setState(() {
                //       // if(widget.check_url==false){
                //       //   update_value(data[i],data_value[0][i], i);
                //       // }else{
                //       //   update_value(data[i],up, i);
                //       // }
                //
                //       updateValue(data[i],up, i);
                //       _buildButtonsWithNames();
                //     });
                //     //print("Connection: present");
                //   } else {
                //     showDialog(
                //         context: context,
                //         builder: (_) => AlertDialog(
                //           backgroundColor: Colors.black,
                //           title: Text(
                //             "No Internet Connection",
                //             style: TextStyle(color: Colors.white),
                //           ),
                //           content: Text(
                //               "Please check your Internet Connection",
                //               style: TextStyle(color: Colors.white)),
                //         ));
                //     //print("Connection: not present");
                //   }
                // });
              },
              child: Container(
                // height: MediaQuery.of(context).size.height * 0.12,
                // width: MediaQuery.of(context).size.width * 0.265,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.17,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.37,

                  padding: const EdgeInsets.all(5),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: !dataValue[i]["Device_Status"]
                          ? Colors.grey[900]
                          : Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 0),
                            color: Colors.grey[700],
                            blurRadius: 1,
                            spreadRadius: 1),
                        BoxShadow(
                            offset: Offset(1, 1),
                            color: Colors.black87,
                            blurRadius: 1,
                            spreadRadius: 1)
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.04,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.2,
                        margin: EdgeInsets.only(top: 10),
                        child:
                        dataValue[i]["Device_Name"].toString().contains("TV") ?
                        Image(image: AssetImage("images/tv.png",),
                          color: Colors.white,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.051,) :
                        dataValue[i]["Device_Name"].toString().contains(
                            "Home Theatre") ?
                        Image(image: AssetImage("images/home-theater.png",),
                          color: Colors.white,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.051,) :
                        dataValue[i]["Device_Name"].toString().contains("Ac") ?
                        Image(image: AssetImage("images/ac.png",),
                          color: Colors.white,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.051,) :
                        dataValue[i]["Device_Name"].toString().contains(
                            "Heater") ?
                        Image(image: AssetImage("images/water-heater.png",),
                          color: Colors.white,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.051,) :
                        dataValue[i]["Device_Name"].toString().contains(
                            "Printer") ?
                        Image(image: AssetImage("images/printer.png",),
                          color: Colors.white,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.051,) :
                        Image(image: AssetImage("images/socket.png",),
                          color: Colors.white,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.051,),
                        // SvgPicture.asset(
                        //   "images/ac.svg",
                        //   height: MediaQuery.of(context).size.height * 0.051,
                        // ),

                      ),
                      SizedBox(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.015,
                      ),
                      Container(
                        child: Column(
                          children: [
                            AutoSizeText(
                              dataValue[i]["Device_Name"].toString(),
                              style: GoogleFonts.robotoSlab(
                                /*fontSize: 12,*/
                                  color: Colors.white),
                              maxLines: 1,
                              minFontSize: 7,
                            )
                          ],
                        ),
                      ),
                    ],
                  )))));
    }
    else if (dataValue[i]["Fan_Name"].toString().contains("Fan") &&
        dataValue[i]["Room"].toString() == widget.roomName) {

      /// Edited on Mohan.................
      setState(() {
        fanName.add(dataValue[i]['Fan_Name']);
        fanNameList = fanName.toSet().toList();
        // print(fanNameList);
      });

      buttonsList.add(Container(
        child: Container(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.12,
            // height: MediaQuery.of(context).size.height * 0.17,
            // width: MediaQuery.of(context).size.width * 0.33,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 0),
                      color: Colors.grey[700],
                      blurRadius: 1,
                      spreadRadius: 1),
                  BoxShadow(
                      offset: Offset(1, 1),
                      color: Colors.black87,
                      blurRadius: 1,
                      spreadRadius: 1)
                ]),
            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,

                  children: [
                    /*Text(data[i].toString().split("Slide")[0].replaceAll("_", " "),
                      style: GoogleFonts.robotoSlab(color: Colors.black)),*/
                    Text(
                        dataValue[i]["Fan_Name"].toString(),

                        style: GoogleFonts.robotoSlab(color: Colors.white)),
                  ],
                ),
                Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.05,
                  child: Slider(
                    activeColor: Colors.yellowAccent,
                    inactiveColor: Colors.grey[500],
                    value: double.parse(
                        dataValue[i]['Fan_Status'] ? dataValue[i]["Fan_Speed"]
                            .toString() : "0"),
                    min: 0,
                    max: 5,
                    divisions: 5,
                    label: dataValue[i]["Fan_Speed"].toString().substring(0, 1),
                    onChangeEnd: (double value) {
                      setState(() {
                        if (vibrate) {
                          Vibration.vibrate(duration: 50, amplitude: 25);
                        } else {
                          Vibration.cancel();
                        }
                        updateValue(
                            dataValue[i]["id"], dataValue[i]["Fan_Name"],
                            dataValue[i]["Fan_Status"],
                            dataValue[i]["Fan_Speed"]);
                        //updateValue(dataValue[i]["id"], status)
                      });
                      // check().then((intenet) {
                      //   if (intenet) {
                      //     // Internet Present Case
                      //
                      //     setState(() {
                      //       dataValue[0][i] = value.toInt().toString();
                      //       /*update_value(data[i], data_value[0][i], i);
                      //     _buildButtonsWithNames();*/
                      //     });
                      //     //print("Connection: present");
                      //   } else {
                      //     showDialog(
                      //         context: context,
                      //         builder: (_) => AlertDialog(
                      //           backgroundColor: Colors.black,
                      //           title: Text(
                      //             "No Internet Connection",
                      //             style: TextStyle(color: Colors.white),
                      //           ),
                      //           content: Text(
                      //               "Please check your Internet Connection",
                      //               style: TextStyle(color: Colors.white)),
                      //         ));
                      //   }
                      //   setState(() {
                      //     updateValue(data[i], dataValue[0][i], i);
                      //     _buildButtonsWithNames();
                      //   });
                      // });
                    },
                    onChanged: (double value) {
                      // print("value of fan is $value");
                      setState(() {
                        dataValue[i]["Fan_Speed"] = value;

                        //print("datavalue is ${dataValue[i]["Fan_Speed"]}");
                      });
                    },
                  ),
                )
              ],
            )),
      ));
    }
  }

  void buttonOffline(int i) {
    if (dataValue[i]["Device_Type"].toString().contains("Light") &&
        dataValue[i]["Room"].toString() == widget.roomName) {
      //print("im inside the button above button list container ${dataValue[i]}");
      // print("$boolStatusValue uiyiuyuyuiyui ");
      // print("${boolStatusValue[i]} ");
      buttonsList.add(Container(
        child: InkWell(
            onTap: () {
              // print("im inside the inkwell on Tap()");
              // print(dataValue[i]["Room"]);
              // print(dataValue[i]["Device_Type"]);
              // print(dataValue[i]["Device_Name"]);
              // print(dataValue[i]["id"]);
              // print(dataValue[i]["Device_Status"]);
              setState(() {
                if (vibrate) {
                  Vibration.vibrate(duration: 50, amplitude: 25);
                } else {
                  Vibration.cancel();
                }
                dataValue[i]["Device_Status"] = !dataValue[i]["Device_Status"];
                //print(dataValue[i]["Device_Status"]);
                updateValue(dataValue[i]["id"], dataValue[i]["Device_Name"],
                    dataValue[i]["Device_Status"], 0);
              });
              //print(dataValue[i]["Device_Status"]);
              // check().then((intenet) {
              //   //print("im inside the inkwell");
              //   if (intenet) {
              //     // Internet Present Case
              //     //print("im inside the button above if ");
              //     if ((dataValue[0][i] == 1) || (dataValue[0][i] == "1")) {
              //       //print("im inside the if of inkwell ++++++++++");
              //       setState(() {
              //         dataValue[0][i] = 0;
              //         up = "False";
              //       });
              //     } else {
              //       setState(() {
              //         dataValue[0][i] = 1;
              //         up = "True";
              //       });
              //     }
              //     setState(() {
              //       // if(widget.check_url==false){
              //       //   update_value(data[i],data_value[0][i], i);
              //       // }else{
              //       //   update_value(data[i],up, i);
              //       // }
              //       updateValue(data[i],up, i);
              //       // print("${data_value[0][i]} data value is =================");
              //       // print("$up the value of up is *************");
              //       // print("$i after i is+++++++++++++++++------");
              //       _buildButtonsWithNames();
              //     });
              //     //print("Connection: present");
              //   } else {
              //     showDialog(
              //         context: context,
              //         builder: (_) => AlertDialog(
              //           backgroundColor: Colors.black,
              //           title: Text(
              //             "No Internet Connection",
              //             style: TextStyle(color: Colors.white),
              //           ),
              //           content: Text(
              //               "Please check your Internet Connection",
              //               style: TextStyle(color: Colors.white)),
              //         ));
              //     //print("Connection: not present");
              //   }
              // });
            },
            child: Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.17,
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.37,
                padding: const EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  // color: (boolStatusValue[i] == false)? Colors.grey[900]:Colors.orange,
                    color: !dataValue[i]["Device_Status"]
                        ? Colors.grey[900]
                        : Colors.orange,
                    //color: Colors.orange,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 0),
                          color: Colors.grey[700],
                          blurRadius: 1,
                          spreadRadius: 1),
                      BoxShadow(
                          offset: Offset(1, 1),
                          color: Colors.black87,
                          blurRadius: 1,
                          spreadRadius: 1)
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.08,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.25,
                      child:
                      SvgPicture.asset(
                        "images/light.svg",
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.010,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.015,
                    ),
                    Container(
                      child: Column(
                        children: [
                          AutoSizeText(
                            dataValue[i]["Device_Name"].toString(),
                            style: GoogleFonts.robotoSlab(
                              /*fontSize: 12,*/
                                color: Colors.white),
                            maxLines: 1,
                            minFontSize: 7,
                          )
                        ],
                      ),
                    ),
                  ],
                ))),
      ));
    }
    else if (dataValue[i]["Device_Type"].toString().contains("Valve") &&
        dataValue[i]["Room"].toString() == widget.roomName) {
      //print("im inside the button above button list container ${dataValue[i]}");
      // print("$buttonsList ");
      buttonsList.add(Container(
        child: InkWell(
            onTap: () {
              // print("im inside the inkwell on Tap()");
              // print(dataValue[i]["Room"]);
              // print(dataValue[i]["Device_Type"]);
              // print(dataValue[i]["Device_Name"]);
              // print(dataValue[i]["id"]);
              // print(dataValue[i]["Device_Status"]);
              setState(() {
                if (vibrate) {
                  Vibration.vibrate(duration: 50, amplitude: 25);
                } else {
                  Vibration.cancel();
                }
                dataValue[i]["Device_Status"] = !dataValue[i]["Device_Status"];
                //print(dataValue[i]["Device_Status"]);
                updateValue(dataValue[i]["id"], dataValue[i]["Device_Name"],
                    dataValue[i]["Device_Status"], 0);
              });
              //print(dataValue[i]["Device_Status"]);
              // check().then((intenet) {
              //   //print("im inside the inkwell");
              //   if (intenet) {
              //     // Internet Present Case
              //     //print("im inside the button above if ");
              //     if ((dataValue[0][i] == 1) || (dataValue[0][i] == "1")) {
              //       //print("im inside the if of inkwell ++++++++++");
              //       setState(() {
              //         dataValue[0][i] = 0;
              //         up = "False";
              //       });
              //     } else {
              //       setState(() {
              //         dataValue[0][i] = 1;
              //         up = "True";
              //       });
              //     }
              //     setState(() {
              //       // if(widget.check_url==false){
              //       //   update_value(data[i],data_value[0][i], i);
              //       // }else{
              //       //   update_value(data[i],up, i);
              //       // }
              //       updateValue(data[i],up, i);
              //       // print("${data_value[0][i]} data value is =================");
              //       // print("$up the value of up is *************");
              //       // print("$i after i is+++++++++++++++++------");
              //       _buildButtonsWithNames();
              //     });
              //     //print("Connection: present");
              //   } else {
              //     showDialog(
              //         context: context,
              //         builder: (_) => AlertDialog(
              //           backgroundColor: Colors.black,
              //           title: Text(
              //             "No Internet Connection",
              //             style: TextStyle(color: Colors.white),
              //           ),
              //           content: Text(
              //               "Please check your Internet Connection",
              //               style: TextStyle(color: Colors.white)),
              //         ));
              //     //print("Connection: not present");
              //   }
              // });
            },
            child: Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.17,
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.37,
                padding: const EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  // color: !dataValue[i]["Device_Status"] ? Colors.grey[900]:Colors.orange,
                    color: !dataValue[i]["Device_Status"]
                        ? Colors.grey[900]
                        : Colors.orange,
                    //color: Colors.orange,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 0),
                          color: Colors.grey[700],
                          blurRadius: 1,
                          spreadRadius: 1),
                      BoxShadow(
                          offset: Offset(1, 1),
                          color: Colors.black87,
                          blurRadius: 1,
                          spreadRadius: 1)
                    ]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.08,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.25,
                      child:
                      SvgPicture.asset(
                        "images/valve.svg",
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.010,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.015,
                    ),
                    Container(
                      child: Column(
                        children: [
                          AutoSizeText(
                            dataValue[i]["Device_Name"].toString(),
                            style: GoogleFonts.robotoSlab(
                              /*fontSize: 12,*/
                                color: Colors.white),
                            maxLines: 1,
                            minFontSize: 7,
                          )
                        ],
                      ),
                    ),
                  ],
                ))),
      ));
    }
    else if (dataValue[i]["Device_Type"].toString().contains("Switch") &&
        dataValue[i]["Room"].toString() == widget.roomName) {
      buttonsList.add(Container(
          child: InkWell(
              onTap: () {
                setState(() {
                  if (vibrate) {
                    Vibration.vibrate(duration: 50, amplitude: 25);
                  } else {
                    Vibration.cancel();
                  }
                  dataValue[i]["Device_Status"] =
                  !dataValue[i]["Device_Status"];
                  updateValue(dataValue[i]["id"], dataValue[i]["Device_Name"],
                      dataValue[i]["Device_Status"], 0);
                  //updateValue(dataValue[i]["id"],dataValue[i]["Device_Status"]);
                });

                // check().then((intenet) {
                //   if (intenet) {
                //     // Internet Present Case
                //     if ((dataValue[0][i] == 1) || (dataValue[0][i] == "1")) {
                //       setState(() {
                //         dataValue[0][i] = 0;
                //         up = "False";
                //       });
                //     } else {
                //       setState(() {
                //         dataValue[0][i] = 1;
                //         up = "True";
                //       });
                //     }
                //     setState(() {
                //       // if(widget.check_url==false){
                //       //   update_value(data[i],data_value[0][i], i);
                //       // }else{
                //       //   update_value(data[i],up, i);
                //       // }
                //
                //       updateValue(data[i],up, i);
                //       _buildButtonsWithNames();
                //     });
                //     //print("Connection: present");
                //   } else {
                //     showDialog(
                //         context: context,
                //         builder: (_) => AlertDialog(
                //           backgroundColor: Colors.black,
                //           title: Text(
                //             "No Internet Connection",
                //             style: TextStyle(color: Colors.white),
                //           ),
                //           content: Text(
                //               "Please check your Internet Connection",
                //               style: TextStyle(color: Colors.white)),
                //         ));
                //     //print("Connection: not present");
                //   }
                // });
              },
              child: Container(
                // height: MediaQuery.of(context).size.height * 0.12,
                // width: MediaQuery.of(context).size.width * 0.265,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.17,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.37,

                  padding: const EdgeInsets.all(5),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    // color: !dataValue[i]["Device_Status"]? Colors.grey[900]:Colors.orange,
                      color: !dataValue[i]["Device_Status"]
                          ? Colors.grey[900]
                          : Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 0),
                            color: Colors.grey[700],
                            blurRadius: 1,
                            spreadRadius: 1),
                        BoxShadow(
                            offset: Offset(1, 1),
                            color: Colors.black87,
                            blurRadius: 1,
                            spreadRadius: 1)
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.04,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.2,
                        margin: EdgeInsets.only(top: 10),
                        child:
                        dataValue[i]["Device_Name"].toString().contains("TV") ?
                        Image(image: AssetImage("images/tv.png",),
                          color: Colors.white,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.051,) :
                        dataValue[i]["Device_Name"].toString().contains(
                            "Home Theatre") ?
                        Image(image: AssetImage("images/home-theater.png",),
                          color: Colors.white,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.051,) :
                        dataValue[i]["Device_Name"].toString().contains("Ac") ?
                        Image(image: AssetImage("images/ac.png",),
                          color: Colors.white,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.051,) :
                        dataValue[i]["Device_Name"].toString().contains(
                            "Heater") ?
                        Image(image: AssetImage("images/water-heater.png",),
                          color: Colors.white,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.051,) :
                        dataValue[i]["Device_Name"].toString().contains(
                            "Printer") ?
                        Image(image: AssetImage("images/printer.png",),
                          color: Colors.white,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.051,) :
                        Image(image: AssetImage("images/socket.png",),
                          color: Colors.white,
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.051,),
                        // SvgPicture.asset(
                        //   "images/ac.svg",
                        //   height: MediaQuery.of(context).size.height * 0.051,
                        // ),

                      ),
                      SizedBox(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.015,
                      ),
                      Container(
                        child: Column(
                          children: [
                            AutoSizeText(
                              dataValue[i]["Device_Name"].toString(),
                              style: GoogleFonts.robotoSlab(
                                /*fontSize: 12,*/
                                  color: Colors.white),
                              maxLines: 1,
                              minFontSize: 7,
                            )
                          ],
                        ),
                      ),
                    ],
                  )))));
    }
    else if (dataValue[i]["Device_Type"].toString().contains("Fan") &&
        dataValue[i]["Room"].toString() == widget.roomName) {
      /// Edited on Mohan.................
      setState(() {
        fanName.add(dataValue[i]['Fan_Name']);
        fanNameList = fanName.toSet().toList();
        // print(fanNameList);
      });

      buttonsList.add(Container(
        child: Container(
            height: MediaQuery
                .of(context)
                .size
                .height * 0.12,
            // height: MediaQuery.of(context).size.height * 0.17,
            // width: MediaQuery.of(context).size.width * 0.33,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 0),
                      color: Colors.grey[700],
                      blurRadius: 1,
                      spreadRadius: 1),
                  BoxShadow(
                      offset: Offset(1, 1),
                      color: Colors.black87,
                      blurRadius: 1,
                      spreadRadius: 1)
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    /*Text(data[i].toString().split("Slide")[0].replaceAll("_", " "),
                      style: GoogleFonts.robotoSlab(color: Colors.black)),*/
                    Text(
                        dataValue[i]["Fan_Name"].toString(),
                        style: GoogleFonts.robotoSlab(color: Colors.white)),
                  ],
                ),
                Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.05,
                  child: Slider(
                    activeColor: Colors.yellowAccent,
                    inactiveColor: Colors.grey[500],
                    value: double.parse(
                        dataValue[i]['Fan_Status'] ? dataValue[i]["Fan_Speed"]
                            .toString() : "0"),
                    min: 0,
                    max: 5,
                    divisions: 5,
                    label: dataValue[i]["Fan_Speed"].toString().substring(0, 1),
                    onChangeEnd: (double value) {
                      setState(() {
                        if (vibrate) {
                          Vibration.vibrate(duration: 50, amplitude: 25);
                        } else {
                          Vibration.cancel();
                        }
                        // print(dataValue[i]["Fan_Speed"]);
                        // print(dataValue[i]["Fan_Status"]);
                        updateValue(
                            dataValue[i]["id"], dataValue[i]["Fan_Name"],
                            dataValue[i]["Fan_Status"],
                            dataValue[i]["Fan_Speed"]);
                        //updateValue(dataValue[i]["id"], status)
                      });
                      // check().then((intenet) {
                      //   if (intenet) {
                      //     // Internet Present Case
                      //
                      //     setState(() {
                      //       dataValue[0][i] = value.toInt().toString();
                      //       /*update_value(data[i], data_value[0][i], i);
                      //     _buildButtonsWithNames();*/
                      //     });
                      //     //print("Connection: present");
                      //   } else {
                      //     showDialog(
                      //         context: context,
                      //         builder: (_) => AlertDialog(
                      //           backgroundColor: Colors.black,
                      //           title: Text(
                      //             "No Internet Connection",
                      //             style: TextStyle(color: Colors.white),
                      //           ),
                      //           content: Text(
                      //               "Please check your Internet Connection",
                      //               style: TextStyle(color: Colors.white)),
                      //         ));
                      //   }
                      //   setState(() {
                      //     updateValue(data[i], dataValue[0][i], i);
                      //     _buildButtonsWithNames();
                      //   });
                      // });
                    },
                    onChanged: (double value) {
                      //print("value of fan is $value");
                      setState(() {
                        dataValue[i]["Fan_Speed"] = value;
                        //print("datavalue is ${dataValue[i]["Fan_Speed"]}");
                      });
                    },
                  ),
                )
              ],
            )),
      ));
    }
    else if (dataValue[i]["Device_Type"].toString().contains("Motion Sensor") &&
        dataValue[i]["Room"].toString() == widget.roomName) {
      buttonsList.add(Container(
          child: InkWell(
              onTap: () {
                setState(() {
                  if (vibrate) {
                    Vibration.vibrate(duration: 50, amplitude: 25);
                  } else {
                    Vibration.cancel();
                  }
                  // print(dataValue[i]["id"]);
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) =>
                      MotionSensorPage(deviceName: dataValue[i]["Device_Name"],
                        deviceId: dataValue[i]["id"], ip: ip.toString(),
                      )));
                  // dataValue[i]["Device_Status"] = !dataValue[i]["Device_Status"];
                  // updateValue(dataValue[i]["id"],dataValue[i]["Device_Name"],dataValue[i]["Device_Status"],0);
                  // //updateValue(dataValue[i]["id"],dataValue[i]["Device_Status"]);
                });
              },
              child: Container(
                // height: MediaQuery.of(context).size.height * 0.12,
                // width: MediaQuery.of(context).size.width * 0.265,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.17,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.37,

                  padding: const EdgeInsets.all(5),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    // color: !dataValue[i]["Device_Status"]? Colors.grey[900]:Colors.orange,
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 0),
                            color: Colors.grey[700],
                            blurRadius: 1,
                            spreadRadius: 1),
                        BoxShadow(
                            offset: Offset(1, 1),
                            color: Colors.black87,
                            blurRadius: 1,
                            spreadRadius: 1)
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.04,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.2,
                        margin: EdgeInsets.only(top: 10),
                        child:
                        Image(image: AssetImage("images/motion_sensor.png",),
                          color: Colors.white, height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.051,),
                      ),
                      SizedBox(
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.015,
                      ),
                      Container(
                        child: Column(
                          children: [
                            AutoSizeText(
                              dataValue[i]["Device_Name"].toString(),
                              style: GoogleFonts.robotoSlab(
                                /*fontSize: 12,*/
                                  color: Colors.white),
                              maxLines: 1,
                              minFontSize: 7,
                            )
                          ],
                        ),
                      ),
                    ],
                  )))));
    }

    else if (dataValue[i]["Device_Type"].toString().contains("Led") &&
        dataValue[i]["Room"].toString() == widget.roomName) {
      buttonsList.add(Container(
        child: InkWell(
          onTap: () {
            setState(() {
              if (vibrate) {
                Vibration.vibrate(duration: 50, amplitude: 25);
              } else {
                Vibration.cancel();
              }
              // print(dataValue[i]["id"]);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) =>
                  LedLightsPage(deviceName: dataValue[i]["Device_Name"],
                    deviceId: dataValue[i]["id"], ip: ip.toString(),
                    status: dataValue[i]['Device_Status'],
                  )));
              // dataValue[i]["Device_Status"] = !dataValue[i]["Device_Status"];
              // updateValue(dataValue[i]["id"],dataValue[i]["Device_Name"],dataValue[i]["Device_Status"],0);
              // //updateValue(dataValue[i]["id"],dataValue[i]["Device_Status"]);
            });
          },
          child: Container(
            // height: MediaQuery.of(context).size.height * 0.12,
            // width: MediaQuery.of(context).size.width * 0.265,
            height: MediaQuery
                .of(context)
                .size
                .height * 0.17,
            width: MediaQuery
                .of(context)
                .size
                .width * 0.37,
            padding: const EdgeInsets.all(5),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              // color: !dataValue[i]["Device_Status"]? Colors.grey[900]:Colors.orange,
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 0),
                      color: Colors.grey[700],
                      blurRadius: 1,
                      spreadRadius: 1),
                  BoxShadow(
                      offset: Offset(1, 1),
                      color: Colors.black87,
                      blurRadius: 1,
                      spreadRadius: 1)
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.08,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.2,
                  margin: EdgeInsets.only(top: 01),
                  child:
                  SvgPicture.asset(
                    "images/light.svg",
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.010,
                  ),
                ),
                SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.015,
                ),
                Container(
                  child: Column(
                    children: [
                      AutoSizeText(
                        dataValue[i]["Device_Name"].toString(),
                        style: GoogleFonts.robotoSlab(
                          /*fontSize: 12,*/
                            color: Colors.white),
                        maxLines: 1,
                        minFontSize: 7,
                      )
                    ],
                  ),
                ),
              ],
            ),),),),);
    }
  }

  keyValues() async {
    loginData = await SharedPreferences.getInstance();
    final locIp = loginData.getString('ip') ?? null;
    final onIp = loginData.getString('onlineIp') ?? null;

    if ((locIp != null) && (locIp != "false")) {
      // print("1457 indivi ${locIp}");
      final response = await http.get(Uri.parse("http://$locIp/")).timeout(
          const Duration(milliseconds: 500), onTimeout: () {
        //ignore:avoid_print
        // print(" inside the timeout ");
        data.clear();
        setState(() {
          ip = onIp;
        });
        loginData.setString('individualIp', ip);
        initial();


        return;
      });
      // print("1467 indivi ${response.statusCode}");
      if (response.statusCode > 0) {
        setState(() {
          data.clear();
          ip = locIp;
          loginData.setString('individualIp', ip);
          initial();
        });
      }
    } else if (locIp == "false") {
      setState(() {
        ip = locIp;
        loginData.setString('individualIp', ip);
        initial();
      });
      //print("im inisde the keyvalue");
      //initial();
    }
  }

  initial() async {
    loginData = await SharedPreferences.getInstance();
    setState(() {
      username = loginData.getString('username');
      if ((username == " ") || (username == null)) {
        username = userName;
      }
      ip = loginData.getString('individualIp');
      vibrate = loginData.get('vibrationStatus') ?? false;
    });
    if (ip == null) {
      // print("ip iiiiiiiiiiiii $ip");
      keyValues();
    } else {
      // print("1502 ip ii $ip");
      call().then((value) {
        // statusValue();
        callByValue();
      });
    }
  }


  updateValue(id, name, status, speed) {
    // print(name);
    // print("im inside the update ");
    Timestamp myTimeStamp = Timestamp.fromDate(currentPhoneDate);
    // print(myTimeStamp.millisecondsSinceEpoch);
    // print(username);
    if (ip.toString() != 'false') {
      setState(() {
        // print(ip);
        if (fanNameList.contains(name)) {
          int fan_speed = speed.toInt();
          if (fan_speed == 0) {
            http.put(
              Uri.parse('http://$ip/fan/$id/'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, dynamic>{
                'Fan_Status': false,
                'Last_Updated': username,
                'Time_Stamp': myTimeStamp.millisecondsSinceEpoch,
              }),
            ).then((value) => callByValue());
          } else {
            http.put(
              Uri.parse('http://$ip/fan/$id/'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, dynamic>{
                'Fan_Speed': fan_speed,
                'Fan_Status': true,
                'Last_Updated': username,
                'Time_Stamp': myTimeStamp.millisecondsSinceEpoch,
              }),
            ).then((value) => callByValue());
          }
        } else {
          http.put(
            Uri.parse('http://$ip/$id/'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, dynamic>{
              'Device_Status': status,
              'Last_Updated': username,
              'Time_Stamp': myTimeStamp.millisecondsSinceEpoch,
            }),
          ).then((value) => callByValue());
        }
        result = true;
      });
    } else if (ip.toString() == 'false') {
      setState(() {
        if (fanNameList.contains(name)) {
          int fan_speed = speed.toInt();
          if (fan_speed == 0) {
            // print("hello");
            databaseReference.child(authKey).child('SmartHome')
                .child('Fan')
                .child('Id$id')
                .update({
              'Fan_Status': false,
              'Last_Updated': username,
              'Time_Stamp': myTimeStamp.millisecondsSinceEpoch,
            });
          } else {
            // print("desperojbfj ");
            // print(fan_speed);
            databaseReference.child(authKey).child('SmartHome')
                .child('Fan')
                .child('Id$id')
                .update({
              'Fan_Speed': fan_speed,
              'Fan_Status': true,
              'Last_Updated': username,
              'Time_Stamp': myTimeStamp.millisecondsSinceEpoch,
            });
          }
          // setState(() {
          //   result = true;
          // });
        } else {
          databaseReference.child(authKey).child('SmartHome')
              .child('Devices')
              .child('Id$id')
              .update({
            'Device_Status': status,
            'Last_Updated': username,
            'Time_Stamp': myTimeStamp.millisecondsSinceEpoch,
          });
        }
        result = true;
      });
    }
  }

  // updateValue(id,name,status,speed) async {
  //   // print("im inside the update ");
  //   if (ip.toString() != 'false') {
  //     setState(() {
  //       if(name == "Fan"){
  //         int fan_speed =  speed.toInt();
  //        if(fan_speed == 0)
  //        {
  //          http.put(
  //            Uri.parse('http://$ip/fan/$id/'),
  //            headers: <String, String>{
  //              'Content-Type': 'application/json; charset=UTF-8',
  //            },
  //            body: jsonEncode(<String, dynamic>{
  //              'Fan_Status': false,
  //            }),
  //          );
  //        }else{
  //          http.put(
  //            Uri.parse('http://$ip/fan/$id/'),
  //            headers: <String, String>{
  //              'Content-Type': 'application/json; charset=UTF-8',
  //            },
  //              body: jsonEncode(<String, dynamic>{
  //                'Fan_Speed': fan_speed,
  //                'Fan_Status': true,
  //              }),
  //          );
  //        }
  //       }else{
  //         http.put(
  //           Uri.parse('http://$ip/$id/'),
  //           headers: <String, String>{
  //             'Content-Type': 'application/json; charset=UTF-8',
  //           },
  //           body: jsonEncode(<String, bool>{
  //             'Device_Status': status,
  //           }),
  //         );
  //       }
  //     });
  //
  //     // if (response.statusCode == 200) {
  //     setState(() {
  //       result = true;
  //       //print("im inside the update the value");
  //     });
  //
  //   }
  //   else if(ip.toString() == 'false'){
  //     // databaseReference.child(auth.currentUser.uid).update({
  //     //   button : buttonValue
  //     // });
  //     //print("im inside the update state ");
  //     if(name == "Fan"){
  //       int fan_speed =  speed.toInt();
  //       if(fan_speed == 0)
  //       {
  //          // print(fan_speed);
  //          // print("hello");
  //         databaseReference.child(authKey).child('SmartHome').child('Fan').child('Id$id').update({
  //           'Fan_Status' : false,
  //         });
  //       }else{
  //         // print("desperojbfj ");
  //         // print(fan_speed);
  //         databaseReference.child(authKey).child('SmartHome').child('Fan').child('Id$id').update({
  //           'Fan_Speed' :  fan_speed,
  //           'Fan_Status' :  true,
  //         });
  //       }
  //       // databaseReference.child(auth.currentUser.uid).child('SmartHome').child('Fan').child('Id$id').update({
  //
  //       setState(() {
  //         result = true;
  //       });
  //
  //     }else{
  //
  //       databaseReference.child(authKey).child('SmartHome').child('Devices').child('Id$id').update({
  //         'Device_Status' :  status,
  //       });
  //       setState(() {
  //         result = true;
  //       });
  //
  //     }
  //
  //   }
  // }
  ///statusMethod
  // statusValue() async {
  //   if (ip.toString() != 'false') {
  //     try{
  //       final response = await http.get(Uri.parse("http://$ip/"));
  //       final fanResponse = await http.get(Uri.parse("http://$ip/fan/"));
  //       var val = jsonDecode(response.body);
  //       var fan = jsonDecode(fanResponse.body);
  //
  //       // if(response.statusCode > 200){
  //       //   print("fuck -================ ${response.statusCode} ");
  //       // }
  //       // print("value in cal by is $val");
  //       // print("value in cal by is $fan");
  //       // setState(() {
  //         boolStatusValue.clear();
  //
  //         for (int i = 0; i < val.length; i++)
  //         {
  //           boolStatusValue.add(val[i]["Device_Status"]);
  //         }
  //         for (int i = 0; i < fan.length; i++)
  //         {
  //           boolStatusValue.add(fan[i]["Fan_Status"]);
  //         }
  //           setState((){
  //             result3 = true;
  //           });
  //         // print(boolStatusValue);
  //       // });
  //     }catch(e){
  //       // print("status in if $e ");
  //     }
  //
  //   } else if (ip.toString() == 'false') {
  //     //print("im inside the else if of call_value() ");
  //     Future.delayed(const Duration(milliseconds: 500), () {
  //       var val = smartHome['Devices'];
  //       var fanVal = smartHome['Fan'];
  //       setState(() {
  //         dataValue.clear();
  //         boolStatusValue.clear();
  //
  //         for (int i = 1; i <= val.length; i++) {
  //           dataValue.add(val['Id$i']);
  //           boolStatusValue.add(val[i]);
  //         }
  //         for (int i = 1; i <= fanVal.length; i++) {
  //           dataValue.add(fanVal['Id$i']);
  //         }
  //       });
  //     });
  //   }
  // }

  Future<dynamic> call() async {
    // print("the ip value in call is line:1302 on call $ip ");
    if (ip.toString() != 'false') {
      // print("1771 the ip inside the call is $ip");
      // print("im inside the if loop of call +++++++++++++++++ *********************");
      try {
        final response = await http.get(Uri.parse("http://$ip/"));
        final fanResponse = await http.get(Uri.parse("http://$ip/fan/"));
        final motionResponse = await http.get(Uri.parse("http://$ip/motion/"));
        final ledResponse = await http.get(Uri.parse("http://$ip/led/"));

        var val = jsonDecode(response.body);
        var fan = jsonDecode(fanResponse.body);
        var motion = jsonDecode(motionResponse.body);
        var led = jsonDecode(ledResponse.body);
        // print(val);
        // print(fan);
        // print(led);
        // if (response.statusCode == 200) {
        // print("response: ${response.statusCode}");
        setState(() {
          data.clear();
          //data = val["Room"];
          for (int i = 0; i < val.length; i++) {
            data.add(val[i]["Room"]);
          }
          for (int i = 0; i < fan.length; i++) {
            // print("room ${widget.roomName}     1795 callll             ");
            if (widget.roomName == fan[i]["Room"]) {
              // print("fan data ${fan[i]["Room"]} 1798 calllllllllllllll");
              data.add(fan[i]["Room"]);
              //print("im printing");
            }
          }
          for (int i = 0; i < motion.length; i++) {
            //print("room ${widget.roomName}");
            if (widget.roomName == motion[i]["Room"]) {
              //print("fan data ${fan[i]["Room"]}");
              data.add(motion[i]["Room"]);
              //print("im printing");
            }
          }
          for (int i = 0; i < led.length; i++) {
            //print("room ${widget.roomName}");
            if (widget.roomName == led[i]["Room"]) {
              //print("fan data ${fan[i]["Room"]}");
              data.add(led[i]["Room"]);
              //print("im printing");
            }
          }
          setState(() {
            result = true;
            // print("1815 $result callllllllllllllllllllllllllllll ");
          });
          //print("$data inside the value of setstate in if case");
        });

        return result;
      } catch (e) {
        // print("call()------------------------ in if $e ");
      }
    }
    else if (ip.toString() == 'false') {
      // print(smartHome);

      Future.delayed(const Duration(milliseconds: 500), () {
        var val = smartHome['Devices'];
        var fanVal = smartHome['Fan'];

        setState(() {
          data.clear();
          for (int i = 1; i <= val.length; i++) {
            data.add(val['Id$i']["Room"]);
          }
          for (int i = 1; i <= fanVal.length; i++) {
            if (widget.roomName == fanVal['Id$i']["Room"]) {
              data.add(fanVal['Id$i']["Room"]);
            }
          }

          result = true;
        });
      });
      return result;
    }
  }

  Future<dynamic> callByValue() async {
    // print("1851 im inside the call-by and the $ip _______________ ");
    if (ip.toString() != 'false') {
      // print("55555555555555555555555");
      try {
        final response = await http.get(Uri.parse("http://$ip/"));
        final fanResponse = await http.get(Uri.parse("http://$ip/fan/"));
        final motionResponse = await http.get(Uri.parse("http://$ip/motion/"));
        final ledResponse = await http.get(Uri.parse("http://$ip/led/"));
        var val = jsonDecode(response.body);
        var fan = jsonDecode(fanResponse.body);
        var motion = jsonDecode(motionResponse.body);
        var led = jsonDecode(ledResponse.body);
        // print("value in cal by is $val");
        // setState(() {
        dataValue.clear();

        for (int i = 0; i < val.length; i++) {
          dataValue.add(val[i]);
        }

        for (int i = 0; i < fan.length; i++) {
          // print("widget ${widget.roomName} 1874 ");
          if (widget.roomName == fan[i]["Room"]) {
            dataValue.add(fan[i]);
          }
        }
        for (int i = 0; i < motion.length; i++) {
          // print("widget ${widget.roomName} 1882 ");
          if (widget.roomName == motion[i]["Room"]) {
            dataValue.add(motion[i]);
            //print("datavalue is ${dataValue[20]}");
            //print("im printing");
          }
        }

        for (int i = 0; i < led.length; i++) {
          // print("widget ${widget.roomName} 1882 ");
          if (widget.roomName == led[i]["Room"]) {
            dataValue.add(led[i]);
            //print("datavalue is ${dataValue[20]}");
            //print("im printing");
          }
        }
        // dataValue = val;
        // print("+++++++++++++++++++++ ssvalue of data_value-----");
        setState(() {
          result2 = true;
          // print(" 1894 $result2 callbyvalue");
        });
        return result2;
      } catch (e) {
        // print("callByValue()+++++++++++++++++++++ in if $e ");
      }
    }
    else if (ip.toString() == 'false') {
      // print("im inside the else if of call_value() ");
      Future.delayed(const Duration(milliseconds: 500), () {
        var val = smartHome['Devices'];
        var fanVal = smartHome['Fan'];
        setState(() {
          dataValue.clear();

          for (int i = 1; i <= val.length; i++) {
            dataValue.add(val['Id$i']);
          }
          for (int i = 1; i <= fanVal.length; i++) {
            if (widget.roomName == fanVal['Id$i']["Room"]) {
              dataValue.add(fanVal['Id$i']);
            }
          }
          //dataValue;
          // print("dataValues is $dataValue ");
          result2 = true;
          //print("$dataValue the data value inside the call_by setsstate");
        });
      });
      return result2;
    }
  }

  firstProcess() async {
    loginData = await SharedPreferences.getInstance();
    setState(() {
      authKey = loginData.getString('ownerId');
      fireData();
    });
  }

  Future<void> fireData() async {
    databaseReference.child(auth.currentUser.uid).once().then((value) async {
      personalDataJson = value.snapshot.value;
      setState(() {
        userName = personalDataJson["name"];
      });
    });

    databaseReference.child(authKey).once().then((snap) async {
      dataJson = snap.snapshot.value;
      setState(() {
        bothOffOn = dataJson['localServer']['BothOfflineAndOnline'];
        noLocalServer = dataJson['noLocalServer'];
        localServer = dataJson['localServer'];

        if (noLocalServer != true) {
          if (bothOffOn == true) {
            //print("im inside the  firedata on individual on line: 1417 on page page ");
            initial();
            //firebase ****************
          } else {
            initial();
            //print("im inside the else of both on and off ");
          }
        } else {
          ip = "false";
          smartHome = dataJson['SmartHome'];
          call();
        }
      });
    });
  }


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
    keyValues();
    firstProcess();
    initial();

    check().then((internet) {
      if (internet) {
        call().then((value) {
          callByValue();
        });
      }
      else {
        showDialog(
            context: context,
            builder: (_) =>
                AlertDialog(
                  backgroundColor: Colors.black,
                  title: Text(
                    "No Internet Connection",
                    style: TextStyle(color: Colors.white),
                  ),
                  content: Text("Please check your Internet Connection",
                      style: TextStyle(color: Colors.white)),
                ));
        //print("Connection: not present");
      }
    });
    timer = Timer.periodic(
        Duration(seconds: 1),
            (Timer t) {
          currentPhoneDate = DateTime.now();
        }
    );
    timer1 = Timer.periodic(
        Duration(seconds: 2),
            (Timer t) {
          firstProcess();
          callByValue();
        }
    );
    super.initState();
  }

  @override
  void dispose() {
    // WidgetsBinding.instance.removeObserver(this);
    timer?.cancel();
    timer1?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(result);
    // print(result2);
    final height = MediaQuery
        .of(context)
        .size
        .height;
    final width = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Container(
          height: height * 1.0,
          width: width * 1.0,
          child: Column(
            children: [
              Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              colors: [
                                // Color.fromRGBO(0, 0, 0, 1.0),
                                // Color.fromRGBO(38, 42, 45, 1.0),
                                Theme
                                    .of(context)
                                    .primaryColor,
                                Theme
                                    .of(context)
                                    .scaffoldBackgroundColor
                              ],
                              stops: [
                                0.1,
                                0.9
                              ])),
                      child: Container(
                        height: height * 0.35,
                        width: width * 1.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.7),
                                    BlendMode.dstATop),
                                image: ((widget.roomName.toString().replaceAll(
                                    "_", " ") == "Hall"))
                                    ? AssetImage(
                                  "images/room/hall.png",
                                )
                                    : ((widget.roomName.toString().replaceAll(
                                    "_", " ") == "Admin Room"))
                                    ? AssetImage(
                                  "images/room/admin room.jpg",
                                ) : ((widget.roomName.toString().replaceAll(
                                    "_", " ") == "Garage"))
                                    ? AssetImage(
                                  "images/room/garage.png",
                                )
                                    : ((widget.roomName.toString().replaceAll(
                                    "_", " ") == "Kitchen"))
                                    ? AssetImage(
                                  "images/room/kitchen.png",
                                )
                                    : ((widget.roomName.toString().replaceAll(
                                    "_", " ") == "Bathroom1"))
                                    ? AssetImage(
                                  "images/room/bathroom 1.png",
                                ) : ((widget.roomName.toString().replaceAll(
                                    "_", " ") == "Bathroom2"))
                                    ? AssetImage(
                                  "images/room/bathroom 2.png",
                                ) : ((widget.roomName.toString().replaceAll(
                                    "_", " ") == "Bathroom"))
                                    ? AssetImage(
                                  "images/room/bathroom 1.png",
                                )
                                    : ((widget.roomName.toString().replaceAll(
                                    "_", " ") == "Bedroom1"))
                                    ? AssetImage(
                                  "images/room/bedroom 1.png",
                                )
                                    : ((widget.roomName.toString().replaceAll(
                                    "_", " ") == "Bedroom2"))
                                    ? AssetImage(
                                  "images/room/bedroom 2.png",
                                )
                                    : ((widget.roomName.toString().replaceAll(
                                    "_", " ") == "Master Bedroom"))
                                    ? AssetImage(
                                  "images/room/master bedroom.png",
                                )
                                    : ((widget.roomName.toString().replaceAll(
                                    "_", " ") == "Bedroom"))
                                    ? AssetImage(
                                  "images/room/bedroom 2.png",
                                )
                                    : ((widget.roomName.toString().replaceAll(
                                    "_", " ") == "Kids Room"))
                                    ? AssetImage(
                                  "images/room/kids bedroom.png",
                                )
                                    : ((widget.roomName.toString().replaceAll(
                                    "_", " ") == "Outside"))
                                    ? AssetImage(
                                  "images/room/outside.png",
                                )
                                    : ((widget.roomName.toString().replaceAll(
                                    "_", " ") == "Garden"))
                                    ? AssetImage(
                                  "images/room/garden.png",
                                )
                                    : ((widget.roomName.toString().replaceAll(
                                    "_", " ") == "Parking"))
                                    ? AssetImage(
                                  "images/room/parking.png",
                                )
                                    : ((widget.roomName.toString().replaceAll(
                                    "_", " ") == "Living Room"))
                                    ? AssetImage(
                                  "images/room/living room.png",

                                )
                                    : ((widget.roomName.toString().replaceAll(
                                    "_", " ") == "Store Room"))
                                    ? AssetImage(
                                  "images/room/store room.png",
                                )
                                    : ((widget.roomName.toString().replaceAll(
                                    "_", " ") == "Farm"))
                                    ? AssetImage(
                                  "images/room/farm.jpg",
                                ) : ((widget.roomName.toString().replaceAll(
                                    "_", " ") == "Green Room"))
                                    ? AssetImage(
                                  "images/room/green_room.png",
                                )
                                    : AssetImage(""),
                                //farm added here
                                fit: BoxFit.fill)
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 18.0),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back, color: Colors.white,
                          size: height * 0.030,),
                      ),
                    )
                  ]
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                //height: height * 0.3724,
                height: height * 0.64889,
                width: width * 1.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        Color.fromRGBO(0, 0, 0, 1.0),
                        Color.fromRGBO(45, 47, 49, 1.0),
                        // Theme.of(context).primaryColor,
                        // Theme.of(context).scaffoldBackgroundColor
                      ],
                      stops: [
                        0.1,
                        0.7
                      ]),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: height * 0.015,
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          widget.roomName.toString().replaceAll("_", " "),
                          style: GoogleFonts.robotoSlab(
                              fontSize: 24, color: Colors.white),
                        )),

                    SizedBox(
                      height: height * 0.010,
                    ),

                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      height: height * 0.5500,
                      width: width * 1.0,
                      color: Colors.transparent,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            result && result2
                                ? Container(
                                padding: EdgeInsets.all(10.0),
                                // color: Colors.red,
                                child: Wrap(
                                  spacing: 2.0,
                                  children: _buildButtonsWithNames(),
                                )) : GridView.builder(
                                shrinkWrap: true,
                                itemCount: 6,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 1.0,
                                    mainAxisSpacing: 1.0),
                                itemBuilder: (BuildContext context, int index) {
                                  return buildMovieShimmer();
                                }),
                            //     : Container(
                            //   child: Container(
                            //     margin: EdgeInsets.only(top: height * 0.4),
                            //     padding: EdgeInsets.all(10),
                            //     child: Column(
                            //       children: [
                            //         CircularProgressIndicator(
                            //           backgroundColor: Colors.grey[700],
                            //           valueColor:
                            //           new AlwaysStoppedAnimation<Color>(
                            //               Colors.white),
                            //         ),
                            //         SizedBox(
                            //           height: height*0.02,
                            //         ),
                            //         Text(" Loading.... ",
                            //           style: GoogleFonts.inter(
                            //               fontWeight: FontWeight.w300, color: Colors.white),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget buildMovieShimmer() =>
      //ListTile(
  //   leading: CustomWidget.circular(height: 64, width: 64),
  //   title: Align(
  //     alignment: Alignment.centerLeft,
  //     child: CustomWidget.rectangular(height: 16,
  //       width: MediaQuery.of(context).size.width*0.3,),
  //   ),
  //   subtitle: CustomWidget.rectangular(height: 14),
  // );
  Container(
    // height: MediaQuery.of(context).size.height * 0.15,
    // width: MediaQuery.of(context).size.width * 0.34,
    margin: EdgeInsets.all(10),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
              offset: Offset(0, 0),
              color: Colors.grey[700],
              blurRadius: 1,
              spreadRadius: 1),
          BoxShadow(
              offset: Offset(1, 1),
              color: Colors.black87,
              blurRadius: 1,
              spreadRadius: 1)
        ]
    ),
    child: CustomWidget.rectangular(height: MediaQuery
        .of(context)
        .size
        .height * 0.17,
      width: MediaQuery
          .of(context)
          .size
          .width * 0.37,),
  );
}
