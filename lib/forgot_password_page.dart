import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  TextEditingController email = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
   email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(" Reset Password ", style:Theme.of(context).textTheme.bodyText2,),
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        child: Container(
          padding: EdgeInsets.all(30.0),
          height: height*1.0,
          width: width*1.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Receive an email to reset your password ", style:Theme.of(context).textTheme.headline5),
              // SizedBox(
              //   height: height * 0.110,
              // ),
              TextFormField
                (
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Email ID';
                  }
                  return null;
                },
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
              ElevatedButton.icon(
                  onPressed: (){
                    if(formKey.currentState.validate()){
                       resetPassword();
                    }
                  },
                icon: Icon(Icons.email_outlined),
                label: Text(" Reset Password ", style:Theme.of(context).textTheme.bodyText2, ),


              )
            ],
          ),
        ),
      ),
    );
  }
  resetPassword() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator(),)
    );
     try{
       await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text.trim());
       Utils.showSnackBar("Password Reset email sent ",context);
       Navigator.of(context).popUntil((route) => route.isFirst);
     }
     on FirebaseAuthException catch(e)
     {
       Utils.showSnackBar(e.message, context);
       Navigator.pop(context);
     }

  }
}

class Utils {
  static void showSnackBar(String val,BuildContext context) {
    final snackBar = SnackBar(
      content: Text(val),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}


