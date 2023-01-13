import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onwords_home/Routine_Page/task_data.dart';
import 'package:onwords_home/forgot_password_page.dart';
import 'package:onwords_home/log_ins/new_user_page.dart';
import 'package:onwords_home/log_ins/sign_up_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home_page.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../product_page/device_pages.dart';



FirebaseAuth auth = FirebaseAuth.instance;

final databaseReference = FirebaseDatabase.instance.reference();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  String loginState;
  SharedPreferences loginData;
  bool newUser = false;
  bool _isHidden = true;
  bool hasInternet = false;
  ConnectivityResult result = ConnectivityResult.none;
  List userId = [];
  List userToken = [];
  String mtoken = " ";
  AndroidNotificationChannel channel;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String authKey = " ";
  var ownerId;
  var dataJson;
  var personalDataJson;
  bool smartHome = false;
  bool home = false;
  bool wta = false;
  bool gate = false;





  ///get token from firestore
  // void getTokenFromFirestore(String collName) async {
  //
  //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(collName).get();
  //
  //   querySnapshot.docs.asMap().forEach((key, value) {
  //     // print(value.id);
  //   });
  //   for (int i = 0; i < querySnapshot.docs.length; i++) {
  //     var a = querySnapshot.docs[i];
  //
  //     //print("helllo ${a.id}");
  //     userId.add(a.id);
  //
  //     final data = await FirebaseFirestore.instance.collection(collName).doc(a.id).get();
  //
  //     data.data()?.forEach((key, value) {
  //       userToken.add(value);
  //     });
  //
  //
  //
  //   }
  // }


  ///sendpush notification
  // void sendPushMessage(String token, String title, String body) async {
  //   try {
  //     await http.post(
  //       Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //         'Authorization': 'key=AAAAyfCaNws:APA91bEo187K7j-Xc7o0tAoaU0rYIKS2n3oR0tZB6TBv0eGZLXjQURLc9AJZ7au6pQSevaw-UGLhw_ashDHdQJ8ZuKQqFVRqtj7GjFajI6uYg4CWCeroZOkj6I3XgqQS2BgWjEmdOEzB',
  //       },
  //       body: jsonEncode(
  //         <String, dynamic>{
  //           'notification': <String, dynamic>{
  //             'body': body,
  //             'title': title
  //           },
  //           'priority': 'high',
  //           'data': <String, dynamic>{
  //             'click_action': 'FLUTTER_NOTIFICATION_CLICK',
  //             'id': '1',
  //             'status': 'done'
  //           },
  //           "to": token,
  //         },
  //       ),
  //     );
  //   } catch (e) {
  //     print("error push notification");
  //   }
  // }

  void saveToken(String token,String saveEmail) async {

    await FirebaseFirestore.instance.collection(auth.currentUser.uid).doc(auth.currentUser.uid).set({
      'token' : token,
      'email' : saveEmail,
    });

  }

  void getToken(String saveEmail) async {
    await FirebaseMessaging.instance.getToken().then(
            (token) {
          setState(() {
            mtoken = token;
          });

          saveToken(token,saveEmail);
        }
    );
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
  }

  void loadFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  register(String saveEmail){

    // getTokenFromFirestore(famName);

    requestPermission();

    loadFCM();

    listenFCM();

    getToken(saveEmail);

  }

  Future<void> internet() async {

    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        this.result = result;
      });
    });

    InternetConnectionChecker().onStatusChange.listen((status) async {
      final hasInternet = status == InternetConnectionStatus.connected;
      setState(() {
        this.hasInternet = hasInternet;
      });
    });
    hasInternet = await InternetConnectionChecker().hasConnection;
    result = await Connectivity().checkConnectivity();
  }

  firstProcess() async {
    loginData = await SharedPreferences.getInstance();
    databaseReference.child('family').once().then((value) async{
      for (var element in value.snapshot.children){
        ownerId = element.value;
        if(element.key == auth.currentUser.uid){
          loginData.setString('ownerId', ownerId['owner-uid']);
          setState(() {
            authKey = loginData.getString('ownerId');
          });
          break;
        }else{
          var val = auth.currentUser.uid;
          loginData.setString('ownerId',val);
          setState(() {
            authKey = loginData.getString('ownerId');
          });
        }
      }
    }).then((value) => fireData());
  }

  fireData(){
    // if(authKey == " "){
    //   setState((){
    //     authKey = auth.currentUser.uid;
    //   });
    //   databaseReference.child(authKey).once().then((snapshot){
    //     dataJson = snapshot.snapshot.value;
    //     setState(() {
    //       smartHome = dataJson['homeAutomate'];
    //       // if(smartHome == null){
    //       //   print("smart home $smartHome ");
    //       //   fireData();
    //       // }
    //       // loginData.setBool('home', smartHome);
    //       // loginData.setBool('wta', dataJson['WTA']);
    //       // loginData.setBool('gate', dataJson['Gate']);
    //       home = smartHome;
    //       wta = dataJson['WTA']??false;
    //       gate = dataJson['Gate']??false;
    //     });
    //   }).then((value) => navigate());
    // }else{
    //   databaseReference.child(authKey).once().then((snapshot){
    //     dataJson = snapshot.snapshot.value;
    //     setState(() {
    //       smartHome = dataJson['homeAutomate'];
    //       // if(smartHome == null){
    //       //   print("smart home $smartHome ");
    //       //   fireData();
    //       // }
    //       // loginData.setBool('home', smartHome);
    //       // loginData.setBool('wta', dataJson['WTA']);
    //       // loginData.setBool('gate', dataJson['Gate']);
    //       home = smartHome;
    //       wta = dataJson['WTA']??false;
    //       gate = dataJson['Gate']??false;
    //     });
    //   }).then((value) => navigate());
    // }
    databaseReference.child(authKey).once().then((snapshot){
      dataJson = snapshot.snapshot.value;
      setState(() {
        smartHome = dataJson['homeAutomate'];
        // if(smartHome == null){
        //   print("smart home $smartHome ");
        //   fireData();
        // }
        // loginData.setBool('home', smartHome);
        // loginData.setBool('wta', dataJson['WTA']);
        // loginData.setBool('gate', dataJson['Gate']);
        home = smartHome??false;
        wta = dataJson['WTA']??false;
        gate = dataJson['Gate']??false;
      });
    }).then((value) => navigate());
  }

  navigate(){
    if(home != null){
      if(home){
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomePage()));
      }else{
        if((wta == false)&&(gate==false))
        {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => NewUserPage()));
        }else{
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => DevicePages(wta: wta,gate: gate,)));
        }

      }
    }else{
      // print("smatttttt $home ");
      //fireData();
    }
  }


  @override
  void initState() {

    // Timer.periodic(Duration(seconds: 1), (Timer t) => getTime());
    //check_if_already_login();

    email = TextEditingController();
    pass = TextEditingController();


    super.initState();
  }



  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

@override
  void dispose() {
    email.dispose();
    pass.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Container(
          height: height * 1.0,
          width: width * 1.0,
          color: Theme.of(context).backgroundColor,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: height * 0.110,
                ),
                SvgPicture.asset(
                  'images/log_anim.svg',
                ),
                SizedBox(
                  height: height * 0.020,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 40.0,vertical: 05.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Text("Login" ,style: Theme.of(context).textTheme.headline4,),
                    SvgPicture.asset(
                      'images/clouds.svg',
                    ),
                  ],),
                ),
                Center(
                  child: Container(
                    width: width * 0.81,
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          controller: email,
                          cursorColor: Colors.orange,
                          style: Theme.of(context).textTheme.bodyText2,
                          keyboardType: TextInputType.emailAddress,
                          maxLines: null,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            enabledBorder : Theme.of(context).inputDecorationTheme.enabledBorder,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            filled: true,
                            fillColor: Colors.transparent,
                            hintText: "Email-Id",
                            hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                            focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.014,
                        ),
                        TextField(
                          controller: pass,
                          obscureText: _isHidden,
                          cursorColor: Colors.orange,
                          style: Theme.of(context).textTheme.bodyText2,
                          decoration: InputDecoration(
                            suffix: InkWell(
                              onTap: _togglePasswordView,
                              child: Icon(
                                _isHidden
                                    ? Icons.visibility
                                    : Icons.visibility_off, color: Colors.grey,
                              ),
                            ),
                            errorBorder: InputBorder.none,
                            disabledBorder : InputBorder.none,
                            enabledBorder : Theme.of(context).inputDecorationTheme.enabledBorder,
                            border: InputBorder.none ,
                            filled: true,
                            fillColor: Colors.transparent,
                            hintText: "Password",
                            hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                            focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
                          ),
                        ),
                        SizedBox(
                          height: height * 0.030,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                //print("$hasInternet inetrnet is available or not_____________________------------------");
                                hasInternet = await InternetConnectionChecker().hasConnection;
                                result = await Connectivity().checkConnectivity();
                                //print("$hasInternet inetrnet is after pressing the button  ++++++++++++++");
                                if(hasInternet) {
                                  try {
                                    await auth.signInWithEmailAndPassword(email: "fbtest@onwords.in",password: "123456");
                                    loginData = await SharedPreferences.getInstance();
                                    await loginData.clear();
                                    setState(() {
                                      loginData.setBool('login', false);
                                      loginData.setString('username', email.text);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HomePage()));
                                      // loginState = "logedin succesfully";
                                      // print(
                                      //     "curent user = ${Firebase.auth.UserProfile}");
                                    });
                                  } catch (e) {
                                    setState(() {
                                      loginState = "Access denied";
                                    });
                                  }
                                }
                                else{
                                  showSimpleNotification(
                                    Text("No Network",
                                      style: TextStyle(color: Colors.white),),
                                    background: Colors.red,
                                  );
                                }

                              },
                              child: Text(
                                "Demo Login",
                                style: Theme.of(context).textTheme.button,
                                // GoogleFonts.inter(
                                //     fontSize: height * 0.016,
                                //     color: Colors.white60,
                                //     fontWeight: FontWeight.bold),
                              ),
                            ),
                            GestureDetector(
                                onTap: () async {
                                  //print("$hasInternet inetrnet is available or not_____________________------------------");

                                  hasInternet = await InternetConnectionChecker().hasConnection;
                                  result = await Connectivity().checkConnectivity();
                                  //print("$hasInternet inetrnet is after pressing the button  ++++++++++++++");

                                  if(hasInternet) {
                                    try {
                                      await auth.signInWithEmailAndPassword(email: email.text.replaceAll(' ', ''),password: pass.text.replaceAll(' ', ''));
                                      register(email.text.replaceAll(' ', ''));
                                      loginData = await SharedPreferences.getInstance();
                                      await loginData.clear();
                                      setState(() {
                                        loginData.setBool('login', false);
                                        //loginData.setString('username', email.text);
                                        firstProcess();
                                        // Navigator.pushReplacement(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             HomePage()));
                                      });
                                    } catch (e) {
                                      setState(() {
                                        loginState = "Incorrect Password or Email";
                                        final snackBar = SnackBar(
                                            content: Text(loginState),
                                            backgroundColor: Colors.red,
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      });
                                    }
                                  }
                                  else{
                                    showSimpleNotification(
                                      Text("No Network",
                                        style: TextStyle(color: Colors.white),),
                                      background: Colors.red,
                                    );
                                  }
                                },
                                child:
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text("Sign In",
                                      style:Theme.of(context).textTheme.bodyText2,
                                    ),
                                    SizedBox(
                                      width:width * 0.03,
                                    ),
                                    CircleAvatar(
                                      backgroundColor: Colors.orange,
                                        child: Icon(Icons.arrow_forward_ios_rounded,color: Colors.white, )),
                                  ],
                                )
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.030,
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SignUpPage()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("create account?",style: Theme.of(context).textTheme.bodyText2),
                              Text("  sign up",style: TextStyle(color: Colors.blue),),

                            ],
                          ),
                        ),
                        SizedBox(
                          height: height * 0.030,
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ForgotPasswordPage()));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("  forgot password  ",style: TextStyle(color: Colors.blue),),

                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                // SizedBox(
                //   height: height * 0.000,
                // ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // CircleAvatar(
                        //   backgroundColor: Color.fromRGBO(247, 179, 28, 1.0),radius: 50,
                        // ),
                        CircleAvatar(
                          radius: 75,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                                border: Border.all(color: Theme.of(context).backgroundColor,),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Color.fromRGBO(247, 179, 28, 1.0),
                                  //Colors.black,
                                  Theme.of(context).backgroundColor,
                                ],
                                stops: [
                                  0.1,0.6
                                ]
                              ),
                            ),
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: Theme.of(context).backgroundColor,radius: 40,
                        ),
                      ],
                    ),
                    Provider.of<TaskData>(context).getTheme() == ThemeMode.dark ?
                    Image(
                      image: AssetImage('images/logo re@4x.png'),
                      height: height * 0.06,
                    ):Image(
                      image: AssetImage('images/logo re@4x.png'),
                      height: height * 0.06,
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // CircleAvatar(
                        //   backgroundColor: Color.fromRGBO(247, 179, 28, 1.0),radius: 50,
                        // ),
                        CircleAvatar(
                          radius: 48,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Theme.of(context).backgroundColor,),
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color.fromRGBO(247, 179, 28, 1.0),
                                    Theme.of(context).backgroundColor,
                                  ],
                                  stops: [
                                    0.1,0.8
                                  ]
                              ),
                            ),
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: Theme.of(context).backgroundColor,radius: 25,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
