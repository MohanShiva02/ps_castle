import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'login_page.dart';

FirebaseAuth auth = FirebaseAuth.instance;

final databaseReference = FirebaseDatabase.instance.reference();


class NewUserPage extends StatefulWidget {
  const NewUserPage({Key key}) : super(key: key);

  @override
  State<NewUserPage> createState() => _NewUserPageState();
}

class _NewUserPageState extends State<NewUserPage> {
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
  String mail = "mailto:cs@onwords.in?subject=Requesting%20for%20features%20installation";

  personalData(){
    databaseReference.child(auth.currentUser.uid).once().then((value) async{
      personalDataJson = value.snapshot.value;
      setState((){
        userName = personalDataJson["name"];
        email = personalDataJson['email'];
        phoneNumber = personalDataJson['phone'].toString();
      });
    });
  }

  firstProcess() async {
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

  Future<void> fireData() async {
    loginData = await SharedPreferences.getInstance();
    databaseReference.child(authKey).once().then((snapshot){
      ownerData = snapshot.snapshot.value;
      setState(() {
        owner = ownerData['owner']??false;
      });
    }).then((value) => showAlertDialog(context));


    // databaseReference.child(authKey).child('WaterTankAutomation').once().then((snapshot) async {
    //   snapshot.snapshot.children.forEach((element) {
    //     dataJson = element.value;
    //     deviceCount = element.key;
    //     setState((){
    //       waterLevel = dataJson['level'];
    //       status = dataJson['status'];
    //       waterTankAutomation = dataJson;
    //     });
    //   });
    // }).then((value) => showAlertDialog(context));
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
    personalData();
    firstProcess();
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
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
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
              // owner ? ListTile(
              //   leading: const Icon(Icons.group_add),
              //   title: Text(' Add Family ',
              //     style: GoogleFonts.inter(
              //         fontSize: height*0.018,
              //         fontWeight: FontWeight.bold,
              //         color: Colors.black87),),
              //   onTap: () {
              //     setState((){
              //       Navigator.push(context,
              //           MaterialPageRoute(builder: (context) => FamilyMembersPage()));
              //     });
              //   },
              // ):Container(),
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
                top: height * 0.05,
                left: width * 0.04,
                right: width * 0.03,
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Welcome $userName",
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
              Center(
                child: Text('Send mail to make contact with our team',
                  style: GoogleFonts.inter(
                    fontSize: height*0.018,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = TextButton(
      style:
          ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
      child: Text("Contact"),
      onPressed: () async {
        if (await canLaunch(mail)) {
          await launch(
            mail,
            forceSafariVC: false,
            forceWebView: false,
          );
        } else {
          print(' could not launch $mail');
        }
      },
    );
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      title: Text(
        "Submit for Enquiry ",
        style :Theme.of(context).dialogTheme.titleTextStyle,
      ),
      content: Text(
        "enquiry now ",
          style: Theme.of(context).dialogTheme.contentTextStyle,
      ),
      actions: [
        okButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
