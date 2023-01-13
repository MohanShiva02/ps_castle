import 'package:flutter/material.dart';
import 'package:onwords_home/Routine_Page/routine_page2.dart';

class RoutinePage1 extends StatefulWidget {
  const RoutinePage1({Key key}) : super(key: key);

  @override
  State<RoutinePage1> createState() => _RoutinePage1State();
}

class _RoutinePage1State extends State<RoutinePage1> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        color: Theme.of(context).backgroundColor,
        //child: TaskView(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height * 0.025,
              ),
              Text(
                " Create Scenes ",
                style: Theme.of(context).appBarTheme.titleTextStyle,
              ),
              SizedBox(
                height: height * 0.025,
              ),
          GridView.count(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            children: <Widget>[
              CreateSceneContainer(height: height, width: width,img: "images/hand.png",small:"Run Manually" ,large: "Turn on/off your selected devices in single tap ",),
              CreateSceneContainer(height: height, width: width,img: "images/time_new.png",small:"Schedule" ,large: "Schedule your home devices to run automatically ",),
              CreateSceneContainer(height: height, width: width,img: "images/wea.png",small:"Weather changes" ,large: "Turn on/off devices on Sunrise/sunset ",),
            ],
          ),
            ],
          ),
        ),
      ),
    );
  }
}



class CreateSceneContainer extends StatelessWidget {
  const CreateSceneContainer({
    Key key, @required this.height,
    @required this.width,@required this.img,
    @required this.small,@required this.large}) : super(key: key);

  final double height;
  final double width;
  final String img;
  final String small;
  final String large;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        if(small == "Weather changes"){
          // print("hello world");
        }else{
          Navigator.push(context, MaterialPageRoute(builder: (context)=>RoutinePage2(name: small,)));
        }

      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.0),
        height: height*0.10,
        width: width*0.20,
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(12.0)
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: height * 0.030,
            ),
            Image(image: AssetImage(img),),
            SizedBox(
              height: height * 0.020,
            ),
            Text(
              small,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            SizedBox(
              height: height * 0.015,
            ),
            Text(
              large,
              style: TextStyle(color: Colors.grey,fontSize: height*0.012),
              textDirection: TextDirection.ltr,
            ),
            SizedBox(
              height: height * 0.015,
            ),
          ],
        ),
      ),
    );
  }
}
