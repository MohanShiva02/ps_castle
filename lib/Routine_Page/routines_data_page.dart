import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:onwords_home/Routine_Page/schedule_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weekday_selector/weekday_selector.dart';


// Route routineRoute(String routineName){
//   return PageRouteBuilder(
//     pageBuilder: (context, animation, secondaryAnimation) =>  SchedulePage(routineName: routineName,),
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       const begin = Offset(0.0, 0.0);
//       const end = Offset.zero;
//       const curve = Curves.slowMiddle;
//
//       var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//
//       return SlideTransition(
//         position: animation.drive(tween),
//         child: child,
//       );
//     },
//   );
// }



class RoutinesDataPage extends StatefulWidget {
  final String routineName;


  const RoutinesDataPage({Key key, @required this.routineName}) : super(key: key);

  @override
  _RoutinesDataPageState createState() => _RoutinesDataPageState();
}

class _RoutinesDataPageState extends State<RoutinesDataPage> {

  SharedPreferences loginData;
  String ipAddress = " ";
  List data = [];
  List<String> localDataVal = [];
  List<String> sceneNameIds = [];
  List<String> trueDeviceIds = [];
  List<String> deviceName = [];
  List<String> deviceRoom = [];
  String authKey = " ";
  bool vibrate = false;
  var deviceData;
  bool loader = true;
  var sceneData;
  List<String> scheduleName = [];
  List scheduleDays=[];
  List<String> scheduleTime = [];
  List<bool> scheduleStatus = [];
  var values = List.filled(7, false);




  keyValues() async {
    loginData = await SharedPreferences.getInstance();
    final locIp = loginData.getString('ip') ?? null;
    final onIp = loginData.getString('onlineIp') ?? null;
    if((locIp != null)&&(locIp != "false")){
      final response = await http.get(Uri.parse("http://$locIp/")).timeout(
          const Duration(milliseconds: 1000),onTimeout: (){
        setState(() {
          ipAddress = onIp;
        });
        data.clear();
        initial();
        throw '';
      });
      if(response.statusCode > 0){
        setState(() {
          data.clear();
          ipAddress = locIp;
          initial();
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



  initialData() async
  {
    loginData = await SharedPreferences.getInstance();
    setState(() {
      vibrate = loginData.get('vibrationStatus')??false;
      authKey = loginData.getString('ownerId')??" ";
      getData();
      // scheduleData();
    });
  }


  Future<void> initial() async {
    if (ipAddress == null){
      keyValues();
    } else if(sceneNameIds != null){
      if (ipAddress.toString() != 'false')
      {
        for(var id in sceneNameIds)
        {
          final response = await http.get(Uri.parse("http://$ipAddress/$id/"));
          var fetchdata = jsonDecode(response.body);
         setState(() {
            deviceName.add(fetchdata['Device_Name']);
            deviceRoom.add(fetchdata['Room']);
         });
        }
      }else if((ipAddress.toString() == 'false'))
      {
        setState(()
        {
          onlineData();
        });
      }
    }else{
      getData();
    }
  }

  onlineData() async {
    await databaseReference.child(authKey).once().then((value) {
      var dataJson;
      deviceName.clear();
      deviceRoom.clear();

      setState(() {
        loader = true;
        dataJson = value.snapshot.value;
      });

      // Map<dynamic, dynamic> values = value.value['SmartHome']['scenes'];
      Map<dynamic, dynamic> valuesData = dataJson['SmartHome']['Devices'];
      valuesData.forEach((key, values) {
        var name = values;
        var keyValues = key;
        for(var id in sceneNameIds){
          if(keyValues == "Id$id"){
            setState(() {
              deviceName.add(name['Device_Name']);
              deviceRoom.add(name['Room']);
            });
          }
        }
      });
    });
  }


  // scheduleData(){
  //   databaseReference.child(authKey).once().then((value) {
  //     var dataJson;
  //     scheduleName.clear();
  //     scheduleTime.clear();
  //     scheduleStatus.clear();
  //     scheduleDays.clear();
  //     setState(() {
  //       dataJson = value.snapshot.value;
  //     });
  //     // Map<dynamic, dynamic> values = value.value['SmartHome']['scenes'];
  //     Map<dynamic, dynamic> valuesData = dataJson['SmartHome']['Scenes']['Schedule'];
  //     valuesData.forEach((key, values) {
  //       var name = values;
  //       if(name['name'] == widget.routineName)
  //       {
  //         setState(() {
  //           scheduleName.add(name['name']);
  //           scheduleTime.add(name['time']);
  //           scheduleStatus.add(name['status']);
  //           scheduleDays.add(name['days']);
  //         });
  //       }
  //     });
  //     values = scheduleDays[0].cast<bool>();
  //     // initial();
  //   });
  // }


  getData() async {
    await databaseReference.child(authKey).once().then((value) {
      var dataJson;
      sceneNameIds.clear();
      trueDeviceIds.clear();
      scheduleName.clear();
      scheduleTime.clear();
      scheduleStatus.clear();
      scheduleDays.clear();

      setState(() {
        loader = true;
        dataJson = value.snapshot.value;
        deviceData = value.snapshot.value;

      });
      // Map<dynamic, dynamic> values = value.value['SmartHome']['scenes'];
      Map<dynamic, dynamic> valuesData = dataJson['SmartHome']['Scenes']['Schedule'];
      valuesData.forEach((key, values) {
        var name = values;
        if(name['name'] == widget.routineName)
        {
          setState((){
            scheduleName.add(name['name']);
            scheduleTime.add(name['time']);
            scheduleStatus.add(name['status']);
            scheduleDays.add(name['days']);
          });


          var sceneNameData = values;
          for(var deviceId in sceneNameData['ids']){
            setState(() {
              sceneNameIds.add(deviceId);
            });
          }
           if(sceneNameData['trueDevices'] != null){
             for(var trueDeviceId in sceneNameData['trueDevices'])
             {
               setState(() {
                 trueDeviceIds.add(trueDeviceId);
               });
             }
           }
        }
      });
      values = scheduleDays[0].cast<bool>();
      initial();
    });
  }



  @override
  void initState() {
    initialData();
    keyValues();

    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
               height: height*0.037,
            ),
            Row(
              children: [
                IconButton(onPressed: (){
                  Navigator.pop(context);
                }, icon: Icon(Icons.clear)),
                SizedBox(
                  width: width*0.74,
                ),
                // IconButton(onPressed: (){
                //   Navigator.of(context).push(routineRoute(widget.routineName));
                // }, icon: Icon(Icons.more_time_rounded)),
                IconButton(onPressed: (){
                  showAlertDialog(context);
                  // showAnotherAlertDialog(context);
                }, icon: Icon(Icons.more_vert_rounded)),
              ],
            ),
            SizedBox(
              height: height*0.010,
            ),
            Text("     ${widget.routineName}",style: Theme.of(context).textTheme.bodyText2,),
            Expanded(
              child: ListView.builder(
                  itemCount: deviceName.length,
                  itemBuilder: (BuildContext context,int index){
                    return Container(
                      margin: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.0),
                          border: Border.all(color: Colors.grey,width: 0.6),
                      ),
                      child: ListTile(
                          tileColor: Colors.transparent,
                          title:Text("${deviceName[index]}",
                              style: GoogleFonts.inter(fontSize: height*0.016,color: Colors.grey, fontWeight: FontWeight.w500)),
                          subtitle: Text("${deviceRoom[index]}",
                              style: GoogleFonts.inter(fontSize: height*0.010,color: Colors.grey, fontWeight: FontWeight.w500)),
                          // trailing: trueDeviceIds.isNotEmpty?Text("On"):deviceName.isNotEmpty?Text("off"):null,
                          trailing: trueDeviceIds.isNotEmpty?trueDeviceIds.contains(sceneNameIds[index])?Text("On",
                              style:  GoogleFonts.inter(fontSize: height*0.016,color: Colors.grey, fontWeight: FontWeight.w500),
                          ): Text("off", style:  GoogleFonts.inter(fontSize: height*0.016,color: Colors.grey, fontWeight: FontWeight.w500),
                          ):Text("off", style:  GoogleFonts.inter(fontSize: height*0.016,color: Colors.grey, fontWeight: FontWeight.w500),),
                      ),
                    );
                  }
              ),
            ),
            Text("     Schedule",style: Theme.of(context).textTheme.bodyText2,),
            Expanded(
              child: scheduleName.isNotEmpty ? ListView.builder(
                  itemCount: scheduleName.length,
                  itemBuilder: (BuildContext context,int index){
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                      margin: EdgeInsets.all(10.0),
                      height: height*0.20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Theme.of(context).canvasColor,
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Switch(
                                  inactiveTrackColor: Colors.grey.shade400,
                                  activeColor: Colors.orange,
                                  thumbColor: MaterialStateProperty.all(Colors.orange),
                                  value: scheduleStatus[index],
                                  onChanged: (bool value) {
                                    setState(() {
                                      scheduleStatus[index] = value;
                                      databaseReference.child(authKey).child('SmartHome').child("Scenes").child('Schedule').child(scheduleName[index]).update({
                                        'status': scheduleStatus[index],
                                      });
                                    });
                                  })
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("${scheduleName[index]}",style: Theme.of(context).textTheme.bodyText2,),
                              Text("${scheduleTime[index]}",style: Theme.of(context).textTheme.bodyText2,),
                            ],
                          ),
                          SizedBox(
                            height: height*0.010,
                          ),
                          WeekdaySelector(
                            selectedFillColor: Colors.orange,
                            fillColor: Colors.white,
                            selectedColor: Colors.black,
                            onChanged: (int day) {

                              print(scheduleDays[index]);
                              // setState(() {
                              //   final index = day % 7;
                              //   values[index] = !values[index];
                              // });
                            },
                            values: values,
                          ),
                          SizedBox(
                            height: height*0.030,
                          ),
                        ],
                      ),
                    );
                  }
              ):Center(
                child: Text("No schedule"),
              )
            ),
            SizedBox(
              height: height*0.030,
            ),
          ],
        ),
      ),
    );
  }
  // showAnotherAlertDialog(BuildContext context) {
  //   // Create button
  //   Widget cancelButton = TextButton(
  //     child: Text("cancel"),
  //     onPressed: () {
  //       Navigator.pop(context, false);
  //     },
  //   );
  //   Widget okButton = TextButton(
  //     child: Text("ok"),
  //     onPressed: () {
  //
  //       databaseReference.child(authKey).child('SmartHome').child('scenes').child(widget.routineName).once().then((value){
  //        sceneData = value.snapshot.value;
  //        if(sceneData['scheduleName'] !="")
  //          {
  //            databaseReference.child(authKey).child('SmartHome').child('schedule').child(sceneData['scheduleName'].toString()).remove();
  //            databaseReference.child(authKey).child('SmartHome').child('scenes').child(widget.routineName).remove();
  //            Navigator.pop(context, true);
  //            Navigator.pop(context);
  //          }else{
  //          databaseReference.child(authKey).child('SmartHome').child('scenes').child(widget.routineName).remove();
  //          Navigator.pop(context, true);
  //          Navigator.pop(context);
  //        }
  //       });
  //     },
  //   );
  //   // Create AlertDialog
  //   AlertDialog alert = AlertDialog(
  //     backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
  //     content: Text(
  //       "Do you really want to delete this routine ? ",
  //       style: Theme.of(context).dialogTheme.contentTextStyle,
  //     ),
  //     actions: [
  //       cancelButton,
  //       okButton,
  //     ],
  //   );
  //
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }
///
  showAlertDialog(BuildContext context) {
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
        databaseReference.child(authKey).child('SmartHome').child("Scenes").child('Schedule').child(widget.routineName).remove();
        // databaseReference.child(authKey).child('SmartHome').child('scenes').child(widget.routineName).update({
        //   'schedule': false,
        //   'scheduleName':"",
        // });
        Navigator.pop(context, true);
        Navigator.pop(context, true);
        // scheduleData();
      },
    );
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      content: Text(
        "Do you want to delete this Schedule ? ",
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


