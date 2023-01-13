import 'package:flutter/material.dart';
import 'package:onwords_home/settingsPage/Settings_page.dart';
import 'package:onwords_home/firstPage/firstPage.dart';
import 'package:onwords_home/dashbord/second_dashBoard.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:onwords_home/theme/change_theme_button_widget.dart';
import 'package:quick_actions/quick_actions.dart';
import 'Routine_Page/routine_page.dart';
import 'Routine_Page/routine_page2.dart';

class HomePage extends StatefulWidget {
  final int index;

  const HomePage({Key key, this.index}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool valueStatus = false;
  int _currentIndex;
  // final QuickActions quickActions = QuickActions();


  List page = [
    FirstPage(),
    SecondDashBoard(),
    RoutinePage(),
    DummySettingsPage(),
  ];


  // setupQuickActions(){
  //   quickActions.setShortcutItems([
  //     const ShortcutItem(
  //       type: 'home',
  //       localizedTitle: 'Home Page',
  //       icon: 'icon_home',
  //     ),
  //     const ShortcutItem(
  //       type: 'dashboard',
  //       localizedTitle: 'DashBoard',
  //       icon: 'icon_dash',
  //     ),
  //     const ShortcutItem(
  //         type: 'routine',
  //         localizedTitle: 'Routines',
  //         icon: 'icon_routine'),
  //     const ShortcutItem(
  //         type: 'theme',
  //         localizedTitle: 'Themes',
  //         icon: 'icon_theme'),
  //   ]);
  // }
  //
  // handleQuickActions(){
  //   quickActions.initialize((shortcutType) {
  //     setState(() {
  //       if(shortcutType == "home"){
  //         // Navigator.push(context, MaterialPageRoute(builder: (context)=>FirstPage()));
  //         Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage(index: 0,)));
  //         //Get.to(MyHomePage());
  //       }else if (shortcutType == "dashboard") {
  //         //Get.to(const PageOneDemo());
  //         // Navigator.push(context, MaterialPageRoute(builder: (context)=>SecondDashBoard()));
  //         Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage(index: 1,)));
  //       }else if(shortcutType == "routine"){
  //         //Get.to(const PageTwoDemo());
  //         // Navigator.push(context, MaterialPageRoute(builder: (context)=> RoutinePage()));
  //         Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage(index: 2,)));
  //       }else if(shortcutType == "theme"){
  //         //Get.to(const PageTwoDemo());
  //         Navigator.push(context, MaterialPageRoute(builder: (context)=> ChangeThemeButtonWidget()));
  //       }
  //     });
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    _currentIndex = widget.index??0;
    super.initState();
    // handleQuickActions();
    // setupQuickActions();
  }

  @override
  Widget build(BuildContext context) {
    // final height = MediaQuery.of(context).size.height;
    // final width = MediaQuery.of(context).size.width;
    return Scaffold(
      // backgroundColor:  Color.fromRGBO(40, 36, 36, 1.0),
      // backgroundColor: Color.fromRGBO(26, 28, 30, 0.6),
      //backgroundColor: Color.fromRGBO(26, 28, 30, 1.0),
      backgroundColor: Theme.of(context).backgroundColor,
      extendBody: true,
      body: page[_currentIndex],
      // bottomNavigationBar: Container(
      //   padding: EdgeInsets.symmetric(horizontal: 1.0),
      //   width: double.infinity,
      //   decoration: BoxDecoration(
      //     color: Colors.black,
      //     borderRadius: BorderRadius.circular(20.0),
      //   ),
      //   child: BottomNavigationBar(
      //     items: const <BottomNavigationBarItem>[
      //       BottomNavigationBarItem(
      //         backgroundColor: Colors.transparent,
      //         icon: Icon(Icons.home),
      //         label: 'Home',
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.business),
      //         label: 'Business',
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.dashboard),
      //         label: 'DashBoard',
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.settingsPage),
      //         label: 'Settings',
      //       ),
      //     ],
      //     backgroundColor: Colors.white,
      //     selectedItemColor: Colors.amber[800],
      //     unselectedItemColor: Colors.grey,
      //     currentIndex: _currentIndex,
      //     onTap: (int index) {
      //       setState(() {
      //         _currentIndex = index;
      //       });
      //     }
      //   ),
      // ),
        bottomNavigationBar: FloatingNavbar(
          elevation: 20.0,
         itemBorderRadius: 30.0,
        borderRadius: 40.0,
          backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          selectedBackgroundColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
          unselectedItemColor: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
          onTap: (int index) {

            setState(() {
              _currentIndex = index;
            });
          },
          currentIndex: _currentIndex,
          items: [
            FloatingNavbarItem(icon: Icons.home_outlined, title: 'Home'),
            FloatingNavbarItem(icon: Icons.dashboard_outlined, title: 'Dashboard'),
            FloatingNavbarItem(icon: Icons.more_time, title: 'Routine'),
            //FloatingNavbarItem(customWidget: SvgPicture.asset("images/home.svg"),title: 'Home'),
            //FloatingNavbarItem(customWidget: SvgPicture.asset("images/dash.svg"), title: 'Dashboard'),
            //FloatingNavbarItem(customWidget: SvgPicture.asset("images/routine.svg"), title: 'Routine'),
            FloatingNavbarItem(icon: Icons.settings, title: 'Settings'),

          ],
        ),
    );
  }
}

