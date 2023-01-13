import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPage1 extends StatefulWidget {
  const NotificationPage1({Key key}) : super(key: key);

  @override
  _NotificationPage1State createState() => _NotificationPage1State();
}

class _NotificationPage1State extends State<NotificationPage1> {
  var data;
  SharedPreferences loginData;
  String ip;
  List dataJsonKey = [];
  List selectedDevices = [];
  List selectedDevicesID = [];
  List selectedDevicesStatus = [];


  keyValues() async {
    loginData = await SharedPreferences.getInstance();
    final locIp = loginData.getString('ip') ?? null;
    final onIp = loginData.getString('onlineIp') ?? null;

    if((locIp != null)&&(locIp != "false")){
      final response = await http.get(Uri.parse("http://$locIp/")).timeout(
          const Duration(milliseconds: 500),onTimeout: (){
        ip = onIp;
        getDate();
        return;
      });
      if(response.statusCode > 0) {
        print("local ip");
        ip = locIp;
        getDate();
      }

    }else if(locIp == "false")
    {
      print("online ip");
      ip = locIp;
      getDate();
    }
  }

  getDate() async {
    http.Response response = await http.get(Uri.parse('http://$ip/sensor/'));
    data = json.decode(response.body);
    print(data[0]);
    data[0].forEach((key, value){
      // print('key is $key');
      if(key == "id"){
        print("empty");
      }else{
        setState(() {
          dataJsonKey.add(key);
        });
      }
    });
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
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
            padding: EdgeInsets.only(left: 10.0,right: 10.0,top: 38.0,bottom: 5.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(onPressed: (){
                      Navigator.pop(context);
                    }, icon: Icon(Icons.arrow_back_ios)),
                    Text("Select devices", style: Theme.of(context).textTheme.headline5 ,),
                    SizedBox(
                      width: width*0.25,
                    ),
                    IconButton(onPressed: (){

                    }, icon: Icon(Icons.add),iconSize: height*0.04,),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                  itemCount: dataJsonKey.length,
                  itemBuilder: (BuildContext context,int index){
                    return Card(
                      child: ListTile(
                        tileColor: selectedDevicesID.isNotEmpty?selectedDevicesID.contains(dataJsonKey[index])?Colors.orange:Theme.of(context).canvasColor:Theme.of(context).canvasColor,
                        title: Text(dataJsonKey[index],style: Theme.of(context).textTheme.bodyText2,),
                        onTap: (){
                         setState(() {
                           if(true){

                             for(int i = 0; i <= selectedDevicesID.length ; i++){

                               if(selectedDevicesID.contains(dataJsonKey[index]))
                               {

                                 selectedDevicesID.remove(dataJsonKey[index]);
                                 selectedDevicesStatus.remove(dataJsonKey[index]);

                                 break;
                               }else if(selectedDevices.isEmpty){

                                 selectedDevicesID.add(dataJsonKey[index]);
                                 selectedDevicesStatus.add({dataJsonKey[index]:false});
                                 break;
                               }else{

                                 selectedDevicesID.add(dataJsonKey[index]);
                                 selectedDevicesStatus.add({dataJsonKey[index]:false});

                                 break;
                               }
                             }
                           }
                         });
                        },
                      ),
                    );
    }
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
