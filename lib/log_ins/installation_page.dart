import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../home_page.dart';

class InstallationPage extends StatefulWidget {
  @override
  _InstallationPageState createState() => _InstallationPageState();
}

class _InstallationPageState extends State<InstallationPage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: height * 1.0,
          width: width * 1.0,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                Color.fromRGBO(0, 0, 0, 1.0),
                Color.fromRGBO(38, 42, 45, 1.0),
              ],
                  stops: [
                0.1,
                0.9
              ])),
          child: Column(
            children: <Widget>[
              // _Header(),
              Expanded(child: _TimelineDelivery()),
              SizedBox(
                height: 10.0,
              ),
              OutlinedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()));
                      },
                      style: ButtonStyle(
                        padding:
                            MaterialStateProperty.all(EdgeInsets.all(12.0)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                        backgroundColor: MaterialStateProperty.all(
                            Color.fromRGBO(247, 167, 28, 1.0)),
                      ),
                      child: Text(
                        " Finish ",
                        style: GoogleFonts.inter(
                            color: Colors.white, fontSize: height*0.017),
                      )),
              SizedBox(
                height:height*0.022,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimelineDelivery extends StatefulWidget {
  @override
  State<_TimelineDelivery> createState() => _TimelineDeliveryState();
}

class _TimelineDeliveryState extends State<_TimelineDelivery> {
int value = 1;

List arrValue = [];

getData(){
  for(int i =0;i<value;i++){
    arrValue.add(i);
  }
}

@override
  void initState() {
    getData();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    //final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: 0.1,
            isFirst: true,
            indicatorStyle: IndicatorStyle(
              width: width*0.07,
              iconStyle: arrValue.contains(0)?IconStyle(iconData: Icons.check):IconStyle(iconData: Icons.access_time),
              color: arrValue.contains(0)?Color(0xFF27AA69):Color(0xFFDADADA),
              padding: EdgeInsets.all(0),
            ),
            endChild: const _RightChild(
              title: 'process yet to begin',
            ),
            beforeLineStyle: LineStyle(
              color: arrValue.contains(0)?Color(0xFF27AA69):Color(0xFFDADADA),
            ),
          ),
          TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: 0.1,
            indicatorStyle: IndicatorStyle(
              width: width*0.07,
              iconStyle: arrValue.contains(1)?IconStyle(iconData: Icons.check):IconStyle(iconData: Icons.access_time),
              color: arrValue.contains(1)?Color(0xFF27AA69):Color(0xFFDADADA),
              padding: EdgeInsets.all(0),
            ),
            endChild: _RightChild(
              title: 'Device Placement',
            ),
            beforeLineStyle: LineStyle(
              color: arrValue.contains(1)?Color(0xFF27AA69):Color(0xFFDADADA),
            ),
          ),
          TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: 0.1,
            indicatorStyle: IndicatorStyle(
              width: width*0.07,
              iconStyle: arrValue.contains(2)?IconStyle(iconData: Icons.check):IconStyle(iconData: Icons.access_time),
              color: arrValue.contains(2)?Color(0xFF27AA69):Color(0xFFDADADA),
              padding: EdgeInsets.all(0),
            ),
            endChild: const _RightChild(
              title: 'Hardware building / Initializing Server',
            ),
            beforeLineStyle: LineStyle(
              color: arrValue.contains(2)?Color(0xFF27AA69):Color(0xFFDADADA),
            ),
            // afterLineStyle: const LineStyle(
            //   color: Color(0xFFDADADA),
            // ),
          ),
          TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: 0.1,
            indicatorStyle: IndicatorStyle(
              width: width*0.07,
              iconStyle: arrValue.contains(3)?IconStyle(iconData: Icons.check):IconStyle(iconData: Icons.access_time),
              color:arrValue.contains(3)?Color(0xFF27AA69):Color(0xFFDADADA),
              padding: EdgeInsets.all(0),
            ),
            endChild: const _RightChild(
              title: 'Configure App/Tab & Voice Assistants ',
            ),
            beforeLineStyle: LineStyle(
              color: arrValue.contains(3)?Color(0xFF27AA69):Color(0xFFDADADA),
            ),
          ),
          TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: 0.1,
            indicatorStyle: IndicatorStyle(
              width: width*0.07,
              iconStyle: arrValue.contains(4)?IconStyle(iconData: Icons.check):IconStyle(iconData: Icons.access_time),
              color: arrValue.contains(4)?Color(0xFF27AA69):Color(0xFFDADADA),
              padding: EdgeInsets.all(0),
            ),
            endChild: const _RightChild(
              title: 'Configure Voice Assistants ',
            ),
            beforeLineStyle: LineStyle(
              color: arrValue.contains(4)?Color(0xFF27AA69):Color(0xFFDADADA),
            ),
            // afterLineStyle: const LineStyle(
            //   color: Color(0xFFF7B31C),
            // ),
          ),
          TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: 0.1,
            indicatorStyle: IndicatorStyle(
              width: width*0.07,
              iconStyle: arrValue.contains(5)?IconStyle(iconData: Icons.check):IconStyle(iconData: Icons.access_time),
              color: arrValue.contains(5)?Color(0xFF27AA69):Color(0xFFDADADA),
              padding: EdgeInsets.all(0),
            ),
            endChild: const _RightChild(
              title: 'Integrating All together ',
            ),
            beforeLineStyle: LineStyle(
              color: arrValue.contains(5)?Color(0xFF27AA69):Color(0xFFDADADA),
            ),
            // afterLineStyle: const LineStyle(
            //   color: Color(0xFFDADADA),
            // ),
          ),
          TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: 0.1,
            indicatorStyle: IndicatorStyle(
              width: width*0.07,
              iconStyle: arrValue.contains(6)?IconStyle(iconData: Icons.check):IconStyle(iconData: Icons.access_time),
              color: arrValue.contains(6)?Color(0xFF27AA69):Color(0xFFDADADA),
              padding: EdgeInsets.all(0),
            ),
            endChild: const _RightChild(
              disabled: true,
              title: 'Home Wiring ',
            ),
            beforeLineStyle: LineStyle(
              color: arrValue.contains(6)?Color(0xFF27AA69):Color(0xFFDADADA),
            ),
            // afterLineStyle: const LineStyle(
            //   color: Color(0xFFDADADA),
            // ),
          ),
          TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: 0.1,
            indicatorStyle: IndicatorStyle(
              width: width*0.07,
              iconStyle: arrValue.contains(7)?IconStyle(iconData: Icons.check):IconStyle(iconData: Icons.access_time),
              color: arrValue.contains(7)?Color(0xFF27AA69):Color(0xFFDADADA),
              padding: EdgeInsets.all(0),
            ),
            endChild: const _RightChild(
              disabled: true,
              title: 'Configure App/Tab ',
            ),
            beforeLineStyle:  LineStyle(
              color: arrValue.contains(7)?Color(0xFF27AA69):Color(0xFFDADADA),
            ),

          ),
          TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: 0.1,
            indicatorStyle: IndicatorStyle(
              width: width*0.07,
              iconStyle: arrValue.contains(8)?IconStyle(iconData: Icons.check):IconStyle(iconData: Icons.access_time),
              color: arrValue.contains(8)?Color(0xFF27AA69):Color(0xFFDADADA),
              padding: EdgeInsets.all(0),
            ),
            endChild: const _RightChild(
              disabled: true,
              title: 'Installing ',
            ),
            beforeLineStyle: LineStyle(
              color: arrValue.contains(8)?Color(0xFF27AA69):Color(0xFFDADADA),
            ),

          ),
          TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: 0.1,
            indicatorStyle: IndicatorStyle(
              width: width*0.07,
              iconStyle: arrValue.contains(9)?IconStyle(iconData: Icons.check):IconStyle(iconData: Icons.access_time),
              color: arrValue.contains(9)?Color(0xFF27AA69):Color(0xFFDADADA),
              padding: EdgeInsets.all(0),
            ),
            endChild: const _RightChild(
              disabled: true,
              title: 'Alpha Testing ',
            ),
            beforeLineStyle: LineStyle(
              color: arrValue.contains(9)?Color(0xFF27AA69):Color(0xFFDADADA),
            ),
          ),
          TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: 0.1,
            indicatorStyle: IndicatorStyle(
              width: width*0.07,
              iconStyle: arrValue.contains(10)?IconStyle(iconData: Icons.check):IconStyle(iconData: Icons.access_time),
              color: arrValue.contains(10)?Color(0xFF27AA69):Color(0xFFDADADA),
              padding: EdgeInsets.all(0),
            ),
            endChild: const _RightChild(
              disabled: true,
              title: 'Beta Testing ',
            ),
            beforeLineStyle: LineStyle(
              color: arrValue.contains(10)?Color(0xFF27AA69):Color(0xFFDADADA),
            ),
          ),
          TimelineTile(
            alignment: TimelineAlign.manual,
            lineXY: 0.1,
            isLast: true,
            indicatorStyle: IndicatorStyle(
              width: width*0.07,
              iconStyle: arrValue.contains(11)?IconStyle(iconData: Icons.check):IconStyle(iconData: Icons.access_time),
              color: arrValue.contains(11)?Color(0xFF27AA69):Color(0xFFDADADA),
              padding: EdgeInsets.all(0),
            ),
            endChild: const _RightChild(
              disabled: true,
              title: 'Welcome Onboard ',
            ),
            beforeLineStyle: LineStyle(
              color: arrValue.contains(12)?Color(0xFF27AA69):Color(0xFFDADADA),
            ),
          ),
        ],
      ),
    );
  }
}

class _RightChild extends StatelessWidget {
  const _RightChild({
    Key key,
    this.asset,
    this.title,
    this.message,
    this.disabled = false,
  }) : super(key: key);

  final String asset;
  final String title;
  final String message;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          // Opacity(
          //   child: Image.asset(asset, height: 50),
          //   opacity: disabled ? 0.5 : 1,
          // ),
          SizedBox(width: width*0.05),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: GoogleFonts.yantramanav(
                  color: disabled
                      ? const Color(0xFF636564)
                      : const Color(0xFFBABABA),
                  fontSize: height*0.016,
                  fontWeight: FontWeight.w500,
                ),
              ),
              // SizedBox(height:height*0.002),
              // Text(
              //   message,
              //   style: GoogleFonts.yantramanav(
              //     color: disabled
              //         ? const Color(0xFFD5D5D5)
              //         : const Color(0xFF636564),
              //     fontSize: 16,
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
