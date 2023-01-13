import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:onwords_home/Routine_Page/routines_device_status.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

FirebaseAuth auth = FirebaseAuth.instance;
final databaseReference = FirebaseDatabase.instance.reference();


class RoutinePage2 extends StatefulWidget {
  final String name;

  const RoutinePage2({Key key, this.name}) : super(key: key);

  @override
  _RoutinePage2State createState() => _RoutinePage2State();
}

class _RoutinePage2State extends State<RoutinePage2> {

  TextEditingController name = TextEditingController();
  @override
  void initState() {
    //must***
    // timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
    //   confirmation();
    // });
    name = TextEditingController();
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        //backgroundColor: Color.fromRGBO(26, 28, 30, 0.6),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          height: height*1.0,
          width: width*1.0,
          color: Theme.of(context).backgroundColor,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  // height: 40.0,
                  height: height * 0.055,
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => RoutinePageFinal()));
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Theme.of(context).iconTheme.color,
                        size: height * 0.030,
                      ),
                    ),
                    Text(
                      widget.name,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ],
                ),
                // Container(
                //   margin: EdgeInsets.symmetric(horizontal: 40.0),
                //   padding: EdgeInsets.all(20.0),
                //   height: height * 0.070,
                //   width: width * 0.75,
                //   decoration: BoxDecoration(
                //     // color: Color.fromRGBO(54, 54, 54, 1.0),
                //       color: Theme.of(context).canvasColor,
                //       borderRadius: BorderRadius.circular(10.0)),
                //   child: TextFormField(
                //     controller: name,
                //     style: Theme.of(context).textTheme.bodyText2,
                //     keyboardType: TextInputType.name,
                //     textInputAction: TextInputAction.next,
                //     decoration: const InputDecoration(
                //       hintText: 'Routines name',
                //       enabledBorder: InputBorder.none,
                //       focusedBorder: InputBorder.none
                //     ),
                //   ),
                //   //Text(" Routines name ", style: Theme.of(context).textTheme.bodyText2),
                // ),

                SizedBox(
                  // height: 20.0,
                  height: height * 0.035,
                ),
                DeviceBuilder(name: widget.name,),

                // Container(
                //   margin: EdgeInsets.symmetric(horizontal: 20.0),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       // Text(
                //       //   " Actions ",
                //       //   style: Theme.of(context).textTheme.headline5,
                //       //   // style: GoogleFonts.inter(
                //       //   //     fontSize: height * 0.038,
                //       //   //     fontWeight: FontWeight.bold,
                //       //   //     color: Colors.white),
                //       // ),
                //       // SizedBox(
                //       //   // height: 20.0,
                //       //   height: height * 0.035,
                //       // ),
                //
                //       Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           // Text(
                //           //   "          On State ",
                //           //   style: Theme.of(context).textTheme.bodyText2,
                //           //   // style: GoogleFonts.inter(
                //           //   //     fontSize: height * 0.038,
                //           //   //     fontWeight: FontWeight.bold,
                //           //   //     color: Colors.white),
                //           // ),
                //           SizedBox(
                //             // height: 20.0,
                //             height: height * 0.015,
                //           ),
                //           Container(
                //               margin: EdgeInsets.symmetric(horizontal: 05.0),
                //               padding: EdgeInsets.all(10.0),
                //               height: height * 0.070,
                //               width: width * 0.95,
                //               decoration: BoxDecoration(
                //                 // color: Color.fromRGBO(54, 54, 54, 1.0),
                //                   color: Theme.of(context).canvasColor,
                //                   borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),topRight:Radius.circular(10.0) )),
                //               child: Row(
                //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                 children: [
                //                   Text(" Set Status to Selected Device" , style: Theme.of(context).textTheme.bodyText2,),
                //                   IconButton(
                //                     icon: Icon(Icons.add),
                //                     onPressed: (){
                //                       Navigator.push(
                //                           context,
                //                           MaterialPageRoute(
                //                               builder: (context) =>  GetScenesState(value: ,)
                //                           )//TotalDevicePage()
                //                       );
                //                     },
                //                   ),
                //                 ],
                //               )
                //           ),
                //           Container(
                //             margin: EdgeInsets.symmetric(horizontal: 05.0),
                //             padding: EdgeInsets.all(10.0),
                //             height: height*0.75,
                //             width: width * 0.95,
                //             decoration: BoxDecoration(
                //               // color: Color.fromRGBO(54, 54, 54, 1.0),
                //                 color: Theme.of(context).canvasColor,
                //                 borderRadius: BorderRadius.only(bottomLeft:Radius.circular(10.0),bottomRight: Radius.circular(10.0))),
                //             // child: SelectedDevicesViewer(),
                //             child: DeviceBuilder(),
                //           )
                //         ],
                //       ),
                //
                //
                //       // SizedBox(
                //       //   // height: 20.0,
                //       //   height: height * 0.035,
                //       // ),
                //       //
                //       // Column(
                //       //   crossAxisAlignment: CrossAxisAlignment.start,
                //       //   children: [
                //       //     Text(
                //       //       "          Off State ",
                //       //       style: Theme.of(context).textTheme.bodyText2,
                //       //       // style: GoogleFonts.inter(
                //       //       //     fontSize: height * 0.038,
                //       //       //     fontWeight: FontWeight.bold,
                //       //       //     color: Colors.white),
                //       //     ),
                //       //     SizedBox(
                //       //       // height: 20.0,
                //       //       height: height * 0.015,
                //       //     ),
                //       //     Container(
                //       //         margin: EdgeInsets.symmetric(horizontal: 20.0),
                //       //         padding: EdgeInsets.all(10.0),
                //       //         height: height * 0.070,
                //       //         width: width * 0.75,
                //       //         decoration: BoxDecoration(
                //       //           // color: Color.fromRGBO(54, 54, 54, 1.0),
                //       //             color: Theme.of(context).canvasColor,
                //       //             borderRadius: BorderRadius.circular(10.0)),
                //       //         child: Row(
                //       //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       //           children: [
                //       //             Text(" Add device to switch off" , style: Theme.of(context).textTheme.bodyText2,),
                //       //             IconButton(
                //       //               icon: Icon(Icons.add),
                //       //               onPressed: (){},
                //       //             ),
                //       //           ],
                //       //         )
                //       //     ),
                //       //
                //       //     SizedBox(
                //       //       // height: 40.0,
                //       //       height: height * 0.025,
                //       //     ),
                //       //     Center(
                //       //       child: ElevatedButton(
                //       //           style: ButtonStyle(
                //       //             elevation: MaterialStateProperty.all(5),
                //       //             backgroundColor: MaterialStateProperty.all(Colors.orangeAccent),),
                //       //           onPressed: (){
                //       //             setState(() {
                //       //               //StoreKey("Admin");
                //       //
                //       //               print("  ");
                //       //               print("device selected ${selectedDevices}");
                //       //               print(auth.currentUser.uid);
                //       //               // print(Provider.of<TaskData>(context).DevicesSelected);
                //       //               var data1 = [];
                //       //               print(selectedDevices.length);
                //       //               for(int i =0;i<selectedDevices.length;i++){
                //       //                 for(int j =0;j<selectedDevices[i].length;j++){
                //       //                   data1.add(selectedDevices[i][j].toString());
                //       //                 }
                //       //               }
                //       //               //print(data1);
                //       //               var _data = {
                //       //                   'room1': data1.toString(),
                //       //               };
                //       //               var _temp = databaseReference.child(auth.currentUser.uid).child('routines').child(name.text).child("ON").set(_data);
                //       //               print("temp = $_temp");
                //       //
                //       //             });
                //       //
                //       //           }, child: Text("  Done  ")),
                //       //     ),
                //       //   ],
                //       // ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ));
  }

}




class DeviceBuilder extends StatefulWidget {
  final String name;

  const DeviceBuilder({Key key,@required this.name}) : super(key: key);

  @override
  _DeviceBuilderState createState() => _DeviceBuilderState();
}

class _DeviceBuilderState extends State<DeviceBuilder> {

  bool wifiNotifier = false;
  String ip = " ";
  String username = " ";
  bool notifier = false;
  bool mobNotifier = false;
  bool currentIndex = false;
  bool valueStatus = false;
  List <String> selectedDeviceStateTrueList = [];
  bool validate = false;
  List name = [];
  List pg = [];
  List data = [];
  bool first = false;
  bool status = false;
  int statusInt = 0;
  List toggleValues = [];
  int selectedIndex =0;
  List selectedDevices = [];
  List selectedDevicesID = [];
  List selectedDevicesStatus = [];
  List<String> localDataVal = [];
  List<String> dumVariable = [];
  List<String> valueVariable = [];
  List<String> valueVariableId = [];
  List<String> valueStatusList = [];
  var dataJson;
  var acount = 0;
  var count = 0;
  SharedPreferences loginData;
  String userName = " ";
  String ipAddress = " ";
  String ipLocal = " ";
  String onlineIp = " ";
  String phoneNumber = " ";
  String email = " ";
  bool noLocalServer = false;
  var localServer;
  bool bothOffOn = false ;
  var smartHome;
  int intValue = 0;
  bool loader = true;
  bool vibrate = false;
  List buttonTapped = [ ];
  String authKey = " ";
  var ownerId;
  var deviceData;
  List deviceName = [];



  keyValues() async {

    loginData = await SharedPreferences.getInstance();
    final locIp = loginData.getString('ip') ?? null;
    final onIp = loginData.getString('onlineIp') ?? null;
    // final locIp = ipAddress;
    // final onIp = ipAddress;

    if((locIp != null)&&(locIp != "false")){
      // print("locIp $locIp ");
      final response = await http.get(Uri.parse("http://$locIp/")).timeout(
          const Duration(milliseconds: 1000),onTimeout: (){
        //ignore:avoid_print
        //print(" inside the timeout gridPage ");
        setState(() {
          ipAddress = onIp;
        });
        data.clear();
        initial();
        throw '';
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
    //loginData = await SharedPreferences.getInstance();
    //username = loginData.getString('username')!;

    if (ipAddress == null) {
      //fireData();
    } else if ((data == null) || (data.length == 0)) {

      if (ipAddress.toString() != 'false') {

        final response = await http.get(Uri.parse("http://$ipAddress/",));
        var fetchdata = jsonDecode(response.body);

        setState(() {
          // loader = true;
          localDataVal.clear();
          dumVariable.clear();
          var dumData = fetchdata;
          for (int i = 0; i < dumData.length; i++)
          {
            dumVariable.add(dumData[i]["Room"].toString());
            valueVariable.add(dumData[i]["Device_Name"].toString());
            valueStatusList.add(dumData[i]["Device_Status"].toString());
            valueVariableId.add(dumData[i]['id'].toString());
          }
          localDataVal = dumVariable.toSet().toList();
          data = localDataVal;
          loginData.setStringList('dataValues', localDataVal);
          initial();
        });
      }else if((ipAddress.toString() == 'false'))
      {
        // print("im inside the false");
        setState(() {
          initialData();
          //getName();

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
      //getName();
    }
  }

  initialData() async
  {
    loginData = await SharedPreferences.getInstance();
    setState(() {
      vibrate = loginData.get('vibrationStatus')??false;
      authKey = loginData.getString('ownerId')??" ";
      getData();
    });
  }


  getData() async {
    await databaseReference.child(authKey).once().then((value) {
      valueVariable.clear();
      var dataJson;

      setState(() {
        loader = true;
        dataJson = value.snapshot.value;
        deviceData = value.snapshot.value;

      });

      // Map<dynamic, dynamic> values = value.value['SmartHome']['scenes'];
      Map<dynamic, dynamic> valuesData = dataJson['SmartHome']['Devices'];
      valuesData.forEach((key, values) {
          // values.forEach((key, value){
          //
          // });
        setState(() {
          dumVariable.add(values['Room'].toString());
          valueVariable.add(values['Device_Name'].toString());
          valueStatusList.add(values["Device_Status"].toString());
          valueVariableId.add(values['id'].toString());
        });
        // print(dumVariable);
        // print(valueVariable);
      });
      ///fan data fetching method
      // Map<dynamic, dynamic> valuesDataFan = dataJson['SmartHome']['Fan'];
      // valuesDataFan.forEach((key, values) {
      //   // values.forEach((key, value){
      //   //
      //   // });
      //   setState(() {
      //     dumVariable.add(values['Room'].toString());
      //     valueVariable.add(values['Fan_Name'].toString());
      //     valueStatusList.add(values["Device_Status"].toString());
      //     valueVariableId.add(values['id'].toString());
      //   });
      // });



     // print("deviceName $deviceName");
     // print("deviceData $deviceData");
    });
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



  @override
  void initState() {
    keyValues();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return  Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                // height: 20.0,
                height: height * 0.015,
              ),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 05.0),
                  padding: EdgeInsets.all(10.0),
                  height: height * 0.070,
                  width: width * 0.95,
                  decoration: BoxDecoration(
                    // color: Color.fromRGBO(54, 54, 54, 1.0),
                      color: Theme.of(context).canvasColor,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),topRight:Radius.circular(10.0) )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(" Set Status to Selected Device" , style: Theme.of(context).textTheme.bodyText2,),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: (){
                          setState(() {
                            selectedDevicesID.isEmpty? validate = true:validate = false;
                            if(validate){
                              showSimpleNotification(
                                Text(
                                  "please select any device",
                                  style: TextStyle(color: Colors.white),
                                ),
                                background: Colors.red,
                              );
                            }else{
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>  GetScenesState(value: selectedDevicesID,deviceName: valueVariable, ip: ipAddress, roomName: dumVariable, name: widget.name,)
                                  )//TotalDevicePage()
                              );
                            }

                          });
                        },
                      ),
                    ],
                  )
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 05.0),
                padding: EdgeInsets.all(10.0),
                height: height*0.75,
                width: width * 0.95,
                decoration: BoxDecoration(
                  // color: Color.fromRGBO(54, 54, 54, 1.0),
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.only(bottomLeft:Radius.circular(10.0),bottomRight: Radius.circular(10.0))),
                // child: SelectedDevicesViewer(),
                child: loader ?ListView.builder(
                    itemCount: valueVariable.length,
                    itemBuilder: (BuildContext context,int index){
                      return Card(
                        child: ListTile(
                            tileColor: selectedDevicesID.isNotEmpty?selectedDevicesID.contains(valueVariableId[index])?Colors.orange:Theme.of(context).canvasColor:Theme.of(context).canvasColor,
                            onTap: (){
                              initial();

                              setState(() {
                                if(true){

                                  for(int i = 0; i <= selectedDevicesID.length ; i++){

                                    if(selectedDevicesID.contains(valueVariableId[index]))
                                    {

                                      selectedDevicesID.remove(valueVariableId[index]);
                                      selectedDevicesStatus.remove(valueStatusList[index]);

                                      break;
                                    }else if(selectedDevices.isEmpty){

                                      selectedDevicesID.add(valueVariableId[index]);
                                      selectedDevicesStatus.add({valueVariable[index]:false});
                                      break;
                                    }else{

                                      selectedDevicesID.add(valueVariableId[index]);
                                      selectedDevicesStatus.add({valueVariable[index]:false});

                                      break;
                                    }
                                  }
                                }
                              });

                            },

                            title:Text("${valueVariable[index]} in ${dumVariable[index]}", style: Theme.of(context).textTheme.bodyText2,)
                        ),
                      );
                    }
                ) : Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.black,
                    valueColor:
                    new AlwaysStoppedAnimation<Color>(
                        Colors.white),
                  ),
                ),
              )
            ],
          ),
          // SizedBox(
          //   // height: 20.0,
          //   height: height * 0.035,
          // ),
          //
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Text(
          //       "          Off State ",
          //       style: Theme.of(context).textTheme.bodyText2,
          //       // style: GoogleFonts.inter(
          //       //     fontSize: height * 0.038,
          //       //     fontWeight: FontWeight.bold,
          //       //     color: Colors.white),
          //     ),
          //     SizedBox(
          //       // height: 20.0,
          //       height: height * 0.015,
          //     ),
          //     Container(
          //         margin: EdgeInsets.symmetric(horizontal: 20.0),
          //         padding: EdgeInsets.all(10.0),
          //         height: height * 0.070,
          //         width: width * 0.75,
          //         decoration: BoxDecoration(
          //           // color: Color.fromRGBO(54, 54, 54, 1.0),
          //             color: Theme.of(context).canvasColor,
          //             borderRadius: BorderRadius.circular(10.0)),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Text(" Add device to switch off" , style: Theme.of(context).textTheme.bodyText2,),
          //             IconButton(
          //               icon: Icon(Icons.add),
          //               onPressed: (){},
          //             ),
          //           ],
          //         )
          //     ),
          //
          //     SizedBox(
          //       // height: 40.0,
          //       height: height * 0.025,
          //     ),
          //     Center(
          //       child: ElevatedButton(
          //           style: ButtonStyle(
          //             elevation: MaterialStateProperty.all(5),
          //             backgroundColor: MaterialStateProperty.all(Colors.orangeAccent),),
          //           onPressed: (){
          //             setState(() {
          //               //StoreKey("Admin");
          //
          //               print("  ");
          //               print("device selected ${selectedDevices}");
          //               print(auth.currentUser.uid);
          //               // print(Provider.of<TaskData>(context).DevicesSelected);
          //               var data1 = [];
          //               print(selectedDevices.length);
          //               for(int i =0;i<selectedDevices.length;i++){
          //                 for(int j =0;j<selectedDevices[i].length;j++){
          //                   data1.add(selectedDevices[i][j].toString());
          //                 }
          //               }
          //               //print(data1);
          //               var _data = {
          //                   'room1': data1.toString(),
          //               };
          //               var _temp = databaseReference.child(auth.currentUser.uid).child('routines').child(name.text).child("ON").set(_data);
          //               print("temp = $_temp");
          //
          //             });
          //
          //           }, child: Text("  Done  ")),
          //     ),
          //   ],
          // ),
        ],
      ),
    );

  }
}


// class SelectedDevicesViewer extends StatefulWidget {
//   const SelectedDevicesViewer({Key key}) : super(key: key);
//
//   @override
//   _SelectedDevicesViewerState createState() => _SelectedDevicesViewerState();
// }
//
// class _SelectedDevicesViewerState extends State<SelectedDevicesViewer> {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<TaskData>(
//       builder: (context, taskData, child) {
//         return ListView.builder(
//           shrinkWrap: true,
//           scrollDirection: Axis.vertical,
//           itemBuilder: (context, index) {
//             final task = taskData.DevicesSelected[index];
//             return Card(
//               child: Center(child: Text(task.toString())),
//             );
//           },
//           itemCount: taskData.selectedDeviceCount,
//         );
//       },
//     );
//   }
// }


