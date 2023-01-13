import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Routine_Page/routine_page.dart';
import '../Routine_Page/task_data.dart';

final databaseReference = FirebaseDatabase.instance.reference();

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();

  @override
  void initState() {
    name = TextEditingController();
    password = TextEditingController();
    email = TextEditingController();
    phone = TextEditingController();

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    name.dispose();
    password.dispose();
    phone.dispose();
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
      body: SingleChildScrollView(
        child: Container(
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
                      "Sign Up",
                      style: Theme.of(context).textTheme.headline5,
                    )
                  ],
                ),
                SizedBox(
                  height: height * 0.02,
                ),
                Provider.of<TaskData>(context).getTheme() == ThemeMode.dark
                    ? Image(
                        image: AssetImage('images/logo re@4x.png'),
                        height: height * 0.14,
                      )
                    : Image(
                        image: AssetImage('images/logo re@4x.png'),
                        height: height * 0.15,
                      ),
                SizedBox(
                  height: height * 0.02,
                ),
                Center(
                  child: Text(
                    " Smart Solutions",
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                SizedBox(
                  height: height * 0.06,
                ),
                Row(
                  children: [
                    Text(
                      " Name       :",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    Container(
                      width: width * 0.7,
                      height: height * 0.08,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            TextFormField(
                              controller: name,
                              cursorColor: Colors.orange,
                              style: Theme.of(context).textTheme.bodyText2,
                              keyboardType: TextInputType.multiline,
                              minLines: 1,
                              maxLines: 2,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(20),
                                hintStyle: Theme.of(context)
                                    .inputDecorationTheme
                                    .hintStyle,
                                hintText: ' Username',
                                enabledBorder: Theme.of(context)
                                    .inputDecorationTheme
                                    .enabledBorder,
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(35.0),
                                ),
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
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      " Email-Id  :",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    Container(
                      width: width * 0.7,
                      height: height * 0.08,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            TextFormField(
                              controller: email,
                              minLines: 1,
                              maxLines: 2,
                              cursorColor: Colors.orange,
                              style: Theme.of(context).textTheme.bodyText2,
                              keyboardType: TextInputType.emailAddress,
                              textAlignVertical: TextAlignVertical.bottom,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(20),
                                hintStyle: Theme.of(context)
                                    .inputDecorationTheme
                                    .hintStyle,
                                hintText: ' Email-Id',
                                enabledBorder: Theme.of(context)
                                    .inputDecorationTheme
                                    .enabledBorder,
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(35.0),
                                ),
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
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Password:",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    Container(
                      width: width * 0.7,
                      height: height * 0.08,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            TextFormField(
                              controller: password,
                              cursorColor: Colors.orange,
                              style: Theme.of(context).textTheme.bodyText2,
                              keyboardType: TextInputType.multiline,
                              maxLines: 1,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(20),
                                hintStyle: Theme.of(context)
                                    .inputDecorationTheme
                                    .hintStyle,
                                hintText: ' Password',
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
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Phone     :",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    Container(
                      width: width * 0.7,
                      height: height * 0.08,
                      margin: EdgeInsets.symmetric(horizontal: 13),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            TextFormField(
                              controller: phone,
                              cursorColor: Colors.orange,
                              style: Theme.of(context).textTheme.bodyText2,
                              keyboardType: TextInputType.number,
                              maxLines: 1,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(20),
                                hintStyle: Theme.of(context)
                                    .inputDecorationTheme
                                    .hintStyle,
                                hintText: ' +91-Mobile number',
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
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.025,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                            horizontal: 35.0, vertical: 15.0)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.orange)),
                    onPressed: () async {
                      createEmailId();
                    },
                    child: Text(" Sign Up ")),
              ],
            ),
          ),
        ),
      ),
    );
  }

  createEmailId() async {
    try {
      if (name.text.isNotEmpty) {
        if (phone.text.length == 10) {

          final newUser = await auth.createUserWithEmailAndPassword(
              email: email.text.replaceAll(' ', ''),
              password: password.text.replaceAll(' ', ''));

          databaseReference.child(auth.currentUser.uid).set({
            'name': name.text.replaceAll(' ', ''),
            'phone': "+91${phone.text.replaceAll(' ', '')}",
            'email': email.text.replaceAll(' ', ''),
            'password': password.text.replaceAll(' ', ''),
            'owner': false,
            'homeAutomate':false,
            'Gate':false,
            'WTA':false,
          });

          if (newUser != null) {
            name.clear();
            email.clear();
            phone.clear();
            password.clear();
            Navigator.pop(context);
          }
        } else {
          setState(() {
            final snackBar = SnackBar(
              content: Text("Please enter a valid Mobile Number"),
              backgroundColor: Colors.red,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          });
        }
      } else {
        setState(() {
          final snackBar = SnackBar(
            content: Text("Username is required"),
            backgroundColor: Colors.red,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      }
    } catch (e) {
      if (e.code == 'weak-password') {
        final snackBar = SnackBar(
          content: Text("Password is too weak"),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (e.code == 'email-already-in-use') {
        final snackBar = SnackBar(
          content: Text("This email Id is already exist"),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }
}
