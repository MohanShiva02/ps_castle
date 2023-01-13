import 'dart:async';
import 'dart:convert';
import  'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
// import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'individual_page.dart';



FirebaseAuth auth = FirebaseAuth.instance;
final databaseReference = FirebaseDatabase.instance.reference();



Route _createRoute(String word,int index,String ip,Gradient g1){
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Button(word, index, ip, g1,),
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



class FirstPageGridContainer extends StatefulWidget {

  @override
  _FirstPageGridContainerState createState() => _FirstPageGridContainerState();
}

class _FirstPageGridContainerState extends State<FirstPageGridContainer> {

  bool wifiNotifier = false;
  String ip;
  String username ;
  bool notifier = false;
  bool mobNotifier = false;
  Gradient g1 = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Colors.grey[800],
        Colors.grey[800],
      ]);

  bool currentIndex = false;
  bool valueStatus = false;
  List name = [];
  List pg = [];
  List data = [];
  bool first;
  bool status = false;
  int statusInt = 0;
  List toggleValues = [];
  int intValue = 0;
  Timer timer;
  bool hasInternet = false;
  ConnectivityResult result = ConnectivityResult.none;
  List<String> localDataVal = [];
  List<String> dumVariable = [];
  var dataJson;
  var acount = 0;
  var count = 0;
  SharedPreferences loginData;
  String userName = " ";
  String ipAddress = null;
  String ipLocal = " ";
  String onlineIp = " ";
  String phoneNumber = " ";
  String email = " ";
  bool noLocalServer;
  var localServer;
  bool bothOffOn ;
  var smartHome;
  bool vibrate = false;
  String authKey = " ";
  var ownerId;
  var personalDataJson;

  keyValues() async {

    loginData = await SharedPreferences.getInstance();
    final locIp = loginData.getString('ip') ?? null;
    final onIp = loginData.getString('onlineIp') ?? null;

    if((locIp != null)&&(locIp != "false")){
      final response = await http.get(Uri.parse("http://$locIp/")).timeout(
          const Duration(milliseconds: 1000),onTimeout: (){
        //ignore:avoid_print
        //print(" inside the timeout gridPage ");
        setState(() {
          ipAddress = onIp;
        });
        data.clear();
        initial();
        return;
      });
      if(response.statusCode > 0){
        //setState is used timer verify in grid page **************************
        setState(() {
          //ignore:avoid_print
          //print("im inside the if $ipLocal local ip in gridPage");
          data.clear();
          ipAddress = locIp;
          initial();
          //ignore:avoid_print
          //print("im inside the if and the ipAddress is $ipAddress  gridPage");
        });
      }

      //localDataVariableStorage();
    }else if(locIp == "false"){
      setState(() {
        ipAddress = locIp;
        initial();
      });
    }

  }

  Future<void> initial() async {
    loginData = await SharedPreferences.getInstance();
    username = loginData.getString('username');
    if(username == " "){
      setState(() {
        username = userName;
      });
    }
    vibrate = loginData.get('vibrationStatus')??false;

    if (ipAddress == null) {

      fireData();
    } else if ((data == null) || (data.length == 0)) {

      if (ipAddress.toString() != 'false') {

        final response = await http.get(Uri.parse("http://$ipAddress/",));
        var fetchdata = jsonDecode(response.body);

        setState(() {
          localDataVal.clear();
          dumVariable.clear();
          var dumData = fetchdata;
          for (int i = 0; i < dumData.length; i++)
          {
            dumVariable.add(dumData[i]["Room"].toString());
          }
          localDataVal = dumVariable.toSet().toList();
          data = localDataVal;
          loginData.setStringList('dataValues', localDataVal);
          initial();
        });
      }else if((ipAddress.toString() == 'false'))
      {
        //print("im inside the false");
        setState(() {
          getName();

          // fireData();
          // localDataVal.clear();
          // //print(dataJson.keys.toList());
          // data = dataJson.keys.toList();
          // for(int i =0; i<data.length ; i++)
          // {
          //   localDataVal.add(data[i].toString());
          // }
          // //print("im local in else if loop data $localDataVal");
          // loginData.setStringList('dataValues', localDataVal);
        });
        //showAnotherAlertDialog(context);
      }
    } else {
      //print("im going into the getName of list in initial ");
      getName();
    }
  }

  checkData() async {
    //print("im inside the check data of first page");
    loginData = await SharedPreferences.getInstance();
    if(ipLocal == "false"){
      loginData.setString('username', userName);
      loginData.setString('ip', ipLocal );
      loginData.setString('onlineIp', onlineIp);
      keyValues();
    }else{
      loginData.setString('ip', ipLocal );
      loginData.setString('onlineIp', onlineIp);
      loginData.setString('username', userName);
      keyValues();
    }
  }

  firstProcess() async {
    loginData = await SharedPreferences.getInstance();
    databaseReference.child('family').once().then((value){
      for (var element in value.snapshot.children){
        ownerId = element.value;
        if(element.key == auth.currentUser.uid){
          loginData.setString('ownerId', ownerId['owner-uid']);
          authKey = loginData.getString('ownerId');
          fireData();
          break;
        }else{
          loginData.setString('ownerId', auth.currentUser.uid);
          authKey = loginData.getString('ownerId');
          fireData();
        }
      }
    });
  }

  Future<void> fireData() async {

    databaseReference.child(auth.currentUser.uid).once().then((value) async{
      personalDataJson = value.snapshot.value;
      userName = personalDataJson["name"];
      email = personalDataJson['email'];
      phoneNumber = personalDataJson['phone'].toString();
    });

    databaseReference.child(authKey).once().then((snapshot) async {
      dataJson = snapshot.snapshot.value;
      // dataJson = snapshot.value;
      setState(() {
        bothOffOn = dataJson['localServer']['BothOfflineAndOnline'];
        noLocalServer = dataJson['noLocalServer'];
        localServer = dataJson['localServer'];

        if(noLocalServer != true){
          if(bothOffOn == true){
            ipLocal = localServer['offlineIp'].toString();
            onlineIp = localServer['staticIp'].toString();
            checkData();
            //firebase ****************
          }else{
            ipLocal = dataJson['offlineIp'].toString();
            onlineIp = "false";
            checkData();
          }
        }else{
          smartHome = dataJson['SmartHome'];
          ipLocal = "false";
          onlineIp = "false";
          var len = smartHome['Devices'].length;
          for(int i =1;i<=len;i++)
          {
            data.add(smartHome['Devices']['Id$i']['Room']);
          }
          checkData();
          getName();
        }
      });

    });
  }

  // localDataVariableStorage() async {
  //   //print("im abov ethe initial state on local DataVar");
  //   initial();
  //   //print("im inside the localdata of list page");
  //   if ((ipAddress.toString().toLowerCase() != "false") && (ipAddress.toString() != null)) {
  //     //print("iam using online json in below if class and ip address is $ipAddress");
  //     if (result == ConnectivityResult.wifi) {
  //       //print("in the inside the if o local data of storage inside ethe  $ipAddress");
  //       final response = await http.get(Uri.parse(
  //         "http://$ipAddress/key",
  //       ));
  //       var fetchdata = jsonDecode(response.body);
  //       if (response.statusCode > 0) {
  //         // data = fetchdata;
  //         setState(() {
  //           data = fetchdata;
  //           for (int i = 0; i < data.length; i++) {
  //             localDataVal.add(data[i].toString());
  //           }
  //           //print("im local in if loop data in list $localDataVal");
  //           loginData.setStringList('dataValues', localDataVal);
  //           initial();
  //           // print(data);
  //         });
  //       }
  //     } else if (result == ConnectivityResult.mobile) {
  //       if (count < 1) {
  //         //showAnotherAlertDialog(context);
  //         showSimpleNotification(
  //           Text(
  //             " please switch to WiFi ",
  //             style: TextStyle(color: Colors.white),
  //           ),
  //           background: Colors.red,
  //         );
  //         count = 2;
  //       }
  //     } else {
  //       print("no internet in wifi in list page");
  //     }
  //   } else if ((ipAddress.toLowerCase().toString() == "false") &&
  //       (ipAddress.toString() != null)) {
  //     //print("im inisde the else if ");
  //     if (result == ConnectivityResult.mobile) {
  //       setState(() {
  //         data = dataJson.keys.toList();
  //         for (int i = 0; i < data.length; i++) {
  //           localDataVal.add(data[i].toString());
  //         }
  //         //print("im local in else if loop data $localDataVal");
  //         loginData.setStringList('dataValues', localDataVal);
  //       });
  //     } else if (result == ConnectivityResult.wifi) {
  //       //print some add some functionality
  //       print(
  //           "*********im inside the else if of ip Address and inside the esle state********");
  //     }
  //   }
  //   //sharedDataValues = loginData.getStringList('dataValues');
  // }

  // wiFiChecker() {
  //   //print("im wifichecker");
  //   if (result == ConnectivityResult.wifi) {
  //     //getName();
  //     //print("hello im wifi");
  //     if ((acount == 0) && (ipAddress.toString().toLowerCase() != 'false')) {
  //       //print("im iniside the wifi");
  //       if (acount < 1) {
  //         showSimpleNotification(
  //           Text(
  //             " your on wifi network ",
  //             style: TextStyle(color: Colors.white),
  //           ),
  //           background: Colors.green,
  //         );
  //         acount = 2;
  //       }
  //     } else if (ipAddress == null) {
  //       //print("im inside the wifi of else if con");
  //       initial();
  //     }
  //     initial();
  //   } else if ((result == ConnectivityResult.mobile)) {
  //     //print("hello im mobile");
  //     if ((acount == 0) && (ipAddress.toString().toLowerCase() != 'false')) {
  //       //print("im iniside the mobile ");
  //       if (acount < 1) {
  //         showSimpleNotification(
  //           Text(
  //             " your are on Demo Login by Mobile Data   ",
  //             style: TextStyle(color: Colors.white),
  //           ),
  //           background: Colors.green,
  //         );
  //         acount = 2;
  //       }
  //       // getName();
  //       // localData();
  //     }
  //   } else {
  //     print("i am not connected to anything in wifi checker ___------------");
  //   }
  // }

  //
  // Future<void> getData() async {
  //   // fireData();
  //   initial();
  //
  //   // if (result == ConnectivityResult.wifi) {
  //   //   // print("wifi in listPage =============_________(((((((((()))))))");
  //   //   // print("$ipAddress =============------+++++++++++@@@@@@ ");
  //   //   // localData();
  //   //   getName();
  //   // } else if ((result == ConnectivityResult.mobile) && (!mobNotifier)) {
  //   //   // print("mobile in listPage****************************");
  //   //   // print("$ipAddress =============------+++++++++++@@@@@@ ");
  //   //
  //   //   if ((!mobNotifier) && (ipAddress.toString().toLowerCase() == 'false')) {
  //   //
  //   //     showSimpleNotification(
  //   //       Text(" your are on Demo Login by Mobile Data   ",
  //   //         style: TextStyle(color: Colors.white),), background: Colors.green,
  //   //     );
  //   //     // initial();
  //   //     getName();
  //   //     localData();
  //   //     // localData();
  //   //   }
  //   //   else {
  //   //     //showWifiNetAlertDialog(context);
  //   //     showSimpleNotification(
  //   //       Text(
  //   //         " please switch on your wifi network ",
  //   //         style: TextStyle(color: Colors.white),
  //   //       ),
  //   //       background: Colors.red,
  //   //     );
  //   //   }
  //   //   mobNotifier = true;
  //   // }
  //   // else if ((result == ConnectivityResult.none) && (!notifier)) {
  //   //   //print(" ************** none in listPage **************");
  //   //   // print("$notifier the value of the notifier is 00000000");
  //   //   if (!notifier) {
  //   //     // print(" im inside the if notifier class");
  //   //     //showAnotherAlertDialog(context);
  //   //     showSimpleNotification(
  //   //       Text(
  //   //         " No Internet Connectivity ",
  //   //         style: TextStyle(color: Colors.white),
  //   //       ),
  //   //       background: Colors.red,
  //   //     );
  //   //   }
  //   //   showAnotherAlertDialog(context);
  //   //   notifier = true;
  //   // }
  //   // });
  //
  //   // username = loginData.getString('username');
  // }
  //

  Future<void> toggleButton(int index, int sts) async {
    setState(() {
      intValue = 0;
    });
    toggleValues.clear();
    for (int i = 0; i < data.length; i++) {
      if (data[i].toString().contains(name[index].toString())) {
        toggleValues.add(data[i].toString());
      }
    }
    for (int i = 0; i < toggleValues.length; i++) {
      print(toggleValues[i]);
      while (intValue < 2) {
        // print(toggleValues[i]);
        // print("$ipAddress =======");
        // ip = loginData.getString('ip');
        await http.get(Uri.parse('http://$ipAddress/${toggleValues[i]}/$sts'));
        intValue++;
        print(intValue);
      }
      setState(() {
        intValue = 0;
      });
    }
  }

  Future getName() async {
    //  print("im inside the getname of list funtion");
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
      }  else if (data[i].toString().contains("Bathroom2") &&
          (!name.contains(data[i].toString().contains("Bathroom2")))) {
        name.add("Bathroom2");
        pg.add("Bathroom2");
      } else if (data[i].toString().contains("Bathroom") &&
          (!name.contains(data[i].toString().contains("Bathroom")))) {
        name.add("Bathroom");
        pg.add("Bathroom");
      }else if (data[i].toString().contains("Master Bedroom") &&
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
      }else if (data[i].toString().contains("Garden") &&
          (!name.contains(data[i].toString().contains("Garden")))) {
        name.add("Garden");
        pg.add("Garden");
      }else if (data[i].toString().contains("Farm") &&
          (!name.contains(data[i].toString().contains("Farm")))) {
        name.add("Farm");
        pg.add("Farm");
      } else if (data[i].toString().contains("Dining Room") &&
          (!name.contains(data[i].toString().contains("Dining Room")))) {
        name.add("Dining Room");
        pg.add("Dining Room");
      }
    }

    // name = name.toSet().toList();
    // pg = pg.toSet().toList();

    setState(() {
      name = name.toSet().toList();
      pg = pg.toSet().toList();
      //print("$name  88889978");
    });
    // print("name $name");
    // print("pg $pg");

    //return "success";
  }

  Future<void> internet() async {
    //print("the connectivity is now $result """"""""""""""""""""""""""""""""""""""""""""""""""");
    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        //print("the connectivity eeeeeeeeeeeeeeeeeee  is now $result """"""""""""""""""""""""""""""""""""""""""""""""""");
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
    keyValues();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
          return Container(
            //color: Color.fromRGBO(26, 28, 30, 0.6),
            color: Theme.of(context).backgroundColor,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: (){
                  if(vibrate){
                    Vibration.vibrate(duration: 50, amplitude: 25);
                  }else{
                    Vibration.cancel();
                  }
                  Navigator.of(context).push(_createRoute(name[index].toString(), index, ipAddress, g1,));
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=>Button(name[index].toString(),index,ipAddress,g1,)));
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=>IndividualPage(imgValue: widget.choice.backGroundImage,txtValue: widget.choice.title,)));
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
                          blurRadius: 6.0,
                          spreadRadius: 1.0,
                        ),
                      ],
                    ),
                    child: Container(
                      height: height * 0.20,
                      width: width * 0.80,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.7), BlendMode.dstATop),
                          image: name[index]
                              .toString()
                              .contains("Hall")
                              ? AssetImage(
                            "images/room/hall.png",
                          )
                              : name[index]
                              .toString()
                              .contains("Admin")
                              ? AssetImage(
                            "images/room/admin room.jpg",
                          )
                              : name[index]
                              .toString()
                              .contains(
                              "Garage")
                              ? AssetImage(
                            "images/room/garage.png",
                          )
                              : name[index]
                              .toString()
                              .contains(
                              "Kitchen")
                              ? AssetImage(
                            "images/room/kitchen.png",
                          )
                              : name[index]
                              .toString()
                              .contains(
                              "Bathroom1")
                              ? AssetImage(
                            "images/room/bathroom 1.png",
                          ): name[index]
                              .toString()
                              .contains(
                              "Bathroom2")
                              ? AssetImage(
                            "images/room/bathroom 2.png",
                          ) :name[index]
                              .toString()
                              .contains("Bathroom")
                              ? AssetImage(
                            "images/room/bathroom 1.png",
                             )
                              : name[index]
                              .toString()
                              .contains(
                              "Bedroom1")
                              ? AssetImage(
                            "images/room/bedroom 1.png",
                          )
                              : name[index].toString().contains("Bedroom2")
                              ? AssetImage(
                            "images/room/bedroom 2.png",
                          ): name[index].toString().contains("Kids Room")
                              ? AssetImage(
                            "images/room/kids bedroom.png",
                          ): name[index].toString().contains("Master Bedroom")
                              ? AssetImage(
                            "images/room/master bedroom.png",
                          )
                              : name[index].toString().contains("Bedroom")
                              ? AssetImage(
                            "images/room/bedroom 2.png",
                          )
                              : name[index].toString().contains("Outside")
                              ? AssetImage(
                            "images/room/outside.png",
                          )
                              : name[index].toString().contains("Garden")
                              ? AssetImage(
                            "images/room/garden.png",
                          )
                              : name[index].toString().contains("Parking")
                              ? AssetImage(
                            "images/room/parking.png",
                          )
                              : name[index].toString().contains("Living Room")
                              ? AssetImage(
                            "images/room/living room.png",

                          )
                              : name[index].toString().contains("Store Room")
                              ? AssetImage(
                            "images/room/store room.png",
                          )
                              : name[index].toString().contains("Farm")
                              ? AssetImage(
                            "images/room/farm.jpg",
                          ) : AssetImage(""),
                          //farm added here
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(3),
                                  child: name[index]
                                      .toString()
                                      .contains("Hall")
                                      ?Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .end,
                                        crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text("${name[index].toString().replaceAll("_"," ")}",
                                            style: Theme.of(context).textTheme.bodyText1,
                                           ),
                                        ],
                                      ): name[index]
                                      .toString()
                                      .contains("Admin")
                                      ? Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .end,
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text("${name[index].toString().replaceAll("_"," ")}",
                                        style: Theme.of(context).textTheme.bodyText1,
                                      ),
                                      //style: TextStyle(color: Colors.white,fontSize: height*0.013,fontWeight: FontWeight.w900),),

                                    ],
                                  )
                                      : name[index]
                                      .toString()
                                      .contains(
                                      "Garage")
                                      ? Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .end,
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text("${name[index].toString().replaceAll("_"," ")}",
                                        style: Theme.of(context).textTheme.bodyText1,
                                      ),

                                    ],
                                  )
                                      : name[index]
                                      .toString()
                                      .contains(
                                      "Kitchen")
                                      ? Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .end,
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text("${name[index].toString().replaceAll("_"," ")}",
                                        style: Theme.of(context).textTheme.bodyText1,
                                      ),

                                    ],
                                  )
                                      : name[index]
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
                                      Text("${name[index].toString().replaceAll("_"," ")}",
                                        style: Theme.of(context).textTheme.bodyText1,
                                      ),

                                    ],
                                  )
                                      : name[index]
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
                                      Text("${name[index].toString().replaceAll("_"," ")}",
                                        style: Theme.of(context).textTheme.bodyText1,
                                      ),

                                    ],
                                  )
                                      :name[index]
                                      .toString()
                                      .contains(
                                      "Bathroom")
                                      ? Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .end,
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(
                                        "${name[index].toString().replaceAll("_", " ")}",
                                        // style: TextStyle(
                                        //     color: Colors
                                        //         .white,
                                        //     fontSize: height *
                                        //         0.025,
                                        //     fontWeight:
                                        //     FontWeight.w900),
                                        style: Theme.of(
                                            context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                    ],
                                  )
                                      : name[index]
                                      .toString()
                                      .contains(
                                      "Bedroom1")
                                      ? Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .end,
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text("${name[index].toString().replaceAll("_"," ")}",
                                        style: Theme.of(context).textTheme.bodyText1,
                                      ),

                                    ],
                                  )
                                      : name[index].toString().contains("Bedroom2")
                                      ? Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .end,
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text("${name[index].toString().replaceAll("_"," ")}",
                                        style: Theme.of(context).textTheme.bodyText1,
                                      ),

                                    ],
                                  )
                                      : name[index].toString().contains("Master Bedroom")
                                      ? Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .end,
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text("${name[index].toString().replaceAll("_"," ")}",
                                        style: Theme.of(context).textTheme.bodyText1,
                                      ),

                                    ],
                                  )
                                      : name[index].toString().contains("Bedroom")
                                      ? Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .end,
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text("${name[index].toString().replaceAll("_"," ")}",
                                        style: Theme.of(context).textTheme.bodyText1,
                                      ),

                                    ],
                                  )
                                      : name[index].toString().contains("Outside")
                                      ? Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .end,
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text("${name[index].toString().replaceAll("_"," ")}",
                                        style: Theme.of(context).textTheme.bodyText1,
                                      ),

                                    ],
                                  )
                                      : name[index].toString().contains("Garden")
                                      ? Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .end,
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text("${name[index].toString().replaceAll("_"," ")}",
                                        style: Theme.of(context).textTheme.bodyText1,
                                      ),

                                    ],
                                  )
                                      : name[index].toString().contains("Parking")
                                      ? Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .end,
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text("${name[index].toString().replaceAll("_"," ")}",
                                        style: Theme.of(context).textTheme.bodyText1,
                                      ),

                                    ],
                                  )
                                      : name[index].toString().contains("Living Room")
                                      ? Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .end,
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text("${name[index].toString().replaceAll("_"," ")}",
                                        style: Theme.of(context).textTheme.bodyText1,
                                      ),

                                    ],
                                  )
                                      : name[index].toString().contains("Store Room")
                                      ? Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .end,
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text("${name[index].toString().replaceAll("_"," ")}",
                                        style: Theme.of(context).textTheme.bodyText1,
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
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        childCount: name.length,
      ),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: height * 0.40,
        mainAxisSpacing: 0.0,
        crossAxisSpacing: 0.0,
        childAspectRatio: 1.0,
      ),
    );
  }
  showAnotherAlertDialog(BuildContext context) {
    //Create button
    Widget okButton = TextButton(
      child: Text("ok"),
      onPressed: (){
        acount = 0;
        keyValues();
        //initial();
        //wiFiChecker();
        Navigator.pop(context, false);
      },
    );
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      title:Text(" No Internet" ,style: TextStyle(color: Colors.white60,fontWeight: FontWeight.bold), ),
      content: Text("please connect to local WiFi network",style: TextStyle(color: Colors.white60),),
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
