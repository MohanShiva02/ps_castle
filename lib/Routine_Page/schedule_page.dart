// import 'dart:async';
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
//
// FirebaseAuth auth = FirebaseAuth.instance;
// final databaseReference = FirebaseDatabase.instance.reference();
//
// class SchedulePage extends StatefulWidget {
//   const SchedulePage({Key key}) : super(key: key);
//
//   @override
//   _SchedulePageState createState() => _SchedulePageState();
// }
//
// class _SchedulePageState extends State<SchedulePage> {
//
//   var scenesData;
//   List scheduleName = [];
//   List selectedRoutine =[];
//   Timer timer;
//   int id = 0;
//   bool validate = false;
//   bool loader = false;
//   SharedPreferences loginData;
//   String authKey = " ";
//   var personalDataJson;
//   bool vibrate = false;
//
//
//   initial() async
//   {
//     loginData = await SharedPreferences.getInstance();
//     setState(() {
//       vibrate = loginData.get('vibrationStatus')??false;
//       authKey = loginData.getString('ownerId')??" ";
//     });
//   }
//
//
//   getData() async {
//     await databaseReference.child(authKey).once().then((value) {
//       scheduleName.clear();
//       var dataJson;
//
//       setState(() {
//         loader = true;
//         dataJson = value.snapshot.value;
//         scenesData = value.snapshot.value;
//       });
//
//       // Map<dynamic, dynamic> values = value.value['SmartHome']['scenes'];
//       Map<dynamic, dynamic> values = dataJson['SmartHome']['schedule'];
//       values.forEach((key, values) {
//         scheduleName.add(values);
//       });
//
//
//     });
//   }
//
//   @override
//   void initState() {
//     initial();
//     timer = Timer.periodic(Duration(seconds: 3), (Timer t) {
//       getData();
//       //   // getName();
//     });
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     timer?.cancel();
//     // TODO: implement dispose
//     super.dispose();
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       backgroundColor: Theme.of(context).backgroundColor,
//       appBar: AppBar(
//         title: Text("Schedule Page" ,style: Theme.of(context).textTheme.headline5,),
//       ),
//       body: Container(
//         padding: EdgeInsets.fromLTRB(10.0, 70.0, 10.0, 20.0),
//         child: loader ? GridView.builder(
//           scrollDirection: Axis.vertical,
//           itemCount: scheduleName.length, //scenesData.length?? scenesName.length
//           itemBuilder: (BuildContext context, int index) {
//             return GestureDetector(
//               onLongPress: ()async{
//                 showAnotherAlertDialog(context, index);
//               },
//               child: Container(
//                 margin: EdgeInsets.all(10.0),
//                 padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 15.0),
//                 // height: height * 0.15,
//                 // width: width * 0.30,
//                 decoration: BoxDecoration(
//                   //color: Color.fromRGBO(54, 54, 54, 1.0),
//                     color: Theme.of(context).canvasColor,
//                     borderRadius: BorderRadius.circular(25.0)),
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         height: height * 0.020,
//                       ),
//                       Text('''Name : ${scheduleName[index]['ScheduleName']}''',
//                           style: Theme.of(context).textTheme.bodyText2,
//                           textAlign: TextAlign.left),
//                       SizedBox(
//                         height: height * 0.010,
//                       ),
//                       Text('''Date : ${scheduleName[index]['date']}''',
//                           style: Theme.of(context).textTheme.bodyText2,
//                           textAlign: TextAlign.left),
//                       SizedBox(
//                         height: height * 0.010,
//                       ),
//                       Text('''Time : ${scheduleName[index]['time']}hrs''',
//                           style: Theme.of(context).textTheme.bodyText2,
//                           textAlign: TextAlign.left),
//                       SizedBox(
//                         height: height * 0.010,
//                       ),
//                       Text('''Routines :  ${scheduleName[index]['selectedRoutines'].toString()
//                           .replaceAll(RegExp("[\\p{Ps}\\p{Pe}]", unicode: true), "")}''',
//                           style: Theme.of(context).textTheme.bodyText2,
//                           textAlign: TextAlign.left,),
//
//                       Text('''Time : ${scheduleName[index]['status'] == true?"Completed":"Yet to Happen"}''',
//                           style: Theme.of(context).textTheme.bodyText2,
//                           textAlign: TextAlign.left),
//
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//           ),
//         ): Center(
//           child: CircularProgressIndicator(
//             backgroundColor: Colors.black,
//             valueColor:
//             new AlwaysStoppedAnimation<Color>(
//                 Colors.white),
//           ),
//         )
//       ),
//     );
//   }
//   showAnotherAlertDialog(BuildContext context,index) {
//     // Create button
//     Widget cancelButton = TextButton(
//       child: Text("cancel"),
//       onPressed: (){
//         Navigator.pop(context, false);
//       },
//     );
//     Widget okButton = TextButton(
//       child: Text("ok"),
//       onPressed: (){
//         databaseReference.child(authKey).child('SmartHome')
//             .child('schedule').child(scheduleName[index]['ScheduleName']).remove();
//         Navigator.pop(context, true);
//       },
//     );
//     // Create AlertDialog
//     AlertDialog alert = AlertDialog(
//       backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
//       content: Text("Do you really want to delete this schedule ? ",style: Theme.of(context).dialogTheme.contentTextStyle,),
//       actions: [
//         cancelButton,
//         okButton,
//       ],
//     );
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert ;
//       },
//     );
//   }
// }
import 'dart:async';
import 'package:day_night_time_picker/lib/constants.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weekday_selector/weekday_selector.dart';






final databaseReference = FirebaseDatabase.instance.reference();

class SchedulePage extends StatefulWidget {
  final String routineName;
  final List trueDevices;
  final List selectedDevice;
  const SchedulePage({Key key,this.routineName,this.trueDevices,this.selectedDevice}) : super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {

  TextEditingController _controller = TextEditingController();
  String newTaskTitle;
  bool _validate = false;
  SharedPreferences loginData;
  TimeOfDay selectedTime = TimeOfDay.now();
  var dummyTime = TimeOfDay.now();
  var currentDate = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  String formattedDate = " ";
  int day = 0;
  int month = 0;
  int year = 0;
  String combination = " ";
  String dumTime = " ";
  FocusNode f1 = FocusNode();
  bool everyDay = false;
  String authKey = " ";
  bool vibrate = false;
  Timer timer;
  final values = List.filled(7, false);
  bool scheduleStatus= true;
  List existingScheduleName = [];



  ///date and time
  // Future<void> _selectDate() async {
  //   formattedDate = formatter.format(currentDate);
  //   final DateTime pickedDate = await showDatePicker(
  //       context: context,
  //       builder: (BuildContext context, Widget child) {
  //         return Theme(
  //           data: ThemeData(
  //             colorScheme: ColorScheme.light(
  //               primary: Colors.blue,
  //               onPrimary: Colors.white,
  //               surface: Colors.white,
  //               onSurface: Colors.blue,
  //             ),
  //             dialogBackgroundColor: Colors.white,
  //           ),
  //           child: child ??Text(""),
  //         );
  //       },
  //       initialDate: currentDate,
  //       firstDate: DateTime(2020),
  //       lastDate: DateTime(2050));
  //   if (pickedDate != null && pickedDate != currentDate) {
  //     setState(() {
  //       currentDate = pickedDate;
  //       day = pickedDate.day;
  //       month = pickedDate.month;
  //       year = pickedDate.year;
  //       combination = "$day/$month/$year";
  //     });
  //   }
  // }
  // // time() {
  // //   selectedTime = TimeOfDay.now();
  // // }
  //
  // _selectTime() async {
  //   final TimeOfDay timeOfDay = await showTimePicker(
  //     context: context,
  //     builder: (BuildContext context, Widget child) {
  //       return Theme(
  //         data: ThemeData(
  //           colorScheme: ColorScheme.light(
  //             primary: Colors.blue,
  //             onPrimary: Colors.white,
  //             surface: Colors.white,
  //             onSurface: Colors.blue,
  //           ),
  //           dialogBackgroundColor: Colors.white,
  //         ),
  //         child: child ??Text(""),
  //       );
  //     },
  //     initialTime: selectedTime,
  //     initialEntryMode: TimePickerEntryMode.dial,
  //   );
  //   if (timeOfDay != null && timeOfDay != selectedTime) {
  //     setState(() {
  //       dummyTime = timeOfDay;
  //       dumTime = dummyTime.toString().substring(10, 15);
  //
  //     });
  //   }
  // }


  void onTimeChanged(TimeOfDay newTime) {
    setState(() {
      selectedTime = newTime;
    });
  }

  initialData() async
  {
    loginData = await SharedPreferences.getInstance();
    setState(() {
      vibrate = loginData.get('vibrationStatus')??false;
      authKey = loginData.getString('ownerId')??" ";
      readData();
    });
  }



  readData(){
    databaseReference.child(authKey).child('SmartHome').child("Scenes").child('Schedule').once().then((value){
      value.snapshot.children.forEach((element) {
        setState(() {
          existingScheduleName.add(element.key);
        });
      });
    });
  }

  @override
  void initState() {
    initialData();
    // time();
    // timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    //
    // });
    _controller = TextEditingController();
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
        child: SingleChildScrollView(
          child: Column(
            children: [
            SizedBox(
            height: height*0.037,
          ),
          Row(
            children: [
              IconButton(
                  onPressed: (){
                Navigator.pop(context);
                },
                  icon: Icon(Icons.clear)
              ),
            ],
          ),
              SizedBox(
                height: height*0.037,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Make it schedule ",style: Theme.of(context).textTheme.bodyText2),
                  SizedBox(
                    width: width*0.037,
                  ),
                  Switch(
                      inactiveTrackColor: Colors.grey.shade400,
                      activeColor: Colors.orange,
                      thumbColor: MaterialStateProperty.all(Colors.orange),
                      value: scheduleStatus,
                      onChanged: (bool value) {
                        setState(() {
                          scheduleStatus = value;
                        });
                      })
                ],
              ),
              SizedBox(
                height: height*0.027,
              ),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 30.0),
                padding: EdgeInsets.all(6.0),
                width: width * 0.80,
                height: height*0.090,
                decoration: BoxDecoration(
                  //color: Color.fromRGBO(54, 54, 54, 1.0),
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.circular(15.0)),
                child: Center(
                  child: TextFormField(
                    onEditingComplete: (){
                      f1.unfocus();
                    },
                    focusNode: f1,
                    autofocus: false,
                    controller: _controller,
                    style: Theme.of(context).textTheme.bodyText2,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: '  Schedule name',
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorText: _validate ? ' Schedule name is required' : null,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: height*0.037,
              ),
              //headline2: TextStyle(color: Colors.grey,fontWeight: FontWeight.w800,),
              GestureDetector(
                onTap: (){
                  Navigator.of(context).push(
                    showPicker(
                        cancelText: " ",
                        accentColor: Colors.blue,
                        elevation: 1,
                      context: context,
                      value: selectedTime,
                      onChange: onTimeChanged,
                      minuteInterval: MinuteInterval.ONE,
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 30.0),
                  padding: EdgeInsets.all(6.0),
                  width: width * 0.80,
                  height: height*0.090,
                  decoration: BoxDecoration(
                    //color: Color.fromRGBO(54, 54, 54, 1.0),
                      color: Theme.of(context).canvasColor,
                      borderRadius: BorderRadius.circular(15.0)),
                  child:  Center(
                    child: Text(
                      selectedTime.format(context),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline2),
                  ),
                  ),
              ),
              SizedBox(
                height: height*0.037,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 30.0),
                padding: EdgeInsets.all(6.0),
                width: width * 0.80,
                height: height*0.090,
                decoration: BoxDecoration(
                  //color: Color.fromRGBO(54, 54, 54, 1.0),
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.circular(15.0)),
                child: WeekdaySelector(
                  selectedFillColor: Colors.orange,
                  fillColor: Colors.white,
                  selectedColor: Colors.black,
                  onChanged: (int day) {
                    setState(() {
                      final index = day % 7;
                      values[index] = !values[index];
                    });
                  },
                  values: values,
                ),
              ),
              SizedBox(
                height: height*0.017,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 40.0,vertical: 10.0),
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Theme.of(context).canvasColor)
                        ),
                        onPressed: (){
                          setState(() {
                            _controller.text.isEmpty
                                ? _validate = true
                                : _validate = false;
                            if (_validate)
                            {
                              showSimpleNotification(
                                Text(
                                  "please enter the schedule name",
                                  style: TextStyle(color: Colors.white),
                                ),
                                background: Colors.red,
                              );
                            } else if ((_validate == false) && (selectedTime.toString().substring(10, 15) != " ") &&(values.contains(true))){

                                if(existingScheduleName.contains(_controller.text))
                                {
                                  showSimpleNotification(
                                    Text(
                                      "please enter different names",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    background: Colors.red,
                                  );
                                }else{
                                  // var da = {
                                  //   'ScheduleName': _controller.text,
                                  //   "selectedRoutines" : widget.routineName,
                                  //   "time": selectedTime.toString().substring(10, 15),
                                  //   "status": scheduleStatus,
                                  //   "days": values,
                                  //   "wait":false,
                                  // };
                                  var da = {
                                    'name': _controller.text,
                                    "schedule":true,
                                    "ids": widget.selectedDevice,
                                    "trueDevices": widget.trueDevices,
                                    "time": selectedTime.toString().substring(10, 15),
                                    "status": scheduleStatus,
                                    "days": values,
                                    "wait":false,
                                  };
                                  // print(da);
                                  // print(widget.routineName);
                                  // databaseReference.child(authKey).child('SmartHome').child('scenes').child(widget.routineName).update({
                                  //   'schedule': true,
                                  //   'scheduleName':_controller.text,
                                  // });
                                  databaseReference.child(authKey).child('SmartHome').child('Scenes').child('Schedule').child(_controller.text).set(da);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                }
                            } else {
                              showSimpleNotification(
                                Text(
                                  "please enter days",
                                  style: TextStyle(color: Colors.white),
                                ),
                                background: Colors.red,
                              );
                            }
                          });
                        }, child: Text(" Done ")),
                  ),
                ],
              )
          ]
       ),
        ),
      ),
    );
  }
}
