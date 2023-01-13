import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

FirebaseAuth auth = FirebaseAuth.instance;
final databaseReference = FirebaseDatabase.instance.reference();

class SelectRoutinesPages extends StatefulWidget {
  final String name;
  final String date;
  final String time;
  final bool everyDay;
  SelectRoutinesPages({@required this.name,@required this.date,@required this.time,@required this.everyDay});

  @override
  _SelectRoutinesPagesState createState() => _SelectRoutinesPagesState();
}

class _SelectRoutinesPagesState extends State<SelectRoutinesPages> {
  var scenesData;
  List scenesName = [];
  List selectedRoutine =[];
  Timer timer;
  int id = 0;
  bool loader = false;
  bool vibrate = false;
  SharedPreferences loginData;
  String authKey = " ";
  var ownerId;
  var personalDataJson;
  var selectDeviceName;


  initial() async
  {
    loginData = await SharedPreferences.getInstance();
    setState(() {
      vibrate = loginData.get('vibrationStatus')??false;
      authKey = loginData.getString('ownerId')??" ";
    });
  }



  getData() async {

    await databaseReference.child(authKey).once().then((value) {
      scenesName.clear();
      var dataJson;

      setState(() {
        loader = true;
        dataJson = value.snapshot.value;
        scenesData = value.snapshot.value;
      });

      // Map<dynamic, dynamic> values = value.value['SmartHome']['scenes'];
      Map<dynamic, dynamic> values = dataJson['SmartHome']['scenes'];
      values.forEach((key, values) {
        scenesName.add(values);
      });


    });
  }

  @override
  void initState() {

    initial();
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
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        actions: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.orange)
              ),
                onPressed: (){

                  var da = {
                    'ScheduleName': widget.name,
                    "selectedRoutines" : selectDeviceName.toString(),
                    "date": widget.date,
                    "time": widget.time,
                    "everyDay":widget.everyDay,
                    "status":false,
                  };
                  // print(da);
                  databaseReference.child(authKey).child('SmartHome').child('schedule').child(widget.name).set(da);
                  Navigator.pop(context);
                  Navigator.pop(context);


                }, child: Text(" Done ")),
          )
        ],
        title: Text("Select Routines",style: Theme.of(context).textTheme.headline5,),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(10.0, 70.0, 10.0, 20.0),
        child: loader?GridView.builder(
          scrollDirection: Axis.vertical,
          itemCount: scenesName.length, //scenesData.length?? scenesName.length
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
            onTap: () async {

              setState(() {

                if(vibrate){
                  Vibration.vibrate(duration: 50, amplitude: 25);
                }else{
                  Vibration.cancel();
                }

                selectDeviceName = scenesName[index]["sceneName"];

                // if(selectedRoutine.contains(scenesName[index]["sceneName"])){
                //   selectedRoutine.remove(scenesName[index]["sceneName"]);
                // }else{
                //   selectedRoutine.add(scenesName[index]["sceneName"]);
                // }
              });
            },
            child: Container(
              margin: EdgeInsets.all(10.0),
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 15.0),
              // height: height * 0.15,
              // width: width * 0.30,
              decoration: BoxDecoration(
                //color: Color.fromRGBO(54, 54, 54, 1.0),
                  color: selectDeviceName == scenesName[index]["sceneName"]?Colors.orange:Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.circular(25.0)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.power_settings_new,
                          color: Theme.of(context).iconTheme.color,
                          size: height * 0.031,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 0.020,
                  ),
                  Text("${scenesName[index]['sceneName']}",
                      style: Theme.of(context).textTheme.bodyText2,
                      textAlign: TextAlign.left),
                ],
              ),
            ),
              );
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
        ) : Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.black,
            valueColor:
            new AlwaysStoppedAnimation<Color>(
                Colors.white),
          ),
        )
      ),
    );
  }
}
