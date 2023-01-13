 import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onwords_home/splashScreen.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Routine_Page/task_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'log_ins/installation_page.dart';







//version: 1.0.0+3 updated date on 13.01.2023



FirebaseAuth auth = FirebaseAuth.instance;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  //print('Handling a background message ${message.messageId}');
}



void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
  //   SystemUiOverlay.bottom,
  // ]);

  SharedPreferences.getInstance().then((loginData) {
    var isDarkTheme = loginData.getInt("darValue") ?? 3 ;
    var darkTime = loginData.getInt('time') ?? 0;
    //ignore:avoid_print
    // print("the dark value is $isDarkTheme");
    // print("the dark value is time $darkTime");
    runApp(MyApp(isDarkTheme,darkTime));
  });
}


class MyApp extends StatelessWidget {
  final int darkNum;
  final int darkTim;
  MyApp(this.darkNum,this.darkTim);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
            statusBarColor: Colors.black12
          //color set to transperent or set your own color
        )
    );
    return ChangeNotifierProvider(
        create: (context) => TaskData(darkNum,darkTim),
        builder: (context, _) {
          final themeProvider = Provider.of<TaskData>(context);
          return OverlaySupport.global(
            child: MaterialApp(
              themeMode: themeProvider.getTheme(),
              theme: MyThemes.lightTheme,
              darkTheme: MyThemes.darkTheme,
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                // body: InstallationPage(),
                body: SplashScreenPage(),
              ),
            ),
          );
        }
    );
  }
}
