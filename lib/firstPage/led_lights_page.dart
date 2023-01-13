import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class LedLightsPage extends StatefulWidget {
  final String deviceName;
  final String ip;
  final int deviceId;
  bool status;

  LedLightsPage({Key key, this.deviceName, this.deviceId, this.ip, this.status})
      : super(key: key);

  @override
  State<LedLightsPage> createState() => _LedLightsPageState();
}

class _LedLightsPageState extends State<LedLightsPage> {
  Color color = Colors.white;

  int red = 0;
  int green = 0;
  int blue = 0;

  double sli = 0.0;

  bool lightValue;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      appBar: AppBar(
        title: Text(
          'LED Lights',
          style:
              TextStyle(fontWeight: FontWeight.w500, fontSize: height * 0.03,color: Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.03,
        ),
        child: Column(
          children: [
            Neumorphic(
              margin: EdgeInsets.only(top: height*0.01),
              style: NeumorphicStyle(
                depth: 5,
                boxShape: NeumorphicBoxShape.roundRect(
                  BorderRadius.circular(15),
                ),
                shadowDarkColorEmboss: Colors.white.withOpacity(0.5),
                shadowLightColorEmboss: Color(0xff000000),
                color: Color(0xffF8F8FF),
              ),
              child: Container(
                height: height * 0.08,
                // color: Theme.of(context).canvasColor,
                // margin: EdgeInsets.all(8.0),
                child: Center(
                  child: ListTile(
                    // contentPadding: EdgeInsets.all(10.0),
                    title: Text("Light Status",
                        style: TextStyle(color: Colors.black)),
                    trailing: Container(
                      width: width * 0.25,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(widget.status == true ? 'On' : 'Off',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
                          CupertinoSwitch(
                              // inactiveTrackColor: Colors.grey.shade300,
                            trackColor: Colors.grey.shade300,
                              activeColor: Colors.lightBlue.withOpacity(0.5),
                              thumbColor: Colors.lightBlue,
                              // thumbColor:
                                  // MaterialStateProperty.all(Colors.lightBlue),
                              value: widget.status,
                              onChanged: (bool value) {
                                setState(() {
                                  widget.status = !widget.status;
                                  http.put(
                                    Uri.parse(
                                        'http://${widget.ip}/led/${widget.deviceId}/'),
                                    headers: <String, String>{
                                      'Content-Type':
                                          'application/json; charset=UTF-8',
                                    },
                                    body: jsonEncode(<String, dynamic>{
                                      'Device_Status': widget.status,
                                    }),
                                  );
                                });
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Neumorphic(
              margin: EdgeInsets.only(top: height*0.02),
              style: NeumorphicStyle(
                depth: 5,
                boxShape: NeumorphicBoxShape.roundRect(
                  BorderRadius.circular(15),
                ),
                shadowDarkColorEmboss: Colors.black,
                shadowLightColorEmboss: Colors.black,
                color: Color(0xffF8F8FF),
              ),
              child: Container(
                // color: Theme.of(context).canvasColor,
                // margin: EdgeInsets.symmetric(horizontal: width*0.08),
                child: Column(
                  children: [
                    ListTile(
                      // contentPadding: EdgeInsets.all(10.0),
                      title: Text("Brightness ",
                          style: TextStyle(color: Colors.black)),
                      trailing: Text("${sli.toInt()}",
                          style: TextStyle(color: Colors.black),),
                    ),
                    Slider(
                        label: "${sli.toInt()}mins",
                        thumbColor: Colors.white,
                        activeColor: Colors.blue.shade500,
                        inactiveColor: Colors.grey.shade300,

                        divisions: 250,
                        max: 250.0,
                        min: 0.0,
                        value: sli,
                        onChanged: (value) {
                          setState(() {
                            sli = value;
                            var val = sli.toInt();
                            http.put(
                              Uri.parse(
                                  'http://${widget.ip}/led/${widget.deviceId}/'),
                              headers: <String, String>{
                                'Content-Type':
                                    'application/json; charset=UTF-8',
                              },
                              body: jsonEncode(<String, dynamic>{
                                'Brightness': val,
                              }),
                            );
                          });
                        }),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  // _showDialog(context);
                  QuickAlert.show(
                      context: context,
                      barrierDismissible: false,
                      type: QuickAlertType.custom,
                      title: 'Select Color',
                      // text: '',
                      // autoCloseDuration: const Duration(seconds: 2),
                      widget: BuildColorPicker(),
                      borderRadius: 20,
                      onCancelBtnTap: () {
                        setState(() {
                          Navigator.pop(context);
                        });
                      },
                      onConfirmBtnTap: () {
                        setState(() {
                          red = color.red;
                          blue = color.blue;
                          green = color.green;
                          http.put(
                            Uri.parse('http://${widget.ip}/led/1/'),
                            headers: <String, String>{
                              'Content-Type': 'application/json; charset=UTF-8',
                            },
                            body: jsonEncode(<String, int>{
                              "R": red,
                              "G": green,
                              "B": blue,
                            }),
                          );
                          Navigator.of(context).pop();
                        });
                      });
                });
              },
              child: Neumorphic(
                margin: EdgeInsets.only(top: height*0.09),
                style: NeumorphicStyle(
                  depth: 5,
                  boxShape: NeumorphicBoxShape.roundRect(
                    BorderRadius.circular(15),
                  ),
                  shadowDarkColorEmboss: Colors.black,
                  shadowLightColorEmboss: Colors.black,
                  color: Color(0xffF8F8FF),
                ),
                child: Container(
                  height: height*0.08,
                  alignment: Alignment.center,
                  child:  Text(
                    'Select Your  Color',
                    style: TextStyle(
                      fontSize: height*0.02,
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget BuildColorPicker() => ColorPicker(
        paletteType: PaletteType.hueWheel,
        pickerColor: color,
        displayThumbColor: false,
        showLabel: false,
        hexInputBar: false,
        enableAlpha: false,
        pickerAreaBorderRadius: const BorderRadius.all(Radius.circular(20)),
        onColorChanged: (colors) => setState(() {
          color = colors;
          // int red = color.red;
          // int green = color.green;
          // int blue = color.blue;

          // print("Red ${red}");
          // print("Green ${green}");
          // print("Blue ${blue}");

          http.put(
            Uri.parse('http://192.168.1.18/led/1/'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, int>{
              "R": red,
              "G": green,
              "B": blue,
            }),
          );
        }),
      );
}
