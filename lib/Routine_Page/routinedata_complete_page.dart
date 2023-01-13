import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:onwords_home/Routine_Page/routine_page.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebaseAuth auth = FirebaseAuth.instance;
final databaseReference = FirebaseDatabase.instance.reference();

class FinalRoutinePage extends StatefulWidget {
  var trueDevices;
  var selectedDevice;
  FinalRoutinePage({Key key, @required this.trueDevices, @required this.selectedDevice}) : super(key: key);

  @override
  _FinalRoutinePageState createState() => _FinalRoutinePageState();
}

class _FinalRoutinePageState extends State<FinalRoutinePage> {
  var DeviceNames;
  bool validate = false;
  TextEditingController name = TextEditingController();
  SharedPreferences loginData;
  String authKey = " ";
  var personalDataJson;
  bool vibrate = false;
  List existingSceneName = [];


  initial() async
  {
    loginData = await SharedPreferences.getInstance();
    setState(() {
      vibrate = loginData.get('vibrationStatus')??false;
      authKey = loginData.getString('ownerId')??" ";
      readData();
    });
  }


  readData(){
    databaseReference.child(authKey).child('SmartHome').child('Scenes').child('TabToRun').once().then((value){
      value.snapshot.children.forEach((element) {
        setState(() {
          existingSceneName.add(element.key);
        });
      });
    });
  }

  // var DeviceNames ;
  // getData()  {
  //   setState(() async {
  //     var d = await http.get(Uri.parse("http://192.168.1.18"));
  //     _d = jsonDecode(d.body);
  //     print(_d);
  //     List x = widget.selectedDevice;
  //     print("x = ${x.length}");
  //
  //     // for(var key in _d){
  //     //  if((widget.selectedDevice))
  //     // }
  //
  //     // return _d;
  //   });
  //
  // }

  @override
  void initState() {
    initial();
    //must***
    // timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
    //   confirmation();
    // });
    name = TextEditingController();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text(
            "Routines Name",
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Text("selected devices = ${widget.selectedDevice.toString()}"),
              // Text("true devices = ${widget.trueDevices.toString()}"),
              SizedBox(
                // height: 40.0,
                height: height * 0.055,
              ),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 40.0),
                padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
                height: height * 0.075,
                width: width * 0.75,
                decoration: BoxDecoration(
                    // color: Color.fromRGBO(54, 54, 54, 1.0),
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.circular(10.0)),
                child: TextFormField(
                  controller: name,
                  style: Theme.of(context).textTheme.bodyText2,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'Routines name',
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorText: validate ? "please enter any value" : null,
                  ),
                ),
              ),
              SizedBox(
                // height: 40.0,
                height: height * 0.035,
              ),

              // Text("d = ${_d}"),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:MaterialStateProperty.all(Colors.orange)),
                  onPressed: () {
                    setState(() {
                      name.text.isEmpty? validate = true: validate = false;
                      var da = {
                        'name': name.text,
                        "ids": widget.selectedDevice,
                        "trueDevices": widget.trueDevices,
                        "tabToRun":true
                      };
                      if(!validate){
                        if(existingSceneName.contains(name.text)){

                          showSimpleNotification(
                            Text(
                              "please enter different names",
                              style: TextStyle(color: Colors.white),
                            ),
                            background: Colors.red,
                          );
                        }else{
                          databaseReference.child(authKey).child('SmartHome').child('Scenes').child('TabToRun').child(name.text).set(da);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }
                      }
                    });
                    //Navigator.push(context, MaterialPageRoute(builder: (context) =>RoutinePage()));
                  },
                  child: const Text(' Done '))
            ],
          ),
        ));
  }
}
