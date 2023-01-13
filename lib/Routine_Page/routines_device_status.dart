import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:onwords_home/Routine_Page/routinedata_complete_page.dart';
import 'package:onwords_home/Routine_Page/schedule_page.dart';
import 'package:shared_preferences/shared_preferences.dart';


final databaseReference = FirebaseDatabase.instance.reference();

class GetScenesState extends StatefulWidget {
  final List value;
  final List deviceName;
  final String ip;
  final List roomName;
  final String name;


  GetScenesState({Key key, @required this.value,@required this.deviceName,@required this.ip, @required this.roomName,@required this.name}) : super(key: key);

  @override
  _GetScenesStateState createState() => _GetScenesStateState();
}

class _GetScenesStateState extends State<GetScenesState> {
  var ids;
  List trueDevicesList = [];
  List deviceName = [];
  List roomName = [];
  String ip = "";
  bool vibrate = false;
  String authKey = " ";
  SharedPreferences loginData;
  var dataJson;
  
  initialData() async
  {
    loginData = await SharedPreferences.getInstance();
    setState(() {
      vibrate = loginData.get('vibrationStatus')??false;
      authKey = loginData.getString('ownerId')??" ";
      ip = widget.ip;
      getData();
    });
  }
  
  getData(){
    if(ip =="false"){
      deviceName.clear();
      var val = widget.value;
      for(var i in val)
        {
          databaseReference.child(authKey).child("SmartHome").child("Devices").child('Id$i').once().then((value){
              dataJson = value.snapshot.value;
             setState(() {
               deviceName.add(dataJson['Device_Name']);
               roomName.add(dataJson["Room"]);
             });
          });
        }
    }
  }

  @override
  void initState() {
    initialData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(title: Text("selected devices", style: Theme.of(context).textTheme.headline5,),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 05.0),
            child: IconButton(onPressed: (){
              if(widget.name == "Run Manually"){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>   FinalRoutinePage(trueDevices: trueDevicesList,selectedDevice:( widget.value),)),
                );
              }else{
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>   SchedulePage(trueDevices: trueDevicesList,selectedDevice: widget.value,)),
                );
              }


            }, icon: Icon(Icons.navigate_next_outlined,size: height*0.04,)),
          )
        ],

      ),

      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        height: height*1.0,
        width: width*1.0,
        color: Theme.of(context).backgroundColor,
        child: ListView.builder(
            // itemCount: (widget.value).length ,
            itemCount: ip!="false"?(widget.value).length: deviceName.length,
            itemBuilder: (BuildContext context,int index){
              return ListTile(

                  trailing: Switch(
                      activeColor: Colors.orange,
                      trackColor: MaterialStateProperty.all(Colors.grey),
                      onChanged: (bool value){
                    setState(() {
                      // print(widget.deviceName);
                      // // print(trueDevicesList.contains(widget.value[index]));
                      // print(widget.deviceName[int.parse(widget.value[index])-1]);
                      // print(int.parse(widget.value[index]));

                      if(trueDevicesList.contains(widget.value[index])==false){
                        trueDevicesList.add(widget.value[index]);
                      }
                      else{
                        trueDevicesList.remove(widget.value[index]);
                      }
                    });

                  }, value: trueDevicesList.contains(widget.value[index])?true:false),
                  title: ip !="false"?Text("${widget.deviceName[int.parse(widget.value[index])-1]} in ${widget.roomName[int.parse(widget.value[index])-1]}",
                    style: Theme.of(context).textTheme.bodyText2,):
                  Text("${deviceName[index]} in ${roomName[index]}",
                    style: Theme.of(context).textTheme.bodyText2,)
              );
            }
        ),
      ),
    );
  }
}
