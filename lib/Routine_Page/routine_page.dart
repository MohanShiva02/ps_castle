import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onwords_home/Routine_Page/routine_page1.dart';
import 'package:http/http.dart' as http;
import 'package:onwords_home/Routine_Page/routines_data_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';






FirebaseAuth auth = FirebaseAuth.instance;
final databaseReference = FirebaseDatabase.instance.reference();


Route _createRoute(){
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>  RoutinePage1(),
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

Route routineDataPage(String name){
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>  RoutinesDataPage(routineName: name,),
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

class RoutinePage extends StatefulWidget {
  @override
  _RoutinePageState createState() => _RoutinePageState();
}



class _RoutinePageState extends State<RoutinePage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          // Navigator.pop(context);
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
      return true;
    },
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          color: Theme.of(context).backgroundColor,
          //child: TaskView(),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * 0.025,
                ),
                Text(
                  " Routines ",
                  style: Theme.of(context).appBarTheme.titleTextStyle,
                ),
                SizedBox(
                  height: height * 0.009,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "   Press and hold to schedule ",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),

                  ],
                ),
                SizedBox(
                  height: height * 0.005,
                ),
                Stack(
                  children:[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      height: height * 0.78,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15.0),
                            topRight: Radius.circular(15.0)),
                        color: Theme.of(context).backgroundColor,
                        // color: Colors.green,

                      ),
                      //child: SingleChildScrollView(child: TaskView()),
                      child: ListViewBuilding(),
                    ),
                    Positioned(
                      top: height*0.69,
                      left: width*0.75,
                      child:Container(
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                          padding: EdgeInsets.only(right: 5,bottom: 6),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).canvasColor,
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).push(_createRoute());
                            },
                            icon: Icon(
                              Icons.add_rounded,
                              color: Theme.of(context).iconTheme.color,
                              size: height * 0.04,
                            ),
                          ),
                        ),
                    ),
                  ]
                ),
                SizedBox(
                  height: height * 0.060,
                ),
                SizedBox(
                  height: height * 0.090,
                ),
              ],
            ),
          ),
        ),
      ),);
  }

  showAnotherAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = TextButton(
      child: Text("ok"),
      onPressed: () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => RoutinePage1()));
      },
    );
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      title: Text(
        "Routines ",
        style: Theme.of(context).dialogTheme.titleTextStyle,
      ),
      content: Text(
        " Features are Coming Soon ",
        style: Theme.of(context).dialogTheme.contentTextStyle,
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

class ListViewBuilding extends StatefulWidget {
  const ListViewBuilding({Key key}) : super(key: key);

  @override
  _ListViewBuildingState createState() => _ListViewBuildingState();
}

class _ListViewBuildingState extends State<ListViewBuilding> {
  var scenesData;
  List scenesName = [];
  List scheduleName = [];
  List routines = [];
  List scenesDatas = [];
  Timer timer;
  bool loader = false;
  bool vibrate = false;
  SharedPreferences loginData;
  List buttonTapped = [ ];
  String authKey = " ";
  var ownerId;
  var personalDataJson;
  String ip;



  keyValues() async {
    loginData = await SharedPreferences.getInstance();
    final locIp = loginData.getString('ip') ?? null;
    final onIp = loginData.getString('onlineIp') ?? null;

    if((locIp != null)&&(locIp != "false")){
      final response = await http.get(Uri.parse("http://$locIp/")).timeout(
          const Duration(milliseconds: 500),onTimeout: (){
        //ignore:avoid_print
        //print(" inside the timeout  in second screeen");
        ip = onIp;
        initial();
        return;
      });
      if(response.statusCode > 0) {
        ip = locIp;
        initial();
      }

    }else if(locIp == "false")
    {
      ip = locIp;
      initial();
    }
  }


  initial() async
  {
    loginData = await SharedPreferences.getInstance();
    setState(() {
      vibrate = loginData.get('vibrationStatus')??false;
      authKey = loginData.getString('ownerId')??" ";
      if(authKey == " ")
      {
        firstProcess();
      }else{
        getData();
      }
    });
  }

  firstProcess() async {
    loginData = await SharedPreferences.getInstance();
    databaseReference.child('family').once().then((value) {
      for (var element in value.snapshot.children) {
        ownerId = element.value;
        if (element.key == auth.currentUser.uid) {
          loginData.setString('ownerId', ownerId['owner-uid']);
          authKey = loginData.getString('ownerId');
          getData();
          break;
        } else {
          loginData.setString('ownerId', auth.currentUser.uid);
          authKey = loginData.getString('ownerId');
          getData();
        }
      }
    });
  }

  getData() async {
     await databaseReference.child(authKey).once().then((value) {
      scenesName.clear();
      routines.clear();
      var dataJson;

      setState(() {
        loader = true;
        dataJson = value.snapshot.value;
        scenesData = value.snapshot.value;

      });
       // print("dataJson $dataJson");
      // Map<dynamic, dynamic> values = value.value['SmartHome']['scenes'];
      try{
        Map<dynamic, dynamic> values = dataJson['SmartHome']['Scenes']['TabToRun'];
        values.forEach((key, values) {
          setState(() {
            scenesName.add(values);
            routines.add(values);
          });
        });
        // print(routines);
      }catch(e){
        // print(e);
      }

      try{
        Map<dynamic, dynamic> val = dataJson['SmartHome']['Scenes']['Schedule'];
        val.forEach((key, value) {
          setState(() {
            scheduleName.add(value);
            routines.add(value);
          });
        });
      }catch(e){
        print(e);
      }
      // print("scenesName = ----------------- $scenesName");
      // Map<dynamic, dynamic> _values = value.value['SmartHome']['scenes'];
      // values.forEach((key, values) {
      //   scenesDatas.add(values);
      // });
    });
  }

  @override
  void initState() {
    keyValues();
    timer = Timer.periodic(Duration(seconds: 3), (Timer t) {
      getData();
      //   // getName();
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
    return loader ? routines.isNotEmpty?GridView.builder(
      scrollDirection: Axis.vertical,
      itemCount: routines.length, //scenesData.length?? scenesName.length
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
            onLongPress: () async
            {
              // Navigator.of(context).push(routineDataPage(scenesName[index]['sceneName']));
              if(routines[index]['tabToRun']==true){
                showAlertDialog(context,"TabToRun",routines[index]['name']);
              }else if(routines[index]['schedule']==true){
                showAlertDialog(context,"Schedule",routines[index]['name']);
              }else{
                print("hehe");
              }

            },

            onTap: () async {
              if(routines[index]['tabToRun']==true)
              {
                setState(() {
                  buttonTapped.add(index);
                });
                Future.delayed(Duration(milliseconds: 200), () {
                  setState(() {
                    buttonTapped.remove(index);
                  });

                });
                if(vibrate)
                {
                  Vibration.vibrate(duration: 50, amplitude: 25);
                }else{
                  Vibration.cancel();
                }

                var trueData = scenesName[index]['trueDevices'];

                var idsData = scenesName[index]['ids'];

                List<int> trueDataList = [];
                List<int> idsDataList = [];

                if (trueData != null) {
                  for (var td in trueData) {
                    trueDataList.add(int.parse(td));
                  }
                }

                for (var id in idsData) {
                  idsDataList.add(int.parse(id));
                }

                List<int> falseDataList = [];

                for (int x in idsDataList) {
                  if (trueDataList.isNotEmpty) {
                    if (trueDataList.contains(x)) {
                      null;
                    } else {
                      falseDataList.add(x);
                    }
                  } else {
                    falseDataList.add(x);
                  }
                }

                if ((trueData != null)&&(ip != "false")) {
                  for (var d in trueData) {
                    var fff = (await http.put(
                      Uri.parse('http://$ip/$d/'),
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                      },
                      body: jsonEncode(<String, bool>{"Device_Status": true}),
                    ));
                  }
                }

                if((trueData != null)&&(ip== "false"))
                {
                  for (var d in trueData) {
                    databaseReference.child(authKey).child('SmartHome').child('Devices').child('Id$d').update({
                      'Device_Status': true,
                    });
                  }
                }

                if((falseDataList !=null)&&(ip == "false"))
                {
                  for (var d in falseDataList) {
                    databaseReference.child(authKey).child('SmartHome').child('Devices').child('Id$d').update({'Device_Status': false,});
                  }
                }

                if ((falseDataList != null)&&(ip != "false")) {
                  for (var d in falseDataList) {
                    //print("$d is false");
                    var fff = (await http.put(
                      Uri.parse('http://$ip/$d/'),
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                      },
                      body: jsonEncode(<String, bool>{"Device_Status": false}),
                    ));
                  }
                }

              }
              else if(routines[index]['schedule']==true){
                setState(() {
                  buttonTapped.add(index);
                });
                Future.delayed(Duration(milliseconds: 200), () {
                  setState(() {
                    buttonTapped.remove(index);
                  });
                });
                if(vibrate)
                {
                  Vibration.vibrate(duration: 50, amplitude: 25);
                }else{
                  Vibration.cancel();
                }
                Navigator.of(context).push(routineDataPage(routines[index]['name']));
              }
              else{
                print("hello schedule ");
              }

            },
            child: Stack(
              children:[
                Container(
                  decoration: BoxDecoration(
                    color: buttonTapped.contains(index) ? Color.fromRGBO(193, 208, 240, 1.0): Theme.of(context).canvasColor,
                    //color: Theme.of(context).canvasColor.withOpacity(1.0),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Center(
                    child: ListTile(
                      // leading: Icon(Icons.fiber_manual_record_outlined,size: height * 0.021,color: Theme.of(context).iconTheme.color,),
                      leading: routines[index]['tabToRun']==true?
                      Image(image: AssetImage("images/hand.png"),height: height*0.035,):
                      routines[index]['schedule']==true?
                       Image(image: AssetImage("images/time_new.png"),height: height*0.035,):null,
                      title:Text("${routines[index]['name']}", style: Theme.of(context).textTheme.bodyText2,),
                      subtitle: routines[index]['tabToRun']==true?
                      Text("Tab to Run",style: TextStyle(color: Colors.black,fontSize: height*0.010),):
                      routines[index]['schedule']==true?
                      Text("Scheduled",style: TextStyle(color: Colors.black,fontSize: height*0.010),):null,
                    ),
                  ),
                ),
                // routines[index]['schedule']==true?Positioned(
                //   top: height*0.01,
                //   left: height*0.18,
                //   child: Icon(Icons.access_time_filled,
                //     color: Theme.of(context).iconTheme.color,
                //     size: height * 0.021,),
                // ):Container(),
              ]
            )
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisExtent:  height*0.10,
        crossAxisCount: 2,
        mainAxisSpacing: 12.0,
        crossAxisSpacing: 6.0,
      ),
    ):Center(
     child: Column(
       mainAxisAlignment: MainAxisAlignment.center,
       children: [
          SvgPicture.asset("images/routineNoData.svg",height: height*0.090,),
         SizedBox(
           height: height*0.020,
         ),
         Text("  You don’t have any new routines\n Click + button to add new routines",
           style:  GoogleFonts.inter(fontSize: height*0.016,color: Colors.grey, fontWeight: FontWeight.w500),

         ),
       ],
     ),
    ): Center(
        child: SpinKitThreeBounce(
          color: Colors.orange,
          size: 50.0,
        )
    );
  }
  showAlertDialog(BuildContext context,String route,String name) {
    // Create button
    Widget cancelButton = TextButton(
      child: Text("cancel"),
      onPressed: () {
        Navigator.pop(context, false);
      },
    );
    Widget okButton = TextButton(
      child: Text("ok"),
      onPressed: () {
        databaseReference.child(authKey).child('SmartHome').child("Scenes").child(route).child(name).remove();
        Navigator.pop(context, true);
      },
    );
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      content: Text(
        "Do you want to delete ? ",
        style: Theme.of(context).dialogTheme.contentTextStyle,
      ),
      actions: [
        cancelButton,
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
