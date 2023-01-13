import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class MotionSensorPage extends StatefulWidget {

  final String deviceName;
  final String ip;
  final int deviceId;
  const MotionSensorPage({Key key, this.deviceName, this.deviceId, this.ip}) : super(key: key);

  @override
  State<MotionSensorPage> createState() => _MotionSensorPageState();
}

class _MotionSensorPageState extends State<MotionSensorPage> {
  bool onSensorStatus = false;
  bool offSensorStatus = false;
  double sli = 0.0;





  readData() async {
    final response = await http.get(Uri.parse("http://${widget.ip}/motion/${widget.deviceId}/",));
    var fetchdata = jsonDecode(response.body);
    setState((){
      onSensorStatus = fetchdata['On_State'];
      offSensorStatus = fetchdata['Off_State'];
      var time = fetchdata['Time'];
      sli = double.parse(time.toString());
    });
  }

  @override
  void initState(){
    readData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height*1.0,
        width: width*1.0,
        padding: EdgeInsets.all(10.0),
        color: Theme.of(context).backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: height*0.037,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios)
                ),
                SizedBox(
                  width: width*0.030,
                ),
                Text("Set motion sensor ",style: Theme.of(context).textTheme.bodyText2),
              ],
            ),
            SizedBox(
              height: height*0.037,
            ),
            Text( widget.deviceName,style: Theme.of(context).textTheme.bodyText2,),
            SizedBox(
              height: height*0.037,
            ),
            Card(
              color: Theme.of(context).canvasColor,
              margin: EdgeInsets.all(8.0),
              child: Column(
                children: [
                   Slider(
                     label: "${sli.toInt()}mins",
                     thumbColor: Colors.orange,
                     activeColor: Colors.orange,
                     inactiveColor: Colors.grey,
                     divisions: 6,
                     max: 30.0,
                     min: 0.0,
                       value: sli,
                       onChanged: (value){
                     setState((){
                       sli = value;
                       var val = sli.toInt();
                       http.put(
                         Uri.parse('http://${widget.ip}/motion/${widget.deviceId}/'),
                         headers: <String, String>{
                           'Content-Type': 'application/json; charset=UTF-8',
                         },
                         body: jsonEncode(<String, dynamic>{
                           'Time': val,
                         }),
                       );
                     });
                   }),
                  ListTile(
                    contentPadding: EdgeInsets.all(10.0),
                    title: Text("Set Time ",style: Theme.of(context).textTheme.bodyText2),
                    trailing: Text("${sli.toInt()} mins ",style: Theme.of(context).textTheme.bodyText2),
                  ),
                ],
              ),
            ),
            Card(
              color: Theme.of(context).canvasColor,
              margin: EdgeInsets.all(8.0),
              child: ListTile(
                contentPadding: EdgeInsets.all(10.0),
                title: Text("On State ",style: Theme.of(context).textTheme.bodyText2),
                trailing: Switch(
                    inactiveTrackColor: Colors.grey.shade400,
                    activeColor: Colors.orange,
                    thumbColor: MaterialStateProperty.all(Colors.orange),
                    value: onSensorStatus,
                    onChanged: (bool value) {
                      setState(() {
                        onSensorStatus = value;
                        http.put(
                          Uri.parse('http://${widget.ip}/motion/${widget.deviceId}/'),
                          headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                          body: jsonEncode(<String, dynamic>{
                            'On_State': onSensorStatus,
                          }),
                        );
                      });
                    }),
              ),
            ),
            Card(
              color: Theme.of(context).canvasColor,
              margin: EdgeInsets.all(8.0),
              child: ListTile(
                contentPadding: EdgeInsets.all(10.0),
                title: Text("Off State ",style: Theme.of(context).textTheme.bodyText2),
                trailing: Switch(
                    inactiveTrackColor: Colors.grey.shade400,
                    activeColor: Colors.orange,
                    thumbColor: MaterialStateProperty.all(Colors.orange),
                    value: offSensorStatus,
                    onChanged: (bool value) {
                      setState(() {
                        offSensorStatus = value;
                        http.put(
                          Uri.parse('http://${widget.ip}/motion/${widget.deviceId}/'),
                          headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                          body: jsonEncode(<String, dynamic>{
                            'Off_State': offSensorStatus,
                          }),
                        );
                      });
                    }),
              ),
            ),

          ],
        )

      ),
    );
  }
}

