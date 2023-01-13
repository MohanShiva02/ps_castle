import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

// import 'package:flutter/material.dart' hide BoxDecoration,BoxShadow;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../product_page/device_pages.dart';

FirebaseAuth auth = FirebaseAuth.instance;
final databaseReference = FirebaseDatabase.instance.reference();

class SecondDashBoard extends StatefulWidget {
  const SecondDashBoard({Key key}) : super(key: key);

  @override
  _SecondDashBoardState createState() => _SecondDashBoardState();
}

class _SecondDashBoardState extends State<SecondDashBoard> {
  //"mailto:ceo@onwords.in?subject=Requesting%20for%20features%20installation&body=test%20body"
  String email =
      "mailto:ceo@onwords.in?subject=Requesting%20for%20features%20installation";
  int count = 0;

  List deviceStatus = [];

  List onlineDeviceStatus = [];
  Timer timer;

  SharedPreferences loginData;

  String ip;

  var data;

  bool eBill = false;
  int batteryLevel = 0;
  int waterLevel = 0;
  int voltage = 0;
  double amps = 0.0;
  int bill = 0;
  double unit = 0.0;
  double today_bill = 0.0;
  double total_bill = 0.0;
  bool door = false;
  var dataJson;
  bool bothOffOn;

  bool noLocalServer;
  var localServer;
  var smartHome;
  int countValue = 0;
  String authKey = " ";
  var ownerId;
  var personalDataJson;
  bool closePressed = false;
  bool openPressed = false;
  bool pausePressed = false;
  bool smartDoor = false;
  bool loader = false;
  bool dashboard = false;
  bool wta = false;
  bool gate = false;
  bool table = false;
  bool downTablePressed = false;
  bool upTablePressed = false;
  bool pauseTablePressed = false;

  keyValues() async {
    loginData = await SharedPreferences.getInstance();
    final locIp = loginData.getString('ip') ?? null;
    final onIp = loginData.getString('onlineIp') ?? null;

    if ((locIp != null) && (locIp != "false")) {
      try {
        final response = await http
            .get(Uri.parse("http://$locIp/"))
            .timeout(const Duration(milliseconds: 500), onTimeout: () {
          //ignore:avoid_print
          //print(" inside the timeout  in second screeen");
          ip = onIp;
          getDevice();
          return;
        });
        if (response.statusCode > 0) {
          ip = locIp;
          getDevice();
        }
      } catch (e) {
        // print(e);
      }
    } else if (locIp == "false") {
      ip = locIp;
      getDevice();
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
    //print("im at before atlast of firedata");

    databaseReference.child(authKey).once().then((snapshot) async {
      dataJson = snapshot.snapshot.value;

      setState(() {
        noLocalServer = dataJson['noLocalServer'];
        localServer = dataJson['localServer'];
        dashboard = dataJson['dashboard'] ?? false;
        // bothOffOn = localServer["BothOfflineAndOnline"];
        bothOffOn =
            localServer != null ? localServer["BothOfflineAndOnline"] : false;
        if (noLocalServer != true) {
          if (bothOffOn == true) {
            keyValues();
            //firebase ****************
          } else {
            keyValues();
            //print("im inside the else of both on and off ");
          }
        } else {
          ip = "false";
          smartHome = dataJson['SmartHome'];
          getDevice();
        }
        if (!dashboard) {
          initial();
        }
      });
    });
  }

  getDevice() async {
    //print("im inside the in second screeen  is $ip");
    if ((ip != 'false') && (ip != null)) {
      try {
        final res = await http.get(Uri.parse(
          "http://$ip/",
        ));
        var dumStatus = jsonDecode(res.body);
        final fanRes = await http.get(Uri.parse(
          "http://$ip/fan/",
        ));
        var fanStatus = jsonDecode(fanRes.body);

        http.Response response =
            await http.get(Uri.parse('http://$ip/sensor/'));
        data = json.decode(response.body);

        http.Response tableRes = await http.get(Uri.parse('http://$ip/table/'));
        if (tableRes.statusCode == 200) {
          // var tableData = json.decode(tableRes.body);
          setState(() {
            table = true;
          });
        }

        setState(() {
          eBill = data[0]['EB_Status'];
          batteryLevel = data[0]['UPS'];
          waterLevel = data[0]['Water_Level'];
          voltage = data[0]['Voltage'];
          amps = data[0]['Ampere'];
          door = data[0]["Door"];
          unit = data[0]["Units"];
          today_bill = data[0]["Todays_Bill"];
          total_bill = data[0]["Total_Bill"];
          smartDoor = data[0]['Door_Motor'];
          //
          // if((batteryLevel<= 40)&&(countValue == 0)){
          //   countValue = 1;
          //   NotificationApi.showNotification(
          //     title: 'Battery percentage',
          //     body: 'your UPS Battery Percentage is less than 20 %',
          //     payload: 'Battery.low',
          //   );
          // }else if((batteryLevel>= 80)&&(countValue == 1)){
          //   countValue = 0;
          //   NotificationApi.showNotification(
          //     title: 'Battery percentage',
          //     body: 'your UPS Battery Percentage is good -80 %',
          //     payload: 'Battery.high',
          //   );
          // }else{
          //   print("nothing");
          // }
          setState(() {
            loader = true;
          });
          deviceStatus.clear();
          for (int i = 0; i < dumStatus.length; i++) {
            deviceStatus.add(dumStatus[i]["Device_Status"].toString());
          }
          for (int i = 0; i < fanStatus.length; i++) {
            deviceStatus.add(fanStatus[i]["Fan_Speed"].toString());
          }
          count = 0;
          for (int i = 0; i < deviceStatus.length; i++) {
            if ((deviceStatus[i] == "true") ||
                (deviceStatus[i] == "1") ||
                (deviceStatus[i] == "2") ||
                (deviceStatus[i] == "3") ||
                (deviceStatus[i] == "4") ||
                (deviceStatus[i] == "5")) {
              count++;
            }
          }
          //print("count is $count");
        });
      } catch (e) {}
    } else if (ip == "false") {
      try {
        var val = smartHome['Devices'];
        var fanVal = smartHome['Fan'];
        var sensorValues = smartHome['Sensor'];

        setState(() {
          //acount =1;
          eBill = sensorValues['EB_Status'];
          batteryLevel = sensorValues['UPS'];
          waterLevel = sensorValues['Water_Level'];
          voltage = sensorValues['Voltage'];
          amps = sensorValues['Ampere'];
          door = sensorValues['Door'];
          smartDoor = sensorValues['door_motor'];
          count = 0;

          loader = true;

          onlineDeviceStatus.clear();

          for (int i = 1; i <= val.length; i++) {
            onlineDeviceStatus.add(val['Id$i']["Device_Status"].toString());
          }
          for (int i = 1; i <= fanVal.length; i++) {
            onlineDeviceStatus.add(fanVal['Id$i']["Fan_Speed"].toString());
          }

          for (int i = 0; i < onlineDeviceStatus.length; i++) {
            if ((onlineDeviceStatus[i] == "true") ||
                (onlineDeviceStatus[i] == "1") ||
                (onlineDeviceStatus[i] == "2") ||
                (onlineDeviceStatus[i] == "3") ||
                (onlineDeviceStatus[i] == "4") ||
                (onlineDeviceStatus[i] == "5")) {
              count++;
            }
          }
        });
        //showAnotherAlertDialog(context);
      } catch (e) {}
    } else {
      //print("the second page has online service still ");
    }
  }

  initial() async {
    loginData = await SharedPreferences.getInstance();
    setState(() {
      wta = loginData.getBool('wta');
      gate = loginData.getBool('gate');
      loader = true;
    });
  }

  int acount = 0;

  @override
  void initState() {
    //initial();
    // keyValues();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      firstProcess();
      //keyValues();
      getDevice();
    });
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
    // WillPopScope(
    //     onWillPop: () => showDialog<bool>(
    //       context: context,
    //       builder: (context) => AlertDialog(
    //         backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
    //         shape:
    //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    //         title: Text(
    //           'Warning',
    //           style:
    //           Theme.of(context).dialogTheme.titleTextStyle,
    //         ),
    //         content: Text(
    //           'Do you really want to exit',
    //           style: Theme.of(context).dialogTheme.contentTextStyle,
    //         ),
    //         actions: [
    //           TextButton(
    //             child: Text('Yes'),
    //             onPressed: () => Navigator.pop(context, true),
    //           ),
    //           TextButton(
    //             child: Text('No'),
    //             onPressed: () => Navigator.pop(context, false),
    //           ),
    //         ],
    //       ),
    //     ),
    //     child:
    return WillPopScope(
      onWillPop: () async {
        // Navigator.pop(context);
        SystemNavigator.pop();
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage(index: 0,)));
        return true;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Container(
          height: height * 1.0,
          width: width * 1.0,
          child: loader
              ? dashboard
                  ? SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            // height: 40.0,
                            height: height * 0.045,
                          ),
                          Center(
                            child: Text(
                              "PS Castle Dashboard",
                              // style: GoogleFonts.inter(
                              //     fontSize: height * 0.033,
                              //     fontWeight: FontWeight.bold,
                              //     color: Colors.white),
                              style: TextStyle(
                                fontFamily: 'Monotype',
                                fontSize: height * 0.05,
                              ),
                            ),
                          ),
                          SizedBox(
                            // height: 30.0,
                            height: height * 0.033,
                          ),
                          Center(
                            child: Text(
                              "Power Source",
                              style: Theme.of(context).textTheme.bodyText2,
                              // style: GoogleFonts.inter(
                              //     fontSize: height * 0.018, color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.011,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                // height: 80.0,
                                // width: 180.0,
                                height: height * 0.080,
                                width: width * 0.42,
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(64, 60, 60, 1.0),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CircleAvatar(
                                      child: SvgPicture.asset(
                                        "images/battery-svgrepo-com.svg",
                                        // height: 20.0,
                                        height: height * 0.024,
                                        color: Colors.white,
                                      ),
                                      backgroundColor: eBill
                                          ? Colors.grey.shade400
                                          : Colors.orange,
                                      radius: height * 0.022,
                                    ),
                                    Text(
                                      "Inverter",
                                      style: GoogleFonts.inter(
                                          fontSize: height * 0.018,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                // height: 80.0,
                                // width: 180.0,
                                height: height * 0.080,
                                width: width * 0.42,
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(64, 60, 60, 1.0),
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CircleAvatar(
                                      child: SvgPicture.asset(
                                        "images/eb.svg",
                                        // height: 20.0,
                                        height: height * 0.026,
                                        color: Colors.white,
                                      ),
                                      backgroundColor: eBill
                                          ? Colors.green
                                          : Colors.grey.shade400,
                                      radius: height * 0.022,
                                    ),
                                    Text(
                                      "Electricity",
                                      style: GoogleFonts.inter(
                                          fontSize: height * 0.017,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            // height: 20.0,
                            height: height * 0.022,
                          ),
                          Center(
                            child: Container(
                              // height: 80.0,
                              // width: 370.0,
                              height: height * 0.080,
                              width: width * 0.89,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                gradient: LinearGradient(
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                    colors: [
                                      Color.fromRGBO(64, 60, 60, 1.0),
                                      Color.fromRGBO(40, 26, 26, 1.0),
                                    ],
                                    stops: [
                                      0.1,
                                      0.9
                                    ]),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Remaining Battery",
                                    style: GoogleFonts.inter(
                                        fontSize: height * 0.017,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  CircularPercentIndicator(
                                    backgroundColor:
                                        Color.fromRGBO(56, 56, 56, 1.0),
                                    radius: height * 0.054,
                                    lineWidth: 5.0,
                                    animation: true,
                                    percent: batteryLevel / 100,
                                    center: new Text(
                                      "${batteryLevel.toInt()} %",
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 9.0,
                                          color: Colors.grey),
                                    ),
                                    circularStrokeCap: CircularStrokeCap.round,
                                    progressColor:
                                        Color.fromRGBO(255, 82, 82, 1.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.022,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 38.0),
                            child: Text(
                              "Water level",
                              // style: GoogleFonts.inter(
                              //   fontSize: height * 0.017,
                              //   color: Colors.white,
                              //   fontWeight: FontWeight.bold,
                              // ),
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ),
                          SizedBox(
                            height: height * 0.022,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                // height: 290.0,
                                // width: 120.0,
                                height: height * 0.32,
                                width: width * 0.29,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                        colors: [
                                          Color.fromRGBO(0, 22, 31, 1.0),
                                          Color.fromRGBO(0, 0, 0, 1.0),
                                        ],
                                        stops: [
                                          0.1,
                                          0.9
                                        ]),
                                    borderRadius: BorderRadius.circular(20.0)),
                                child: LiquidLinearProgressIndicator(
                                  value: waterLevel / 100,
                                  // Defaults to 0.5.
                                  valueColor: AlwaysStoppedAnimation(
                                    Color.fromRGBO(91, 156, 190, 1.0),
                                  ),
                                  // Defaults to the current Theme's accentColor.
                                  backgroundColor: Colors.transparent,
                                  // Defaults to the current Theme's backgroundColor.
                                  borderColor: Colors.black,
                                  borderWidth: 0.30,
                                  borderRadius: 20.0,
                                  direction: Axis.vertical,
                                  // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                                  center: Text(
                                    "$waterLevel %",
                                    style: GoogleFonts.inter(
                                        color: Colors.grey.shade50,
                                        fontSize: 20.0),
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Center(
                                    child: Container(
                                      // height: 200.0,
                                      // width: 240.0,
                                      height: height * 0.23,
                                      width: width * 0.55,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        gradient: LinearGradient(
                                            begin: Alignment.bottomLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Color.fromRGBO(66, 55, 143, 1.0),
                                              Color.fromRGBO(245, 56, 68, 1.0),
                                            ],
                                            stops: [
                                              0.1,
                                              0.9
                                            ]),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(20.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            // Row(
                                            //   mainAxisAlignment: MainAxisAlignment.start,
                                            //   children: [
                                            //     Text(
                                            //       "EB BILL",
                                            //       style: GoogleFonts.inter(
                                            //         fontSize: height * 0.022,
                                            //         color: Colors.white,
                                            //         fontWeight: FontWeight.bold,
                                            //       ),
                                            //     ),
                                            //   ],
                                            // ),
                                            // Column(
                                            //   crossAxisAlignment: CrossAxisAlignment.end,
                                            //   mainAxisAlignment: MainAxisAlignment.end,
                                            //   children: [
                                            //     Text(
                                            //       "Today's Bill",
                                            //       style: GoogleFonts.inter(
                                            //         fontSize: height * 0.015,
                                            //         color: Colors.white,
                                            //         fontWeight: FontWeight.bold,
                                            //       ),
                                            //     ),
                                            //     Text(
                                            //       " ₹  122.0",
                                            //       style: GoogleFonts.inter(
                                            //         fontSize: height * 0.028,
                                            //         color: Colors.white,
                                            //         fontWeight: FontWeight.bold,
                                            //       ),
                                            //     ),
                                            //     Text(
                                            //       "Total Bill",
                                            //       style: GoogleFonts.inter(
                                            //         fontSize: height * 0.013,
                                            //         color: Colors.white,
                                            //         fontWeight: FontWeight.bold,
                                            //       ),
                                            //     ),
                                            //     Text(
                                            //       " ₹ 1140.0",
                                            //       style: GoogleFonts.inter(
                                            //         fontSize: height * 0.025,
                                            //         color: Colors.white,
                                            //         fontWeight: FontWeight.bold,
                                            //       ),
                                            //     ),
                                            //   ],
                                            // )
                                            Row(
                                              //mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  " Voltage",
                                                  style: GoogleFonts.inter(
                                                    fontSize: height * 0.018,
                                                    color: Colors.white,
                                                    //fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width * 0.13,
                                                ),
                                                Text(
                                                  voltage.toString(),
                                                  style: GoogleFonts.inter(
                                                    fontSize: height * 0.015,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Divider(
                                              indent: 15.0,
                                              endIndent: 23.0,
                                              color: Colors.white38,
                                              thickness: 1.0,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  " Current",
                                                  style: GoogleFonts.inter(
                                                    fontSize: height * 0.018,
                                                    color: Colors.white,
                                                    //fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width * 0.13,
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      amps.toString(),
                                                      style: GoogleFonts.inter(
                                                        fontSize:
                                                            height * 0.015,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      " amps",
                                                      style: GoogleFonts.inter(
                                                        fontSize:
                                                            height * 0.007,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Divider(
                                              indent: 15.0,
                                              endIndent: 23.0,
                                              color: Colors.white38,
                                              thickness: 1.0,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "  Unit",
                                                  style: GoogleFonts.inter(
                                                    fontSize: height * 0.017,
                                                    color: Colors.white,
                                                    //fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width * 0.20,
                                                ),
                                                Text(
                                                  unit.toString(),
                                                  style: GoogleFonts.inter(
                                                    fontSize: height * 0.015,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.012,
                                  ),
                                  Center(
                                    child: Container(
                                        // height: 75.0,
                                        // width: 240.0,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12.0,
                                        ),
                                        height: height * 0.075,
                                        width: width * 0.55,
                                        decoration: BoxDecoration(
                                          //color: Color.fromRGBO(70, 70, 70, 1.0),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          gradient: LinearGradient(
                                              begin: Alignment.topRight,
                                              end: Alignment.bottomLeft,
                                              colors: [
                                                Color.fromRGBO(14, 11, 12, 1.0),
                                                Color.fromRGBO(
                                                    0, 159, 194, 1.0),
                                              ],
                                              stops: [
                                                0.1,
                                                0.9
                                              ]),
                                        ),
                                        child:
                                            // Row(
                                            //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            //   children: [
                                            //     Column(
                                            //       mainAxisAlignment: MainAxisAlignment.center,
                                            //       crossAxisAlignment: CrossAxisAlignment.start,
                                            //       children: [
                                            //         Text(
                                            //           "Power",
                                            //           style: GoogleFonts.inter(
                                            //             fontSize: height * 0.014,
                                            //             color: Colors.white,
                                            //             fontWeight: FontWeight.bold,
                                            //           ),
                                            //         ),
                                            //         Text(
                                            //           "Consumption",
                                            //           style: GoogleFonts.inter(
                                            //             fontSize: height * 0.014,
                                            //             color: Colors.white,
                                            //             fontWeight: FontWeight.bold,
                                            //           ),
                                            //         ),
                                            //       ],
                                            //     ),
                                            //     Column(
                                            //       mainAxisAlignment: MainAxisAlignment.center,
                                            //       crossAxisAlignment: CrossAxisAlignment.start,
                                            //       children: [
                                            //         Text(
                                            //           "Unit",
                                            //           style: GoogleFonts.inter(
                                            //             fontSize: height * 0.014,
                                            //             color: Colors.white,
                                            //             fontWeight: FontWeight.bold,
                                            //           ),
                                            //         ),
                                            //         Text(
                                            //           "215",
                                            //           style: GoogleFonts.inter(
                                            //             fontSize: height * 0.019,
                                            //             color: Colors.white,
                                            //             fontWeight: FontWeight.bold,
                                            //           ),
                                            //         ),
                                            //       ],
                                            //     ),
                                            //   ],
                                            // ),
                                            Row(
                                          children: [
                                            Text(
                                              "EB Bill",
                                              style: GoogleFonts.inter(
                                                fontSize: height * 0.014,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              width: width * 0.04,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Today's Bill",
                                                  style: GoogleFonts.inter(
                                                    fontSize: height * 0.009,
                                                    color: Colors.white,
                                                    //fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: height * 0.01,
                                                ),
                                                Text(
                                                  " ₹ $today_bill",
                                                  style: GoogleFonts.inter(
                                                    fontSize: height * 0.014,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: width * 0.03,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Total Bill",
                                                  style: GoogleFonts.inter(
                                                    fontSize: height * 0.009,
                                                    color: Colors.white,
                                                    //fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: height * 0.01,
                                                ),
                                                Text(
                                                  " ₹ $total_bill",
                                                  style: GoogleFonts.inter(
                                                    fontSize: height * 0.014,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        )),
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: height * 0.022,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Security System",
                                    // style: GoogleFonts.inter(
                                    //     fontSize: height * 0.013, color: Colors.white),
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                  SizedBox(
                                    height: height * 0.011,
                                  ),
                                  Container(
                                      // height: 70.0,
                                      // width: 170.0,
                                      height: height * 0.078,
                                      width: width * 0.40,
                                      decoration: BoxDecoration(
                                          color: door
                                              ? Color.fromRGBO(0, 179, 0, 1.0)
                                              : Colors.red.shade500,
                                          borderRadius:
                                              BorderRadius.circular(20.0)),
                                      child: door
                                          ? Center(
                                              child: Image(
                                              image:
                                                  AssetImage("images/lock.png"),
                                              height: height * 0.033,
                                            ))
                                          : Center(
                                              child: Image(
                                              image: AssetImage(
                                                  "images/unlock.png"),
                                              height: height * 0.033,
                                            ))),
                                ],
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Total Running Devices",
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                    // style: GoogleFonts.inter(
                                    //     fontSize: height * 0.013, color: Colors.white),
                                  ),
                                  SizedBox(
                                    height: height * 0.011,
                                  ),
                                  Container(
                                    // height: 70.0,
                                    // width: 170.0,
                                    height: height * 0.078,
                                    width: width * 0.40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.bottomLeft,
                                          colors: [
                                            Color.fromRGBO(255, 174, 0, 1.0),
                                            Color.fromRGBO(255, 216, 133, 1.0),
                                          ],
                                          stops: [
                                            0.1,
                                            0.9
                                          ]),
                                    ),
                                    child: Center(
                                      child: Text(
                                        count.toString(),
                                        style: GoogleFonts.inter(
                                            fontSize: height * 0.029,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: height * 0.022,
                          ),
                          smartDoor
                              ? Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        "Door Control",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                      SizedBox(
                                        height: height * 0.011,
                                      ),
                                      Container(
                                        height: height * 0.18,
                                        width: width * double.infinity,
                                        margin: EdgeInsets.all(10.0),
                                        padding: EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).canvasColor,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          // crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  openPressed = !openPressed;
                                                  http.put(
                                                    Uri.parse(
                                                        'http://$ip/sensor/2/'),
                                                    headers: <String, String>{
                                                      'Content-Type':
                                                          'application/json; charset=UTF-8',
                                                    },
                                                    body: jsonEncode(<String,
                                                        bool>{
                                                      "Door_Open": true,
                                                    }),
                                                  );
                                                });
                                              },
                                              child: Listener(
                                                onPointerUp: (_) =>
                                                    setState(() {
                                                  openPressed = true;
                                                }),
                                                onPointerDown: (_) =>
                                                    setState(() {
                                                  openPressed = true;
                                                }),
                                                child: AnimatedContainer(
                                                  duration: Duration(
                                                      milliseconds: 100),
                                                  // height: 200,
                                                  // width: 200,
                                                  // duration: Duration(milliseconds: 100),
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .cardColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              300),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          blurRadius:
                                                              openPressed
                                                                  ? 5.0
                                                                  : 30.0,
                                                          offset: openPressed
                                                              ? -Offset(3, 3)
                                                              : -Offset(10, 10),
                                                          color:
                                                              Theme.of(context)
                                                                  .splashColor,
                                                        ),
                                                        BoxShadow(
                                                          blurRadius:
                                                              openPressed
                                                                  ? 5.0
                                                                  : 30.0,
                                                          offset: openPressed
                                                              ? Offset(6, 8)
                                                              : Offset(10, 10),
                                                          color:
                                                              Theme.of(context)
                                                                  .hoverColor,
                                                          // inset: true,
                                                        ),
                                                      ]),
                                                  child: CircleAvatar(
                                                    radius: height * 0.06,
                                                    foregroundColor:
                                                        Colors.transparent,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    // height: height * 0.09,
                                                    // width: width * 0.20,
                                                    child: Center(
                                                      child: Text(
                                                        "Open",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium,
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
                                                  http.put(
                                                    Uri.parse(
                                                        'http://$ip/sensor/2/'),
                                                    headers: <String, String>{
                                                      'Content-Type':
                                                          'application/json; charset=UTF-8',
                                                    },
                                                    body: jsonEncode(<String,
                                                        bool>{
                                                      "Door_Pause": true,
                                                    }),
                                                  );
                                                });
                                              },
                                              child: Listener(
                                                onPointerUp: (_) =>
                                                    setState(() {
                                                  pausePressed = true;
                                                }),
                                                onPointerDown: (_) =>
                                                    setState(() {
                                                  pausePressed = true;
                                                }),
                                                child: AnimatedContainer(
                                                  duration: Duration(
                                                      milliseconds: 100),
                                                  // height: 200,
                                                  // width: 200,
                                                  // duration: Duration(milliseconds: 100),
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .cardColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              300),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          blurRadius:
                                                              pausePressed
                                                                  ? 5.0
                                                                  : 30.0,
                                                          offset: pausePressed
                                                              ? -Offset(3, 3)
                                                              : -Offset(10, 10),
                                                          color:
                                                              Theme.of(context)
                                                                  .splashColor,
                                                        ),
                                                        BoxShadow(
                                                          blurRadius:
                                                              pausePressed
                                                                  ? 5.0
                                                                  : 30.0,
                                                          offset: pausePressed
                                                              ? Offset(6, 8)
                                                              : Offset(10, 10),
                                                          color:
                                                              Theme.of(context)
                                                                  .hoverColor,
                                                          // inset: true,
                                                        ),
                                                      ]),
                                                  child: CircleAvatar(
                                                    radius: height * 0.06,
                                                    foregroundColor:
                                                        Colors.transparent,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    // height: height * 0.09,
                                                    // width: width * 0.20,
                                                    child: Center(
                                                      child: Text(
                                                        "Pause",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium,
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
                                                  http.put(
                                                    Uri.parse(
                                                        'http://$ip/sensor/2/'),
                                                    headers: <String, String>{
                                                      'Content-Type':
                                                          'application/json; charset=UTF-8',
                                                    },
                                                    body: jsonEncode(<String,
                                                        bool>{
                                                      "Door_Close": true,
                                                    }),
                                                  );
                                                });
                                              },
                                              child: Listener(
                                                onPointerUp: (_) =>
                                                    setState(() {
                                                  closePressed = true;
                                                }),
                                                onPointerDown: (_) =>
                                                    setState(() {
                                                  closePressed = true;
                                                }),
                                                child: AnimatedContainer(
                                                  duration: Duration(
                                                      milliseconds: 100),
                                                  // height: 200,
                                                  // width: 200,
                                                  // duration: Duration(milliseconds: 100),
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .cardColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              300),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          blurRadius:
                                                              closePressed
                                                                  ? 5.0
                                                                  : 30.0,
                                                          offset: closePressed
                                                              ? -Offset(3, 3)
                                                              : -Offset(10, 10),
                                                          color:
                                                              Theme.of(context)
                                                                  .splashColor,
                                                        ),
                                                        BoxShadow(
                                                          blurRadius:
                                                              closePressed
                                                                  ? 5.0
                                                                  : 30.0,
                                                          offset: closePressed
                                                              ? Offset(6, 8)
                                                              : Offset(10, 10),
                                                          color:
                                                              Theme.of(context)
                                                                  .hoverColor,
                                                          // inset: true,
                                                        ),
                                                      ]),
                                                  child: CircleAvatar(
                                                    radius: height * 0.06,
                                                    foregroundColor:
                                                        Colors.transparent,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    child: Center(
                                                      child: Text(
                                                        "Close",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium,
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
                                )
                              : Container(),
                          SizedBox(
                            height: height * 0.022,
                          ),
                          table
                              ? Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        "Table Control",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                      ),
                                      SizedBox(
                                        height: height * 0.011,
                                      ),
                                      Container(
                                        height: height * 0.12,
                                        width: width * double.infinity,
                                        margin: EdgeInsets.all(10.0),
                                        padding: EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).canvasColor,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          // crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  upTablePressed =
                                                      !upTablePressed;
                                                  http.put(
                                                    Uri.parse(
                                                        'http://$ip/table/1/'),
                                                    headers: <String, String>{
                                                      'Content-Type':
                                                          'application/json; charset=UTF-8',
                                                    },
                                                    body: jsonEncode(<String,
                                                        bool>{
                                                      "Up": true,
                                                    }),
                                                  );
                                                });
                                              },
                                              child: Listener(
                                                onPointerUp: (_) =>
                                                    setState(() {
                                                  upTablePressed = true;
                                                }),
                                                onPointerDown: (_) =>
                                                    setState(() {
                                                  upTablePressed = true;
                                                }),
                                                child: AnimatedContainer(
                                                  duration: Duration(
                                                      milliseconds: 100),
                                                  // height: 200,
                                                  // width: 200,
                                                  // duration: Duration(milliseconds: 100),
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .cardColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          blurRadius:
                                                              upTablePressed
                                                                  ? 5.0
                                                                  : 30.0,
                                                          offset: upTablePressed
                                                              ? -Offset(3, 3)
                                                              : -Offset(10, 10),
                                                          color:
                                                              Theme.of(context)
                                                                  .splashColor,
                                                        ),
                                                        BoxShadow(
                                                          blurRadius:
                                                              upTablePressed
                                                                  ? 5.0
                                                                  : 30.0,
                                                          offset: upTablePressed
                                                              ? Offset(6, 8)
                                                              : Offset(10, 10),
                                                          color:
                                                              Theme.of(context)
                                                                  .hoverColor,
                                                          // inset: true,
                                                        ),
                                                      ]),
                                                  child: CircleAvatar(
                                                    radius: height * 0.04,
                                                    foregroundColor:
                                                        Colors.transparent,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    // height: height * 0.09,
                                                    // width: width * 0.20,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .arrow_upward_outlined,
                                                          color: Colors.black,
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              height * 0.005,
                                                        ),
                                                        Text(
                                                          "Up",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  pauseTablePressed =
                                                      !pauseTablePressed;
                                                  http.put(
                                                    Uri.parse(
                                                        'http://$ip/table/1/'),
                                                    headers: <String, String>{
                                                      'Content-Type':
                                                          'application/json; charset=UTF-8',
                                                    },
                                                    body: jsonEncode(<String,
                                                        bool>{
                                                      "Pause": true,
                                                    }),
                                                  );
                                                });
                                              },
                                              child: Listener(
                                                onPointerUp: (_) =>
                                                    setState(() {
                                                  pauseTablePressed = true;
                                                }),
                                                onPointerDown: (_) =>
                                                    setState(() {
                                                  pauseTablePressed = true;
                                                }),
                                                child: AnimatedContainer(
                                                  duration: Duration(
                                                      milliseconds: 100),
                                                  // height: 200,
                                                  // width: 200,
                                                  // duration: Duration(milliseconds: 100),
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .cardColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          blurRadius:
                                                              pauseTablePressed
                                                                  ? 5.0
                                                                  : 30.0,
                                                          offset:
                                                              pauseTablePressed
                                                                  ? -Offset(
                                                                      3, 3)
                                                                  : -Offset(
                                                                      10, 10),
                                                          color:
                                                              Theme.of(context)
                                                                  .splashColor,
                                                        ),
                                                        BoxShadow(
                                                          blurRadius:
                                                              pauseTablePressed
                                                                  ? 5.0
                                                                  : 30.0,
                                                          offset:
                                                              pauseTablePressed
                                                                  ? Offset(6, 8)
                                                                  : Offset(
                                                                      10, 10),
                                                          color:
                                                              Theme.of(context)
                                                                  .hoverColor,
                                                          // inset: true,
                                                        ),
                                                      ]),
                                                  child: CircleAvatar(
                                                    radius: height * 0.04,
                                                    foregroundColor:
                                                        Colors.transparent,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    // height: height * 0.09,
                                                    // width: width * 0.20,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons.pause,
                                                          color: Colors.black,
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              height * 0.005,
                                                        ),
                                                        Text(
                                                          "Pause",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  downTablePressed =
                                                      !downTablePressed;
                                                  http.put(
                                                    Uri.parse(
                                                        'http://$ip/table/1/'),
                                                    headers: <String, String>{
                                                      'Content-Type':
                                                          'application/json; charset=UTF-8',
                                                    },
                                                    body: jsonEncode(<String,
                                                        bool>{
                                                      "Down": true,
                                                    }),
                                                  );
                                                });
                                              },
                                              child: Listener(
                                                onPointerUp: (_) =>
                                                    setState(() {
                                                  downTablePressed = true;
                                                }),
                                                onPointerDown: (_) =>
                                                    setState(() {
                                                  downTablePressed = true;
                                                }),
                                                child: AnimatedContainer(
                                                  duration: Duration(
                                                      milliseconds: 100),
                                                  // height: 200,
                                                  // width: 200,
                                                  // duration: Duration(milliseconds: 100),
                                                  decoration: BoxDecoration(
                                                      color: Theme.of(context)
                                                          .cardColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          blurRadius:
                                                              downTablePressed
                                                                  ? 5.0
                                                                  : 30.0,
                                                          offset:
                                                              downTablePressed
                                                                  ? -Offset(
                                                                      3, 3)
                                                                  : -Offset(
                                                                      10, 10),
                                                          color:
                                                              Theme.of(context)
                                                                  .splashColor,
                                                        ),
                                                        BoxShadow(
                                                          blurRadius:
                                                              downTablePressed
                                                                  ? 5.0
                                                                  : 30.0,
                                                          offset:
                                                              downTablePressed
                                                                  ? Offset(6, 8)
                                                                  : Offset(
                                                                      10, 10),
                                                          color:
                                                              Theme.of(context)
                                                                  .hoverColor,
                                                          // inset: true,
                                                        ),
                                                      ]),
                                                  child: CircleAvatar(
                                                    radius: height * 0.04,
                                                    foregroundColor:
                                                        Colors.transparent,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .arrow_downward_outlined,
                                                          color: Colors.black,
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              height * 0.005,
                                                        ),
                                                        Text(
                                                          "Down",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium,
                                                        ),
                                                      ],
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
                                )
                              : Container(),
                          SizedBox(
                            height: height * 0.15,
                          ),
                        ],
                      ),
                    )
                  : ((wta == false) && (gate == false))
                      ? Center(child: Text("Contact Admin for more details"))
                      : DevicePages(
                          wta: wta,
                          gate: gate,
                        )
              : Center(
                  child: SpinKitThreeBounce(
                  color: Colors.orange,
                  size: 50.0,
                )),
        ),
      ),
    );
  }

  ///mail concept
//for launching the mail for installation
//   showAlertDialog(BuildContext context) {
//     // Create button
//     Widget okButton = TextButton(
//       style:
//           ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
//       child: Text("Contact"),
//       onPressed: () async {
//         if (await canLaunch(email)) {
//           await launch(
//             email,
//             forceSafariVC: false,
//             forceWebView: false,
//           );
//         } else {
//           print(' could not launch $email');
//         }
//       },
//     );
//     // Create AlertDialog
//     AlertDialog alert = AlertDialog(
//       backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
//       title: Text(
//         "DashBoard Installation ",
//         style :Theme.of(context).dialogTheme.titleTextStyle,
//       ),
//       content: Text(
//         "Enable Dashboard by installing the feature ",
//           style: Theme.of(context).dialogTheme.contentTextStyle,
//       ),
//       actions: [
//         okButton,
//       ],
//     );
//     // show the dialog
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }

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
