import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:onwords_home/Routine_Page/task_data.dart';
import 'package:onwords_home/home_page.dart';
import 'package:onwords_home/log_ins/login_page.dart';
import 'package:onwords_home/settingsPage/tab_sett/tab_settings_page.dart';
import 'package:onwords_home/theme/change_theme_button_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:vibration/vibration.dart';
import 'family_members_adding_page.dart';



FirebaseAuth auth = FirebaseAuth.instance;


class DummySettingsPage extends StatefulWidget {
  @override
  _DummySettingsPageState createState() => _DummySettingsPageState();
}

class _DummySettingsPageState extends State<DummySettingsPage> {

  SharedPreferences loginData;
  String username;
  var value;
  String text ;
  String connection ;
  bool hasInternet = false;
  bool vibrationStatus = false;
  bool soundStatus = false;
  bool notificationStatus = false;
  bool tabStatus = false;
  ConnectivityResult result = ConnectivityResult.none;
  Timer timer;
  Timer timer1;
  bool vibrate = false;
  bool owner = false;
  bool loader = false;


  keyValues() async {

    loginData = await SharedPreferences.getInstance();
    final locIp = loginData.getString('ip') ?? null;
    final onIp = loginData.getString('onlineIp') ?? null;

    if((locIp != null)&&(locIp != "false") ){
      final response =  await http.get(Uri.parse("http://$locIp/")).timeout(
          const Duration(milliseconds: 500),onTimeout: (){
        connection = "Online Server ";
        return ;
      });
      if(response.statusCode > 0){
        connection = "Offline Server ";
      }
    }else if(locIp == "false"){
      setState(() {
        connection = " Cloud Server ";
      });
    }
  }

  void initial() async {
    loginData = await SharedPreferences.getInstance();
    setState(() {
      vibrationStatus = loginData.get('vibrationStatus') ?? false;
      username = loginData.getString('username');
      vibrate = loginData.get('vibrationStatus')??false;
      value = loginData.getInt("val") ?? 3;
      owner = loginData.getBool('owner')??false;
      loader = true;
      //print("value is $value -------------------------");
      text = ((value == 0)) ? "System" : (value == 1) ? "Dark" : (value == 2) ? "Light " : "Auto" ;
    });
  }



  @override
  void initState() {
    //initial();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => initial());
    timer1= Timer.periodic(Duration(seconds: 1), (Timer t) => keyValues());
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    timer1?.cancel();
    // TODO: implement dispose
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        // Navigator.pop(context);
        SystemNavigator.pop();
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage(index: 0,)));
        return true;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        //backgroundColor: Color.fromRGBO(26, 28, 30, 0.6),
        body: Container(
          height: height*1.0,
          width: width*1.0,
          child:SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  // height: 40.0,
                  height: height * 0.075,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.0),
                  child: Text(
                    " Settings ",
                    style: Theme.of(context).textTheme.headline4,
                    // style: GoogleFonts.inter(
                    //     fontSize: height * 0.028,
                    //     fontWeight: FontWeight.bold,
                    //     color: Colors.white),
                  ),
                ),
                SizedBox(
                  // height: 20.0,
                  height: height * 0.025,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.0),
                  child: Container(
                    decoration: BoxDecoration(
                        //color: Color.fromRGBO(54, 54, 54, 1.0),
                        color: Theme.of(context).canvasColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(30.0)),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => ChangeThemeButtonWidget()));
                            if(vibrate){
                              Vibration.vibrate(duration: 50, amplitude: 25);
                            }else{
                              Vibration.cancel();
                            }
                          },
                          child:
                          Container(
                            decoration: BoxDecoration(
                              //color: Color.fromRGBO(54, 54, 54, 1.0),
                              color: Theme.of(context).canvasColor,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 10.0,horizontal:18.0 ),
                            height: height * 0.080,
                            width: width * 0.96,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: height * 0.030,
                                  backgroundColor: Color.fromRGBO(94, 94, 94, 0.7),
                                  child: Image(
                                    image: AssetImage("images/sun.png"),
                                    height: height * 0.028,
                                  ),
                                ),
                                SizedBox(
                                  width: width*0.045,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Themes ",
                                      style: Theme.of(context).textTheme.bodyText2,
                                    ),
                                    Text(
                                       text ?? "Auto",
                                      style: Theme.of(context).textTheme.subtitle1,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 48.0),
                          child: Divider(
                            thickness: 1.0,
                            color: Theme.of(context).dividerColor,
                            height: height * 0.004,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            //color: Color.fromRGBO(54, 54, 54, 1.0),
                            color: Theme.of(context).canvasColor,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 10.0,horizontal:18.0 ),
                          height: height * 0.080,
                          width: width * 0.96,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: height * 0.030,
                                backgroundColor: Color.fromRGBO(94, 94, 94, 0.7),
                                child: Icon(
                                  Icons.network_check,color: Colors.grey.shade200,
                                )
                              ),
                              SizedBox(
                                width: width*0.045,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Connectivity ",
                                    style: Theme.of(context).textTheme.bodyText2,
                                    // style: GoogleFonts.inter(
                                    //     fontSize: height * 0.022,
                                    //     fontWeight: FontWeight.bold,
                                    //     color: Colors.white),
                                  ),
                                  Text(
                                    connection ?? "Server",
                                    style: Theme.of(context).textTheme.subtitle1,
                                    // style: GoogleFonts.inter(
                                    //     fontSize: height * 0.022,
                                    //     fontWeight: FontWeight.bold,
                                    //     color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        owner?Padding(
                          padding: EdgeInsets.symmetric(horizontal: 48.0),
                          child: Divider(
                            thickness: 1.0,
                            color: Theme.of(context).dividerColor,
                            height: height * 0.004,
                          ),
                        ):Container(),
                        owner?GestureDetector(
                          onTap: (){
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => FamilyMembersPage()));
                            if(vibrate){
                              Vibration.vibrate(duration: 50, amplitude: 25);
                            }else{
                              Vibration.cancel();
                            }
                          },
                          child:
                          Container(
                            decoration: BoxDecoration(
                              //color: Color.fromRGBO(54, 54, 54, 1.0),
                              color: Theme.of(context).canvasColor,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 10.0,horizontal:18.0 ),
                            height: height * 0.080,
                            width: width * 0.96,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: height * 0.030,
                                  backgroundColor: Color.fromRGBO(94, 94, 94, 0.7),
                                  child: Icon(Icons.people_alt_outlined,color: Colors.grey.shade200,)
                                ),
                                SizedBox(
                                  width: width*0.045,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Family ",
                                      style: Theme.of(context).textTheme.bodyText2,
                                    ),
                                    Text(
                                      "add members",
                                      style: Theme.of(context).textTheme.subtitle1,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: width*0.25,
                                ),
                                Center(
                                  child: Icon(Icons.arrow_forward),
                                )
                              ],
                            ),
                          ),
                        ):Container(),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 48.0),
                          child: Divider(
                            thickness: 1.0,
                            color: Theme.of(context).dividerColor,
                            height: height * 0.004,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            //color: Color.fromRGBO(54, 54, 54, 1.0),
                            color: Theme.of(context).canvasColor,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 10.0,horizontal:18.0 ),
                          height: height * 0.080,
                          width: width * 0.96,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: height * 0.030,
                                backgroundColor: Color.fromRGBO(94, 94, 94, 0.7),
                                child:  Icon(
                                  Icons.vibration,color: Colors.grey.shade200,
                                )
                              ),
                              SizedBox(
                                width: width*0.045,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Vibration ",
                                    style: Theme.of(context).textTheme.bodyText2,
                                    // style: GoogleFonts.inter(
                                    //     fontSize: height * 0.022,
                                    //     fontWeight: FontWeight.bold,
                                    //     color: Colors.white),
                                  ),
                                  vibrationStatus ? Text(
                                    "ON ",
                                    style: Theme.of(context).textTheme.subtitle1,
                                    // style: GoogleFonts.inter(
                                    //     fontSize: height * 0.022,
                                    //     fontWeight: FontWeight.bold,
                                    //     color: Colors.white),
                                  ) : Text(
                                    "OFF ",
                                    style: Theme.of(context).textTheme.subtitle1,
                                    // style: GoogleFonts.inter(
                                    //     fontSize: height * 0.022,
                                    //     fontWeight: FontWeight.bold,
                                    //     color: Colors.white),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: width*0.25,
                              ),
                              Switch(
                                  inactiveTrackColor: Colors.grey.shade400,
                                  activeColor: Colors.orange,
                                  thumbColor: MaterialStateProperty.all(Colors.orange),
                                  value: vibrationStatus,
                                  onChanged: (bool value) {
                                    setState(() {
                                      vibrationStatus = value;
                                      loginData.setBool('vibrationStatus', vibrationStatus);

                                    });
                                  })
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 48.0),
                          child: Divider(
                            thickness: 1.0,
                            color: Theme.of(context).dividerColor,
                            height: height * 0.004,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            //color: Color.fromRGBO(54, 54, 54, 1.0),
                            color: Theme.of(context).canvasColor,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 10.0,horizontal:18.0 ),
                          height: height * 0.080,
                          width: width * 0.96,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: height * 0.030,
                                backgroundColor: Color.fromRGBO(94, 94, 94, 0.7),
                                child:  Icon(
                                  Icons.touch_app,color: Colors.grey.shade200,
                                )
                              ),
                              SizedBox(
                                width: width*0.045,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Sound ",
                                    style: Theme.of(context).textTheme.bodyText2,
                                    // style: GoogleFonts.inter(
                                    //     fontSize: height * 0.022,
                                    //     fontWeight: FontWeight.bold,
                                    //     color: Colors.white),
                                  ),
                                  soundStatus ? Text(
                                    "ON ",
                                    style: Theme.of(context).textTheme.subtitle1,
                                    // style: GoogleFonts.inter(
                                    //     fontSize: height * 0.022,
                                    //     fontWeight: FontWeight.bold,
                                    //     color: Colors.white),
                                  ) : Text(
                                    "OFF ",
                                    style: Theme.of(context).textTheme.subtitle1,
                                    // style: GoogleFonts.inter(
                                    //     fontSize: height * 0.022,
                                    //     fontWeight: FontWeight.bold,
                                    //     color: Colors.white),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: width*0.30,
                              ),
                              Switch(
                                  inactiveTrackColor: Colors.grey.shade400,
                                  activeColor: Colors.orange,
                                  thumbColor: MaterialStateProperty.all(Colors.orange),
                                  value: soundStatus,
                                  onChanged: (bool value) {
                                    setState(() {
                                      soundStatus = value;
                                    });
                                  })
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 48.0),
                          child: Divider(
                            thickness: 1.0,
                            color: Theme.of(context).dividerColor,
                            height: height * 0.004,
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (context) => NotificationPage1()));
                            if(vibrate){
                              Vibration.vibrate(duration: 50, amplitude: 25);
                            }else{
                              Vibration.cancel();
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              //color: Color.fromRGBO(54, 54, 54, 1.0),
                              color: Theme.of(context).canvasColor,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 10.0,horizontal:18.0 ),
                            height: height * 0.080,
                            width: width * 0.96,
                            child: Row(
                              children: [
                                CircleAvatar(
                                    radius: height * 0.030,
                                    backgroundColor: Color.fromRGBO(94, 94, 94, 0.7),
                                    child:  Icon(
                                      Icons.notifications_active,color: Colors.grey.shade200,
                                    )
                                ),
                                SizedBox(
                                  width: width*0.045,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Notification ",
                                      style: Theme.of(context).textTheme.bodyText2,
                                      // style: GoogleFonts.inter(
                                      //     fontSize: height * 0.022,
                                      //     fontWeight: FontWeight.bold,
                                      //     color: Colors.white),
                                    ),
                                    notificationStatus ? Text(
                                      "ON ",
                                      style: Theme.of(context).textTheme.subtitle1,
                                      // style: GoogleFonts.inter(
                                      //     fontSize: height * 0.022,
                                      //     fontWeight: FontWeight.bold,
                                      //     color: Colors.white),
                                    ) : Text(
                                      "OFF ",
                                      style: Theme.of(context).textTheme.subtitle1,
                                      // style: GoogleFonts.inter(
                                      //     fontSize: height * 0.022,
                                      //     fontWeight: FontWeight.bold,
                                      //     color: Colors.white),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: width*0.25,
                                ),
                                Icon(Icons.arrow_forward)
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 48.0),
                          child: Divider(
                            thickness: 1.0,
                            color: Theme.of(context).dividerColor,
                            height: height * 0.004,
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => TabSettingsPage()));
                            },
                            child:
                            Container(
                              decoration: BoxDecoration(
                                //color: Color.fromRGBO(54, 54, 54, 1.0),
                                color: Theme.of(context).canvasColor,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 10.0,horizontal:18.0 ),
                              height: height * 0.080,
                              width: width * 0.96,
                              child: Row(
                                children: [
                                  CircleAvatar(
                                      radius: height * 0.030,
                                      backgroundColor: Color.fromRGBO(94, 94, 94, 0.7),
                                      child:  Icon(
                                        Icons.tablet,color: Colors.grey.shade200,
                                      )
                                  ),
                                  SizedBox(
                                    width: width*0.045,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Tab Settings ",
                                        style: Theme.of(context).textTheme.bodyText2,
                                        // style: GoogleFonts.inter(
                                        //     fontSize: height * 0.022,
                                        //     fontWeight: FontWeight.bold,
                                        //     color: Colors.white),
                                      ),
                                      tabStatus ? Text(
                                        "ON ",
                                        style: Theme.of(context).textTheme.subtitle1,
                                        // style: GoogleFonts.inter(
                                        //     fontSize: height * 0.022,
                                        //     fontWeight: FontWeight.bold,
                                        //     color: Colors.white),
                                      ) : Text(
                                        "OFF ",
                                        style: Theme.of(context).textTheme.subtitle1,
                                        // style: GoogleFonts.inter(
                                        //     fontSize: height * 0.022,
                                        //     fontWeight: FontWeight.bold,
                                        //     color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: width*0.20
                                  ),
                                  Switch(
                                      inactiveTrackColor: Colors.grey.shade400,
                                      activeColor: Colors.orange,
                                      thumbColor: MaterialStateProperty.all(Colors.orange),
                                      value: tabStatus,
                                      onChanged: (bool value) {
                                        setState(() {
                                          tabStatus = value;
                                        });
                                      })
                                ],
                              ),
                            ),

                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  // height: 20.0,
                  height: height * 0.025,
                ),
                Padding(
                  padding: EdgeInsets.all(18.0),
                  child: GestureDetector(
                    onTap: () async {
                      Provider.of<TaskData>(context, listen: false).logout();
                      loginData.setBool('login', true);
                      auth.signOut();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                      // loginData = await SharedPreferences.getInstance();
                      setState(() {
                        if(vibrate){
                          Vibration.vibrate(duration: 50, amplitude: 25);
                        }else{
                          Vibration.cancel();
                        }


                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        //color: Color.fromRGBO(54, 54, 54, 1.0),
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10.0,horizontal:18.0 ),
                      height: height * 0.080,
                      width: width * 0.96,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: height * 0.030,
                            backgroundColor: Color.fromRGBO(94, 94, 94, 0.7),
                            child: Image(
                              image: AssetImage("images/logout.png"),
                              height: height * 0.028,
                            ),
                          ),
                          SizedBox(
                            width: width*0.045,
                          ),
                          Text(
                            "Logout ",
                            style: Theme.of(context).textTheme.bodyText2,
                            // style: GoogleFonts.inter(
                            //     fontSize: height * 0.022,
                            //     fontWeight: FontWeight.bold,
                            //     color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  // height: 20.0,
                  height: height * 0.15,
                ),
              ],
            ),
          )
              // :Center(
              // child: SpinKitThreeBounce(
              //   color: Colors.orange,
              //   size: 50.0,
              // )),
        ),
      ),
    );
  }
}

