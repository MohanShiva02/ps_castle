import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../Routine_Page/routine_page.dart';

final databaseReference = FirebaseDatabase.instance.reference();

class FamilyMembersPage extends StatefulWidget {
  const FamilyMembersPage({Key key}) : super(key: key);

  @override
  _FamilyMembersPageState createState() => _FamilyMembersPageState();
}

class _FamilyMembersPageState extends State<FamilyMembersPage> {
  TextEditingController email = TextEditingController();
  // TextEditingController password = TextEditingController();
  var validatingData;
  var validatingDataKey;
  bool temEmail = false;
  var fireData;
  var firebaseData;
  int count =0;
  int count1 =0;
  List data = [];
  List firebaseEmailData = [];
  String mtoken = " ";

  initial(){

    databaseReference.once().then((value){
      for (var element in value.snapshot.children) {
        firebaseData = element.value;
        setState(() {
          firebaseEmailData.add(firebaseData['email']);
        });

      }
    });



    databaseReference.child(auth.currentUser.uid).child('family').once().then((value){
      for (var element in value.snapshot.children) {
        firebaseData = element.value;
        setState(() {
          data.add(firebaseData['email']);
        });

      }
    });

  }

  void getTokenFromFirestore(String saveEmail,String uidValue) async {
      final data = await FirebaseFirestore.instance.collection(uidValue).doc(uidValue).get();
      setState(() {
        mtoken = data.get('token');
      });
      saveToken(mtoken,saveEmail,uidValue);
  }

  void saveToken(String token,String saveEmail,String uidValue) async {

    await FirebaseFirestore.instance.collection(auth.currentUser.uid).doc(uidValue).set({
      'token' : token,
      'email' : saveEmail,
    });

  }
  ///getToken
  // void getToken(String saveEmail,String uidValue) async {
  //   await FirebaseMessaging.instance.getToken().then(
  //           (token) {
  //         setState(() {
  //           mtoken = token;
  //         });
  //
  //         saveToken(token,saveEmail,uidValue);
  //       }
  //   );
  // }

  register(String saveEmail,String uidValue){
    getTokenFromFirestore(saveEmail,uidValue);
  }

  @override
  void initState() {

    initial();
    email = TextEditingController();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {

    email.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      resizeToAvoidBottomInset: false,
      body: Container(
        margin: EdgeInsets.only(top: height * 0.030),
        padding: EdgeInsets.only(left: height * 0.015),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                      )),
                  Text(
                    "Family Members",
                    style: Theme.of(context).textTheme.headline5,
                  )
                ],
              ),
              SizedBox(
                height: height * 0.12,
              ),
              Row(
                children: [
                  Text(
                    "Name :",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  Container(
                    width: width * 0.7,
                    height: height * 0.08,
                    margin: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: email,
                          cursorColor: Colors.orange,
                          style: Theme.of(context).textTheme.bodyText2,
                          keyboardType: TextInputType.multiline,
                          maxLines: 1,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(20),
                            hintStyle:
                                Theme.of(context).inputDecorationTheme.hintStyle,
                            hintText: ' Email-Id',
                            enabledBorder: Theme.of(context)
                                .inputDecorationTheme
                                .enabledBorder,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            filled: true,
                            fillColor: Colors.transparent,
                            focusedBorder: Theme.of(context)
                                .inputDecorationTheme
                                .focusedBorder,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.025,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(horizontal: 35.0, vertical: 15.0)),
                      backgroundColor: MaterialStateProperty.all(Colors.orange)),
                  onPressed: () async {

                   if(firebaseEmailData.contains(email.text.replaceAll(' ', '')))
                   {
                     if(data.contains(email.text.replaceAll(' ', '')))
                     {
                       final snackBar = SnackBar(
                         content: Text("This member is already exist in family"),
                         backgroundColor: Colors.red,
                       );
                       ScaffoldMessenger.of(context).showSnackBar(snackBar);
                     }else{
                     databaseReference.once().then((value){
                       //print(value.snapshot.value);
                       for (var element in value.snapshot.children) {
                         validatingDataKey = element.key;
                         validatingData = element.value;
                         if (validatingData['email'] == email.text.replaceAll(' ', '')) {

                           databaseReference.child('family').child(validatingDataKey).set({
                             'uid' : validatingDataKey,
                             'email': email.text.replaceAll(' ', ''),
                             'owner-uid':auth.currentUser.uid,
                           });

                           databaseReference.child(auth.currentUser.uid).child('family').child(validatingDataKey).set({
                             'uid' : validatingDataKey,
                             'email': email.text.replaceAll(' ', ''),
                           });
                           register(email.text.replaceAll(' ', ''), validatingDataKey.toString());
                           showDialog(
                               context: context,
                               builder: (BuildContext context) {
                                 return Center(
                                   child: Container(
                                     height: 240,
                                     width: 250,
                                     child: Column(
                                       mainAxisAlignment: MainAxisAlignment
                                           .spaceAround,
                                       children: [
                                         SvgPicture.asset(
                                           'images/signed.svg',
                                           color: Colors.green,
                                           height: height * 0.20,
                                         ),
                                         Text(
                                           "Successfully added", style: TextStyle(
                                           fontSize: height*0.012,
                                           fontWeight: FontWeight.w600,
                                           color: Colors.black,
                                         ))
                                       ],
                                     ),
                                     margin: EdgeInsets.symmetric(
                                         horizontal: 20, vertical: 25.0),
                                     padding: EdgeInsets.all(10.0),
                                     decoration: BoxDecoration(
                                         color: Colors.white,
                                         borderRadius: BorderRadius.circular(
                                             40)),
                                   ),
                                 );
                               });
                           Future.delayed(Duration(seconds: 2), () {
                             Navigator.pop(context);
                             Navigator.pop(context);
                           });
                         }
                       }
                     });
                   }
                    }else{
                     final snackBar = SnackBar(
                       content: Text("This Email ID does not exist"),
                       backgroundColor: Colors.red,
                     );
                     ScaffoldMessenger.of(context).showSnackBar(snackBar);
                   }

                  },
                  child: Text(" Add ")),
              Container(
                height: height*0.60,
                width: width*1.0,
                padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                    itemCount: data.length??0,
                    itemBuilder: (BuildContext context,int index){
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Theme.of(context).canvasColor,
                        child: ListTile(
                            leading: Icon(Icons.person),
                            title:Text(data[index],style: Theme.of(context).textTheme.bodyText2,)
                        ),
                      );
                    }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
