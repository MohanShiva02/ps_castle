import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onwords_home/Routine_Page/task_data.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';



class ChangeThemeButtonWidget extends StatefulWidget {
  @override
  _ChangeThemeButtonWidgetState createState() => _ChangeThemeButtonWidgetState();
}

class _ChangeThemeButtonWidgetState extends State<ChangeThemeButtonWidget> {

  SharedPreferences loginData;
   int _grpValue = 3;

  Timer timer;
  DateTime now ;
  var timeFormat ;
  int time = 0;

  void getTime() {
      DateTime now = DateTime.now();
      timeFormat = DateFormat('HH').format(now);
      time = int.parse(timeFormat.toString());
      loginData.setInt('time', time);
  }

  initial() async {
    loginData = await SharedPreferences.getInstance();
    setState(() {
      _grpValue = loginData.getInt("val") ?? 3;
      //ignore:avoid_print
      //print("_grp value is $_grpValue");
      if(_grpValue == 0){
        setState(() {
          //ignore:avoid_print
          //print("the _grpValue 0 $_grpValue");
          _grpValue = 0;
        });
      }else if(_grpValue == 1){
        setState(() {
          //ignore:avoid_print
          //print("the _grpValue 1 $_grpValue");
          _grpValue = 1;
        });
      }else if(_grpValue == 2){
        setState(() {
          //ignore:avoid_print
          //print("the _grpValue 2 $_grpValue");
          _grpValue = 2;
        });
      }else{
        setState(() {
          //ignore:avoid_print
          //print("the _grpValue 3 $_grpValue");
          _grpValue = 3;
        });
      }
    });
    //_grpValue ??= 0;
  }


  @override
  void initState() {
    // TODO: implement initState
    initial();
    Timer.periodic(Duration(seconds: 1), (Timer t) => getTime());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: height*0.07,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0,vertical: 5.0),
              child: Text(" Theme",style: Theme.of(context).textTheme.headline4,),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  RadioListTile(
                      dense: true,
                      activeColor: Colors.orangeAccent,
                      title:  Text(" system ",
                          style:Theme.of(context).textTheme.bodyText2
                      ),
                      value: 0,
                      groupValue: _grpValue,
                      onChanged: (newValue){
                        setState(() {
                          //_grpValue = newValue;
                          //ignore:avoid_print
                          //print("the radio button 0 $newValue");
                          loginData.setInt('val', newValue);
                          initial();
                          Provider.of<TaskData>(context, listen: false).swapTheme();
                        });
                      }
                  ),
                  RadioListTile(
                      dense: true,
                      activeColor: Colors.orangeAccent,
                      title:  Text(" Dark ",style:Theme.of(context).textTheme.bodyText2),
                      value: 1,
                      groupValue: _grpValue,
                      onChanged: (newValue){
                        setState(() {
                          //_grpValue = newValue;
                          //ignore:avoid_print
                          //print("the radio button 0 $newValue");
                          loginData.setInt('val', newValue);
                          initial();
                          Provider.of<TaskData>(context, listen: false).swapTheme();
                        });
                      }
                  ),
                  const SizedBox(height: 10),
                  RadioListTile(
                      dense: true,
                      activeColor: Colors.orangeAccent,
                      title:  Text(" Light ",style:Theme.of(context).textTheme.bodyText2),
                      value: 2,
                      groupValue: _grpValue,
                      onChanged: (newValue){
                        setState(() {
                          //_grpValue = newValue;
                          //ignore:avoid_print
                          //print("the radio button 1 $newValue");
                          loginData.setInt('val', newValue);
                          initial();
                          Provider.of<TaskData>(context, listen: false).swapTheme();
                        });
                      }
                  ),
                  const SizedBox(height: 10),
                  RadioListTile(
                      dense: true,
                      activeColor: Colors.orangeAccent,
                      title:  Text(" Auto ",style:Theme.of(context).textTheme.bodyText2),
                      value: 3,
                      groupValue: _grpValue,
                      onChanged: (newValue){
                        setState(() {
                          //_grpValue = newValue;
                          //ignore:avoid_print
                          //print("the radio button 0 $newValue");
                          loginData.setInt('val', newValue);
                          initial();
                          Provider.of<TaskData>(context, listen: false).swapTheme();
                        });
                      }
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

